//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

public class KuringMapsLink {
    private static let antenna = Antenna()
    
    public static var linkHost: String = ""
    public static var libraryHost: String = ""
    
    public static func fetchCategories() async throws -> MapCategoryListResponse {
        try await antenna.categories()
    }
    
    public static func fetchBuildings() async throws -> BuildingListResponse {
        try await antenna.buildings()
    }
    
    public static func searchBuildings(by keyword: String) async throws -> MapSearchResponse {
        try await antenna.search(by: keyword)
    }
    
    public static func fetchCampusPlaces(categories: [String]) async throws -> CampusPlaceListResponse {
        try await antenna.campusPlaces(categories: categories)
    }
    
    public static func fetchBuildingDetail(id: Int) async throws -> BuildingDetailResponse {
        try await antenna.getBuildingDetail(id: id)
    }
}
