import SwiftUI
import Playgrounds
import Combine
import UIKit

struct BreakView: View {
    @State private var category: PaintingCategory = .sleepingFox
    @State private var savedArtworkURL: URL?
    @State private var encouragementMessage = ""
    @State private var showArtwork = false
    
    
    private var isArtworkComplete: Bool {
        !selectedArtworkRegions.isEmpty &&
        selectedArtworkRegions.allSatisfy {
            regionColors[$0.id] != nil
        }
    }
    // MARK: - Timer Func
    @State private var remainingSeconds = 300
    @State private var showingCompletionAlert = false
    
    private let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    
    // MARK: - Color Palette
    @State private var selectedNumber = 1
    @State private var regionColors: [String: Color] = [:]
    
    private let palette: [(number: Int, color: Color)] = [
        (1,  Color(red: 0.949, green: 0.757, blue: 0.306)), // Golden yellow
        (2,  Color(red: 0.212, green: 0.365, blue: 0.608)), // Deep blue
        (3,  Color(red: 0.914, green: 0.663, blue: 0.753)), // Soft pink
        (4,  Color(red: 0.204, green: 0.318, blue: 0.227)), // Dark green
        (5,  Color(red: 1.000, green: 0.941, blue: 0.847)), // Cream
        (6,  Color(red: 0.784, green: 0.247, blue: 0.310)), // Red
        (7,  Color(red: 0.471, green: 0.722, blue: 0.871)), // Sky blue
        (8,  Color(red: 0.439, green: 0.290, blue: 0.557)), // Purple
        (9,  Color(red: 0.851, green: 0.725, blue: 0.549)), // Sand
        (10, Color(red: 0.435, green: 0.596, blue: 0.294)), // Leaf green
        
        (11, Color(red: 0.271, green: 0.271, blue: 0.294)), // Charcoal
        (12, Color(red: 0.937, green: 0.545, blue: 0.208)), // Orange
        (13, Color(red: 0.659, green: 0.804, blue: 0.690)), // Mint
        (14, Color(red: 0.150, green: 0.250, blue: 0.450)), // Navy blue
        (15, Color(red: 0.914, green: 0.510, blue: 0.475)), // Coral
        (16, Color(red: 0.635, green: 0.471, blue: 0.310)), // Light brown
        (17, Color(red: 0.663, green: 0.608, blue: 0.835)), // Lavender
        (18, Color(red: 0.980, green: 0.870, blue: 0.420)), // Bright yellow
        (19, Color(red: 0.220, green: 0.549, blue: 0.537)), // Teal
        (20, Color(red: 1.000, green: 1.000, blue: 1.000)), // White
        
        (21, Color(red: 0.769, green: 0.365, blue: 0.227)), // Terracotta
        (22, Color(red: 0.750, green: 0.850, blue: 0.920)), // Light blue
        (23, Color(red: 0.294, green: 0.184, blue: 0.129)), // Dark brown
        (24, Color(red: 0.980, green: 0.780, blue: 0.820)), // Light pink
        (25, Color(red: 0.390, green: 0.470, blue: 0.250)), // Olive
        (26, Color(red: 0.350, green: 0.230, blue: 0.500)), // Dark purple
        (27, Color(red: 0.549, green: 0.506, blue: 0.471)), // Warm gray
        (28, Color(red: 0.320, green: 0.650, blue: 0.590)), // Aqua green
        (29, Color(red: 0.660, green: 0.160, blue: 0.210)), // Dark red
        (30, Color(red: 0.830, green: 0.700, blue: 0.790)), // Light mauve
        
        (31, Color(red: 0.580, green: 0.690, blue: 0.350)), // Fresh green
        (32, Color(red: 0.439, green: 0.290, blue: 0.188)), // Medium brown
        (33, Color(red: 0.330, green: 0.580, blue: 0.760)), // Medium blue
        (34, Color(red: 0.960, green: 0.820, blue: 0.600)), // Warm peach
        (35, Color(red: 0.520, green: 0.420, blue: 0.700)), // Violet
        (36, Color(red: 0.294, green: 0.435, blue: 0.235)), // Forest green
        (37, Color(red: 0.749, green: 0.706, blue: 0.647)), // Beige gray
        (38, Color(red: 0.700, green: 0.690, blue: 0.400)), // Soft olive
        (39, Color(red: 0.780, green: 0.850, blue: 0.650)), // Light green
        (40, Color(red: 0.439, green: 0.290, blue: 0.557))  // Purple
    ]
    
    private var selectedArtworkRegions: [ColoringRegion] {
        switch category {
        case .animals:
            return ColoringArtwork.animals
        case .sleepingFox:
            return ColoringArtwork.sleepingFox
        case .words:
            return ColoringArtwork.words
        case .nature:
            return ColoringArtwork.nature
        }
    }
    
