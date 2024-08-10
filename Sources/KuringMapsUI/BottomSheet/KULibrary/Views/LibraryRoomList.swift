//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import KuringMapsLink

struct LibraryRoomList: View {
    @Environment(\.mapAppearance) var appearance
    @StateObject private var konkukLibrary = KonkukLibrary()
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            infoView
            
            LazyVGrid(columns: columns) {
                ForEach(konkukLibrary.rooms) { room in
                    RoomRow(room: room)
                }
            }
            
            Spacer()
        }
        .onAppear { konkukLibrary.send(.onAppear) }
        .padding(.top, 18)
    }
    
    var infoView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("도서관 잔여좌석")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                
                Text(
                     """
                     도서관 잔여좌석을 확인할 수 있어요.
                     열람실 예약하러가기 버튼을 누르면
                     도서관 앱으로 이동해요.
                     """
                )
                .font(appearance.body)
                .foregroundStyle(.gray)
            }
            
            Spacer()
        }
        .padding(.leading, 20)
    }
    
    var oldView: some View {
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