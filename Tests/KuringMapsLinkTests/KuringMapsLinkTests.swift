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
    
    func test_categories() async throws {
        let categories = try await KuringMapsLink.fetchCategories()
        print(categories)
        XCTAssertFalse(categories.categories.isEmpty)
    }
    
    func test_buildingsFromServer() async throws {
        let buildings = try await KuringMapsLink.fetchBuildings()
        print(buildings)
        XCTAssertFalse(buildings.buildings.isEmpty)
    }
}
