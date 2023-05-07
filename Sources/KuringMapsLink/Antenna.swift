//
//  Antenna.swift
//  
//
//  Created by Jaesung Lee on 2023/05/02.
//

import Satellite
import Foundation

class Antenna {
    private let satellite: Satellite
    
    init() {
        #if DEBUG
        satellite = Satellite(host: "ec2-54-173-178-211.compute-1.amazonaws.com:8080", scheme: .http)
        #else
        satellite = Satellite(host: "maps.ku-ring.com")
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
}


struct Response<ResultData: Decodable>: Decodable {
    let code: Int
    let message: String
    let data: ResultData
}
