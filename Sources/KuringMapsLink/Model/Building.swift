//
//  Building.swift
//  package-kuring-maps
//
//  Created by Jung Hwan Park on 7/26/26.
//

import Foundation

public enum OperatingPeriod: String, Codable, Hashable {
    case semester = "SEMESTER"
    case vacation = "VACATION"
}

public enum OperatingDayGroup: String, Codable, Hashable {
    case weekday = "WEEKDAY"
    case weekend = "WEEKEND"
}

public enum OperatingStatus: String, Codable, Hashable {
    case scheduled = "SCHEDULED"
    case open24Hours = "OPEN_24_HOURS"
    case unknown = "UNKNOWN"
}

public struct OperatingHour: Codable, Hashable {
    public let period: OperatingPeriod
    public let dayGroup: OperatingDayGroup
    public let status: OperatingStatus
    public let opensAt: String?
    public let closesAt: String?
    public let isCurrent: Bool
    
    public init(
        period: OperatingPeriod,
        dayGroup: OperatingDayGroup,
        status: OperatingStatus,
        opensAt: String?,
        closesAt: String?,
        isCurrent: Bool
    ) {
        self.period = period
        self.dayGroup = dayGroup
        self.status = status
        self.opensAt = opensAt
        self.closesAt = closesAt
        self.isCurrent = isCurrent
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
    public let operatingHours: [OperatingHour]
    public let campusPlaces: [CampusPlaceDetail]
    
    public init(
        id: Int,
        name: String,
        address: String,
        latitude: Double,
        longitude: Double,
        imageUrl: String?,
        operatingHours: [OperatingHour],
        campusPlaces: [CampusPlaceDetail]
    ) {
        self.id = id
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.imageUrl = imageUrl
        self.operatingHours = operatingHours
        self.campusPlaces = campusPlaces
    }
}

extension Array where Element == OperatingHour {
    public func isCurrent(for period: OperatingPeriod) -> Bool {
        return self.contains(where: { $0.period == period && $0.isCurrent == true })
    }
    
    public var formattedCurrentHours: String {
        if let current = self.first(where: { $0.isCurrent }) {
            return current.formattedString
        }
        return "운영시간 정보 없음"
    }
    
    public func formattedPeriodHours(for period: OperatingPeriod) -> String {
        let periodHours = self.filter { $0.period == period }
        if periodHours.isEmpty {
            return "운영시간 정보 없음"
        }
        
        var parts: [String] = []
        let sortedHours = periodHours.sorted { h1, h2 in
            if h1.dayGroup == .weekday && h2.dayGroup == .weekend { return true }
            if h1.dayGroup == .weekend && h2.dayGroup == .weekday { return false }
            return false
        }
        
        for hour in sortedHours {
            let dayGroupKor = hour.dayGroup == .weekday ? "주중" : "주말"
            parts.append("\(dayGroupKor) \(hour.formattedString)")
        }
        
        return parts.joined(separator: "\n")
    }
}

extension OperatingHour {
    public var formattedString: String {
        switch self.status {
        case .scheduled:
            if let opens = self.opensAt, let closes = self.closesAt {
                return "\(opens) ~ \(closes)"
            }
            return "운영 정보 없음"
        case .open24Hours:
            return "24시간 운영"
        case .unknown:
            return "운영시간 정보 없음"
        }
    }
}
