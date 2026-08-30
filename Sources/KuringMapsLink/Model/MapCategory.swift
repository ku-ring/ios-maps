//
//  MapCategory.swift
//  package-kuring-maps
//
//  Created by Jung Hwan Park on 7/26/26.
//

import Foundation

public struct MapCategory: Codable, Identifiable, Hashable {
    public var id: String { name }
    
    public let name: String
    public let korName: String
    public let displayOrder: Int
    
    public init(name: String, korName: String, displayOrder: Int) {
        self.name = name
        self.korName = korName
        self.displayOrder = displayOrder
    }
}

public struct MapCategoryListResponse: Codable {
    public let categories: [MapCategory]
    
    public init(categories: [MapCategory]) {
        self.categories = categories
    }
}
