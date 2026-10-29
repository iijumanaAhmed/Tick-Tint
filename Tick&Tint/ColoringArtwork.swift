import SwiftUI
import CoreGraphics

// MARK: - Universal Palette
enum UniversalPalette {
    static let colors: [(number: Int, color: Color)] = [
        (1,  Color(red: 0.949, green: 0.757, blue: 0.306)), // Golden yellow
        (2,  Color(red: 0.212, green: 0.365, blue: 0.608)), // Deep blue
        (3,  Color(red: 0.914, green: 0.663, blue: 0.753)), // Soft pink
        (4,  Color(red: 0.204, green: 0.318, blue: 0.227)), // Dark green
        (5,  Color(red: 1.000, green: 0.941, blue: 0.847)), // Cream
        (6,  Color(red: 0.784, green: 0.247, blue: 0.310)), // Red
        (7,  Color(red: 0.471, green: 0.722, blue: 0.871)), // Sky blue
        (8,  Color(red: 0.439, green: 0.290, blue: 0.557)), // Purple
        (9,  Color(red: 0.851, green: 0.725, blue: 0.549)), // Sand
        (10, Color(red: 0.435, green: 0.596, blue: 0.294)), // Leaf green
        
        (11, Color(red: 0.271, green: 0.271, blue: 0.294)), // Charcoal
        (12, Color(red: 0.937, green: 0.545, blue: 0.208)), // Orange
        (13, Color(red: 0.659, green: 0.804, blue: 0.690)), // Mint
        (14, Color(red: 0.150, green: 0.250, blue: 0.450)), // Navy blue
        (15, Color(red: 0.914, green: 0.510, blue: 0.475)), // Coral
        (16, Color(red: 0.635, green: 0.471, blue: 0.310)), // Light brown
        (17, Color(red: 0.663, green: 0.608, blue: 0.835)), // Lavender
        (18, Color(red: 0.980, green: 0.870, blue: 0.420)), // Bright yellow
        (19, Color(red: 0.220, green: 0.549, blue: 0.537)), // Teal
        (20, Color(red: 1.000, green: 1.000, blue: 1.000)), // White
        
        (21, Color(red: 0.769, green: 0.365, blue: 0.227)), // Terracotta
        (22, Color(red: 0.750, green: 0.850, blue: 0.920)), // Light blue
        (23, Color(red: 0.294, green: 0.184, blue: 0.129)), // Dark brown
        (24, Color(red: 0.980, green: 0.780, blue: 0.820)), // Light pink
        (25, Color(red: 0.390, green: 0.470, blue: 0.250)), // Olive
        (26, Color(red: 0.350, green: 0.230, blue: 0.500)), // Dark purple
        (27, Color(red: 0.549, green: 0.506, blue: 0.471)), // Warm gray
        (28, Color(red: 0.320, green: 0.650, blue: 0.590)), // Aqua green
        (29, Color(red: 0.660, green: 0.160, blue: 0.210)), // Dark red
        (30, Color(red: 0.830, green: 0.700, blue: 0.790)), // Light mauve
        
        (31, Color(red: 0.580, green: 0.690, blue: 0.350)), // Fresh green
        (32, Color(red: 0.439, green: 0.290, blue: 0.188)), // Medium brown
        (33, Color(red: 0.330, green: 0.580, blue: 0.760)), // Medium blue
        (34, Color(red: 0.960, green: 0.820, blue: 0.600)), // Warm peach
        (35, Color(red: 0.520, green: 0.420, blue: 0.700)), // Violet
        (36, Color(red: 0.294, green: 0.435, blue: 0.235)), // Forest green
        (37, Color(red: 0.749, green: 0.706, blue: 0.647)), // Beige gray
        (38, Color(red: 0.700, green: 0.690, blue: 0.400)), // Soft olive
        (39, Color(red: 0.780, green: 0.850, blue: 0.650)), // Light green
        (40, Color(red: 0.439, green: 0.290, blue: 0.557))  // Purple
    ]
    
    static func color(for number: Int) -> Color {
        colors.first { $0.number == number }?.color ?? .white
    }
}

// MARK: - Artwork Shapes
enum ArtworkShapes {
    static func region(
        _ id: String,
        _ number: Int,
        _ path: CGPath
    ) -> ColoringRegion {
        ColoringRegion(
            id: id,
            number: number,
            color: UniversalPalette.color(for: number),
            path: path
        )
    }
    
