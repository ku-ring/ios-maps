//
//  Building.swift
//  package-kuring-maps
//
//  Created by Jung Hwan Park on 7/26/26.
//

import Foundation

public struct CurrentOperatingHours: Codable, Hashable {
    public let period: String
    public let dayGroup: String
    public let status: String
    public let opensAt: String?
    public let closesAt: String?
    
    public init(period: String, dayGroup: String, status: String, opensAt: String?, closesAt: String?) {
        self.period = period
        self.dayGroup = dayGroup
        self.status = status
        self.opensAt = opensAt
        self.closesAt = closesAt
    }
}

// 건물 하나
public struct Building: Codable, Identifiable, Hashable {
    public let id: Int
    public let name: String
    public let address: String
    public let latitude: Double
    public let longitude: Double
    
    public init(id: Int, name: String, address: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Building, rhs: Building) -> Bool {
        lhs.id == rhs.id
    }
}

public struct BuildingListResponse: Codable {
    public let buildings: [Building]
    
    public init(buildings: [Building]) {
        self.buildings = buildings
    }
}

// 건물 하나 + 그 안의 시설 목록
public struct BuildingDetailResponse: Codable, Identifiable, Hashable {
    public let id: Int
    public let name: String
    public let address: String
    public let latitude: Double
    public let longitude: Double
    public let imageUrl: String?
    public let currentOperatingHours: CurrentOperatingHours
    public let campusPlaces: [CampusPlaceDetail]
    
    public init(
        id: Int,
        name: String,
        address: String,
        latitude: Double,
        longitude: Double,
        imageUrl: String?,
        currentOperatingHours: CurrentOperatingHours,
        campusPlaces: [CampusPlaceDetail]
    ) {
        self.id = id
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.imageUrl = imageUrl
        self.currentOperatingHours = currentOperatingHours
        self.campusPlaces = campusPlaces
    }
}
