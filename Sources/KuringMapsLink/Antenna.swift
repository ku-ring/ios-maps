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
        satellite = Satellite(host: KuringMapsLink.linkHost, scheme: .http)
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
}


struct Response<ResultData: Decodable>: Decodable {
    let code: Int
    let message: String
    let data: ResultData
}