    static func ellipse(
        _ id: String,
        _ number: Int,
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        height: CGFloat
    ) -> ColoringRegion {
        let path = CGMutablePath()
        path.addEllipse(
            in: CGRect(x: x, y: y, width: width, height: height)
        )
        return region(id, number, path)
    }
    
    static func polygon(
        _ id: String,
        _ number: Int,
        points: [CGPoint]
    ) -> ColoringRegion {
        let path = CGMutablePath()
        
        guard let first = points.first else {
            return region(id, number, path)
        }
        
        path.move(to: first)
        
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        
        path.closeSubpath()
        return region(id, number, path)
    }
    
    static func rectangle(
        _ id: String,
        _ number: Int,
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        height: CGFloat
    ) -> ColoringRegion {
        let path = CGMutablePath()
        path.addRect(CGRect(x: x, y: y, width: width, height: height))
        return region(id, number, path)
    }
}

// MARK: - Hardcoded Artworks
enum PaintingCategories {
    case words
    case animals
    case sleepingFox
    case nature
}
enum ColoringArtwork {
    
    static let width: CGFloat = 600
    static let height: CGFloat = 800
    
    // MARK: - Animals: Fox
    static let animals: [ColoringRegion] = [
        ArtworkShapes.polygon("fox_left_ear", 21, points: [
            CGPoint(x: 180, y: 220),
            CGPoint(x: 190, y: 100),
            CGPoint(x: 260, y: 190)
        ]),
        ArtworkShapes.polygon("fox_right_ear", 21, points: [
            CGPoint(x: 340, y: 190),
            CGPoint(x: 410, y: 100),
            CGPoint(x: 420, y: 220)
        ]),
        ArtworkShapes.ellipse(
            "fox_face", 21,
            x: 170, y: 180, width: 260, height: 260
        ),
        ArtworkShapes.ellipse(
            "fox_left_cheek", 34,
            x: 190, y: 300, width: 100, height: 100
        ),
        ArtworkShapes.ellipse(
            "fox_right_cheek", 34,
            x: 310, y: 300, width: 100, height: 100
        ),
        ArtworkShapes.ellipse(
            "fox_left_eye", 23,
            x: 235, y: 270, width: 24, height: 32
        ),
        ArtworkShapes.ellipse(
            "fox_right_eye", 23,
            x: 340, y: 270, width: 24, height: 32
        ),
        ArtworkShapes.polygon("fox_muzzle", 5, points: [
            CGPoint(x: 245, y: 350),
            CGPoint(x: 300, y: 385),
            CGPoint(x: 355, y: 350),
            CGPoint(x: 300, y: 420)
        ]),
        ArtworkShapes.ellipse(
            "fox_nose", 2,
            x: 286, y: 365, width: 28, height: 20
        ),
        ArtworkShapes.ellipse(
            "fox_body", 21,
            x: 190, y: 420, width: 220, height: 220
        ),
        ArtworkShapes.ellipse(
            "fox_belly", 5,
            x: 235, y: 465, width: 130, height: 150
        ),
        ArtworkShapes.ellipse(
            "fox_tail", 21,
            x: 340, y: 500, width: 180, height: 90
        ),
        ArtworkShapes.ellipse(
            "fox_tail_tip", 5,
            x: 450, y: 510, width: 65, height: 70
        ),
        ArtworkShapes.ellipse(
            "fox_left_paw", 21,
            x: 205, y: 610, width: 90, height: 45
        ),
        ArtworkShapes.ellipse(
            "fox_right_paw", 21,
            x: 305, y: 610, width: 90, height: 45
        ),
        ArtworkShapes.ellipse(
            "fox_sun", 1,
            x: 440, y: 70, width: 70, height: 70
        ),
        ArtworkShapes.ellipse(
            "fox_leaf_left", 10,
            x: 65, y: 470, width: 55, height: 95
        ),
        ArtworkShapes.ellipse(
            "fox_leaf_right", 15,
            x: 480, y: 390, width: 55, height: 95
        )
    ]
    
