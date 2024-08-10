//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
@_spi(Tests) import KuringMapsLink

struct RoomRow: View {
    @Environment(\.mapAppearance) var appearance
    
    let room: KonkukLibraryLink.Room
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                CircularProgressView(room: room)
                    .frame(width: 108, height: 108)
                
                VStack {
                    Text("\(room.seats.available)")
                        .font(.system(size: 24))
                        .foregroundStyle(appearance.primary)
                        
                    Text("\(room.seats.occupied) / \(room.seats.total)")
                        .font(appearance.caption)
                        .foregroundStyle(.gray)
                }
            }
            
            Text(room.name)
                .font(appearance.body)
                .padding(.top, 12)
        }
        .padding(.bottom, 32)
    }
    
    var oldView: some View {
        HStack {
            Text(room.name)
                .font(.system(size: 20))
                .foregroundStyle(appearance.primary)
                .padding(.vertical, 20)
            
            Spacer()
            
            if room.unableMessage != nil {
                Text("지금은 운영하지 않아요")
                    .font(appearance.subtitle)
                    .foregroundStyle(appearance.secondary)
            } else {
                VStack(alignment: .trailing) {
                    if room.seats.available == .zero {
                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.circle.fill")
                            
                            Text("자리가 꽉 찼어요")
                        }
                        .foregroundStyle(appearance.primary)
                    } else {
                        Text("\(room.seats.available) 좌석 남았어요")
                            .foregroundStyle(appearance.primary)
                    }
                    
                    Text("\(room.seats.occupied)/\(room.seats.total)")
                        .foregroundStyle(appearance.secondary)
                }
                .font(appearance.subtitle)
            }
        }
    }
}

#Preview {
    ScrollView {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
            RoomRow(
                room: .init(
                    id: 0,
                    name: "제 1 열람실",
                    roomType: .init(
                        id: 0,
                        name: "type_name",
                        sortOrder: 1
                    ),
                    awaitable: true,
                    isChargeable: true,
                    unableMessage: "unabledMessage",
                    seats: .init(
                        total: 300,
                        occupied: 100,
                        waiting: 200,
                        available: 50
                    )
                )
            )
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            RoomRow(
                room: .init(
                    id: 0,
                    name: "제 2 열람실",
                    roomType: .init(
                        id: 0,
                        name: "type_name",
                        sortOrder: 1
                    ),
                    awaitable: true,
                    isChargeable: true,
                    unableMessage: nil,
                    seats: .init(
                        total: 300,
                        occupied: 100,
                        waiting: 200,
                        available: 50
                    )
                )
            )
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            RoomRow(
                room: .init(
                    id: 0,
                    name: "제 3 열람실",
                    roomType: .init(
                        id: 0,
                        name: "type_name",
                        sortOrder: 1
                    ),
                    awaitable: true,
                    isChargeable: true,
                    unableMessage: nil,
                    seats: .init(
                        total: 300,
                        occupied: 100,
                        waiting: 200,
                        available: 0
                    )
                )
            )
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            RoomRow(
                room: .init(
                    id: 0,
                    name: "제 4 열람실",
                    roomType: .init(
                        id: 0,
                        name: "type_name",
                        sortOrder: 1
                    ),
                    awaitable: true,
                    isChargeable: true,
                    unableMessage: nil,
                    seats: .init(
                        total: 300,
                        occupied: 100,
                        waiting: 200,
                        available: 0
                    )
                )
            )
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            RoomRow(
                room: .init(
                    id: 0,
                    name: "제 5 열람실",
                    roomType: .init(
                        id: 0,
                        name: "type_name",
                        sortOrder: 1
                    ),
                    awaitable: true,
                    isChargeable: true,
                    unableMessage: nil,
                    seats: .init(
                        total: 300,
                        occupied: 100,
                        waiting: 200,
                        available: 0
                    )
                )
            )
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            RoomRow(
                room: .init(
                    id: 0,
                    name: "제 6 열람실",
                    roomType: .init(
                        id: 0,
                        name: "type_name",
                        sortOrder: 1
                    ),
                    awaitable: true,
                    isChargeable: true,
                    unableMessage: nil,
                    seats: .init(
                        total: 300,
                        occupied: 100,
                        waiting: 200,
                        available: 0
                    )
                )
            )
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            RoomRow(
                room: .init(
                    id: 0,
                    name: "제 7 열람실",
                    roomType: .init(
                        id: 0,
                        name: "type_name",
                        sortOrder: 1
                    ),
                    awaitable: true,
                    isChargeable: true,
                    unableMessage: nil,
                    seats: .init(
                        total: 300,
                        occupied: 100,
                        waiting: 200,
                        available: 0
                    )
                )
            )
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            RoomRow(
                room: .init(
                    id: 0,
                    name: "제 8 열람실",
                    roomType: .init(
                        id: 0,
                        name: "type_name",
                        sortOrder: 1
                    ),
                    awaitable: true,
                    isChargeable: true,
                    unableMessage: nil,
                    seats: .init(
                        total: 300,
                        occupied: 100,
                        waiting: 200,
                        available: 0
                    )
                )
            )
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            RoomRow(
                room: .init(
                    id: 0,
                    name: "제 9 열람실",
                    roomType: .init(
                        id: 0,
                        name: "type_name",
                        sortOrder: 1
                    ),
                    awaitable: true,
                    isChargeable: true,
                    unableMessage: nil,
                    seats: .init(
                        total: 300,
                        occupied: 100,
                        waiting: 200,
                        available: 0
                    )
                )
            )
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .listStyle(.plain)
    }
    
}
