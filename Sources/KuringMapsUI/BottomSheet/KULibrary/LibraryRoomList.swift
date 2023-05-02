//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import KuringMapsLink

@MainActor
class KonkukLibrary: ObservableObject {
    @Published var rooms: [KonkukLibraryLink.Room] = []
    @Published var loadingState: LoadingState = .none
    
    let link = KonkukLibraryLink()
    
    enum LoadingState: Equatable {
        case none
        case loading
        case succeeded
        case failed
    }
    
    enum Action {
        case onAppear
        case refreshButtonTapped
        case resetLoadingState
    }
    
    func fetchRooms() {
        Task {
            do {
                self.rooms = try await link.fetchRooms()
                self.loadingState = .succeeded
                try await Task.sleep(nanoseconds: 1_000_000)
                self.resetLoadingState()
            } catch {
                print(error.localizedDescription)
                self.loadingState = .failed
                self.resetLoadingState()
            }
            
        }
    }
    
    func resetLoadingState() {
        self.loadingState = .none
    }
    
    
    func send(_ action: Action) {
        switch action {
        case .onAppear:
            guard self.rooms.isEmpty else { return }
            self.loadingState = .loading
            self.fetchRooms()
        case .refreshButtonTapped:
            self.loadingState = .loading
            self.fetchRooms()
        case .resetLoadingState:
            self.resetLoadingState()
        }
    }
}

struct LibraryRoomList: View {
    @StateObject private var konkukLibrary = KonkukLibrary()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    konkukLibrary.send(.refreshButtonTapped)
                } label: {
                    HStack {
                        switch konkukLibrary.loadingState {
                        case .none:
                            Text(Date.now, style: .time)
                        case .loading:
                            Text("불러오는 중")
                                .foregroundStyle(.gray)
                        case .succeeded:
                            Text("업데이트 완료")
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
                .tint(.accentColor)
            }
            .padding(.horizontal, 20)
            
            LazyVStack(alignment: .leading) {
                ForEach(konkukLibrary.rooms) { room in
                    RoomRow(room: room)
                }
            }
        }
        .onAppear { konkukLibrary.send(.onAppear) }
    }
}

struct RoomRow: View {
    let room: KonkukLibraryLink.Room
    
    var body: some View {
        HStack(alignment: .top) {
            room.color
                .frame(width: 6)
                .clipShape(Capsule())
            
            VStack {
                Text(room.name)
                    .font(.title3.bold())
                
                if let message = room.unableMessage {
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background {
                            Capsule()
                                .stroke(.red, lineWidth: 1.0)
                        }
                }
                
            }
            
            Spacer()
            
            HStack(alignment: .top) {
                VStack(alignment: .trailing) {
                    if room.unableMessage != nil {
                        Text("0 좌석 남음")
                            .font(.title3.bold())
                            .foregroundStyle(.secondary)
                    } else {
                        Text("\(room.seats.available) 좌석 남음")
                            .font(.title3.bold())
                            .foregroundStyle(room.color)
                    }
                    
                    
                    Text("/\(room.seats.total)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

extension KonkukLibraryLink.Room {
    var seatStatus: SeatStatus {
        guard self.unableMessage == nil else {
            return .unavailable
        }
        let percentage = Double(self.seats.available) / Double(self.seats.total)
        switch percentage {
        case 0:
            return .unavailable
        case 0.3..<0.7:
            return .normal
        case 0.7...:
            return .good
        default:
            return .bad
        }
    }
    
    var color: Color {
        switch self.seatStatus {
        case .good:
            return .blue
        case .normal:
            return .green
        case .bad:
            return .orange
        case .unavailable:
            return .red
        }
    }
    
    enum SeatStatus: String, CaseIterable, Identifiable, Equatable {
        case good = "여유"
        case normal = "보통"
        case bad = "부족"
        case unavailable = "이용불가"
        
        var id: String { self.rawValue }
    }
}

