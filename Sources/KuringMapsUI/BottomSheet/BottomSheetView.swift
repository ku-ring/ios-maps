//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import KuringMapsLink

fileprivate enum Constants {
    static let radius: CGFloat = 16
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
    static let snapRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0.575
}


struct BottomSheetView<Content: View>: View {
    @Environment(\.mapAppearance) var appearance
    @Binding var isOpen: Bool

    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content

    @GestureState private var translation: CGFloat = 0

    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }

    private var indicator: some View {
        RoundedRectangle(cornerRadius: Constants.radius)
            .fill(Color.secondary)
            .frame(
                width: Constants.indicatorWidth,
                height: Constants.indicatorHeight
        ).onTapGesture {
            self.isOpen.toggle()
            keyboardVisibilityPublisher.send(false)
        }
    }

    init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.minHeight = maxHeight * Constants.minHeightRatio
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                // over bottom sheet
                HStack(alignment: .bottom, spacing: 4) {
                    Image(systemName: "applelogo")
                    
                    Text("지도")
                    
                    Spacer()
                    
                    Button {
                        placeSeletionPublisher
                            .send(Place.places.first(where: { $0.id == "상허기념도서관" }))
                    } label: {
                        LibraryCircularButton()
                    }
                    
                    Spacer()
                    
                    Link(
                        "법적정보",
                        destination: URL(
                            string: "https://www.apple.com/kr/legal/privacy/data/ko/apple-maps/"
                        )!
                    )
                    .font(.caption)
                }
//                .font(appearance.footnote)
//                .foregroundColor(appearance.secondary)
                .padding(.horizontal)
                
                // bottom sheet
                VStack(spacing: 0) {
                    self.indicator
                        .padding()
                    self.content
                }
                .frame(
                    width: geometry.size.width,
                    height: self.maxHeight,
                    alignment: .top
                )
//                .background(appearance.background)
                .cornerRadius(Constants.radius)
            }
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.spring)
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                    keyboardVisibilityPublisher.send(false)
                }.onEnded { value in
                    let snapDistance = self.maxHeight * Constants.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                }
            )
            
        }
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.secondarySystemBackground)
            
            BottomSheetView(isOpen: .constant(false), maxHeight: UIScreen.main.bounds.height * 0.8) {
                BottomContentView(isOpen: .constant(false))
            }
        }
        .edgesIgnoringSafeArea(.all)
//        .environment(
//            \.mapAppearance,
//             Appearance(
//                tint: .red,
//                primary: .orange,
//                secondary: .yellow,
//                background: .green,
//                secondaryBackground: .blue,
//                link: .purple,
//                body: .body,
//                title: .title,
//                subtitle: .subheadline,
//                footnote: .footnote,
//                caption: .caption
//             )
//        )
        .environmentObject(PlaceService())
    }
}
