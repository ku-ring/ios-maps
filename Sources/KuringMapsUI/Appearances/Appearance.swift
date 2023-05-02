//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI

public struct Appearance {
    /// The main colors used in views provide by ``KuringMapUI``. The default is `Color(.systemBlue)`
    public let tint: Color
    
    public let primary: Color
    
    public let secondary: Color
    
    public let background: Color
    
    public let secondaryBackground: Color
    
    public let link: Color
    
    public let body: Font
    
    public let title: Font
    
    public let subtitle: Font
    
    public let footnote: Font
    
    public let caption: Font
    
    public init(
        tint: Color = Color(.tintColor),
        primary: Color = Color.primary,
        secondary: Color = Color.secondary,
        background: Color = Color(.systemBackground),
        secondaryBackground: Color = Color(.secondarySystemBackground),
        link: Color = Color(uiColor: .link),
        body: Font = .body,
        title: Font = .headline,
        subtitle: Font = .subheadline,
        footnote: Font = .footnote,
        caption: Font = .caption
    ) {
        self.tint = tint
        self.primary = primary
        self.secondary = secondary
        self.background = background
        self.secondaryBackground = secondaryBackground
        self.link = link
        self.body = body
        self.title = title
        self.subtitle = subtitle
        self.footnote = footnote
        self.caption = caption
    }
}