    // MARK: - Animals: Sleeping Fox
    static let sleepingFox: [ColoringRegion] = [
        
        // MARK: Moon and stars
        ArtworkShapes.ellipse(
            "sleeping_fox_moon", 18,
            x: 405, y: 75, width: 95, height: 95
        ),
        
        ArtworkShapes.polygon("sleeping_fox_star_1", 1, points: [
            CGPoint(x: 130, y: 115),
            CGPoint(x: 140, y: 140),
            CGPoint(x: 165, y: 145),
            CGPoint(x: 145, y: 160),
            CGPoint(x: 150, y: 185),
            CGPoint(x: 130, y: 170),
            CGPoint(x: 110, y: 185),
            CGPoint(x: 115, y: 160),
            CGPoint(x: 95, y: 145),
            CGPoint(x: 120, y: 140)
        ]),
        
        ArtworkShapes.polygon("sleeping_fox_star_2", 3, points: [
            CGPoint(x: 480, y: 220),
            CGPoint(x: 490, y: 240),
            CGPoint(x: 510, y: 245),
            CGPoint(x: 493, y: 258),
            CGPoint(x: 498, y: 280),
            CGPoint(x: 480, y: 267),
            CGPoint(x: 462, y: 280),
            CGPoint(x: 467, y: 258),
            CGPoint(x: 450, y: 245),
            CGPoint(x: 470, y: 240)
        ]),
        
        ArtworkShapes.ellipse(
            "sleeping_fox_small_star_1", 24,
            x: 320, y: 105, width: 18, height: 18
        ),
        
        ArtworkShapes.ellipse(
            "sleeping_fox_small_star_2", 7,
            x: 520, y: 145, width: 15, height: 15
        ),
        
        ArtworkShapes.ellipse(
            "sleeping_fox_small_star_3", 1,
            x: 85, y: 230, width: 14, height: 14
        ),
        
        // MARK: Ground and bedding
        ArtworkShapes.ellipse(
            "sleeping_fox_pillow", 22,
            x: 100, y: 570, width: 400, height: 115
        ),
        
        ArtworkShapes.ellipse(
            "sleeping_fox_blanket", 17,
            x: 115, y: 605, width: 365, height: 115
        ),
        
        ArtworkShapes.ellipse(
            "sleeping_fox_ground", 13,
            x: 45, y: 690, width: 510, height: 45
        ),
        
        // MARK: Curled tail — behind the body
        ArtworkShapes.ellipse(
            "sleeping_fox_tail_outer", 21,
            x: 320, y: 405, width: 200, height: 195
        ),
        
        ArtworkShapes.ellipse(
            "sleeping_fox_tail_inner", 23,
            x: 350, y: 435, width: 140, height: 135
        ),
        
        ArtworkShapes.ellipse(
            "sleeping_fox_tail_tip", 5,
            x: 420, y: 465, width: 75, height: 80
        ),
        
        // MARK: Curled body
        ArtworkShapes.ellipse(
            "sleeping_fox_body", 21,
            x: 150, y: 385, width: 290, height: 250
        ),
        
        ArtworkShapes.ellipse(
            "sleeping_fox_belly", 34,
            x: 205, y: 465, width: 175, height: 145
        ),
        
        // MARK: Head
        ArtworkShapes.ellipse(
            "sleeping_fox_head", 21,
            x: 145, y: 285, width: 235, height: 215
        ),
        
        // Outer ears
        ArtworkShapes.polygon("sleeping_fox_left_ear", 21, points: [
            CGPoint(x: 165, y: 355),
            CGPoint(x: 150, y: 245),
            CGPoint(x: 235, y: 320)
        ]),
        
        ArtworkShapes.polygon("sleeping_fox_right_ear", 21, points: [
            CGPoint(x: 295, y: 315),
            CGPoint(x: 365, y: 245),
            CGPoint(x: 350, y: 365)
        ]),
        
        // Inner ears
        ArtworkShapes.polygon("sleeping_fox_left_inner_ear", 24, points: [
            CGPoint(x: 174, y: 322),
            CGPoint(x: 165, y: 270),
            CGPoint(x: 211, y: 318)
        ]),
        
        ArtworkShapes.polygon("sleeping_fox_right_inner_ear", 24, points: [
            CGPoint(x: 309, y: 318),
            CGPoint(x: 350, y: 271),
            CGPoint(x: 337, y: 330)
        ]),
        
        // Face markings
        ArtworkShapes.ellipse(
            "sleeping_fox_left_cheek", 34,
            x: 155, y: 385, width: 100, height: 80
        ),
        
        ArtworkShapes.ellipse(
            "sleeping_fox_right_cheek", 34,
            x: 270, y: 385, width: 85, height: 80
        ),
        
        ArtworkShapes.polygon("sleeping_fox_muzzle", 5, points: [
            CGPoint(x: 220, y: 395),
            CGPoint(x: 265, y: 415),
            CGPoint(x: 305, y: 395),
            CGPoint(x: 285, y: 440),
            CGPoint(x: 250, y: 448),
            CGPoint(x: 225, y: 430)
        ]),
        
        // Closed, peaceful eyes
        ArtworkShapes.polygon("sleeping_fox_left_eye", 23, points: [
            CGPoint(x: 180, y: 370),
            CGPoint(x: 200, y: 382),
            CGPoint(x: 222, y: 370),
            CGPoint(x: 202, y: 392)
        ]),
        
        ArtworkShapes.polygon("sleeping_fox_right_eye", 23, points: [
            CGPoint(x: 270, y: 370),
            CGPoint(x: 290, y: 382),
            CGPoint(x: 312, y: 370),
            CGPoint(x: 292, y: 392)
        ]),
        
        ArtworkShapes.ellipse(
            "sleeping_fox_nose", 23,
            x: 253, y: 408, width: 24, height: 17
        ),
        
        // MARK: Paws tucked beneath the fox
        ArtworkShapes.ellipse(
            "sleeping_fox_front_paw", 34,
            x: 190, y: 555, width: 90, height: 48
        ),
        
        ArtworkShapes.ellipse(
            "sleeping_fox_second_paw", 34,
            x: 270, y: 565, width: 80, height: 42
        ),
        
        ArtworkShapes.ellipse(
            "sleeping_fox_back_paw", 21,
            x: 315, y: 575, width: 75, height: 42
        ),
        
        // MARK: Decorative flowers
        ArtworkShapes.ellipse(
            "sleeping_fox_flower_center", 1,
            x: 90, y: 610, width: 25, height: 25
        ),
        
        ArtworkShapes.ellipse(
            "sleeping_fox_flower_petal_top", 3,
            x: 92, y: 585, width: 22, height: 25
        ),
        
        ArtworkShapes.ellipse(
            "sleeping_fox_flower_petal_left", 24,
            x: 68, y: 607, width: 25, height: 22
        ),
        
        ArtworkShapes.ellipse(
            "sleeping_fox_flower_petal_right", 24,
            x: 112, y: 607, width: 25, height: 22
        ),
        
        ArtworkShapes.ellipse(
            "sleeping_fox_flower_petal_bottom", 3,
            x: 92, y: 632, width: 22, height: 24
        ),
        
        ArtworkShapes.ellipse(
            "sleeping_fox_leaf", 10,
            x: 115, y: 640, width: 25, height: 45
        )
    ]
    
