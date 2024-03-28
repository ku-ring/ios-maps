//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import KuringMapsLink

struct BottomContentView: View {
    @Environment(\.mapAppearance) var appearance
    @Binding var isOpen: Bool
    @EnvironmentObject var placeService: PlaceService
    
    @State private var selectedPlace: Place?
    
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 12) {
                if !isOpen {
                    if let icon = Image.icon(named: "museum.colored") {
                        icon
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 90, height: 90)
                            .clipped()
                            .foregroundStyle(appearance.secondary)
                    }
                    
                    VStack(spacing: 4) {
                        Text("환영합니다")
                            .font(appearance.title.bold())
                            .foregroundColor(appearance.primary)
                        
                        Text("건국대학교 캠퍼스 장소를 조회 해보세요")
                            .font(appearance.footnote)
                            .foregroundColor(appearance.secondary)
                    }
                    
                    HStack {
                        if let bull2Icon = Image.icon(named: "place.bull2.light") {
                            bull2Icon
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 45, height: 45)
                                .clipped()
                        }
                        
                        if let newmilliIcon = Image.icon(named: "area.newmilli.light") {
                            newmilliIcon
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 45, height: 45)
                                .clipped()
                        }
                        
                        if let libraryIcon = Image.icon(named: "area.library.light") {
                            libraryIcon
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 45, height: 45)
                                .clipped()
                        }
                        
                        if let languageIcon = Image.icon(named: "area.language.light") {
                            languageIcon
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 45, height: 45)
                                .clipped()
                        }
                        
                        if let bullIcon = Image.icon(named: "place.bull.light") {
                            bullIcon
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 45, height: 45)
                                .clipped()
                        }
                    }
                }
                
                PlaceSearchBar(isSearchFocused: _isSearchFocused, isOpen: $isOpen)
                
                if let selectedPlace = selectedPlace, selectedPlace.id == "상허기념도서관" {
                    LibraryRoomList()
                }
                                
                if let results = placeService.results, !results.isEmpty {
                    ForEach(results) { result in
                        Button {
                            if isSearchFocused {
                                isSearchFocused = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    placeService.selectPlace(result)
                                }
                            } else {
                                placeService.selectPlace(result)
                            }
                            isOpen = false
                        } label: {
                            PlaceSearchResultRow(place: result)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                } else {
                    if placeService.selectedCategory == nil {
                        MenuList()
                        
                        HStack {
                            /// Terms & Conditions >
                            Button {
                                if let url = URL(string: "https://kuring.notion.site/e88095d4d67d4c4c92983fd85cb693b9") {
                                    UIApplication.shared.open(url, options: [:])
                                }
                            } label: {
                                HStack(spacing: 2) {
                                    Text("이용약관")
                                        .font(appearance.caption)
                                    
                                    Image(systemName: "chevron.right")
                                        .font(appearance.caption)
                                }
                            }
                            .tint(appearance.secondary)
                            
                            Spacer()
                        }
                    }
                }
                
                Spacer()
                    .frame(height: 64)
            }
            .padding(.horizontal, 20)
        }
        .environmentObject(placeService)
        .onReceive(placeSeletionPublisher) {
            isSearchFocused = false
            isOpen = $0?.id == "상허기념도서관"
            self.selectedPlace = $0
        }
    }
}

#Preview("기본 모드") {
    BottomContentView(isOpen: .constant(false))
        .environment(\.mapAppearance, Appearance())
        .environmentObject(PlaceService())
}

#Preview("확장") {
    BottomContentView(isOpen: .constant(true))
        .environment(\.mapAppearance, Appearance())
        .environmentObject(PlaceService())
}
