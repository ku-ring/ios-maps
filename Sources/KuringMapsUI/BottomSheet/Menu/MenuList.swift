//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI

struct MenuList: View {
    var body: some View {
        VStack(spacing: 12) {
            MenuButton(title: "장소 수정 제안", action: {
                if let url = URL(string: "https://forms.gle/88AtxkTSZ1ZxgEQ99") {
                    UIApplication.shared.open(url)
                }
            })
        }
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MenuList()
            .environment(\.mapAppearance, Appearance())
    }
}
