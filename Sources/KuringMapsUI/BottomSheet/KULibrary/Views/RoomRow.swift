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
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(appearance.primary)
                        
                    Text("\(room.seats.occupied) / \(room.seats.total)")
                        .font(.system(size: 13, weight: .light))
                        .foregroundStyle(.gray)
                }
            }
            
            Text(room.name)
                .font(.system(size: 16, weight: .regular))
                .padding(.top, 12)
        }
        .padding(.bottom, 32)
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
