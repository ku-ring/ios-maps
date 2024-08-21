//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI

struct MenuButton: View {
    @Environment(\.mapAppearance) var appearance
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
//                .foregroundColor(appearance.tint)
//                .font(appearance.subtitle.bold())
                .frame(maxWidth: .infinity)
                .frame(height: 48)
//                .background {
//                    appearance.secondaryBackground
//                        .cornerRadius(10)
//                }
        }
    }
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                MenuButton(title: "실시간 위치 공유하기", action: {})
                
                MenuButton(title: "발자국 남기기", action: {})
                
                MenuButton(title: "장소 수정 제안", action: {})
            }
            .padding(.horizontal, 20)
        }
        .environment(\.mapAppearance, Appearance())
    }
}