    // All numbers that still have at least one uncolored region.
    private var remainingNumbers: [Int] {
        palette.compactMap { item in
            let hasUncoloredRegions = selectedArtworkRegions.contains {
                $0.number == item.number &&
                regionColors[$0.id] == nil
            }
            
            return hasUncoloredRegions ? item.number : nil
        }
    }
    
    // Remaining fraction for the progress ring.
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
            NavigationStack {
                
                VStack(spacing: 0) {
                    
                    // MARK: - Header, Subheadline
                    VStack(spacing: AppSpacing.small) {
                        
                        Text("Break Time")
                            .font(
                                .system(
                                    size: AppFonts.title1,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(Color.primaryText)
                        
                        Text("Take Your Time and Enjoy Coloring")
                            .font(
                                .system(size: AppFonts.headline)
                            )
                            .foregroundStyle(Color.primaryText)
                    }
                    .padding(.top, AppSpacing.topHeaderOffset)
                    
                    // MARK: - Timer
                    Text(formattedTime)
                        .font(
                            .system(
                                size: AppFonts.title2,
                                weight: .bold
                            )
                        )
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
                    .shadow(
                        color: .black.opacity(0.15),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
                    .padding(.horizontal, AppSpacing.screenPadding)
                    .padding(.top, AppSpacing.medium)
                    .onChange(of: isArtworkComplete) { _, isComplete in
                        guard isComplete, remainingSeconds > 0 else { return }
                        
                        saveArtwork()
                        
                        let messages = [
                            "Amazing work! Take a sip of water 💧",
                            "Beautifully done! Give your body a little stretch 🌸",
                            "You did it! Relax your shoulders and take a deep breath 🌿",
                            "Wonderful! Give your eyes a little rest ✨"
                        ]
                        
                        encouragementMessage = messages.randomElement() ?? messages[0]
                        showingCompletionAlert = true
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
                                            // Background track.
                                            Circle()
                                                .stroke(
                                                    Color.gray.opacity(0.22),
                                                    lineWidth: 4
                                                )
                                            
                                            // Remaining regions.
                                            Circle()
                                                .trim(
                                                    from: 1 - remainingProgress(for: item.number),
                                                    to: 1
                                                )
                                                .stroke(
                                                    item.color,
                                                    style: StrokeStyle(
                                                        lineWidth: 4,
                                                        lineCap: .round
                                                    )
                                                )
                                                .rotationEffect(.degrees(-90))
                                            
                                            // Color swatch.
                                            Circle()
                                                .fill(item.color)
                                                .padding(7)
                                        }
                                        .frame(width: 48, height: 48)
                                        .overlay {
                                            Circle()
                                                .stroke(
                                                    selectedNumber == item.number
                                                    ? Color.primaryText
                                                    : Color.clear,
                                                    lineWidth: 2
                                                )
                                                .padding(2)
                                        }
                                        .scaleEffect(
                                            selectedNumber == item.number ? 1.08 : 1
                                        )
                                        
                                        Text("\(item.number)")
                                            .font(
                                                .system(
                                                    size: 14,
                                                    weight: selectedNumber == item.number
                                                    ? .bold
                                                    : .regular
                                                )
                                            )
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
                    if let url = savedArtworkURL {
                        Button("View My Artwork") {
                            showArtwork = true
                        }
                        .sheet(isPresented: $showArtwork) {
                            EndOfSessionView(savedArtworkURL: url)
                        }
                        
                        
                    }
                }
            }
            Spacer(minLength: AppSpacing.medium)
            
            
        }
        .navigationTitle("Coloring Break")
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(timer) { _ in
            guard remainingSeconds > 0 else {
                return
            }
            
            remainingSeconds -= 1
            
            if remainingSeconds == 0 {
                saveArtwork()
                showingCompletionAlert = true
            }            }
        .alert(
            remainingSeconds == 0 ? "Break Complete" : "Beautifully Done!",
            isPresented: $showingCompletionAlert
        ) {
            Button("OK", role: .cancel) { }
            
        } message: {
            Text(
                remainingSeconds == 0
                ? "Your five-minute coloring break has ended."
                : encouragementMessage
            )
        }
    }
    
    private var formattedTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        
        return String(
            format: "%02d:%02d",
            minutes,
            seconds
        )
    }
    
    private func saveArtwork() {
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
            return
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
            
            let fileURL = directory.appendingPathComponent(
                "completed-artwork.png"
            )
            
            try data.write(to: fileURL, options: .atomic)
            savedArtworkURL = fileURL
            
            print("Artwork saved at: \(fileURL)")
            
        } catch {
            print("Failed to save artwork: \(error)")
        }
    }
}

#Preview {
    BreakView()
}

#Playground {
    _ = 1 + 2
}
