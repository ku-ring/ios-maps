//
//  CampusPlace.swift
//  package-kuring-maps
//
//  Created by Jung Hwan Park on 7/26/26.
//

import Foundation

// 시설(카페, 프린터, 휴게공간 등) 하나
struct CampusPlaceDetail: Codable {
    let id: Int64
    let name: String
    let category: String
    let categoryKorName: String
    let imageUrl: String?
    let locationType: LocationType
    let floor: String
    let locationDetail: String?
    let quantity: Int?
    let currentOperatingHours: CurrentOperatingHours
    let externalUrl: String?
}

struct CampusPlaceItem: Codable {
    let id: Int
    let name: String
    let category: String
    let categoryKorName: String
    let imageUrl: String?
    let locationType: LocationType
    let floor: String
    let locationDetail: String?
    let quantity: Int?
    let currentOperatingHours: CurrentOperatingHours
    let externalUrl: String?
    let building: Building
}

struct CampusPlaceListResponse: Codable {
    let campusPlaces: [CampusPlaceItem]
}

enum LocationType: String, Codable {
    case INDOOR
    case OUTDOOR
}
