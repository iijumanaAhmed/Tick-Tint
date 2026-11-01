import SwiftUI

@main
struct MyApp: App {
    @StateObject private var soundManager = SoundManager()
    var body: some Scene {
       
        WindowGroup {
            ContentView()
                .environmentObject(soundManager)
        }
    }
}
