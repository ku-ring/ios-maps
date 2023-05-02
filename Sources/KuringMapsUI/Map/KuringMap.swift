//
//  KuringMap.swift
//  
//
//  Created by Jaesung Lee on 2023/05/03.
//

import MapKit
import SwiftUI
import KuringMapsLink

/**
 캠퍼스 지도를 띄어주는 `View`.
 
```swift
 struct KonkukCampusMap: View {
    @StateObject private var configuration = MapConfiguration(
        appID = "B1D6861E-E40E-4CF9-AB7F-E574FB835037"
    )
 
    var body: some View {
        KuringMap(configuration: configuration)
    }
 }
```
 
MIT License
Copyright (c) 2023 쿠링
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
public struct KuringMap: View {
    @StateObject private var placeService = PlaceService()
    @Environment(\.mapAppearance) var appearance
    
    @State private var isOpen: Bool = false
    
    public var body: some View {
        ZStack() {
            CampusMapView()
            
            BottomSheetView(isOpen: $isOpen, maxHeight: UIScreen.main.bounds.height * 0.8) {
                BottomContentView(isOpen: $isOpen)
            }
            .shadow(radius: 4)
        }
        .ignoresSafeArea()
        .environmentObject(PlaceService())
    }
    
    public init() { }
}


struct KuringMap_Previews: PreviewProvider {
    static var previews: some View {
        KuringMap()
            .environment(\.mapAppearance, Appearance())
    }
}
