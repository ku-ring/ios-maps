//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import MapKit
import SwiftUI
import KuringMapsLink

/**
 캠퍼스 지도를 띄어주는 `View`.
 
```swift
 struct KonkukCampusMap: View {
    private let configuration = MapConfiguration(
        appID = "B1D6861E-E40E-4CF9-AB7F-E574FB835037"
    )
 
    var body: some View {
        KuringMap(configuration: configuration)
            .environment(\.mapConfiguration, configuration)
    }
 }
```
*/
public struct KuringMap: View {
    @StateObject private var placeService = PlaceService()
    @Environment(\.mapAppearance) var appearance
    
    @State private var path: [NavigationPath] = []
    
    public var body: some View {
        NavigationStack(path: $path) {
            ZStack() {
                CampusMapView()
                
                Button {
                    print("AAAA")
                    path.append(.libraryRoom)
                } label: {
                    libraryCapsule
                }
                
    //            BottomSheetView(
    //                isOpen: $isOpen,
    //                maxHeight: UIScreen.main.bounds.height * 0.8
    //            ) {
    //                BottomContentView(isOpen: $isOpen)
    //            }
    //            .shadow(radius: 4)
            }
            .ignoresSafeArea()
            .environmentObject(placeService)
            .navigationDestination(for: NavigationPath.self) { path in
                switch path {
                case .libraryRoom:
                    LibraryRoomList()
                }
            }
        }
    }
    
    private var libraryCapsule: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                HStack(spacing: 6) {
                    Image(.union)
                    
                    Text("열람실 좌석 현황")
                        .font(.system(size: 12))
                        .foregroundStyle(appearance.primary)
                }
                .padding(12)
                .background(appearance.background)
                .clipShape(.capsule)
            }
        }
        .padding(.trailing, 20)
        .padding(.bottom, 24)
        .shadow(radius: 4)
    }
    
    public init(
        linkConfig: LinkConfiguration?,
        libConfig: LibraryConfiguration?
    ) {
        KuringMapsLink.linkHost = linkConfig?.host ?? ""
        KuringMapsLink.libraryHost = libConfig?.host ?? ""
    }
    
    public struct LinkConfiguration {
        let host: String
        
        public init(host: String = "") {
            self.host = host
        }
    }
    
    public struct LibraryConfiguration {
        let host: String
        
        public init(host: String = "") {
            self.host = host
        }
    }
    
    enum NavigationPath {
        /// 도서관 잔여 좌석
        case libraryRoom
    }
}

struct KuringMap_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            KuringMap(
                linkConfig: .init(host: ""),
                libConfig: .init(host: "")
            )
            .environment(
                \.mapAppearance,
                 Appearance(
                    tint: .red,
                    primary: .orange,
                    secondary: .yellow,
                    background: .green,
                    secondaryBackground: .blue,
                    link: .purple,
                    body: .body,
                    title: .title,
                    subtitle: .subheadline,
                    footnote: .footnote,
                    caption: .caption
                 )
            )
            .tabItem { Text("maps") }
        }
    }
}
