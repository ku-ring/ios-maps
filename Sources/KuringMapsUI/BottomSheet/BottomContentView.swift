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
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 12) {
                if !isOpen {
                    if let icon = Image.icon(named: "area.museum.light") {
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
                
                PlaceSearchBar(isOpen: $isOpen)
                                
                if let results = placeService.results, !results.isEmpty {
                    ForEach(results) { result in
                        Button {
                            placeService.selectPlace(result)
                            isOpen = false
                        } label: {
                            PlaceSearchResultRow(place: result)
                        }
                        .buttonStyle(.plain)
                    }
                } else {
                    if placeService.selectedCategory == nil {
                        MenuList()
                        
                        HStack {
                            /// Terms & Conditions >
                            Button(action: {}) {
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
