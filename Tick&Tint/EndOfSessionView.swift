import SwiftUI

struct EndOfSessionView: View {
    let savedArtworkURL: URL
    var body: some View {
        
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack (spacing: AppSpacing.small) {
                Text("Great Work!")
                    .font(
                        .system(
                            size: AppFonts.title1,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(Color.primaryText)
                
                Text("All Sessions are Completed")
                    .font(
                        .system(size: AppFonts.headline)
                    )
                    .foregroundStyle(Color.primaryText)
                Text("You showed up, you focused, and you made progress.\nThat’s a win!")
                    .font(
                        .system(size: AppFonts.caption)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.primaryText)
                    .padding(.top, AppSpacing.extraLarge)
                
                
                if let image = UIImage(contentsOfFile: savedArtworkURL.path) {
                    
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .padding()
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
                    
                } else {
                    Text("No saved artwork found.")
                        .foregroundStyle(.secondary)
                }
                
                Button {
                    // redirect to nada's first screen
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.primaryBrand, in: Circle())
                }
                .padding(.top, AppSpacing.small)

                
            }
            .padding(.horizontal, AppSpacing.screenPadding)
            

        }
        
    }
}

