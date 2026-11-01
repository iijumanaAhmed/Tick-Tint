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
    case cat
    case owl
    case robot
    case dream
    case nature
}
enum ColoringArtwork {
    
    static let width: CGFloat = 500
    static let height: CGFloat = 500
    
    // MARK: - Cat 🐱 (01-cat.svg) — Cool Electric & Pastel Cyan Sky
    static let cat: [ColoringRegion] = [
        // Background Sunburst Rays (Alternating Sky Blue [7], Aqua Green [28], Soft Pink [3], & Bright Yellow [18])
        ArtworkShapes.polygon("cat_bg_ray_1", 7, points: [CGPoint(x: 0, y: 0), CGPoint(x: 80, y: 0), CGPoint(x: 250, y: 250), CGPoint(x: 0, y: 90)]),
        ArtworkShapes.polygon("cat_bg_ray_2", 28, points: [CGPoint(x: 80, y: 0), CGPoint(x: 160, y: 0), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("cat_bg_ray_3", 3, points: [CGPoint(x: 160, y: 0), CGPoint(x: 240, y: 0), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("cat_bg_ray_4", 18, points: [CGPoint(x: 240, y: 0), CGPoint(x: 320, y: 0), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("cat_bg_ray_5", 7, points: [CGPoint(x: 320, y: 0), CGPoint(x: 400, y: 0), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("cat_bg_ray_6", 28, points: [CGPoint(x: 400, y: 0), CGPoint(x: 500, y: 0), CGPoint(x: 500, y: 80), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("cat_bg_ray_7", 3, points: [CGPoint(x: 500, y: 80), CGPoint(x: 500, y: 170), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("cat_bg_ray_8", 18, points: [CGPoint(x: 500, y: 170), CGPoint(x: 500, y: 250), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("cat_bg_ray_9", 7, points: [CGPoint(x: 500, y: 250), CGPoint(x: 500, y: 330), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("cat_bg_ray_10", 28, points: [CGPoint(x: 500, y: 330), CGPoint(x: 500, y: 420), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("cat_bg_ray_11", 3, points: [CGPoint(x: 500, y: 420), CGPoint(x: 500, y: 500), CGPoint(x: 410, y: 500), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("cat_bg_ray_12", 18, points: [CGPoint(x: 410, y: 500), CGPoint(x: 320, y: 500), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("cat_bg_ray_13", 7, points: [CGPoint(x: 320, y: 500), CGPoint(x: 230, y: 500), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("cat_bg_ray_14", 28, points: [CGPoint(x: 230, y: 500), CGPoint(x: 140, y: 500), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("cat_bg_ray_15", 3, points: [CGPoint(x: 140, y: 500), CGPoint(x: 50, y: 500), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("cat_bg_ray_16", 18, points: [CGPoint(x: 50, y: 500), CGPoint(x: 0, y: 500), CGPoint(x: 0, y: 410), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("cat_bg_ray_17", 7, points: [CGPoint(x: 0, y: 410), CGPoint(x: 0, y: 320), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("cat_bg_ray_18", 28, points: [CGPoint(x: 0, y: 320), CGPoint(x: 0, y: 230), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("cat_bg_ray_19", 3, points: [CGPoint(x: 0, y: 230), CGPoint(x: 0, y: 140), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("cat_bg_ray_20", 18, points: [CGPoint(x: 0, y: 140), CGPoint(x: 0, y: 50), CGPoint(x: 250, y: 250)]),

        // Stars & Sparkles
        ArtworkShapes.polygon("cat_star_left", 18, points: [
            CGPoint(x: 65, y: 80), CGPoint(x: 75, y: 100), CGPoint(x: 95, y: 102),
            CGPoint(x: 80, y: 115), CGPoint(x: 85, y: 135), CGPoint(x: 65, y: 122),
            CGPoint(x: 45, y: 135), CGPoint(x: 50, y: 115), CGPoint(x: 35, y: 102), CGPoint(x: 55, y: 100)
        ]),
        ArtworkShapes.polygon("cat_star_right", 18, points: [
            CGPoint(x: 430, y: 95), CGPoint(x: 440, y: 115), CGPoint(x: 460, y: 117),
            CGPoint(x: 445, y: 130), CGPoint(x: 450, y: 150), CGPoint(x: 430, y: 137),
            CGPoint(x: 410, y: 150), CGPoint(x: 415, y: 130), CGPoint(x: 400, y: 117), CGPoint(x: 420, y: 115)
        ]),
        ArtworkShapes.polygon("cat_sparkle_left", 20, points: [
            CGPoint(x: 60, y: 150), CGPoint(x: 68, y: 162), CGPoint(x: 80, y: 170),
            CGPoint(x: 68, y: 178), CGPoint(x: 60, y: 190), CGPoint(x: 52, y: 178),
            CGPoint(x: 40, y: 170), CGPoint(x: 52, y: 162)
        ]),
        ArtworkShapes.polygon("cat_sparkle_right", 20, points: [
            CGPoint(x: 435, y: 155), CGPoint(x: 443, y: 167), CGPoint(x: 455, y: 175),
            CGPoint(x: 443, y: 183), CGPoint(x: 435, y: 195), CGPoint(x: 427, y: 183),
            CGPoint(x: 415, y: 175), CGPoint(x: 427, y: 167)
        ]),

        // Ears
        ArtworkShapes.polygon("cat_left_outer_ear", 12, points: [
            CGPoint(x: 115, y: 65), CGPoint(x: 230, y: 140), CGPoint(x: 135, y: 180)
        ]),
        ArtworkShapes.polygon("cat_left_inner_ear", 5, points: [
            CGPoint(x: 135, y: 88), CGPoint(x: 212, y: 140), CGPoint(x: 150, y: 168)
        ]),
        ArtworkShapes.polygon("cat_right_outer_ear", 12, points: [
            CGPoint(x: 385, y: 65), CGPoint(x: 270, y: 140), CGPoint(x: 365, y: 180)
        ]),
        ArtworkShapes.polygon("cat_right_inner_ear", 5, points: [
            CGPoint(x: 365, y: 88), CGPoint(x: 288, y: 140), CGPoint(x: 350, y: 168)
        ]),

        // Head
        ArtworkShapes.ellipse("cat_head", 34, x: 105, y: 135, width: 290, height: 250),

        // Forehead Stripes
        ArtworkShapes.ellipse("cat_forehead_stripe_center", 21, x: 242, y: 155, width: 16, height: 45),
        ArtworkShapes.ellipse("cat_forehead_stripe_left", 21, x: 212, y: 160, width: 15, height: 40),
        ArtworkShapes.ellipse("cat_forehead_stripe_right", 21, x: 273, y: 160, width: 15, height: 40),

        // Eyes
        ArtworkShapes.ellipse("cat_left_eye_outer", 20, x: 165, y: 218, width: 64, height: 64),
        ArtworkShapes.ellipse("cat_left_eye_iris", 7, x: 177, y: 230, width: 40, height: 40),
        ArtworkShapes.ellipse("cat_left_eye_pupil", 11, x: 187, y: 240, width: 20, height: 20),
        ArtworkShapes.ellipse("cat_right_eye_outer", 20, x: 271, y: 218, width: 64, height: 64),
        ArtworkShapes.ellipse("cat_right_eye_iris", 7, x: 283, y: 230, width: 40, height: 40),
        ArtworkShapes.ellipse("cat_right_eye_pupil", 11, x: 293, y: 240, width: 20, height: 20),

        // Cheeks, Muzzle, Nose
        ArtworkShapes.ellipse("cat_left_cheek", 3, x: 125, y: 282, width: 42, height: 32),
        ArtworkShapes.ellipse("cat_right_cheek", 3, x: 333, y: 282, width: 42, height: 32),
        ArtworkShapes.ellipse("cat_muzzle", 5, x: 202, y: 280, width: 96, height: 60),
        ArtworkShapes.polygon("cat_nose", 15, points: [
            CGPoint(x: 234, y: 290), CGPoint(x: 266, y: 290), CGPoint(x: 250, y: 308)
        ]),

        // Collar & Bell
        ArtworkShapes.polygon("cat_collar", 8, points: [
            CGPoint(x: 135, y: 368), CGPoint(x: 365, y: 368), CGPoint(x: 345, y: 412), CGPoint(x: 155, y: 412)
        ]),
        ArtworkShapes.ellipse("cat_bell", 1, x: 230, y: 420, width: 40, height: 40),

        // Yarn Ball & Heart Accent
        ArtworkShapes.ellipse("cat_yarn_ball", 29, x: 38, y: 390, width: 75, height: 75),
        ArtworkShapes.polygon("cat_heart", 6, points: [
            CGPoint(x: 410, y: 410), CGPoint(x: 430, y: 390), CGPoint(x: 450, y: 410), CGPoint(x: 430, y: 445)
        ])
    ]

    // MARK: - owl 🦉 (02-owl.svg) — Golden Psychedelic Sunset
    static let owl: [ColoringRegion] = [
        // Background Sunburst Rays (Alternating Fresh Green [31], Orange [12], Lavender [17], & Golden Yellow [1])
        ArtworkShapes.polygon("owl_bg_ray_1", 31, points: [CGPoint(x: 0, y: 0), CGPoint(x: 75, y: 0), CGPoint(x: 250, y: 250), CGPoint(x: 0, y: 75)]),
        ArtworkShapes.polygon("owl_bg_ray_2", 12, points: [CGPoint(x: 75, y: 0), CGPoint(x: 150, y: 0), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("owl_bg_ray_3", 17, points: [CGPoint(x: 150, y: 0), CGPoint(x: 225, y: 0), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("owl_bg_ray_4", 1, points: [CGPoint(x: 225, y: 0), CGPoint(x: 300, y: 0), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("owl_bg_ray_5", 31, points: [CGPoint(x: 300, y: 0), CGPoint(x: 375, y: 0), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("owl_bg_ray_6", 12, points: [CGPoint(x: 375, y: 0), CGPoint(x: 450, y: 0), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("owl_bg_ray_7", 17, points: [CGPoint(x: 450, y: 0), CGPoint(x: 500, y: 0), CGPoint(x: 500, y: 75), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("owl_bg_ray_8", 1, points: [CGPoint(x: 500, y: 75), CGPoint(x: 500, y: 150), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("owl_bg_ray_9", 31, points: [CGPoint(x: 500, y: 150), CGPoint(x: 500, y: 225), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("owl_bg_ray_10", 12, points: [CGPoint(x: 500, y: 225), CGPoint(x: 500, y: 300), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("owl_bg_ray_11", 17, points: [CGPoint(x: 500, y: 300), CGPoint(x: 500, y: 375), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("owl_bg_ray_12", 1, points: [CGPoint(x: 500, y: 375), CGPoint(x: 500, y: 450), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("owl_bg_ray_13", 31, points: [CGPoint(x: 500, y: 450), CGPoint(x: 500, y: 500), CGPoint(x: 425, y: 500), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("owl_bg_ray_14", 12, points: [CGPoint(x: 425, y: 500), CGPoint(x: 350, y: 500), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("owl_bg_ray_15", 17, points: [CGPoint(x: 350, y: 500), CGPoint(x: 275, y: 500), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("owl_bg_ray_16", 1, points: [CGPoint(x: 275, y: 500), CGPoint(x: 200, y: 500), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("owl_bg_ray_17", 31, points: [CGPoint(x: 200, y: 500), CGPoint(x: 125, y: 500), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("owl_bg_ray_18", 12, points: [CGPoint(x: 125, y: 500), CGPoint(x: 50, y: 500), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("owl_bg_ray_19", 17, points: [CGPoint(x: 50, y: 500), CGPoint(x: 0, y: 500), CGPoint(x: 0, y: 425), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("owl_bg_ray_20", 1, points: [CGPoint(x: 0, y: 425), CGPoint(x: 0, y: 350), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("owl_bg_ray_21", 31, points: [CGPoint(x: 0, y: 350), CGPoint(x: 0, y: 275), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("owl_bg_ray_22", 18, points: [CGPoint(x: 0, y: 275), CGPoint(x: 0, y: 200), CGPoint(x: 250, y: 250)]),
            ArtworkShapes.polygon("owl_bg_ray_23", 12, points: [CGPoint(x: 0, y: 200), CGPoint(x: 0, y: 125), CGPoint(x: 250, y: 250)]),
            ArtworkShapes.polygon("owl_bg_ray_24", 17, points: [CGPoint(x: 0, y: 125), CGPoint(x: 0, y: 75), CGPoint(x: 250, y: 250)]),
        // Moon and Craters
        ArtworkShapes.ellipse("owl_moon", 18, x: 350, y: 40, width: 90, height: 90),
        ArtworkShapes.ellipse("owl_moon_crater_1", 9, x: 370, y: 58, width: 20, height: 20),
        ArtworkShapes.ellipse("owl_moon_crater_2", 9, x: 398, y: 52, width: 14, height: 14),
        ArtworkShapes.ellipse("owl_moon_crater_3", 9, x: 392, y: 84, width: 26, height: 26),

        // Stars
        ArtworkShapes.polygon("owl_star_top_left", 1, points: [
            CGPoint(x: 95, y: 100), CGPoint(x: 105, y: 120), CGPoint(x: 125, y: 125),
            CGPoint(x: 110, y: 140), CGPoint(x: 115, y: 160), CGPoint(x: 95, y: 145),
            CGPoint(x: 75, y: 160), CGPoint(x: 80, y: 140), CGPoint(x: 65, y: 125), CGPoint(x: 85, y: 120)
        ]),
        ArtworkShapes.polygon("owl_star_middle_left", 1, points: [
            CGPoint(x: 50, y: 200), CGPoint(x: 58, y: 215), CGPoint(x: 75, y: 218),
            CGPoint(x: 62, y: 230), CGPoint(x: 66, y: 247), CGPoint(x: 50, y: 235),
            CGPoint(x: 34, y: 247), CGPoint(x: 38, y: 230), CGPoint(x: 25, y: 218), CGPoint(x: 42, y: 215)
        ]),
        ArtworkShapes.polygon("owl_star_middle_right", 1, points: [
            CGPoint(x: 440, y: 180), CGPoint(x: 448, y: 195), CGPoint(x: 465, y: 198),
            CGPoint(x: 452, y: 210), CGPoint(x: 456, y: 227), CGPoint(x: 440, y: 215),
            CGPoint(x: 424, y: 227), CGPoint(x: 428, y: 210), CGPoint(x: 415, y: 198), CGPoint(x: 432, y: 195)
        ]),

        // Head & Body
        ArtworkShapes.polygon("owl_left_tuft", 32, points: [
            CGPoint(x: 160, y: 50), CGPoint(x: 225, y: 130), CGPoint(x: 160, y: 145)
        ]),
        ArtworkShapes.polygon("owl_right_tuft", 32, points: [
            CGPoint(x: 340, y: 50), CGPoint(x: 340, y: 145), CGPoint(x: 275, y: 130)
        ]),
        ArtworkShapes.ellipse("owl_head", 32, x: 140, y: 90, width: 220, height: 175),

        // Eyes & Beak
        ArtworkShapes.ellipse("owl_left_eye_outer", 20, x: 152, y: 135, width: 92, height: 92),
        ArtworkShapes.ellipse("owl_left_eye_inner", 17, x: 168, y: 151, width: 60, height: 60),
        ArtworkShapes.ellipse("owl_left_eye_pupil", 11, x: 183, y: 166, width: 30, height: 30),
        ArtworkShapes.ellipse("owl_right_eye_outer", 20, x: 256, y: 135, width: 92, height: 92),
        ArtworkShapes.ellipse("owl_right_eye_inner", 17, x: 272, y: 151, width: 60, height: 60),
        ArtworkShapes.ellipse("owl_right_eye_pupil", 11, x: 287, y: 166, width: 30, height: 30),
        ArtworkShapes.polygon("owl_beak", 12, points: [
            CGPoint(x: 235, y: 205), CGPoint(x: 265, y: 205), CGPoint(x: 250, y: 245)
        ]),

        // Body, Wings & Perch
        ArtworkShapes.ellipse("owl_body", 32, x: 135, y: 215, width: 230, height: 215),
        ArtworkShapes.ellipse("owl_belly", 5, x: 175, y: 250, width: 150, height: 180),
        ArtworkShapes.ellipse("owl_left_wing", 26, x: 80, y: 248, width: 65, height: 155),
        ArtworkShapes.ellipse("owl_right_wing", 26, x: 355, y: 248, width: 65, height: 155),
        ArtworkShapes.ellipse("owl_branch", 16, x: 120, y: 418, width: 260, height: 32)
    ]
    
    // MARK: - Robot 🤖 (04-robot.svg) - Cyber Retro Neon
    static let robot: [ColoringRegion] = [
        // 1. Background Coverage (أشعة الخلفية مقسمة ومغطاة بالكامل بدون أي فراغ)
        ArtworkShapes.polygon("robot_bg_ray_1", 19, points: [CGPoint(x: 0, y: 0), CGPoint(x: 125, y: 0), CGPoint(x: 250, y: 250), CGPoint(x: 0, y: 125)]),
        ArtworkShapes.polygon("robot_bg_ray_2", 13, points: [CGPoint(x: 125, y: 0), CGPoint(x: 250, y: 0), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("robot_bg_ray_3", 28, points: [CGPoint(x: 250, y: 0), CGPoint(x: 375, y: 0), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("robot_bg_ray_4", 11, points: [CGPoint(x: 375, y: 0), CGPoint(x: 500, y: 0), CGPoint(x: 500, y: 125), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("robot_bg_ray_5", 19, points: [CGPoint(x: 500, y: 125), CGPoint(x: 500, y: 250), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("robot_bg_ray_6", 13, points: [CGPoint(x: 500, y: 250), CGPoint(x: 500, y: 375), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("robot_bg_ray_7", 28, points: [CGPoint(x: 500, y: 375), CGPoint(x: 500, y: 500), CGPoint(x: 375, y: 500), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("robot_bg_ray_8", 11, points: [CGPoint(x: 375, y: 500), CGPoint(x: 250, y: 500), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("robot_bg_ray_9", 19, points: [CGPoint(x: 250, y: 500), CGPoint(x: 125, y: 500), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("robot_bg_ray_10", 13, points: [CGPoint(x: 125, y: 500), CGPoint(x: 0, y: 500), CGPoint(x: 0, y: 375), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("robot_bg_ray_11", 28, points: [CGPoint(x: 0, y: 375), CGPoint(x: 0, y: 250), CGPoint(x: 250, y: 250)]),
        ArtworkShapes.polygon("robot_bg_ray_12", 11, points: [CGPoint(x: 0, y: 250), CGPoint(x: 0, y: 125), CGPoint(x: 250, y: 250)]),

        // 2. Antenna & Ears
        ArtworkShapes.ellipse("robot_antenna_ball", 18, x: 235, y: 30, width: 30, height: 30),
        ArtworkShapes.polygon("robot_antenna_stem", 11, points: [
            CGPoint(x: 246, y: 60), CGPoint(x: 254, y: 60), CGPoint(x: 254, y: 95), CGPoint(x: 246, y: 95)
        ]),
        ArtworkShapes.ellipse("robot_left_ear", 14, x: 120, y: 130, width: 30, height: 60),
        ArtworkShapes.ellipse("robot_right_ear", 14, x: 350, y: 130, width: 30, height: 60),

        // 3. Head & Face Details
        ArtworkShapes.ellipse("robot_head", 37, x: 145, y: 90, width: 210, height: 145),
        ArtworkShapes.ellipse("robot_left_eye_outer", 20, x: 170, y: 120, width: 60, height: 60),
        ArtworkShapes.ellipse("robot_left_eye_pupil", 11, x: 185, y: 135, width: 30, height: 30),
        ArtworkShapes.ellipse("robot_right_eye_outer", 20, x: 270, y: 120, width: 60, height: 60),
        ArtworkShapes.ellipse("robot_right_eye_pupil", 11, x: 285, y: 135, width: 30, height: 30),
        ArtworkShapes.ellipse("robot_mouth_bar", 11, x: 185, y: 195, width: 130, height: 25),

        // 4. Body, Screen & Heart
        ArtworkShapes.ellipse("robot_body", 37, x: 160, y: 250, width: 180, height: 155),
        ArtworkShapes.ellipse("robot_screen", 5, x: 185, y: 275, width: 130, height: 90),
        ArtworkShapes.polygon("robot_heart", 6, points: [
            CGPoint(x: 232, y: 295), CGPoint(x: 250, y: 275), CGPoint(x: 268, y: 295), CGPoint(x: 250, y: 335)
        ]),

        // 5. Limbs & Feet
        ArtworkShapes.ellipse("robot_left_arm", 27, x: 95, y: 275, width: 65, height: 80),
        ArtworkShapes.ellipse("robot_right_arm", 27, x: 340, y: 275, width: 65, height: 80),
        ArtworkShapes.ellipse("robot_left_leg", 11, x: 185, y: 400, width: 50, height: 60),
        ArtworkShapes.ellipse("robot_right_leg", 11, x: 265, y: 400, width: 50, height: 60),
        ArtworkShapes.ellipse("robot_left_foot", 11, x: 170, y: 455, width: 80, height: 30),
        ArtworkShapes.ellipse("robot_right_foot", 11, x: 250, y: 455, width: 80, height: 30)
    ]

    // MARK: - Dream 💭 (12-dream.svg) - Psychedelic Sunset
    static let dream: [ColoringRegion] = [
        // 1. Top Sky Rays
        ArtworkShapes.polygon("dream_top_ray_1", 7, points: [CGPoint(x: 0, y: 0), CGPoint(x: 100, y: 0), CGPoint(x: 250, y: 220), CGPoint(x: 0, y: 100)]),
        ArtworkShapes.polygon("dream_top_ray_2", 3, points: [CGPoint(x: 100, y: 0), CGPoint(x: 200, y: 0), CGPoint(x: 250, y: 220)]),
        ArtworkShapes.polygon("dream_top_ray_3", 13, points: [CGPoint(x: 200, y: 0), CGPoint(x: 300, y: 0), CGPoint(x: 250, y: 220)]),
        ArtworkShapes.polygon("dream_top_ray_4", 8, points: [CGPoint(x: 300, y: 0), CGPoint(x: 400, y: 0), CGPoint(x: 250, y: 220)]),
        ArtworkShapes.polygon("dream_top_ray_5", 21, points: [CGPoint(x: 400, y: 0), CGPoint(x: 500, y: 0), CGPoint(x: 500, y: 100), CGPoint(x: 250, y: 220)]),

        // 2. Main Title Oval Frame & Interior Fill
        ArtworkShapes.ellipse("dream_banner_outer", 5, x: 25, y: 130, width: 450, height: 190),
        ArtworkShapes.ellipse("dream_banner_inner_fill", 5, x: 35, y: 140, width: 430, height: 170),

        // 3. Letters DREAM
        ArtworkShapes.polygon("letter_D", 12, points: [
            CGPoint(x: 55, y: 180), CGPoint(x: 100, y: 180), CGPoint(x: 115, y: 225), CGPoint(x: 100, y: 270), CGPoint(x: 55, y: 270)
        ]),
        ArtworkShapes.polygon("letter_R", 1, points: [
            CGPoint(x: 135, y: 180), CGPoint(x: 175, y: 180), CGPoint(x: 185, y: 210), CGPoint(x: 165, y: 225), CGPoint(x: 185, y: 270), CGPoint(x: 135, y: 270)
        ]),
        ArtworkShapes.polygon("letter_E", 13, points: [
            CGPoint(x: 205, y: 180), CGPoint(x: 255, y: 180), CGPoint(x: 205, y: 225), CGPoint(x: 250, y: 225), CGPoint(x: 205, y: 270), CGPoint(x: 255, y: 270)
        ]),
        ArtworkShapes.polygon("letter_A", 6, points: [
            CGPoint(x: 290, y: 180), CGPoint(x: 320, y: 180), CGPoint(x: 340, y: 270), CGPoint(x: 270, y: 270)
        ]),
        ArtworkShapes.polygon("letter_M", 35, points: [
            CGPoint(x: 355, y: 180), CGPoint(x: 380, y: 225), CGPoint(x: 405, y: 180), CGPoint(x: 430, y: 270), CGPoint(x: 355, y: 270)
        ]),

        // 4. Lower Ground Perspective Rays
        ArtworkShapes.polygon("dream_bot_ray_1", 2, points: [CGPoint(x: 0, y: 500), CGPoint(x: 100, y: 500), CGPoint(x: 250, y: 320), CGPoint(x: 0, y: 420)]),
        ArtworkShapes.polygon("dream_bot_ray_2", 29, points: [CGPoint(x: 100, y: 500), CGPoint(x: 200, y: 500), CGPoint(x: 250, y: 320)]),
        ArtworkShapes.polygon("dream_bot_ray_3", 16, points: [CGPoint(x: 200, y: 500), CGPoint(x: 300, y: 500), CGPoint(x: 250, y: 320)]),
        ArtworkShapes.polygon("dream_bot_ray_4", 7, points: [CGPoint(x: 300, y: 500), CGPoint(x: 400, y: 500), CGPoint(x: 250, y: 320)]),
        ArtworkShapes.polygon("dream_bot_ray_5", 6, points: [CGPoint(x: 400, y: 500), CGPoint(x: 500, y: 500), CGPoint(x: 500, y: 420), CGPoint(x: 250, y: 320)]),

        // 5. Accents & Clouds
        ArtworkShapes.ellipse("dream_top_left_moon", 18, x: 20, y: 20, width: 95, height: 95),
        ArtworkShapes.ellipse("dream_horizontal_bar", 1, x: 90, y: 350, width: 320, height: 18),
        ArtworkShapes.polygon("dream_hanging_heart", 3, points: [
            CGPoint(x: 232, y: 375), CGPoint(x: 250, y: 360), CGPoint(x: 268, y: 375), CGPoint(x: 250, y: 400)
        ]),
        ArtworkShapes.ellipse("dream_bottom_left_cloud", 22, x: 90, y: 400, width: 110, height: 45),
        ArtworkShapes.ellipse("dream_bottom_right_cloud", 22, x: 295, y: 410, width: 100, height: 45)
    ]
    
    // MARK: - Nature 🌳 (500x500 Canvas — Full Surface & Blue Sky Coverage)
    static let nature: [ColoringRegion] = [
        // 1. Sky Rays Background (Varied Blue Shades: Navy [14], Sky Blue [7], Light Blue [22], & Deep Blue [2])
        ArtworkShapes.polygon("nature_sky_ray_1", 14, points: [
            CGPoint(x: 0, y: 0), CGPoint(x: 100, y: 0), CGPoint(x: 350, y: 70), CGPoint(x: 0, y: 80)
        ]),
        ArtworkShapes.polygon("nature_sky_ray_2", 7, points: [
            CGPoint(x: 100, y: 0), CGPoint(x: 200, y: 0), CGPoint(x: 350, y: 70)
        ]),
        ArtworkShapes.polygon("nature_sky_ray_3", 22, points: [
            CGPoint(x: 200, y: 0), CGPoint(x: 300, y: 0), CGPoint(x: 350, y: 70)
        ]),
        ArtworkShapes.polygon("nature_sky_ray_4", 2, points: [
            CGPoint(x: 300, y: 0), CGPoint(x: 400, y: 0), CGPoint(x: 350, y: 70)
        ]),
        ArtworkShapes.polygon("nature_sky_ray_5", 14, points: [
            CGPoint(x: 400, y: 0), CGPoint(x: 500, y: 0), CGPoint(x: 500, y: 100), CGPoint(x: 350, y: 70)
        ]),
        ArtworkShapes.polygon("nature_sky_ray_6", 7, points: [
            CGPoint(x: 500, y: 100), CGPoint(x: 500, y: 220), CGPoint(x: 350, y: 70)
        ]),
        ArtworkShapes.polygon("nature_sky_ray_7", 22, points: [
            CGPoint(x: 0, y: 80), CGPoint(x: 0, y: 220), CGPoint(x: 350, y: 70)
        ]),

        // 2. Sun & Sun Rays (Golden Yellow [1] & Warm Peach [34])
        ArtworkShapes.ellipse("nature_sun", 1, x: 350, y: 40, width: 80, height: 80),
        ArtworkShapes.polygon("nature_sun_ray_top", 34, points: [
            CGPoint(x: 380, y: 10), CGPoint(x: 390, y: 35), CGPoint(x: 400, y: 10)
        ]),
        ArtworkShapes.polygon("nature_sun_ray_right", 34, points: [
            CGPoint(x: 440, y: 70), CGPoint(x: 465, y: 80), CGPoint(x: 440, y: 90)
        ]),

        // 3. Sky Clouds (Mint [13] & Soft Light Mauve [30])
        ArtworkShapes.ellipse("nature_cloud_left", 5, x: 60, y: 65, width: 90, height: 40),
        ArtworkShapes.ellipse("nature_cloud_right", 5, x: 110, y: 50, width: 90, height: 50),
        ArtworkShapes.ellipse("nature_cloud_far_right", 5, x: 390, y: 120, width: 80, height: 35),

        // 4. Back Mountain & Snow Cap (Medium Brown [32] & Cream Snow Cap [5])
        ArtworkShapes.polygon("mountain_back", 32, points: [
            CGPoint(x: 30, y: 310), CGPoint(x: 175, y: 145), CGPoint(x: 320, y: 310)
        ]),
        ArtworkShapes.polygon("mountain_snow", 5, points: [
            CGPoint(x: 135, y: 195), CGPoint(x: 175, y: 145), CGPoint(x: 215, y: 195),
            CGPoint(x: 190, y: 185), CGPoint(x: 175, y: 200), CGPoint(x: 155, y: 185)
        ]),

        // 5. Front Mountain & Snow Cap (Terracotta [21] & Cream Snow Cap [5])
        ArtworkShapes.polygon("mountain_front", 21, points: [
            CGPoint(x: 190, y: 325), CGPoint(x: 335, y: 170), CGPoint(x: 480, y: 325)
        ]),
        ArtworkShapes.polygon("front_snow", 5, points: [
            CGPoint(x: 295, y: 210), CGPoint(x: 335, y: 170), CGPoint(x: 375, y: 212),
            CGPoint(x: 350, y: 202), CGPoint(x: 335, y: 215), CGPoint(x: 320, y: 202)
        ]),

        // 6. Rolling Hills (Dark Green [4] & Leaf Green [10])
        ArtworkShapes.polygon("back_hill", 4, points: [
            CGPoint(x: 0, y: 310), CGPoint(x: 140, y: 270), CGPoint(x: 270, y: 320),
            CGPoint(x: 375, y: 280), CGPoint(x: 500, y: 310), CGPoint(x: 500, y: 500), CGPoint(x: 0, y: 500)
        ]),
        ArtworkShapes.polygon("front_hill", 10, points: [
            CGPoint(x: 0, y: 375), CGPoint(x: 150, y: 335), CGPoint(x: 300, y: 390),
            CGPoint(x: 415, y: 345), CGPoint(x: 500, y: 370), CGPoint(x: 500, y: 500), CGPoint(x: 0, y: 500)
        ]),

        // 7. Tree Trunk, Top Canopy & Leaves
        ArtworkShapes.rectangle("tree_trunk", 23, x: 60, y: 285, width: 38, height: 140),
        ArtworkShapes.ellipse("tree_top", 36, x: 20, y: 230, width: 120, height: 100),
        ArtworkShapes.ellipse("tree_left_leaf", 10, x: 10, y: 270, width: 70, height: 65),
        ArtworkShapes.ellipse("tree_right_leaf", 25, x: 80, y: 270, width: 70, height: 65),

        // 8. Foreground Flower Details (Soft Pink Petals [3] & Bright Yellow Center [1])
        ArtworkShapes.ellipse("flower_center", 1, x: 365, y: 415, width: 30, height: 30),
        ArtworkShapes.ellipse("flower_petal_top", 3, x: 370, y: 390, width: 20, height: 25),
        ArtworkShapes.ellipse("flower_petal_left", 3, x: 345, y: 410, width: 25, height: 20),
        ArtworkShapes.ellipse("flower_petal_right", 3, x: 390, y: 410, width: 25, height: 20),
        ArtworkShapes.ellipse("flower_petal_bottom", 3, x: 370, y: 435, width: 20, height: 25),
        ArtworkShapes.polygon("flower_stem", 4, points: [
            CGPoint(x: 378, y: 445), CGPoint(x: 382, y: 445), CGPoint(x: 382, y: 475), CGPoint(x: 378, y: 475)
        ]),
        ArtworkShapes.ellipse("flower_leaf_left", 10, x: 360, y: 450, width: 20, height: 12),
        ArtworkShapes.ellipse("flower_leaf_right", 10, x: 380, y: 455, width: 20, height: 12)
    ]
}