    // MARK: - Words: BREATHE
    static let words: [ColoringRegion] = [
        // B
        ArtworkShapes.rectangle("b_stem", 8, x: 75, y: 160, width: 22, height: 110),
        ArtworkShapes.rectangle("b_top", 15, x: 95, y: 160, width: 45, height: 22),
        ArtworkShapes.rectangle("b_middle", 15, x: 95, y: 205, width: 40, height: 22),
        ArtworkShapes.rectangle("b_bottom", 15, x: 95, y: 248, width: 45, height: 22),
        ArtworkShapes.rectangle("b_upper_side", 15, x: 118, y: 180, width: 22, height: 25),
        ArtworkShapes.rectangle("b_lower_side", 15, x: 118, y: 225, width: 22, height: 25),
        
        // R
        ArtworkShapes.rectangle("r_stem", 7, x: 165, y: 160, width: 22, height: 110),
        ArtworkShapes.rectangle("r_top", 7, x: 185, y: 160, width: 45, height: 22),
        ArtworkShapes.rectangle("r_middle", 7, x: 185, y: 205, width: 45, height: 22),
        ArtworkShapes.rectangle("r_side", 7, x: 208, y: 180, width: 22, height: 25),
        ArtworkShapes.polygon("r_leg", 7, points: [
            CGPoint(x: 190, y: 220),
            CGPoint(x: 212, y: 220),
            CGPoint(x: 240, y: 270),
            CGPoint(x: 215, y: 270)
        ]),
        
        // E
        ArtworkShapes.rectangle("e_stem", 40, x: 265, y: 160, width: 22, height: 110),
        ArtworkShapes.rectangle("e_top", 40, x: 285, y: 160, width: 50, height: 22),
        ArtworkShapes.rectangle("e_middle", 40, x: 285, y: 204, width: 42, height: 22),
        ArtworkShapes.rectangle("e_bottom", 40, x: 285, y: 248, width: 50, height: 22),
        
        // A
        ArtworkShapes.polygon("a_left", 14, points: [
            CGPoint(x: 355, y: 270),
            CGPoint(x: 380, y: 160),
            CGPoint(x: 400, y: 160),
            CGPoint(x: 380, y: 270)
        ]),
        ArtworkShapes.polygon("a_right", 14, points: [
            CGPoint(x: 380, y: 160),
            CGPoint(x: 400, y: 160),
            CGPoint(x: 430, y: 270),
            CGPoint(x: 405, y: 270)
        ]),
        ArtworkShapes.rectangle("a_crossbar", 14, x: 375, y: 220, width: 38, height: 20),
        
        // T
        ArtworkShapes.rectangle("t_top", 19, x: 445, y: 160, width: 75, height: 22),
        ArtworkShapes.rectangle("t_stem", 19, x: 472, y: 180, width: 22, height: 90),
        
        // Decorative accents
        ArtworkShapes.ellipse("word_sun", 18, x: 75, y: 350, width: 70, height: 70),
        ArtworkShapes.ellipse("word_flower", 3, x: 250, y: 370, width: 55, height: 55),
        ArtworkShapes.ellipse("word_leaf", 10, x: 400, y: 350, width: 60, height: 90)
    ]
    
