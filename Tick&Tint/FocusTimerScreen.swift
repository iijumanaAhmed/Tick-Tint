import SwiftUI
import Combine

struct FocusTimerScreen: View {

    let totalRounds: Int
    let workDurationMinutes: Int

    @State private var currentRound = 1
    @State private var timeRemaining: Int
    @State private var isRunning = false
    @State private var showExitAlert = false

    @Environment(\.dismiss) private var dismiss
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private let timerPublisher = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(totalRounds: Int = 4, workDurationMinutes: Int = 25) {
        self.totalRounds = totalRounds
        self.workDurationMinutes = workDurationMinutes
        _timeRemaining = State(initialValue: workDurationMinutes * 60)
    }

    // MARK: - Derived values

    private var progress: Double {
        let total = Double(workDurationMinutes * 60)
        return total > 0 ? Double(timeRemaining) / total : 0
    }

    private var timeString: String {
        String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60)
    }

    private var isStandBy: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .compact
    }

    // MARK: - Actions

    private func exitSession() {
        isRunning = false
        timeRemaining = workDurationMinutes * 60
        dismiss()
    }

    private func finishRound() {
        isRunning = false
        if currentRound < totalRounds {
            currentRound += 1
            timeRemaining = workDurationMinutes * 60
        }
    }

    // MARK: - Body

    var body: some View {
        Group {
            if isStandBy { standByLayout } else { portraitLayout }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
        .ignoresSafeArea(edges: .top)
        .onReceive(timerPublisher) { _ in
            guard isRunning, timeRemaining > 0 else { return }
            timeRemaining -= 1
            if timeRemaining == 0 { finishRound() }
        }
        .alert("End Focus Session?", isPresented: $showExitAlert) {
            Button("Keep Focusing", role: .cancel) { }
            Button("End Session", role: .destructive, action: exitSession)
        } message: {
            Text("Your progress in this round will be lost.")
        }
        .tint(Color.primaryBrand)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - StandBy (landscape)

    private var standByLayout: some View {
        GeometryReader { geo in
            let lineWidth: CGFloat = 20
            let radius = min(geo.size.width * 0.4, geo.size.height - 70)
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height - lineWidth / 2)
            let elapsed = 1 - progress

            ZStack {
                // Track
                Circle()
                    .trim(from: 0.5, to: 1)
                    .stroke(Color.secondaryBrand.opacity(0.15),
                            style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .frame(width: radius * 2, height: radius * 2)
                    .position(center)

                // Progress: fills left -> right
                Circle()
                    .trim(from: 0.5, to: 0.5 + elapsed * 0.5)
                    .stroke(Color.secondaryBrand,
                            style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .frame(width: radius * 2, height: radius * 2)
                    .position(center)
                    .animation(.linear(duration: 1), value: elapsed)

                // Round label above the arch
                Text("Round \(currentRound) of \(totalRounds)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondaryText)
                    .position(x: center.x, y: center.y - radius - lineWidth / 2 - 18)

                // Time + controls inside the arch
                VStack(spacing: 16) {
                    Text(timeString)
                        .font(.system(size: 72, weight: .bold))
                        .foregroundColor(.secondaryBrand)
                        .monospacedDigit()

                    HStack(spacing: 20) {
                        Button { showExitAlert = true } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.secondaryText)
                                .frame(width: 40, height: 40)
                                .background(Color.borderSubtle.opacity(0.3))
                                .clipShape(Circle())
                        }

                        Button { isRunning.toggle() } label: {
                            Image(systemName: isRunning ? "pause.fill" : "play.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 48, height: 48)
                                .background(Color.primaryBrand)
                                .clipShape(Circle())
                        }
                    }
                }
                .position(x: center.x, y: center.y - radius * 0.45)
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - Portrait

    private var portraitLayout: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Spacer().frame(height: AppSpacing.statusBarHeight + AppSpacing.topHeaderOffset)

                Text("Round \(currentRound) of \(totalRounds)")
                    .font(.system(size: AppFonts.subheadline, weight: .regular))
                    .foregroundColor(.secondaryText)
                    .padding(.bottom, AppSpacing.small)

                Text("Focus Time")
                    .font(.system(size: AppFonts.title1, weight: .bold))
                    .foregroundColor(.primaryText)
            }

            Spacer()

            VStack(spacing: 40) {
                ZStack {
                    Circle()
                        .stroke(Color.borderSubtle, lineWidth: 8)
                        .frame(width: 260, height: 260)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Color.secondaryBrand,
                                style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 260, height: 260)
                        .rotationEffect(.degrees(90))
                        .animation(.linear(duration: 1), value: progress)

                    Circle()
                        .fill(Color.secondaryBrand.opacity(0.1))
                        .frame(width: 230, height: 230)

                    Image("TimerIllustration")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 170, height: 170)
                }

                VStack(spacing: 24) {
                    Text(timeString)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.primaryText)
                        .monospacedDigit()

                    HStack(spacing: 32) {
                        Button { showExitAlert = true } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.primaryText)
                                .frame(width: 48, height: 48)
                                .background(Color.borderSubtle)
                                .clipShape(Circle())
                        }

                        Button { isRunning.toggle() } label: {
                            Image(systemName: isRunning ? "pause.fill" : "play.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(Color.primaryBrand)
                                .clipShape(Circle())
                        }
                    }
                }
            }

            Spacer()
        }
        .padding(.horizontal, AppSpacing.screenPadding)
    }
}

#Preview  {
    NavigationStack {
        FocusTimerScreen(totalRounds: 3, workDurationMinutes: 50)
    }
}
// For StandBy: #Preview(traits: .landscapeLeft) { ... }
