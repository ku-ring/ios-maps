//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import KuringMapsLink

struct PlaceSearchBar: View {
    @Environment(\.mapAppearance) var appearance
    @EnvironmentObject var placeService: PlaceService
    
    @FocusState var isSearchFocused: Bool
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
            
            Button {
                placeService.clearSearchText()
            } label: {
                Image(systemName: "multiply.circle.fill")
                    .foregroundColor(.secondary)
                    .opacity(placeService.text.isEmpty ? 0 : 1)
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
