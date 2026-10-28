//
//  SessionView.swift
//  Tick&Tint
//
//  Created by Nada on 11/05/1448 AH.
//

import SwiftUI

struct SessionView: View {

    @State private var selectedSession = ""
    @State private var rounds = 1
    @State private var navigateToTimer = false // تم إضافة هذا المتغير للربط

    private let secondaryBrandSelected = Color(hex: "D65A43")

    var body: some View {
        NavigationStack { // تم إضافة حاوية التنقل هنا لربط الصفحات
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()

                DecorativeBlobs()

                VStack(spacing: 0) {
                    Text("Choose Your Session")
                        .font(.system(size: AppFonts.title1, weight: .bold))
                        .foregroundStyle(Color.primaryText)
                        .padding(.top, AppSpacing.topHeaderOffset + AppSpacing.large)

                    Spacer()
                        .frame(height: 150)

                    HStack(spacing: AppSpacing.medium - 1) {
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
                            .frame(height: 170)
                            .background(
                                selectedSession == "Short Session"
                                    ? secondaryBrandSelected
                                    : Color.secondaryBrand
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                        }
                        .buttonStyle(.plain)

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
                            .frame(height: 170)
                            .background(
                                selectedSession == "Long Session"
                                    ? secondaryBrandSelected
                                    : Color.secondaryBrand
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, AppSpacing.screenPadding)

                    Spacer()
                        .frame(height: 35)

                    Text("Rounds")
                        .font(.system(size: AppFonts.body, weight: .semibold))
                        .foregroundStyle(Color.secondaryText)

                    HStack(spacing: AppSpacing.small) {
                        Button(action: {
                            if rounds > 1 {
                                rounds -= 1
                            }
                        }) {
                            Image(systemName: "minus")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.graySec2)
                        }

                        Text("\(rounds)")
                            .font(.system(size: AppFonts.headline, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 26, height: 26)
                            .background(Circle().fill(Color.primaryBrand))

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

                    Button(action: {
                        navigateToTimer = true // تفعيل الانتقال عند الضغط على Start
                    }) {
                        Text("Start")
                            .font(.system(size: AppFonts.body, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.primaryBrand)
                            .clipShape(Capsule())
                    }
                    .disabled(selectedSession.isEmpty)
                    .opacity(selectedSession.isEmpty ? 0.5 : 1)
                    .padding(.horizontal, 55)
                    .padding(.bottom, 95)
                }
            }
            .navigationDestination(isPresented: $navigateToTimer) {
                // تمرير إجمالي الجولات ووقت التركيز بناءً على اختيار المستخدم (25 دقيقة أو 50 دقيقة)
                let duration = (selectedSession == "Short Session") ? 25 : 50
                FocusTimerScreen(totalRounds: rounds, workDurationMinutes: duration)
            }
        }
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
            Image("Path2")
                .mask(fade(from: 1, to: 0.1))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.top, 45)

            Image("Path1")
                .mask(fade(from: 0.1, to: 1))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.top, 182)

            Image("Path3")
                .mask(fade(from: 1, to: 0.1))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}
