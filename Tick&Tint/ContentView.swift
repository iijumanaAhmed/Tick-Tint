//
//  ContentView.swift
//  Tick&Tint
//
//  Created by Nada on 14/05/1448 AH.
// 


import SwiftUI

enum AppRoute: Hashable {
    case session
    case category(totalRounds: Int, workDurationMinutes: Int, category: String)
    case timer(round: Int, totalRounds: Int, workDurationMinutes: Int, category: String)
    case breakTimer(totalRounds: Int, rounds: Int, workDurationMinutes: Int, category: String)
    case endOfSession(url: URL)
}

struct ContentView: View {
    @State private var navigationPath: [AppRoute] = []
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            IntroView(onBegin: {
                navigationPath.append(.session)
            })
            .navigationDestination(for: AppRoute.self) { route in
                
                switch route {
                case .session:
                    SessionView(navigationPath: $navigationPath)
                    
                case .category(let rounds, let duration, let category):
                    CategoryView(
                        totalRounds: rounds,
                        workDurationMinutes: duration,
                        paintingType: category,
                        navigationPath: $navigationPath)
                    
                case .timer(let rounds, let totalRounds, let duration, let category):
                    FocusTimerScreen(
                        round: rounds,
                        totalRounds: totalRounds,
                        workDurationMinutes: duration,
                        paintingType: category,
                        navigationPath: $navigationPath)
                    
                case .breakTimer(let total, let rounds, let duration, let category):
                    BreakView(
                        totalRounds: total,
                        rounds: rounds,
                        workDurationMinutes: duration,
                        paintingType: category,
                        navigationPath: $navigationPath
                    )
                case .endOfSession(let url):
                    EndOfSessionView(
                        savedArtworkURL: url,
                        navigationPath: $navigationPath
                    )
                }
            }
        }
    }
}

struct IntroView: View {
    let onBegin: () -> Void
    @State private var isVisible = false
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    // Orange top section
                    VStack(spacing: 0) {
                        Color.secondaryBrand
                            .frame(height: geometry.size.height * 0.48)
                        
                        Spacer()
                    }
                    .ignoresSafeArea()
                    
                    // Main content
                    VStack(spacing: AppSpacing.large) {
                        Spacer()
                        
                        // App Logo
                        Image(.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                        
                        // Tagline
                        Text("Where Creativity Meets\nConsistency.")
                            .font(.system(size: AppFonts.title1, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.primaryText)
                        
                        Spacer()
                        
                        // Begin button
                        Button(action: onBegin) {
                            
                            Text("Begin Your Journey")
                                .font(.system(size: AppFonts.body, weight: .medium))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(Color.primaryBrand)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 55)
                        .padding(.bottom, 95)
                    }
                    .padding(.top, 100)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .opacity(isVisible ? 1 : 0)
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.25)) {
                isVisible = true
            }
        }
    }
}

#Preview {
    ContentView()
}
