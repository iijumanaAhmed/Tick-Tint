//
//  SessionView.swift
//  Tick&Tint
//
//  Created by Nada on 14/05/1448 AH.
//

import SwiftUI

struct SessionView: View {
    // Empty means no session has been selected yet
    @State private var selectedSession = ""
    
    // Number of rounds
    @State private var rounds = 1
    
    // Shared navigation path
    @Binding var navigationPath: [AppRoute]
    
    // Selected focus duration
    private var workDurationMinutes: Int {
        selectedSession == "Long Session" ? 50 : 25
    }
    
    var body: some View {
        ZStack {
            // Background
            Color.appBackground
                .ignoresSafeArea()
            
            // Decorative background shapes
            DecorativeBlobs()
            VStack(spacing: 0) {
                // Page title
                Text("Choose Your Session")
                    .font(.system(size: AppFonts.title1, weight: .bold))
                    .foregroundStyle(Color.primaryText)
                    .padding(.top, AppSpacing.topHeaderOffset + AppSpacing.large)
                
                Spacer()
                    .frame(height: 150)
                
                // Session cards
                HStack(spacing: AppSpacing.medium - 1) {
                    // Short Session
                    SessionCard(
                        title: "Short Session",
                        focusText: "25-minutes Focus",
                        breakText: "5-minutes Break",
                        isSelected: selectedSession == "Short Session"
                    ) {
                        selectedSession = "Short Session"
                    }
                    
                    // Long Session
                    SessionCard(
                        title: "Long Session",
                        focusText: "50-minutes Focus",
                        breakText: "10-minutes Break",
                        isSelected: selectedSession == "Long Session"
                    ) {
                        selectedSession = "Long Session"
                    }
                }
                .padding(.horizontal, AppSpacing.screenPadding)
                
                Spacer()
                    .frame(height: 35)
                
                // Rounds title
                Text("Rounds")
                    .font(.system(size: AppFonts.body, weight: .semibold))
                    .foregroundStyle(Color.secondaryText)
                
                // Rounds selector
                HStack(spacing: AppSpacing.small) {
                    // Decrease rounds
                    Button {
                        if rounds > 1 {
                            rounds -= 1
                        }
                    } label: {
                        Image(systemName: "minus")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.graySec2)
                    }
                    
                    // Current number of rounds
                    Text("\(rounds)")
                        .font(.system(size: AppFonts.headline, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 26, height: 26)
                        .background(Circle().fill(Color.primaryBrand))
                    
                    // Increase rounds
                    Button {
                        if rounds < 10 {
                            rounds += 1
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.graySec2)
                    }
                }
                .padding(.horizontal, AppSpacing.small + 2)
                .padding(.vertical, 5)
                .background(Capsule().fill(Color.white))
                .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 3)
                .padding(.top, AppSpacing.small + 2)
                
                Spacer()
                
                // Navigate to CategoryView
                Button {
                    navigationPath.append(
                        .category(
                            totalRounds: rounds,
                            workDurationMinutes: workDurationMinutes
                        )
                    )
                } label: {
                    Text("Start")
                        .font(.system(size: AppFonts.body, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.primaryBrand)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .disabled(selectedSession.isEmpty)
                .opacity(selectedSession.isEmpty ? 0.5 : 1)
                .padding(.horizontal, 55)
                .padding(.bottom, 95)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

// One session card (used for both Short and Long)
struct SessionCard: View {
    let title: String
    let focusText: String
    let breakText: String
    let isSelected: Bool
    let onTap: () -> Void
    
    // Darker coral for the selected card
    private let secondaryBrandSelected = Color(hex: "D65A43")
    
    var body: some View {
        Button {
            onTap()
        } label: {
            
            VStack(spacing: AppSpacing.small) {
                
                Text(title)
                    .font(.system(size: AppFonts.subheadline, weight: .bold))
                
                Text(focusText)
                    .font(.system(size: AppFonts.caption))
                
                Text(breakText)
                    .font(.system(size: AppFonts.caption))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 170)
            .background(isSelected ? secondaryBrandSelected : Color.secondaryBrand)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        SessionView(navigationPath: .constant([]))
    }
}

struct DecorativeBlobs: View {
    
    private func fade(from top: Double, to bottom: Double) -> LinearGradient {
        LinearGradient(
            colors: [Color.black.opacity(top), Color.black.opacity(bottom)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var body: some View {
        ZStack {
            // Top-left shape: strong at the top, fades out going down
            Image("Path2")
                .mask(fade(from: 1, to: 0.1))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.top, 45)
            
            // Right shape: faint at the top, gets stronger going down
            Image("Path1")
                .mask(fade(from: 0.1, to: 1))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.top, 182)
            
            // Bottom-left shape: strong at the top, fades out going down
            Image("Path3")
                .mask(fade(from: 1, to: 0.1))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}
