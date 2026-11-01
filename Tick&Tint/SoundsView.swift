import SwiftUI
import Combine
import AVFoundation

struct SoundItem: Identifiable, Equatable {
    let id: String
    let title: String
    let icon: String        // image name in Assets.xcassets
    let file: String        // audio file name (without .m4a)
}

// MARK: - Screen

struct SoundsView: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var sound: SoundManager
    @State private var selected: SoundItem?

    private let items = [
        SoundItem(id: "fire",   title: "Fire",   icon: "fire",   file: "fire"),
        SoundItem(id: "ocean",  title: "Ocean",  icon: "ocean",  file: "ocean"),
        SoundItem(id: "rain",   title: "Rain",   icon: "rain",   file: "rain"),
        SoundItem(id: "stream", title: "Stream", icon: "stream", file: "stream")
    ]

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                Text("Background Sounds")
                    .font(.system(size: AppFonts.largeTitle, weight: .bold))
                    .foregroundColor(.primaryText)
                    .padding(.top, AppSpacing.topHeaderOffset)

                VStack(spacing: AppSpacing.large) {
                    ForEach(items) { item in
                        card(for: item)
                    }
                }
                .padding(.horizontal, AppSpacing.extraLarge)
                .padding(.top, AppSpacing.extraLarge)

                Spacer()

                VStack(spacing: AppSpacing.small) {
                    startButton
                    cancelButton
                }
                .padding(.horizontal, AppSpacing.extraLarge)
                .padding(.bottom, AppSpacing.extraLarge)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Sound card (معاينة 3 ثوانٍ فقط)

    private func card(for item: SoundItem) -> some View {
        let isSelected = selected == item

        return Button {
            selected = item
            sound.preview(item.file) // تشغيل صوت معاينة 3 ثوانٍ
        } label: {
            HStack(spacing: AppSpacing.medium) {
                ZStack {
                    Circle().fill(Color.white)
                    Image(item.icon)
                        .resizable()
                        .scaledToFill()
                }
                .frame(width: 52, height: 52)
                .clipShape(Circle())

                Text(item.title)
                    .font(.system(size: AppFonts.title2))
                    .foregroundColor(.white)

                Spacer()
            }
            .padding(.horizontal, AppSpacing.medium)
            .frame(height: 68)
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.secondaryBrandSelected : Color.secondaryBrand)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.large, style: .continuous))
            .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
            .animation(.easeInOut(duration: 0.15), value: isSelected)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Start Button (تشغيل الصوت 5 دقائق بالخلفية والعودة لـ BreakView)

    private var startButton: some View {
        Button {
            if let soundFile = selected?.file {
                sound.start(soundFile) // تشغيل الصوت لمدة 5 دقائق بالخلفية
            }
            dismiss() // العودة مباشرة لصفحة BreakView
        } label: {
            Text("Start")
                .font(.system(size: AppFonts.title2, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 46)
                .background(selected != nil ? Color.primaryBrand : Color.primaryBrand.opacity(0.5))
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
        }
        .buttonStyle(.plain)
        .disabled(selected == nil)
    }

    // MARK: - Cancel Button (إيقاف المعاينة والعودة لـ BreakView)

    private var cancelButton: some View {
        Button {
            sound.stop()
            dismiss()
        } label: {
            Text("Cancel")
                .font(.system(size: AppFonts.title2, weight: .semibold))
                .foregroundColor(.secondaryText)
                .frame(maxWidth: .infinity, minHeight: 46)
                .background(Color.white)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SoundsView()
        .environmentObject(SoundManager())
}

// MARK: - Sound manager

final class SoundManager: ObservableObject {

    static let duration: TimeInterval = 5 * 60       // 5 دقائق
    static let previewDuration: TimeInterval = 3     // 3 ثواني للمعاينة

    @Published private(set) var isPlaying = false
    @Published private(set) var remaining = 0

    private var player: AVAudioPlayer?
    private var timer: Timer?
    private var endDate = Date()
    private var fadeStarted = false
    private var previewWorks: [DispatchWorkItem] = []

    func preview(_ name: String) {
        stop()
        guard play(name) else { return }

        let fade = DispatchWorkItem { [weak self] in
            self?.player?.setVolume(0, fadeDuration: 0.5)
        }
        let end = DispatchWorkItem { [weak self] in
            self?.stop()
        }
        previewWorks = [fade, end]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (Self.previewDuration - 0.5), execute: fade)
        DispatchQueue.main.asyncAfter(deadline: .now() + Self.previewDuration, execute: end)
    }

    func start(_ name: String) {
        stop()
        guard play(name) else { return }

        endDate = Date().addingTimeInterval(Self.duration)
        fadeStarted = false
        remaining = Int(Self.duration)
        isPlaying = true

        let t = Timer(timeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.tick()
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    private func play(_ name: String) -> Bool {
        guard let url = Bundle.main.url(forResource: name, withExtension: "m4a") else {
            print("Missing file: \(name).m4a")
            return false
        }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)

            let p = try AVAudioPlayer(contentsOf: url)
            p.numberOfLoops = -1
            p.volume = 1
            p.prepareToPlay()
            p.play()
            player = p
            return true
        } catch {
            print("Audio error: \(error)")
            return false
        }
    }

    private func tick() {
        let left = endDate.timeIntervalSinceNow
        let secs = max(0, Int(ceil(left)))
        if secs != remaining { remaining = secs }

        if left <= 2, !fadeStarted {
            fadeStarted = true
            player?.setVolume(0, fadeDuration: 2)
        }
        if left <= 0 { stop() }
    }

    func stop() {
        previewWorks.forEach { $0.cancel() }
        previewWorks = []
        timer?.invalidate()
        timer = nil
        player?.stop()
        player = nil
        try? AVAudioSession.sharedInstance()
            .setActive(false, options: .notifyOthersOnDeactivation)
        isPlaying = false
        remaining = 0
    }

    deinit {
        timer?.invalidate()
    }
}
