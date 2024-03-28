//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI

struct LibraryCircularButton: View {
    @Environment(\.mapAppearance) var appearance
    
    var body: some View {
        VStack {
            Image.icon(named: "area.library.light")!
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .clipShape(.circle)
                .padding(4)
                .background {
                    appearance.background
                        .clipShape(.circle)
                }
                .padding(2)

            Text("잔여좌석 보기")
                .font(appearance.footnote)
                .foregroundStyle(appearance.secondary)
        }
    }
}

struct LibraryCircularButton_Previews: PreviewProvider {
    static var previews: some View {
        LibraryCircularButton()
    }
}
