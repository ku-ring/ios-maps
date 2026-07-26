//
//  Category.swift
//  package-kuring-maps
//
//  Created by Jung Hwan Park on 7/26/26.
//

import Foundation

struct Category: Codable {
    let name: String
    let korName: String
    let displayOrder: Int
}

struct CategoryListResponse: Codable {
    let categories: [Category]
}
