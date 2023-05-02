//
//  PlaceSearchBar.swift
//  
//
//  Created by Jaesung Lee on 2023/05/03.
//

import SwiftUI
import KuringMapsLink

struct PlaceSearchBar: View {
    @Environment(\.mapAppearance) var appearance
    @EnvironmentObject var placeService: PlaceService
    
    @FocusState private var isSearchFocused: Bool
    @Binding var isOpen: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "magnifyingglass")
                .font(.body)
                .foregroundColor(appearance.secondary)
            
            TextField("장소를 검색 해보세요", text: $placeService.text)
                .focused($isSearchFocused)
                .onChange(of: isSearchFocused) { onSearch in
                    isOpen = onSearch
                }
        }
        .padding(8)
        .background {
            appearance.secondaryBackground
                .cornerRadius(10)
        }
        .onReceive(keyboardVisibilityPublisher) { visible in
            isSearchFocused = visible
        }
    }
}
