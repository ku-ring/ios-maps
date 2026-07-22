//
//  KuringMapCategory.swift
//  package-kuring-maps
//
//  Created by Jung Hwan Park on 7/19/26.
//

import Foundation

public enum KuringMapCategory: String, CaseIterable, Identifiable {
    case cafe
    case cafeteria
    case printer
    case smoke
    case store
    case rest
    case kCube

    public var id: Self { self }

    public var title: String {
        switch self {
        case .cafe: return "교내 카페"
        case .cafeteria: return "식당"
        case .printer: return "프린터"
        case .smoke: return "흡연부스"
        case .store: return "편의점"
        case .rest: return "휴게실"
        case .kCube: return "k-cube"
        }
    }

    public var icon: String {
        switch self {
        case .cafe: return "cafe"
        case .cafeteria: return "cafeteria"
        case .printer: return "printer"
        case .smoke: return "smoke"
        case .store: return "store"
        case .rest: return "rest"
        case .kCube: return "k-cube"
        }
    }
}
