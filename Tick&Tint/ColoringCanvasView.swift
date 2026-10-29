import SwiftUI
import CoreGraphics

struct ColoringCanvasView: View {
    let selectedNumber: Int
    @Binding var regionColors: [String: Color]
    let regions: [ColoringRegion]
    
    // MARK: - Zoom State
    @State private var zoomScale: CGFloat = 1.0
    @State private var lastZoomScale: CGFloat = 1.0
    @State private var panOffset: CGSize = .zero
    @State private var lastPanOffset: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            let baseScale = min(
                geometry.size.width / ColoringArtwork.width,
                geometry.size.height / ColoringArtwork.height
            )
            
            let scale = baseScale * zoomScale
            
            let offsetX =
            (geometry.size.width - ColoringArtwork.width * scale) / 2
            + panOffset.width
            
            let offsetY =
            (geometry.size.height - ColoringArtwork.height * scale) / 2
            + panOffset.height
            
            Canvas { context, _ in
                for region in regions {
                    let transform = CGAffineTransform(
                        scaleX: scale,
                        y: scale
                    ).concatenating(
                        CGAffineTransform(
                            translationX: offsetX,
                            y: offsetY
                        )
                    )
                    
                    let path = Path(region.path).applying(transform)
                    let isColored = regionColors[region.id] != nil
                    let isSelected = region.number == selectedNumber
                    let bounds = path.boundingRect
                    
                    // Fill the region.
                    if let color = regionColors[region.id] {
                        context.fill(path, with: .color(color))
                    } else if isSelected {
                        context.fill(
                            path,
                            with: .color(region.color.opacity(0.28))
                        )
                    } else {
                        context.fill(path, with: .color(.white))
                    }
                    
                    // Outline the region.
                    let outlineColor: Color =
                    isSelected && !isColored ? region.color : .black
                    
                    context.stroke(
                        path,
                        with: .color(outlineColor),
                        lineWidth: isSelected && !isColored ? 4 : 2
                    )
                    
                    // Display the number on uncolored regions.
                    if !isColored {
                        let numberText = Text("\(region.number)")
                            .font(
                                .system(
                                    size: max(10, 18 * scale),
                                    weight: isSelected ? .bold : .medium
                                )
                            )
                            .foregroundColor(.black)
                        
                        context.draw(
                            numberText,
                            at: CGPoint(
                                x: bounds.midX,
                                y: bounds.midY
                            )
                        )
                    }
                }
            }
            .contentShape(Rectangle())
            .gesture(
                SpatialTapGesture()
                    .onEnded { value in
                        guard scale > 0 else { return }
                        
                        let artworkPoint = CGPoint(
                            x: (value.location.x - offsetX) / scale,
                            y: (value.location.y - offsetY) / scale
                        )
                        
                        if let region = regions.reversed().first(
                            where: { $0.path.contains(artworkPoint) }
                        ) {
                            if region.number == selectedNumber,
                               regionColors[region.id] == nil {
                                regionColors[region.id] = region.color
                            }
                        }
                    }
            )
            .simultaneousGesture(
                DragGesture(minimumDistance: 5)
                    .onChanged { value in
                        guard zoomScale > 1.0 else { return }
                        
                        panOffset = CGSize(
                            width: lastPanOffset.width + value.translation.width,
                            height: lastPanOffset.height + value.translation.height
                        )
                    }
                    .onEnded { _ in
                        lastPanOffset = panOffset
                    }
            )
            .simultaneousGesture(
                MagnificationGesture()
                    .onChanged { value in
                        zoomScale = min(
                            max(lastZoomScale * value, 1.0),
                            4.0
                        )
                    }
                    .onEnded { _ in
                        lastZoomScale = zoomScale
                    }
            )
        }
        .aspectRatio(
            ColoringArtwork.width / ColoringArtwork.height,
            contentMode: .fit
        )
        .clipped()
    }
}
