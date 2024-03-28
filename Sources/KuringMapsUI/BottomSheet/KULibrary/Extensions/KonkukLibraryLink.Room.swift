//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import KuringMapsLink

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
