//
//  SessionView.swift
//  Tick&Tint
//
//  Created by Nada on 11/05/1448 AH.
//
import SwiftUI

struct SessionView: View {
    
    // Selected session
    @State private var selectedSession = "Short Session"
    
    // Number of rounds
    @State private var rounds = 1
    
    var body: some View {
        
        ZStack {
            
            // Background
            offWhite
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // Page Title
                Text("Choose Your Session")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 40)
                
                Spacer()
                    .frame(height: 100)
                
                // Session Cards
                HStack(spacing: 15) {
                    
                    // Short Session Card
                    Button(action: {
                        
                        selectedSession = "Short Session"
                        
                    }) {
                        
                        VStack(spacing: 8) {
                            
                            Text("Short Session")
                                .font(.system(size: 15, weight: .bold))
                            
                            Text("25-minutes Focus")
                                .font(.system(size: 12))
                            
                            Text("5-minutes Break")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 125)
                        .background(coralOrange)
                        .cornerRadius(15)
                        .overlay {
                            
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(
                                    selectedSession == "Short Session"
                                    ? navyBlue
                                    : Color.clear,
                                    lineWidth: 3
                                )
                        }
                    }
                    .buttonStyle(.plain)
                    
                    // Long Session Card
                    Button(action: {
                        
                        selectedSession = "Long Session"
                        
                    }) {
                        
                        VStack(spacing: 8) {
                            
                            Text("Long Session")
                                .font(.system(size: 15, weight: .bold))
                            
                            Text("50-minutes Focus")
                                .font(.system(size: 12))
                            
                            Text("10-minutes Break")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 125)
                        .background(coralOrange)
                        .cornerRadius(15)
                        .overlay {
                            
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(
                                    selectedSession == "Long Session"
                                    ? navyBlue
                                    : Color.clear,
                                    lineWidth: 3
                                )
                        }
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                    .frame(height: 35)
                
                // Rounds Title
                Text("Rounds")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                // Rounds Selector
                HStack(spacing: 20) {
                    
                    // Decrease rounds
                    Button(action: {
                        
                        if rounds > 1 {
                            rounds -= 1
                        }
                        
                    }) {
                        
                        Image(systemName: "minus")
                            .foregroundColor(.black)
                    }
                    
                    // Current number of rounds
                    Text("\(rounds)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(navyBlue)
                    
                    // Increase rounds
                    Button(action: {
                        
                        if rounds < 10 {
                            rounds += 1
                        }
                        
                    }) {
                        
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                    }
                }
                .padding(.top, 10)
                
                Spacer()
                
                // Start Button
                Button(action: {
                    
                    print("Selected Session: \(selectedSession)")
                    print("Number of Rounds: \(rounds)")
                    
                }) {
                    
                    Text("Start")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(navyBlue)
                        .cornerRadius(25)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
        }
    }
}
