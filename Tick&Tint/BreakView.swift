import SwiftUI
import Combine
import UIKit

struct BreakView: View {
    
    let totalRounds: Int
    let rounds: Int
    let workDurationMinutes: Int
    let paintingType: String
    
    // Shared navigation path
    @Binding var navigationPath: [AppRoute]
    
    // Shared Sound Manager
    @EnvironmentObject private var sound: SoundManager
    
    @State private var savedArtworkURL: URL?
    @State private var encouragementMessage = ""
    @State private var showArtwork = false
    
    // MARK: - Popup State & Sound Navigation
    @State private var showSoundPopup: Bool = true
    @State private var navigateToSounds: Bool = false
    
    private var isArtworkComplete: Bool {
        !selectedArtworkRegions.isEmpty &&
        selectedArtworkRegions.allSatisfy {
            regionColors[$0.id] != nil
        }
    }
    
    // MARK: - Timer State
    @State private var remainingSeconds: Int
    @State private var isTimerRunning: Bool = false
    @State private var targetEndDate: Date?
    @State private var nativeTimer: Timer?
    
    init(
        totalRounds: Int,
        rounds: Int,
        workDurationMinutes: Int,
        paintingType: String,
        navigationPath: Binding<[AppRoute]>
    ) {
        self.totalRounds = totalRounds
        self.rounds = rounds
        self.workDurationMinutes = workDurationMinutes
        self.paintingType = paintingType
        _navigationPath = navigationPath
        
        let initialSeconds = workDurationMinutes == 50 ? 600 : 300
        _remainingSeconds = State(initialValue: initialSeconds)
    }
    
    private var formattedTime: String {
        let minutes = max(0, remainingSeconds) / 60
        let seconds = max(0, remainingSeconds) % 60
        
        return String(
            format: "%02d:%02d",
            minutes,
            seconds
        )
    }
    
    @State private var showingCompletionAlert = false
    
    // MARK: - Color Palette
    @State private var selectedNumber = 1
    @State private var regionColors: [String: Color] = [:]
    
    private let palette: [(number: Int, color: Color)] = [
        (1,  Color(red: 0.949, green: 0.757, blue: 0.306)),
        (2,  Color(red: 0.212, green: 0.365, blue: 0.608)),
        (3,  Color(red: 0.914, green: 0.663, blue: 0.753)),
        (4,  Color(red: 0.204, green: 0.318, blue: 0.227)),
        (5,  Color(red: 1.000, green: 0.941, blue: 0.847)),
        (6,  Color(red: 0.784, green: 0.247, blue: 0.310)),
        (7,  Color(red: 0.471, green: 0.722, blue: 0.871)),
        (8,  Color(red: 0.439, green: 0.290, blue: 0.557)),
        (9,  Color(red: 0.851, green: 0.725, blue: 0.549)),
        (10, Color(red: 0.435, green: 0.596, blue: 0.294)),
        (11, Color(red: 0.271, green: 0.271, blue: 0.294)),
        (12, Color(red: 0.937, green: 0.545, blue: 0.208)),
        (13, Color(red: 0.659, green: 0.804, blue: 0.690)),
        (14, Color(red: 0.150, green: 0.250, blue: 0.450)),
        (15, Color(red: 0.914, green: 0.510, blue: 0.475)),
        (16, Color(red: 0.635, green: 0.471, blue: 0.310)),
        (17, Color(red: 0.663, green: 0.608, blue: 0.835)),
        (18, Color(red: 0.980, green: 0.870, blue: 0.420)),
        (19, Color(red: 0.220, green: 0.549, blue: 0.537)),
        (20, Color(red: 1.000, green: 1.000, blue: 1.000)),
        (21, Color(red: 0.769, green: 0.365, blue: 0.227)),
        (22, Color(red: 0.750, green: 0.850, blue: 0.920)),
        (23, Color(red: 0.294, green: 0.184, blue: 0.129)),
        (24, Color(red: 0.980, green: 0.780, blue: 0.820)),
        (25, Color(red: 0.390, green: 0.470, blue: 0.250)),
        (26, Color(red: 0.350, green: 0.230, blue: 0.500)),
        (27, Color(red: 0.549, green: 0.506, blue: 0.471)),
        (28, Color(red: 0.320, green: 0.650, blue: 0.590)),
        (29, Color(red: 0.660, green: 0.160, blue: 0.210)),
        (30, Color(red: 0.830, green: 0.700, blue: 0.790)),
        (31, Color(red: 0.580, green: 0.690, blue: 0.350)),
        (32, Color(red: 0.439, green: 0.290, blue: 0.188)),
        (33, Color(red: 0.330, green: 0.580, blue: 0.760)),
        (34, Color(red: 0.960, green: 0.820, blue: 0.600)),
        (35, Color(red: 0.520, green: 0.420, blue: 0.700)),
        (36, Color(red: 0.294, green: 0.435, blue: 0.235)),
        (37, Color(red: 0.749, green: 0.706, blue: 0.647)),
        (38, Color(red: 0.700, green: 0.690, blue: 0.400)),
        (39, Color(red: 0.780, green: 0.850, blue: 0.650)),
        (40, Color(red: 0.439, green: 0.290, blue: 0.557))
    ]
    
