//
//  KuringMapViewModel.swift
//  package-kuring-maps
//
//  Created by Jung Hwan Park on 7/26/26.
//

import SwiftUI
import Combine
import KuringMapsLink

public enum SearchBarState: Equatable {
    case normal
    case active(keyword: String)
    
    public var isActive: Bool {
        switch self {
        case .normal: return false
        case .active: return true
        }
    }
}

public enum MapBottomSheetState: Identifiable, Equatable {
    case list(places: [CampusPlaceItem])
    case detail(response: BuildingDetailResponse, parentList: [CampusPlaceItem]?)
    
    public var id: String {
        switch self {
        case .list:
            return "list"
        case .detail(let response, _):
            return "detail-\(response.id)"
        }
    }
}

@MainActor
public class KuringMapViewModel: ObservableObject {
    @Published public var searchBarState: SearchBarState = .normal
    @Published public var bottomSheetState: MapBottomSheetState? = nil
    
    // 카테고리
    @Published public var categories: [MapCategory] = []
    @Published public var selectedCategoryNames: Set<String> = []
    
    // 건물
    @Published public var allBuildings: [Building] = []
    
    // 시설
    @Published public var campusPlaces: [CampusPlaceItem] = []
    
    // 선택된 건물 + 선택된 건물에 대한 상세 정보
    @Published public var selectedBuilding: Building? = nil
    @Published public var selectedBuildingDetail: BuildingDetailResponse? = nil
    @Published public var isLoadingBuildingDetail: Bool = false
    
    // 검색
    @Published public var searchText: String = ""
    @Published public var searchResults: [Building] = []
    @Published public var recentSearches: [RecentSearch] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        self.categories = Self.defaultCategories
        setupSearchDebounce()
    }
    
    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                Task {
                    await self?.search(by: query)
                }
            }
            .store(in: &cancellables)
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
    
    /// 초기 건물들 조회
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
    
    /// 카테고리 선택
    public func toggleCategory(_ category: MapCategory) {
        if selectedCategoryNames.contains(category.name) {
            selectedCategoryNames.remove(category.name)
        } else {
            selectedCategoryNames.insert(category.name)
        }
        
        if selectedCategoryNames.isEmpty {
            self.searchBarState = .normal
            self.bottomSheetState = nil
            self.campusPlaces = []
        } else {
            self.searchBarState = .active(keyword: category.korName)
            Task {
                await fetchCampusPlacesForSelectedCategories()
            }
        }
    }
    
    /// 선택된 카테고리에 대한 시설들 가져오기
    private func fetchCampusPlacesForSelectedCategories() async {
        guard !selectedCategoryNames.isEmpty else {
            self.campusPlaces = []
            self.bottomSheetState = nil
            return
        }
        
        do {
            let campusPlaceResponse = try await KuringMapsLink.fetchCampusPlaces(categories: Array(selectedCategoryNames))
            self.campusPlaces = campusPlaceResponse.campusPlaces
            
            self.bottomSheetState = .list(places: self.campusPlaces)
        } catch {
            print("Failed to fetch campus places: \(error)")
            self.campusPlaces = []
            self.bottomSheetState = nil
        }
    }
    
    /// 건물 선택
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
            
            let parentList = selectedCategoryNames.isEmpty ? nil : self.campusPlaces
            self.bottomSheetState = .detail(response: detail, parentList: parentList)
        } catch {
            print("Failed to fetch building detail: \(error)")
        }
        self.isLoadingBuildingDetail = false
    }
    
    /// 시설 바텀시트에서 선택
    public func selectPlaceFromList(_ place: CampusPlaceItem) async {
        self.selectedBuilding = place.building
        self.isLoadingBuildingDetail = true
        do {
            let detail = try await KuringMapsLink.fetchBuildingDetail(id: place.building.id)
            self.selectedBuildingDetail = detail
            self.bottomSheetState = .detail(response: detail, parentList: self.campusPlaces)
        } catch {
            print("Failed to fetch building detail: \(error)")
        }
        self.isLoadingBuildingDetail = false
    }
    
    /// 상세 정보 뷰에서 dismiss
    public func dismissDetailView(parentList: [CampusPlaceItem]?) {
        if let parentList {
            self.bottomSheetState = .list(places: parentList)
        } else {
            self.bottomSheetState = nil
            self.selectedBuilding = nil
            self.selectedBuildingDetail = nil
        }
    }
    
    public func deselectBuilding() {
        self.bottomSheetState = nil
        self.selectedBuilding = nil
        self.selectedBuildingDetail = nil
    }
    
    /// 검색 결과 선택
    public func selectSearchResult(_ building: Building) async {
        self.selectedBuilding = building
        self.searchBarState = .active(keyword: searchText)
        
        self.isLoadingBuildingDetail = true
        do {
            let detail = try await KuringMapsLink.fetchBuildingDetail(id: building.id)
            self.selectedBuildingDetail = detail
            self.bottomSheetState = .detail(response: detail, parentList: nil)
        } catch {
            print("Failed to fetch building detail: \(error)")
        }
        self.isLoadingBuildingDetail = false
    }
    
    /// 활성화된 검색창에서 뒤로 갈 때
    public func tapBackOnSearchBar() {
        self.searchBarState = .normal
        self.selectedCategoryNames.removeAll()
        self.campusPlaces.removeAll()
        self.bottomSheetState = nil
        self.selectedBuilding = nil
        self.selectedBuildingDetail = nil
        self.searchText = ""
    }
    
    /// 활성화된 검색창에서 x 를 눌렀을 때
    public func tapClearOnSearchBar() {
        self.searchBarState = .normal
        self.selectedCategoryNames.removeAll()
        self.campusPlaces.removeAll()
        self.bottomSheetState = nil
        self.selectedBuilding = nil
        self.selectedBuildingDetail = nil
        self.searchText = ""
    }
    
    public func search(by query: String) async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            self.searchResults = []
            return
        }
        
        do {
            let response = try await KuringMapsLink.searchBuildings(by: trimmed)
            self.searchResults = response.buildings
        } catch {
            print("Failed to search buildings: \(error)")
            self.searchResults = allBuildings.filter { $0.name.localizedCaseInsensitiveContains(trimmed) }
        }
    }
    
    public func commitSearch(_ query: String) {
        guard !query.isEmpty else {
            return
        }
        if !recentSearches.contains(where: { $0.query == query }) {
            recentSearches.insert(RecentSearch(query: query, iconName: "building"), at: 0)
        }
        Task {
            await search(by: query)
        }
    }
}
