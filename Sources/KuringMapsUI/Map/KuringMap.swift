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
    @Environment(\.mapAppearance) var appearance
    
    @State private var path: [NavigationPath] = []
    @State private var searchText: String = ""
    @State private var selectedCategory: KuringMapCategory?
    @State private var selectedPlace: Place?
    
    private let categories = KuringMapCategory.allCases
    
    public var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                CampusMapView(selectedCategory: selectedCategory)
                    .ignoresSafeArea()
                
                topSearchArea
                
                libraryCapsule
            }
            .navigationTitle("")
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationDestination(for: NavigationPath.self) { path in
                switch path {
                case .libraryRoom:
                    LibraryRoomList()
                        .environment(\.mapAppearance, appearance)
                case .search:
                    KuringMapSearchView { place in
                        print(place)
                    }
                }
            }
        }
        .onReceive(placeSeletionPublisher) { place in
            selectedPlace = place
        }
        .sheet(item: $selectedPlace) { place in
            KuringMapBottomSheet(place: place)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
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
        /// 위치 검색
        case search
    }
}

// MARK: Views
extension KuringMap {
    /// 검색 + 카테고리칩 영역
    private var topSearchArea: some View {
        VStack(spacing: 12) {
            searchBar
            categoryPills
            Spacer()
        }
        .padding(.top, 8)
    }
    
    /// 검색창
    private var searchBar: some View {
        HStack(spacing: 8) {
            TextField("건물명 및 위치 검색", text: $searchText)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.Kuring.caption1)
            
            Image("search2", bundle: .module)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.Kuring.bg)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(radius: 4)
        .padding(.horizontal, 20)
        .onTapGesture {
            path.append(.search)
        }
    }
    
    /// 카테고리칩 ScrollView
    private var categoryPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories) { category in
                    categoryPill(category)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
        }
        .scrollClipDisabled()
    }
    
    /// 카테고리칩 컴포넌트
    private func categoryPill(_ category: KuringMapCategory) -> some View {
        HStack(spacing: 6) {
            Image(category.icon, bundle: .module)
                .renderingMode(.template)
                .font(.system(size: 13))
            
            Text(category.title)
                .font(.system(size: 14, weight: .medium))
        }
        .foregroundStyle(selectedCategory == category ? Color.Kuring.primary : Color.Kuring.body)
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
        .background(
            Capsule()
                .fill(Color.Kuring.bg)
                .stroke(
                    selectedCategory == category ? Color.Kuring.primary : Color.Kuring.bg,
                    lineWidth: selectedCategory == category ? 1 : 0
                )
                .shadow(color: .black.opacity(0.08), radius: 4)
        )
        .onTapGesture {
            if selectedCategory == category {
                selectedCategory = nil      // 다시 누르면 필터 해제
            } else {
                selectedCategory = category // 해당 카테고리 선택
            }
        }
    }
    
    // MARK: - Library Capsule (existing)
    private var libraryCapsule: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    path.append(.libraryRoom)
                } label: {
                    HStack(spacing: 6)  {
                        Image("icon.library.book", bundle: .module)
                        
                        Text("열람실 좌석 현황")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.Kuring.primary)
                    }
                }
                .padding(12)
                .background(Color.Kuring.bg)
                .clipShape(.capsule)
            }
        }
        .padding(.trailing, 20)
        .padding(.bottom, 24)
        .shadow(color: .black.opacity(0.08), radius: 4)
    }
    
}

struct KuringMap_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            KuringMap(
                linkConfig: .init(host: ""),
                libConfig: .init(host: "")
            )
            .tabItem { Text("maps") }
        }
    }
}
