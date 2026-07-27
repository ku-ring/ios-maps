//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Satellite
import Foundation

class Antenna {
    private let satellite: Satellite
    
    init() {
        #if DEBUG
        satellite = Satellite(host: KuringMapsLink.linkHost, scheme: .https)
        satellite._startGPS()
        #else
        satellite = Satellite(host: KuringMapsLink.linkHost)
        #endif
    }
    
    func categories() async throws -> MapCategoryListResponse {
        let response: Response<MapCategoryListResponse> = try await satellite.response(
            for: "api/v2/maps/categories",
            httpMethod: .get
        )
        return response.data
    }
    
    func buildings() async throws -> BuildingListResponse {
        let response: Response<BuildingListResponse> = try await satellite.response(
            for: "api/v2/maps/buildings",
            httpMethod: .get
        )
        return response.data
    }
    
    func campusPlaces(categories: [String]) async throws -> CampusPlaceListResponse {
        let response: Response<CampusPlaceListResponse> = try await satellite.response(
            for: "api/v2/maps/campus-places",
            httpMethod: .get,
            queryItems: [.init(name: "categories", value: categories.joined(separator: ","))]
        )
        return response.data
    }
    
    func getBuildingDetail(id: Int) async throws -> BuildingDetailResponse {
        let response: Response<BuildingDetailResponse> = try await satellite.response(
            for: "api/v2/maps/buildings/\(id)",
            httpMethod: .get
        )
        return response.data
    }
}

struct Response<ResultData: Decodable>: Decodable {
    let code: Int
    let message: String
    let data: ResultData
}
