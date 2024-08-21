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
            
            Circle()
                .frame(width: 46, height: 46)
                .foregroundColor(appearance.bg)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 0)
                .overlay {
                    Button {
                        
                    } label: {
                        Image(.iconRefresh)
                            .padding(11)
                    }
                }
                
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
    }
    
    @ViewBuilder
    private var listView: some View {
        switch konkukLibrary.loadingState {
        case .succeeded:
            LazyVGrid(columns: columns) {
                ForEach(konkukLibrary.rooms) { room in
                    RoomRow(room: room)
                }
            }
            
        case .loading, .none:
            ProgressView()
                .padding(.top, 210)
            
        case .failed:
            Text("홈페이지 사정 상,\n 잔여좌석 정보를 불러올 수 없어요.")
                .multilineTextAlignment(.center)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(appearance.caption2)
                .padding(.top, 210)
        }
    }
}

#Preview {
    LibraryRoomList()
}
