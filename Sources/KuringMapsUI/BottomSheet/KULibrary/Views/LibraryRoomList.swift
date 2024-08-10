//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import KuringMapsLink

struct LibraryRoomList: View {
    @Environment(\.mapAppearance) var appearance
    @Environment(\.dismiss) var dismiss
    @StateObject private var konkukLibrary = KonkukLibrary()
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            infoView
                .padding(.top, 18)
            
            switch konkukLibrary.loadingState {
            case .succeeded:
                LazyVGrid(columns: columns) {
                    ForEach(konkukLibrary.rooms) { room in
                        RoomRow(room: room)
                    }
                }
                
            case .loading, .none:
                ProgressView()
                    .padding(.top, 150)
                
            case .failed:
                Text("불러오기 실패")
                    .font(appearance.subtitle)
                    .foregroundStyle(.red)
                    .padding(.top, 150)
            }
            
        }
        .background(appearance.bg)
        .onAppear { konkukLibrary.send(.onAppear) }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.left")
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
    }
    
    var infoView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("도서관 잔여좌석")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                
                Text("도서관 잔여좌석을 확인할 수 있어요.")
                    .font(appearance.body)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
        }
        .padding(.leading, 20)
        .padding(.bottom, 32)
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
