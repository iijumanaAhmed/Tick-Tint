//
//  SessionView.swift
//  Tick&Tint
//
//  Created by Nada on 11/05/1448 AH.
//

import SwiftUI

struct SessionView: View {

    // Selected session (empty = nothing chosen yet)
    @State private var selectedSession = ""

    // Number of rounds
    @State private var rounds = 1

    // Darker coral (like a shadow) for the chosen card
    private let secondaryBrandSelected = Color(hex: "D65A43")

    var body: some View {

        ZStack {

            // Background
            Color.appBackground
                .ignoresSafeArea()

            // Decorative shapes (Path1, Path2, Path3)
            DecorativeBlobs()

            VStack(spacing: 0) {

                // Page Title
                Text("Choose Your Session")
                    .font(.system(size: AppFonts.title1, weight: .bold))   // CHANGED: title2 -> title1 (28, as in the sketch)
                    .foregroundStyle(Color.primaryText)
                    .padding(.top, AppSpacing.topHeaderOffset + AppSpacing.large)   // CHANGED: 40 -> 80

                Spacer()
                    .frame(height: 150)                                    // CHANGED: 100 -> 150

                // Session Cards
                HStack(spacing: AppSpacing.medium - 1) {

                    // Short Session Card
                    Button(action: {
                        selectedSession = "Short Session"
                    }) {
                        VStack(spacing: AppSpacing.small) {
                            Text("Short Session")
                                .font(.system(size: AppFonts.subheadline, weight: .bold))

                            Text("25-minutes Focus")
                                .font(.system(size: AppFonts.caption))

                            Text("5-minutes Break")
                                .font(.system(size: AppFonts.caption))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 170)                                // CHANGED: 125 -> 170
                        .background(
                            selectedSession == "Short Session"
                                ? secondaryBrandSelected                    // chosen card turns darker coral
                                : Color.secondaryBrand                     // card is coral until chosen
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))     // CHANGED: 15 -> 20
                        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)   // NEW: soft shadow
                    }
                    .buttonStyle(.plain)

                    // Long Session Card
                    Button(action: {
                        selectedSession = "Long Session"
                    }) {
                        VStack(spacing: AppSpacing.small) {
                            Text("Long Session")
                                .font(.system(size: AppFonts.subheadline, weight: .bold))

                            Text("50-minutes Focus")
                                .font(.system(size: AppFonts.caption))

                            Text("10-minutes Break")
                                .font(.system(size: AppFonts.caption))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 170)                                // CHANGED: 125 -> 170
                        .background(
                            selectedSession == "Long Session"
                                ? secondaryBrandSelected                    // chosen card turns darker coral
                                : Color.secondaryBrand                     // card is coral until chosen
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))     // CHANGED: 15 -> 20
                        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)   // NEW
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, AppSpacing.screenPadding)

                Spacer()
                    .frame(height: 35)

                // Rounds Title
                Text("Rounds")
                    .font(.system(size: AppFonts.body, weight: .semibold))
                    .foregroundStyle(Color.secondaryText)                  // CHANGED: primaryText -> secondaryText

                // Rounds Selector (white pill)                            // CHANGED
                HStack(spacing: AppSpacing.small) {

                    // Decrease rounds
                    Button(action: {
                        if rounds > 1 {
                            rounds -= 1
                        }
                    }) {
                        Image(systemName: "minus")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.graySec2)
                    }

                    // Current number of rounds (white number in a blue circle)
                    Text("\(rounds)")
                        .font(.system(size: AppFonts.headline, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 26, height: 26)
                        .background(Circle().fill(Color.primaryBrand))

                    // Increase rounds
                    Button(action: {
                        if rounds < 10 {
                            rounds += 1
                        }
                    }) {
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

                // Start Button
                Button(action: {
                    print("Selected Session: \(selectedSession)")
                    print("Number of Rounds: \(rounds)")
                }) {
                    Text("Start")
                        .font(.system(size: AppFonts.body, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)                                 // CHANGED: 50 -> 44
                        .background(Color.primaryBrand)
                        .clipShape(Capsule())
                }
                .disabled(selectedSession.isEmpty)                         // NEW: can't start before choosing
                .opacity(selectedSession.isEmpty ? 0.5 : 1)                // NEW: looks faded until then
                .padding(.horizontal, 55)                                  // CHANGED: 30 -> 55
                .padding(.bottom, 95)                                      // CHANGED: 30 -> 95
            }
        }
    }
}

import SwiftUI

struct DecorativeBlobs: View {

    // A fade from the top of a shape to its bottom.
    // 1 = fully visible, 0 = invisible.
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
