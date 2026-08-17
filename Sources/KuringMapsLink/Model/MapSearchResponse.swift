//
//  MapSearchResponse.swift
//  package-kuring-maps
//
//  Created by Jung Hwan Park on 8/17/26.
//

import Foundation

// 건물 + 시설 통합 검색 결과
public struct MapSearchResponse: Codable {
    public let buildings: [Building]
    public let campusPlaces: [CampusPlaceItem]

    public init(buildings: [Building], campusPlaces: [CampusPlaceItem]) {
        self.buildings = buildings
        self.campusPlaces = campusPlaces
    }
}
