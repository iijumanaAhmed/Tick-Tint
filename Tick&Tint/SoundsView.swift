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
    @EnvironmentObject private var sound: SoundManager   // shared with the next page
    @State private var selected: SoundItem?

    /// Called when Start is pressed. Your friend connects the
    /// navigation to the next page here (not used yet).
    var onStart: () -> Void = {}

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

    // MARK: - Sound card

    private func card(for item: SoundItem) -> some View {
        let isSelected = selected == item

        return Button {
            selected = item
            sound.preview(item.file)
            // plays for 3 seconds so the user can hear it
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
        .accessibilityLabel(item.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    // MARK: - Start (does nothing for now)

    private var startButton: some View {
        Button {
            // TODO: connect later.
            // When ready:  guard let s = selected else { return }
            //              sound.start(s.file)     // plays 5 minutes
            //              onStart()               // go to the next page
        } label: {
            Text("Start")
                .font(.system(size: AppFonts.title2))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 46)
                .background(Color.primaryBrand)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Cancel (does nothing for now)

    private var cancelButton: some View {
        Button {
            // TODO: connect later.
            // When ready:  sound.stop()
            //              dismiss()
        } label: {
            Text("Cancel")
                .font(.system(size: AppFonts.title2))
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

/// Plays a 3-second preview, or one looping sound for exactly 5 minutes.
final class SoundManager: ObservableObject {

    static let duration: TimeInterval = 5 * 60      // 5 minutes
    static let previewDuration: TimeInterval = 3    // 3 seconds

    @Published private(set) var isPlaying = false
    @Published private(set) var remaining = 0       // seconds left

    private var player: AVAudioPlayer?
    private var timer: Timer?
    private var endDate = Date()
    private var fadeStarted = false
    private var previewWorks: [DispatchWorkItem] = []

    // MARK: - Preview (3 seconds)

    func preview(_ name: String) {
        stop()                                       // stops any sound or older preview
        guard play(name) else { return }

        let fade = DispatchWorkItem { [weak self] in
            self?.player?.setVolume(0, fadeDuration: 0.5)
        }
        let end = DispatchWorkItem { [weak self] in
            self?.stop()
        }
        previewWorks = [fade, end]
        DispatchQueue.main.asyncAfter(deadline: .now() + Self.previewDuration - 0.5, execute: fade)
        DispatchQueue.main.asyncAfter(deadline: .now() + Self.previewDuration, execute: end)
    }

    // MARK: - Start (5 minutes)

    func start(_ name: String) {
        stop()                                       // never play two sounds at once
        guard play(name) else { return }

        // The end time is a real date, so the countdown stays accurate
        // even if the app was busy or the screen was locked.
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

    // MARK: - Shared playback

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
            p.numberOfLoops = -1                     // loop until stopped
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

    // MARK: - Tick

    private func tick() {
        let left = endDate.timeIntervalSinceNow
        let secs = max(0, Int(ceil(left)))
        if secs != remaining { remaining = secs }

        if left <= 2, !fadeStarted {                 // gentle 2-second fade-out
            fadeStarted = true
            player?.setVolume(0, fadeDuration: 2)
        }
        if left <= 0 { stop() }
    }

    // MARK: - Stop

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
