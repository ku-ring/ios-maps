//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import KuringMapsLink

struct LibraryRoomList: View {
    @Environment(\.mapAppearance) var appearance
    @StateObject private var konkukLibrary = KonkukLibrary()
    
    var body: some View {
        VStack {
            HStack {
                Text("열람실")
                    .font(appearance.footnote)
                    .foregroundStyle(appearance.primary)
                
                Spacer()
                
                Button {
                    konkukLibrary.send(.refreshButtonTapped)
                } label: {
                    HStack {
                        switch konkukLibrary.loadingState {
                        case .none, .succeeded:
                            Text(Date.now, style: .time)
                        case .loading:
                            Text("불러오는 중")
                        case .failed:
                            Text("업데이트 실패")
                                .foregroundStyle(.red)
                        }
                        
                        if konkukLibrary.loadingState == .loading {
                            ProgressView()
                        } else {
                            Image(systemName: "arrow.clockwise.circle.fill")
                                .font(.title3)
                        }
                    }
                }
                .font(appearance.caption)
                .tint(appearance.secondary)
            }
            
            LazyVStack(alignment: .leading) {
                ForEach(konkukLibrary.rooms) { room in
                    RoomRow(room: room)
                }
            }
        }
        .onAppear { konkukLibrary.send(.onAppear) }
    }
}

#Preview {
    LibraryRoomList()
}
