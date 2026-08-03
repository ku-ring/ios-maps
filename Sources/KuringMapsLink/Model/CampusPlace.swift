//
//  CampusPlace.swift
//  package-kuring-maps
//
//  Created by Jung Hwan Park on 7/26/26.
//

import Foundation

// 시설(카페, 프린터, 휴게공간 등) 하나
public struct CampusPlaceDetail: Codable, Identifiable, Hashable {
    public let id: Int64
    public let name: String
    public let category: String
    public let categoryKorName: String
    public let imageUrl: String?
    public let locationType: LocationType
    public let floor: String?
    public let locationDetail: String?
    public let quantity: Int?
    public let operatingHours: [OperatingHour]
    public let externalUrl: String?
    
    public init(
        id: Int64,
        name: String,
        category: String,
        categoryKorName: String,
        imageUrl: String?,
        locationType: LocationType,
        floor: String?,
        locationDetail: String?,
        quantity: Int?,
        operatingHours: [OperatingHour],
        externalUrl: String?
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.categoryKorName = categoryKorName
        self.imageUrl = imageUrl
        self.locationType = locationType
        self.floor = floor
        self.locationDetail = locationDetail
        self.quantity = quantity
        self.operatingHours = operatingHours
        self.externalUrl = externalUrl
    }
}

public struct CampusPlaceItem: Codable, Identifiable, Hashable {
    public let id: Int
    public let name: String
    public let category: String
    public let categoryKorName: String
    public let imageUrl: String?
    public let locationType: LocationType
    public let floor: String?
    public let locationDetail: String?
    public let quantity: Int?
    public let operatingHours: [OperatingHour]
    public let externalUrl: String?
    public let building: Building
    
    public init(
        id: Int,
        name: String,
        category: String,
        categoryKorName: String,
        imageUrl: String?,
        locationType: LocationType,
        floor: String?,
        locationDetail: String?,
        quantity: Int?,
        operatingHours: [OperatingHour],
        externalUrl: String?,
        building: Building
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.categoryKorName = categoryKorName
        self.imageUrl = imageUrl
        self.locationType = locationType
        self.floor = floor
        self.locationDetail = locationDetail
        self.quantity = quantity
        self.operatingHours = operatingHours
        self.externalUrl = externalUrl
        self.building = building
    }
}

public struct CampusPlaceListResponse: Codable {
    public let campusPlaces: [CampusPlaceItem]
    
    public init(campusPlaces: [CampusPlaceItem]) {
        self.campusPlaces = campusPlaces
    }
}

public enum LocationType: String, Codable, Hashable {
    case INDOOR
    case OUTDOOR
}
