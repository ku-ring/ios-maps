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
            
            listView
                .padding(.horizontal, 20)
            
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
    
    private var infoView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("도서관 잔여좌석")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                
                Text("도서관 잔여좌석을 확인할 수 있어요.")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.gray)
            }
            
            Spacer()
        }
        .padding(.leading, 20)
        .padding(.bottom, 32)
    }
    
    @ViewBuilder
    private var listView: some View {
        switch konkukLibrary.loadingState {
        case .succeeded, .none:
            LazyVGrid(columns: columns) {
                ForEach(konkukLibrary.rooms) { room in
                    RoomRow(room: room)
                }
            }
            
        case .loading:
            ProgressView()
                .padding(.top, 150)
            
        case .failed:
            Text("불러오기 실패")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.red)
                .padding(.top, 150)
        }
    }
}

#Preview {
    LibraryRoomList()
}
