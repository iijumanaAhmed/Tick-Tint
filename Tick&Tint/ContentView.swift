//
//  ContentView.swift
//  Tick&Tint
//
//  Created by Nada on 11/05/1448 AH.
//

import SwiftUI

struct ContentView: View {
    // false = intro screen, true = session screen
    @State private var showSession = false

    var body: some View {
        ZStack {
            if showSession {
                SessionView()
                    .transition(.opacity)
            } else {
                IntroView(onBegin: {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        showSession = true
                    }
                })
                .transition(.opacity)
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
                    VStack(spacing: 0) {
                        Color.secondaryBrand
                            .frame(height: geometry.size.height * 0.48)
                        Spacer()
                    }
                    .ignoresSafeArea()

                    VStack(spacing: AppSpacing.large) {
                        Spacer()

                        Image(.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)

                        Text("Where Creativity Meets\nConsistency.")
                            .font(.system(
                                size: AppFonts.title1,
                                weight: .bold
                            ))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.primaryText)

                        Spacer()

                        Button(action: onBegin) {
                            Text("Begin Your Journey")
                                .font(.system(
                                    size: AppFonts.body,
                                    weight: .medium
                                ))
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
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
                }
            }
            .opacity(isVisible ? 1 : 0)
        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.0)) {
                isVisible = true
            }
        }
    }
}
