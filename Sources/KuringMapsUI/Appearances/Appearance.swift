//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI

public struct Appearance {

    public let warning: Color
    
    public let borderLine: Color
    
    public let kuringLogoText: Color
    
    public let bg: Color
    
    public let primarySelected: Color
    
    public let primary: Color
    
    public let caption1: Color
    
    public let caption2: Color
    
    public let body: Color
    
    public let title: Color
    
    public let gray600: Color
    
    public let gray400: Color
    
    public let gray300: Color
    
    public let gray200: Color
    
    public let gray100: Color
    
    public init(
        warning: Color = .red,
        borderLine: Color = .gray,
        kuringLogoText: Color = .green,
        bg: Color = .gray.opacity(0.2),
        primarySelected: Color = .green,
        primary: Color = .green.opacity(0.5),
        caption1: Color = .black.opacity(0.4),
        caption2: Color = .black.opacity(0.2),
        body: Color = .black.opacity(0.5),
        title: Color = .black.opacity(0.5),
        gray600: Color = .gray.opacity(0.6),
        gray400: Color = .gray.opacity(0.4),
        gray300: Color = .gray.opacity(0.3),
        gray200: Color = .gray.opacity(0.2),
        gray100: Color = .gray.opacity(0.1)
    ) {
        self.warning = warning
        self.borderLine = borderLine
        self.kuringLogoText = kuringLogoText
        self.bg = bg
        self.primarySelected = primarySelected
        self.primary = primary
        self.caption1 = caption1
        self.caption2 = caption2
        self.body = body
        self.title = title
        self.gray400 = gray400
        self.gray600 = gray600
        self.gray100 = gray100
        self.gray300 = gray300
        self.gray200 = gray200
    }
}

