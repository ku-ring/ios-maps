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
        satellite = Satellite(host: "http://ec2-54-173-178-211.compute-1.amazonaws.com:8080/api/v1/places?category=ss", scheme: .http)
        #else
        satellite = Satellite(host: "maps.ku-ring.com")
        #endif
    }
    
    var allPlaces: [Place] {
        get async throws {
            let response: Response<[Place]> = try await satellite.response(
                for: "api/v1/places",
                httpMethod: .get
            )
            return response.data
        }
    }
}


struct Response<ResultData: Decodable>: Decodable {
    let code: Int
    let message: String
    let data: ResultData
}
