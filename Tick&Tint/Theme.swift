//
//  Theme.swift
//  Tick&Tint
//
//  Created by Ayah Alaqeel on 11/05/1448 AH.
//

import SwiftUI

// colors
extension Color {
    static let appBackground = Color(hex: "FFFBFA")
    static let primaryText = Color(hex: "1C1C1E")
    static let secondaryText = Color(hex: "413333")
    static let primaryBrand = Color(hex: "315B8C")
    static let secondaryBrand = Color(hex: "F2765E")
    static let graySec2 = Color(hex: "8E8E93")
    static let borderSubtle = Color(hex: "D1D1D6")
}

// مساعد لتحويل الأكواد الستينية (Hex) إلى ألوان في SwiftUI
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

// ypography Sizes
struct AppFonts {
    static let largeTitle: CGFloat = 34
    static let title1: CGFloat = 28
    static let title2: CGFloat = 22
    static let title3: CGFloat = 20
    static let headline: CGFloat = 17
    static let body: CGFloat = 17
    static let subheadline: CGFloat = 15
    static let footnote: CGFloat = 13
    static let caption: CGFloat = 12
}

// 
struct AppSpacing {
    static let statusBarHeight: CGFloat = 62
    static let topHeaderOffset: CGFloat = 56
    static let screenPadding: CGFloat = 20.0  // الهامش الجانبي للـ Grid (Offset 20px)
    static let small: CGFloat = 8         // المسافة بين الجولة والعنوان
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let extraLarge: CGFloat = 32
}
