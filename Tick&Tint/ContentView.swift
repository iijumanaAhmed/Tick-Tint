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
                    // Fade from the intro to the session screen
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
    
    // Runs when the user taps "Begin Your Journey"
    let onBegin: () -> Void
    
    // Controls the fade-in when the intro first appears
    @State private var isVisible = false
    
    var body: some View {
        
        ZStack {
            
            // Background (stays still, the rest fades in on top of it)
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
                            .font(.system(
                                size: AppFonts.title1,
                                weight: .bold
                            ))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.primaryText)
                        
                        Spacer()
                        
                        // Begin Your Journey button
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
            // Fade-in effect: starts invisible, then becomes visible
            .opacity(isVisible ? 1 : 0)
        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.0)) {
                isVisible = true
            }
        }
    }
}
