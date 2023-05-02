//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI

extension Image {
    static func icon(named name: String) -> Image? {
        guard let uiImage = UIImage(
            named: name,
            in: Bundle.module,
            compatibleWith: nil
        ) else { return nil }
        return Image(uiImage: uiImage)
    }
}