    private var selectedArtworkRegions: [ColoringRegion] {
        switch paintingType {
        case "Doodles":
            return ColoringArtwork.animals
        case "Animals":
            return ColoringArtwork.sleepingFox
        case "Words":
            return ColoringArtwork.words
        case "Nature":
            return ColoringArtwork.nature
        default:
            return ColoringArtwork.nature
        }
    }
    
    private var remainingNumbers: [Int] {
        palette.compactMap { item in
            let hasUncoloredRegions = selectedArtworkRegions.contains {
                $0.number == item.number &&
                regionColors[$0.id] == nil
            }
            return hasUncoloredRegions ? item.number : nil
        }
    }
    
    private func remainingProgress(for number: Int) -> CGFloat {
        let matchingRegions = selectedArtworkRegions.filter {
            $0.number == number
        }
        
        guard !matchingRegions.isEmpty else { return 0 }
        
        let remainingCount = matchingRegions.filter {
            regionColors[$0.id] == nil
        }.count
        return CGFloat(remainingCount) / CGFloat(matchingRegions.count)
    }
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header, Subheadline
                VStack(spacing: AppSpacing.small) {
                    Text("Break Time")
                        .font(.system(size: AppFonts.title1, weight: .bold))
                        .foregroundStyle(Color.primaryText)
                    
                    Text("Take Your Time and Enjoy Coloring")
                        .font(.system(size: AppFonts.headline))
                        .foregroundStyle(Color.primaryText)
                }
                .padding(.top, AppSpacing.topHeaderOffset)
                
                // MARK: - Timer Display
                Text(formattedTime)
                    .font(.system(size: AppFonts.title2, weight: .bold))
                    .contentTransition(.numericText())
                    .foregroundStyle(Color.primaryText)
                    .padding(.top, AppSpacing.medium)
                
                // MARK: - Native Coloring Canvas
                ColoringCanvasView(
                    selectedNumber: selectedNumber,
                    regionColors: $regionColors,
                    regions: selectedArtworkRegions
                )
                .frame(maxWidth: .infinity)
                .frame(maxHeight: 450)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                .padding(.horizontal, AppSpacing.screenPadding)
                .padding(.top, AppSpacing.medium)
                .onChange(of: isArtworkComplete) { _, isComplete in
                    guard isComplete, remainingSeconds > 0 else { return }
                    
                    let messages: [String] = [
                        "Amazing work! Take a sip of water 💧",
                        "Beautifully done! Give your body a little stretch 🌸",
                        "You did it! Relax your shoulders and take a deep breath 🌿",
                        "Wonderful! Give your eyes a little rest ✨",
                        "Great job! Take a moment to appreciate yourself 💗",
                        "You're doing amazing! Stretch your arms above your head ☁️",
                        "Well done! Take a few slow, calming breaths 🌷",
                        "Fantastic! Unclench your jaw and relax your face 🦋",
                        "You deserve this break! Give your hands and wrists a little rest 🌼",
                        "Keep shining! Look away from your screen and enjoy the moment 🌞"
                    ]
                    
                    encouragementMessage = messages.randomElement() ?? messages[0]
                }
                
