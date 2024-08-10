//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Satellite
import Foundation

public class KonkukLibraryLink {
    private let satellite: Satellite
    
    public init() {
        self.satellite = Satellite(host: KuringMapsLink.libraryHost)
    }
    
    public func fetchRooms() async throws -> [Room] {
        let response: KonkukLibraryLink.Response<[Room]> = try await satellite.response(
            for: "seat-rooms",
            httpMethod: .get,
            queryItems: [
                .init(name: "smufMethodCode", value: "PC"),
                .init(name: "roomTypeId", value: "4"),
                .init(name: "branchGroupId", value: "1"),
            ]
        )
        return response.data.list
    }

    struct Response<DataItem: Decodable>: Decodable {
        let success: Bool
        let code: String
        let message: String
        let data: CollectionData<DataItem>
    }
    
    struct CollectionData<Element: Decodable>: Decodable {
        let totalCount: Int
        let list: Element
    }
    
    public struct Room: Decodable, Identifiable, Equatable {
        public let id: Int
        public let name: String
        public let roomType: RoomType
        public let awaitable: Bool
        public let isChargeable: Bool
        public let unableMessage: String?
        public let seats: Seats
        
        public struct RoomType: Decodable, Identifiable, Equatable {
            public let id: Int
            public let name: String
            public let sortOrder: Int
            
            // MARK: - @_spi(Tests)
            @_spi(Tests) public init(id: Int, name: String, sortOrder: Int) {
                self.id = id
                self.name = name
                self.sortOrder = sortOrder
            }
        }
        
        public struct Seats: Decodable, Equatable {
            public let total: Int
            public let occupied: Int
            public let waiting: Int
            public let available: Int
            
            // MARK: - @_spi(Tests)
            @_spi(Tests) public init(total: Int, occupied: Int, waiting: Int, available: Int) {
                self.total = total
                self.occupied = occupied
                self.waiting = waiting
                self.available = available
            }
        }
        
        // MARK: - @_spi(Tests)
        @_spi(Tests) public init(id: Int, name: String, roomType: RoomType, awaitable: Bool, isChargeable: Bool, unableMessage: String?, seats: Seats) {
            self.id = id
            self.name = name
            self.roomType = roomType
            self.awaitable = awaitable
            self.isChargeable = isChargeable
            self.unableMessage = unableMessage
            self.seats = seats
        }
    }
}
