import SwiftUI
import UIKit
import KuringMapsUI
import KuringMapsLink

@main
struct KuringMapsExampleApp: App {
    var body: some Scene {
        WindowGroup {
            let appearance = Appearance(
                warning: .adaptive(lightHex: "FF4848", darkHex: "DE4343"),
                borderLine: .adaptive(lightHex: "000000", darkHex: "DE4343"),
                kuringLogoText: .adaptive(lightHex: "535B5D", darkHex: "535B5D"),
                bg: .adaptive(lightHex: "FFFFFF", darkHex: "292929"),
                primarySelected: .adaptive(lightHex: "EBF8F2", darkHex: "454D49"),
                primary: .adaptive(lightHex: "3DBD80", darkHex: "38B178"),
                caption1: .adaptive(lightHex: "868A92", darkHex: "878787"),
                caption2: .adaptive(lightHex: "B1B5BD", darkHex: "5E5E5E"),
                body: .adaptive(lightHex: "353C49", darkHex: "E0E0E0"),
                title: .adaptive(lightHex: "333333", darkHex: "F5F5F5"),
                gray600: .adaptive(lightHex: "262626", darkHex: "DFDFDF"),
                gray400: .adaptive(lightHex: "434343", darkHex: "B0B0B0"),
                gray300: .adaptive(lightHex: "999999", darkHex: "6B6B6B"),
                gray200: .adaptive(lightHex: "E5E5E5", darkHex: "4E4E4E"),
                gray100: .adaptive(lightHex: "F2F3F5", darkHex: "3D3D3E")
            )
            
            KuringMap(
                linkConfig: .init(host: "dev.ku-ring.com"),
                libConfig: .init(host: "library.konkuk.ac.kr/pyxis-api/1")
            )
            .environment(\.mapAppearance, appearance)
        }
    }
}

private extension Color {
    static func adaptive(lightHex: String, darkHex: String) -> Color {
        let uiColor = UIColor { traitCollection in
            let lightUI = Color.uiColorFrom(hex: lightHex)
            let darkUI = Color.uiColorFrom(hex: darkHex)
            return traitCollection.userInterfaceStyle == .dark ? darkUI : lightUI
        }
        return Color(uiColor)
    }
    
    private static func uiColorFrom(hex: String) -> UIColor {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