                // MARK: - Color Palette
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppSpacing.medium) {
                        ForEach(palette.filter {
                            remainingNumbers.contains($0.number)
                        }, id: \.number) { item in
                            
                            Button {
                                selectedNumber = item.number
                            } label: {
                                VStack(spacing: 6) {
                                    ZStack {
                                        Circle()
                                            .stroke(Color.gray.opacity(0.22), lineWidth: 4)
                                        
                                        Circle()
                                            .trim(from: remainingProgress(for: item.number), to: 1)
                                            .stroke(item.color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                                            .rotationEffect(.degrees(-90))
                                        
                                        Circle()
                                            .fill(item.color)
                                            .padding(7)
                                    }
                                    .frame(width: 48, height: 48)
                                    .overlay {
                                        Circle()
                                            .stroke(
                                                selectedNumber == item.number ? Color.primaryText : Color.clear,
                                                lineWidth: 2
                                            )
                                            .padding(2)
                                    }
                                    .scaleEffect(selectedNumber == item.number ? 1.08 : 1)
                                    
                                    Text("\(item.number)")
                                        .font(.system(size: 14, weight: selectedNumber == item.number ? .bold : .regular))
                                        .foregroundStyle(Color.primaryText)
                                }
                                .frame(width: 56)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, AppSpacing.screenPadding)
                    .padding(.vertical, AppSpacing.small)
                }
                .padding(.top, AppSpacing.extraLarge)
                .onChange(of: remainingNumbers) { _, newNumbers in
                    if !newNumbers.contains(selectedNumber),
                       let nextNumber = newNumbers.first {
                        selectedNumber = nextNumber
                    }
                }
            }
            
            // MARK: - Popup Overlay
            if showSoundPopup {
                Color.black.opacity(0.12)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismissPopupAndStartTimer()
                    }
                
                VStack(spacing: 12) {
                    Text("Background Sounds")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("Want to listen to a Sound while\ncoloring?")
                        .font(.system(size: 14))
                        .foregroundColor(Color.gray.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 4)
                    
                    HStack(spacing: 12) {
                        // Ignore Button
                        Button(action: {
                            dismissPopupAndStartTimer()
                        }) {
                            Text("Ignore")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(red: 0.90, green: 0.90, blue: 0.91))
                                .cornerRadius(20)
                        }
                        
                        // Yes Button
                        Button(action: {
                            showSoundPopup = false
                            startBreakTimerIfNeeded()
                            navigateToSounds = true
                        }) {
                            Text("Yes")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(red: 0.18, green: 0.35, blue: 0.54))
                                .cornerRadius(20)
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
                .frame(width: 280)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white.opacity(0.96))
                        .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 8)
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .navigationDestination(isPresented: $navigateToSounds) {
            SoundsView()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showArtwork) {
            if let url = savedArtworkURL {
                EndOfSessionView(
                    savedArtworkURL: url,
                    navigationPath: $navigationPath
                )
            }
        }
        .onAppear {
            // إذا كان التايمر قد بدأ سابقاً (مثلاً بعد العودة من صفحة الأصوات)، يستأنف العد
            if isTimerRunning {
                resumeTimer()
            }
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    // MARK: - Timer Control Methods
    private func dismissPopupAndStartTimer() {
        showSoundPopup = false
        startBreakTimerIfNeeded()
    }
    
    private func startBreakTimerIfNeeded() {
        guard !isTimerRunning else { return }
        isTimerRunning = true
        targetEndDate = Date().addingTimeInterval(TimeInterval(remainingSeconds))
        resumeTimer()
    }
    
    private func resumeTimer() {
        stopTimer()
        
        let t = Timer(timeInterval: 0.5, repeats: true) { _ in
            guard let endDate = targetEndDate else { return }
            let secondsLeft = Int(ceil(endDate.timeIntervalSinceNow))
            
            if secondsLeft > 0 {
                if remainingSeconds != secondsLeft {
                    remainingSeconds = secondsLeft
                }
            } else {
                remainingSeconds = 0
                stopTimer()
                handleBreakCompletion()
            }
        }
        RunLoop.main.add(t, forMode: .common)
        nativeTimer = t
    }
    
    private func stopTimer() {
        nativeTimer?.invalidate()
        nativeTimer = nil
    }
    
    private func saveArtwork() -> URL? {
        let canvas = ColoringCanvasView(
            selectedNumber: selectedNumber,
            regionColors: $regionColors,
            regions: selectedArtworkRegions
        )
        .frame(
            width: ColoringArtwork.width,
            height: ColoringArtwork.height
        )
        
        let renderer = ImageRenderer(content: canvas)
        renderer.scale = 2
        
        guard let image = renderer.uiImage,
              let data = image.pngData() else {
            print("Failed to render artwork.")
            return nil
        }
        
        do {
            let directory = FileManager.default.urls(
                for: .applicationSupportDirectory,
                in: .userDomainMask
            )[0]
            
            try FileManager.default.createDirectory(
                at: directory,
                withIntermediateDirectories: true
            )
            
            let fileURL = directory.appendingPathComponent("completed-artwork.png")
            try data.write(to: fileURL, options: .atomic)
            
            print("Artwork saved at: \(fileURL)")
            return fileURL
            
        } catch {
            print("Failed to save artwork: \(error)")
            return nil
        }
    }
    
    private func handleBreakCompletion() {
        sound.stop()
        
        var nextRound: Int
        if rounds < totalRounds {
            nextRound = rounds + 1
            navigationPath.append(
                .timer(
                    round: nextRound,
                    totalRounds: totalRounds,
                    workDurationMinutes: workDurationMinutes,
                    category: paintingType
                )
            )
        } else {
            if let url = saveArtwork() {
                savedArtworkURL = url
                showArtwork = true
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @StateObject private var soundManager = SoundManager()
        
        var body: some View {
            NavigationStack {
                BreakView(
                    totalRounds: 4,
                    rounds: 2,
                    workDurationMinutes: 25,
                    paintingType: "Animals",
                    navigationPath: .constant([])
                )
            }
            .environmentObject(soundManager)
        }
    }
    
    return PreviewWrapper()
}
