import SwiftUI

// App Colors
let coralOrange = Color(
    red: 242.0 / 255.0,
    green: 118.0 / 255.0,
    blue: 94.0 / 255.0
)

let navyBlue = Color(
    red: 49.0 / 255.0,
    green: 91.0 / 255.0,
    blue: 140.0 / 255.0
)

let offWhite = Color(
    red: 255.0 / 255.0,
    green: 251.0 / 255.0,
    blue: 250.0 / 255.0
)

struct ContentView: View {
    
    var body: some View {
        
        NavigationStack {
            
            GeometryReader { geometry in
                
                ZStack(alignment: .top) {
                    
                    // Background
                    offWhite
                        .ignoresSafeArea()
                    
                    // Orange top section
                    VStack(spacing: 0) {
                        
                        coralOrange
                            .frame(height: geometry.size.height * 0.48)
                        
                        Spacer()
                    }
                    .ignoresSafeArea()
                    
                    // Main content
                    ZStack(alignment: .top) {
                        
                        // App Logo
                        Image(.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .clipShape(Circle())
                            .position(
                                x: geometry.size.width / 2,
                                y: geometry.size.height * 0.40
                            )
                        
                        // Tagline
                        Text("Where Creativity Meets\nConsistency.")
                            .font(.system(size: 20, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .position(
                                x: geometry.size.width / 2,
                                y: geometry.size.height * 0.56
                            )
                        
                        // Begin Your Journey button
                        NavigationLink(destination: SessionView()) {
                            
                            Text("Begin Your Journey")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width * 0.78)
                                .frame(height: 50)
                                .background(navyBlue)
                                .cornerRadius(25)
                                .contentShape(Capsule())
                        }
                        .buttonStyle(.plain)
                        .position(
                            x: geometry.size.width / 2,
                            y: geometry.size.height * 0.66
                        )
                    }
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                }
            }
        }
    }
}
