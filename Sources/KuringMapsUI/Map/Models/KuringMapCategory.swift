//
//  KuringMapCategory.swift
//  package-kuring-maps
//
//  Created by Jung Hwan Park on 7/19/26.
//

import Foundation

struct KuringMapCategory: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let icon: String
    
    static func == (lhs: KuringMapCategory, rhs: KuringMapCategory) -> Bool {
        lhs.title == rhs.title
    }
}
