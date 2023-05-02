//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI

extension EnvironmentValues {
    public var mapAppearance: Appearance {
        get { self[AppearanceKey.self] }
        set { self[AppearanceKey.self] = newValue }
    }
}

private struct AppearanceKey: EnvironmentKey {
    static var defaultValue: Appearance = Appearance()
}