    // MARK: - Nature
    static let nature: [ColoringRegion] = [
        ArtworkShapes.ellipse(
            "nature_sun", 1,
            x: 420, y: 85, width: 100, height: 100
        ),
        ArtworkShapes.polygon("mountain_back", 33, points: [
            CGPoint(x: 40, y: 470),
            CGPoint(x: 210, y: 220),
            CGPoint(x: 380, y: 470)
        ]),
        ArtworkShapes.polygon("mountain_snow", 5, points: [
            CGPoint(x: 160, y: 293),
            CGPoint(x: 210, y: 220),
            CGPoint(x: 260, y: 295),
            CGPoint(x: 225, y: 280),
            CGPoint(x: 205, y: 305),
            CGPoint(x: 185, y: 280)
        ]),
        ArtworkShapes.polygon("mountain_front", 2, points: [
            CGPoint(x: 230, y: 490),
            CGPoint(x: 400, y: 260),
            CGPoint(x: 570, y: 490)
        ]),
        ArtworkShapes.polygon("front_snow", 5, points: [
            CGPoint(x: 355, y: 320),
            CGPoint(x: 400, y: 260),
            CGPoint(x: 445, y: 322),
            CGPoint(x: 415, y: 308),
            CGPoint(x: 400, y: 325),
            CGPoint(x: 382, y: 307)
        ]),
        ArtworkShapes.polygon("back_hill", 39, points: [
            CGPoint(x: 0, y: 470),
            CGPoint(x: 170, y: 410),
            CGPoint(x: 320, y: 480),
            CGPoint(x: 450, y: 420),
            CGPoint(x: 600, y: 470),
            CGPoint(x: 600, y: 800),
            CGPoint(x: 0, y: 800)
        ]),
        ArtworkShapes.polygon("front_hill", 31, points: [
            CGPoint(x: 0, y: 570),
            CGPoint(x: 180, y: 510),
            CGPoint(x: 360, y: 590),
            CGPoint(x: 500, y: 520),
            CGPoint(x: 600, y: 560),
            CGPoint(x: 600, y: 800),
            CGPoint(x: 0, y: 800)
        ]),
        ArtworkShapes.rectangle(
            "tree_trunk", 32,
            x: 75, y: 430, width: 45, height: 210
        ),
        ArtworkShapes.ellipse(
            "tree_top", 36,
            x: 25, y: 350, width: 145, height: 150
        ),
        ArtworkShapes.ellipse(
            "tree_left_leaf", 10,
            x: 10, y: 410, width: 85, height: 95
        ),
        ArtworkShapes.ellipse(
            "tree_right_leaf", 13,
            x: 100, y: 410, width: 85, height: 95
        ),
        ArtworkShapes.ellipse(
            "flower_center", 18,
            x: 440, y: 630, width: 35, height: 35
        ),
        ArtworkShapes.ellipse(
            "flower_petal_top", 3,
            x: 445, y: 600, width: 25, height: 30
        ),
        ArtworkShapes.ellipse(
            "flower_petal_left", 3,
            x: 415, y: 625, width: 30, height: 25
        ),
        ArtworkShapes.ellipse(
            "flower_petal_right", 3,
            x: 470, y: 625, width: 30, height: 25
        ),
        ArtworkShapes.ellipse(
            "flower_petal_bottom", 3,
            x: 445, y: 655, width: 25, height: 30
        ),
        ArtworkShapes.ellipse(
            "nature_cloud_left", 22,
            x: 80, y: 100, width: 100, height: 45
        ),
        ArtworkShapes.ellipse(
            "nature_cloud_right", 22,
            x: 130, y: 85, width: 100, height: 60
        )
    ]
}
