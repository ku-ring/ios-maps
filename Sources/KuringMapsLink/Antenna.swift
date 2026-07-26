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
        #else
        satellite = Satellite(host: KuringMapsLink.linkHost)
        #endif
    }
    
    func places(parentId: String) async throws -> [Place] {
        let response: Response<[Place]> = try await satellite.response(
            for: "api/v1/places",
            httpMethod: .get,
            queryItems: [.init(name: "parentId", value: parentId)]
        )
        return response.data
    }
    
    func categories() async throws -> CategoryListResponse {
        let response: Response<CategoryListResponse> = try await satellite.response(
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
    
    func search() async throws -> [Place] {
        let response: Response<[Place]> = try await satellite.response(
            for: "api/v2/maps/buildings/search",
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
    
    func getBuildingDetail() async throws -> BuildingDetailResponse {
        let response: Response<BuildingDetailResponse> = try await satellite.response(
            for: "api/v2/maps/buildings/3",
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
