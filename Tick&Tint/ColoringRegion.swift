import SwiftUI
import CoreGraphics

struct ColoringRegion: Identifiable {
    let id: String
    let number: Int
    let color: Color
    let path: CGPath
}
