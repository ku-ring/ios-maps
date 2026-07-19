//
//  OperatingHours.swift
//  package-kuring-maps
//
//  Created by Jung Hwan Park on 7/19/26.
//

import Foundation
import KuringMapsLink

struct OperatingHours {
    let closingNote: String
    let duringTerm: String
    let duringVacation: String
}

struct Amenity: Identifiable {
    let id: String
    let name: String
    let location: String
    let hours: OperatingHours
}

extension Place {
    var hours: OperatingHours {
        return .init(closingNote: "24시간", duringTerm: "24시간", duringVacation: "09:00 ~ 18:00")
    }
    var amenities: [Amenity] {
        return [
            .init(id: "1", name: "흡연구역", location: "뒤 벤치 옆", hours: .init(closingNote: "24시간", duringTerm: "24시간", duringVacation: "09:00 ~ 18:00"))
        ]
    }
    var facilityIcons: [String] {
        return ["store", "cafe", "smoke"]
    }
}
