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
    
    @State private var isOpen: Bool = false
    
    public var body: some View {
        ZStack() {
            CampusMapView()
            
            BottomSheetView(
                isOpen: $isOpen,
                maxHeight: UIScreen.main.bounds.height * 0.8
            ) {
                BottomContentView(isOpen: $isOpen)
            }
            .shadow(radius: 4)
        }
        .ignoresSafeArea()
        .environmentObject(PlaceService())
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
