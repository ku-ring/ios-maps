//
//  BottomContentView.swift
//  
//
//  Created by Jaesung Lee on 2023/05/03.
//

import SwiftUI
import KuringMapsLink

struct BottomContentView: View {
    @Environment(\.mapAppearance) var appearance
    @Binding var isOpen: Bool
    @EnvironmentObject var placeService: PlaceService
    
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
                    }
                    
                    VStack(spacing: 4) {
                        Text("환영합니다")
                            .font(appearance.title.bold())
                            .foregroundColor(appearance.primary)
                        
                        Text("건국대학교 캠퍼스 장소를 조회 해보세요")
                            .font(appearance.footnote)
                            .foregroundColor(appearance.secondary)
                    }
                }
                
                PlaceSearchBar(isSearchFocused: _isSearchFocused, isOpen: $isOpen)
                                
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
            }
            .padding(.horizontal, 20)
        }
        .environmentObject(placeService)
    }
}


struct BottomContentView_Previews: PreviewProvider {
    static var previews: some View {
        BottomContentView(isOpen: .constant(true))
            .environment(\.mapAppearance, Appearance())
            .environmentObject(PlaceService())
    }
}
