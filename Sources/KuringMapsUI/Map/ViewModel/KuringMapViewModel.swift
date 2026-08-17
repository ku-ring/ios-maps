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

public enum ParentListType: Equatable {
    case places([CampusPlaceItem])
    case buildings([BuildingDetailResponse])
}

public enum MapBottomSheetState: Identifiable, Equatable {
    case list(places: [CampusPlaceItem])
    case buildingList(buildings: [BuildingDetailResponse])
    case detail(response: BuildingDetailResponse, parentList: ParentListType?)
    
    public var id: String {
        switch self {
        case .list:
            return "list"
        case .buildingList:
            return "buildingList"
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
    @Published public var searchPlaceResults: [CampusPlaceItem] = []
    @Published public var recentSearches: [RecentSearch] = []
    private var activeSearchBuildingDetails: [BuildingDetailResponse] = []
    
    @Published public var isMapRotated: Bool = false
    @Published public var mapHeading: Double = 0.0
    public let locationActionSubject = PassthroughSubject<Void, Never>()
    public let compassActionSubject = PassthroughSubject<Void, Never>()
    
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
        
        Task {
            await fetchCampusPlacesForSelectedCategories()
        }
    }
    
    /// 선택된 카테고리에 대한 시설들 가져오기
    private func fetchCampusPlacesForSelectedCategories() async {
        if selectedCategoryNames.isEmpty {
            if !searchResults.isEmpty {
                self.campusPlaces = []
                self.bottomSheetState = .buildingList(buildings: self.activeSearchBuildingDetails)
            } else {
                self.searchBarState = .normal
                self.bottomSheetState = nil
                self.campusPlaces = []
            }
        } else {
            if !searchResults.isEmpty {
                do {
                    let response = try await KuringMapsLink.fetchCampusPlaces(categories: Array(selectedCategoryNames))
                    let searchBuildingIds = Set(searchResults.map { $0.id })
                    let filtered = response.campusPlaces.filter { item in
                        searchBuildingIds.contains(item.building.id)
                    }
                    self.campusPlaces = filtered
                    self.bottomSheetState = .list(places: filtered)
                } catch {
                    print("Failed to fetch campus places: \(error)")
                    self.campusPlaces = []
                    self.bottomSheetState = .list(places: [])
                }
            } else {
                if let firstCategoryName = selectedCategoryNames.first,
                   let mapCategory = categories.first(where: { $0.name == firstCategoryName }) {
                    self.searchBarState = .active(keyword: mapCategory.korName)
                }
                
                do {
                    let response = try await KuringMapsLink.fetchCampusPlaces(categories: Array(selectedCategoryNames))
                    self.campusPlaces = response.campusPlaces
                    self.bottomSheetState = .list(places: self.campusPlaces)
                } catch {
                    print("Failed to fetch campus places: \(error)")
                    self.campusPlaces = []
                    self.bottomSheetState = nil
                }
            }
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
            
            let parentList: ParentListType? = selectedCategoryNames.isEmpty ? nil : .places(self.campusPlaces)
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
            self.bottomSheetState = .detail(response: detail, parentList: .places(self.campusPlaces))
        } catch {
            print("Failed to fetch building detail: \(error)")
        }
        self.isLoadingBuildingDetail = false
    }
    
    /// 건물 바텀시트에서 선택
    public func selectBuildingFromList(_ building: BuildingDetailResponse) {
        self.selectedBuilding = Building(
            id: building.id,
            name: building.name,
            address: building.address,
            latitude: building.latitude,
            longitude: building.longitude
        )
        self.selectedBuildingDetail = building
        
        var parentList: ParentListType? = nil
        if case .buildingList(let list) = bottomSheetState {
            parentList = .buildings(list)
        }
        
        self.bottomSheetState = .detail(response: building, parentList: parentList)
    }
    
    /// 상세 정보 뷰에서 dismiss
    public func dismissDetailView(parentList: ParentListType?) {
        if let parentList {
            switch parentList {
            case .places(let list):
                self.bottomSheetState = .list(places: list)
            case .buildings(let list):
                self.bottomSheetState = .buildingList(buildings: list)
            }
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
            
            var siblingBuildingIds = Set(searchResults.map { $0.id })
            siblingBuildingIds.formUnion(searchPlaceResults.map { $0.building.id })

            let detailResponses = try await withThrowingTaskGroup(of: BuildingDetailResponse.self) { group in
                for id in siblingBuildingIds {
                    group.addTask {
                        try await KuringMapsLink.fetchBuildingDetail(id: id)
                    }
                }

                var results: [BuildingDetailResponse] = []
                for try await res in group {
                    results.append(res)
                }
                return results.sorted(by: { $0.name < $1.name })
            }
            
            self.activeSearchBuildingDetails = detailResponses
            self.bottomSheetState = .detail(response: detail, parentList: .buildings(detailResponses))
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
        self.searchResults.removeAll()
        self.searchPlaceResults.removeAll()
        self.activeSearchBuildingDetails.removeAll()
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
        self.searchResults.removeAll()
        self.searchPlaceResults.removeAll()
        self.activeSearchBuildingDetails.removeAll()
        self.bottomSheetState = nil
        self.selectedBuilding = nil
        self.selectedBuildingDetail = nil
        self.searchText = ""
    }
    
    public func search(by query: String) async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            self.searchResults = []
            self.searchPlaceResults = []
            return
        }

        do {
            let response = try await KuringMapsLink.searchBuildings(by: trimmed)
            self.searchResults = sortedSearchResults(response.buildings)
            self.searchPlaceResults = response.campusPlaces
        } catch {
            print("Failed to search buildings: \(error)")
            let filtered = allBuildings.filter { $0.name.localizedCaseInsensitiveContains(trimmed) }
            self.searchResults = sortedSearchResults(filtered)
            self.searchPlaceResults = []
        }
    }
    
    private func sortedSearchResults(_ buildings: [Building]) -> [Building] {
        let recentQueries = Set(recentSearches.map { $0.query })
        
        let matched = buildings.filter { recentQueries.contains($0.name) }
        let others = buildings.filter { !recentQueries.contains($0.name) }
        
        return matched + others
    }
    
    public func addRecentSearch(_ query: String) {
        guard !query.isEmpty else {
            return
        }
        if !recentSearches.contains(where: { $0.query == query }) {
            recentSearches.insert(RecentSearch(query: query, iconName: "building"), at: 0)
        }
    }
    
    public func commitSearch(_ query: String) {
        guard !query.isEmpty else {
            return
        }
        addRecentSearch(query)
        Task {
            await search(by: query)
        }
    }
}
