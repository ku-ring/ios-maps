//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import XCTest
@testable import KuringMapsLink

final class KuringMapsLinkTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
    }
    
    func test_places() throws {
        let places = Place.places
        print(places)
        XCTAssertFalse(places.isEmpty)
    }
    
    func test_placesFromServer() async throws {
        let places = try await KuringMapsLink.placesInKonkukUniv
        print(places)
        XCTAssertFalse(places.isEmpty)
    }
}
