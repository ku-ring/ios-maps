//
//  Building.swift
//  package-kuring-maps
//
//  Created by Jung Hwan Park on 7/26/26.
//

import Foundation

struct CurrentOperatingHours: Codable {
    let period: String
    let dayGroup: String
    let status: String
    let opensAt: String?
    let closesAt: String?
}

// 건물 하나
struct Building: Codable {
    let id: Int
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
}

struct BuildingListResponse: Codable {
    let buildings: [Building]
}

// 건물 하나 + 그 안의 시설 목록
struct BuildingDetailResponse: Decodable {
    let id: Int
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let imageUrl: String?
    let currentOperatingHours: CurrentOperatingHours
    let campusPlaces: [CampusPlaceDetail]
}
