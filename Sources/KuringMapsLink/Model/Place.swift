//
//  File.swift
//  
//
//  Created by Jaesung Lee on 2023/05/03.
//

import Foundation

/**
 ```json
 {
     "category": "건국대학교",
     "address": "서울특별시 광진구 능동로 120",
     "longitude": 127.07382,
     "id": "상허기념도서관",
     "number": 9,
     "iconUrl": "area.library.light",
     "inCampus": true,
     "latitude": 37.54209,
     "places": {
       "휴게실": [
         "상허쉼터"
       ],
       "식당": [
         "상허마루"
       ],
       "카페": [
         "도서관레스티오"
       ]
     },
     "name": "상허기념도서관"
   },
 ```
 */
public struct Place: Codable, Hashable, Identifiable {
    /// 장소 ID
    public let id: String
    /// 장소 이름. e.g., `"상허기념도서관"`
    public let name: String
    /// 장소 카테고리. e.g., `""`
    public let category: String
    public let address: String
    public let inCampus: Bool
    public let number: Int?
    public let iconUrl: String?
    public let latitude: Double
    public let longitude: Double
    public let phone: String?
    public let data: String?
    public let places: [String: [String]]
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Place, rhs: Place) -> Bool {
        lhs.id == rhs.id
    }
    
    public init(id: String, name: String, category: String, address: String, inCampus: Bool, number: Int?, iconUrl: String?, latitude: Double, longitude: Double, phone: String?, data: String?, places: [String: [String]]) {
        self.id = id
        self.name = name
        self.category = category
        self.address = address
        self.inCampus = inCampus
        self.number = number
        self.iconUrl = iconUrl
        self.latitude = latitude
        self.longitude = longitude
        self.phone = phone
        self.data = data
        self.places = places
    }
}
