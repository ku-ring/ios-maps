//
//  KuringMapViewModel.swift
//  package-kuring-maps
//
//  Created by Jung Hwan Park on 7/26/26.
//

import SwiftUI
import Combine
import KuringMapsLink

@MainActor
public class KuringMapViewModel: ObservableObject {
    // 카테고리
    @Published public var categories: [MapCategory] = []
    @Published public var selectedCategoryNames: Set<String> = []
    
    // 건물들
    @Published public var allBuildings: [Building] = []
    
    // 시설들
    @Published public var campusPlaces: [CampusPlaceItem] = []
    
    // 선택된 건물들
    @Published public var selectedBuilding: Building? = nil
    // 선택된 건물에 대한 상세 정보
    @Published public var selectedBuildingDetail: BuildingDetailResponse? = nil
    @Published public var showBottomSheet: Bool = false
    @Published public var isLoadingBuildingDetail: Bool = false
    
    // 검색
    @Published public var searchText: String = ""
    @Published public var searchResults: [Building] = []
    @Published public var recentSearches: [RecentSearch] = []
    
    public init() {
        self.categories = Self.defaultCategories
    }
    
    public static let defaultCategories: [MapCategory] = [
        MapCategory(name: "cafe", korName: "카페", displayOrder: 1),
        MapCategory(name: "restaurant", korName: "음식점", displayOrder: 2),
        MapCategory(name: "printer", korName: "프린터", displayOrder: 3),
        MapCategory(name: "smoking_booth", korName: "흡연부스", displayOrder: 4),
        MapCategory(name: "convenience_store", korName: "편의점", displayOrder: 5),
        MapCategory(name: "lounge", korName: "휴게공간", displayOrder: 6),
        MapCategory(name: "kcube", korName: "K-Cube", displayOrder: 7)
    ]
    
    // 카테고리와 건물 초기 설정
    public func loadInitialData() async {
        do {
            let categoryResponse = try await KuringMapsLink.fetchCategories()
            self.categories = categoryResponse.categories.sorted(by: { $0.displayOrder < $1.displayOrder })
        } catch {
            print("Failed to fetch categories: \(error)")
            self.categories = Self.defaultCategories
        }
        
        do {
            let buildingResponse = try await KuringMapsLink.fetchBuildings()
            self.allBuildings = buildingResponse.buildings
        } catch {
            print("Failed to fetch buildings: \(error)")
        }
    }
    
    public func toggleCategory(_ category: MapCategory) {
        if selectedCategoryNames.contains(category.name) {
            selectedCategoryNames.remove(category.name)
        } else {
            selectedCategoryNames.insert(category.name)
        }
        
        Task {
            await fetchCampusPlacesForSelectedCategories()
        }
    }
    
    /// 선택된 카테고리에 대한 시설들 가져오기
    private func fetchCampusPlacesForSelectedCategories() async {
        guard !selectedCategoryNames.isEmpty else {
            self.campusPlaces = []
            return
        }
        
        do {
            let campusPlaceResponse = try await KuringMapsLink.fetchCampusPlaces(categories: Array(selectedCategoryNames))
            self.campusPlaces = campusPlaceResponse.campusPlaces
        } catch {
            print("Failed to fetch campus places: \(error)")
            self.campusPlaces = []
        }
    }
    
    /// 건물 선택, 건물 상세 정보 가져오기
    public func selectBuilding(id: Int) async {
        if let building = allBuildings.first(where: { $0.id == id }) {
            self.selectedBuilding = building
        } else if let campusPlace = campusPlaces.first(where: { $0.building.id == id }) {
            self.selectedBuilding = campusPlace.building
        }
        
        self.isLoadingBuildingDetail = true
        do {
            let detail = try await KuringMapsLink.fetchBuildingDetail(id: id)
            self.selectedBuildingDetail = detail
            self.showBottomSheet = true
        } catch {
            print("Failed to fetch building detail: \(error)")
        }
        self.isLoadingBuildingDetail = false
    }
    
    public func deselectBuilding() {
        DispatchQueue.main.async {
            self.selectedBuilding = nil
            self.selectedBuildingDetail = nil
            self.showBottomSheet = false
        }
    }
    
    public func performSearch(_ query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        searchResults = allBuildings.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }
    
    public func commitSearch(_ query: String) {
        guard !query.isEmpty else { return }
        if !recentSearches.contains(where: { $0.query == query }) {
            recentSearches.insert(RecentSearch(query: query, iconName: "building"), at: 0)
        }
    }
}
