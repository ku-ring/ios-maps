import XCTest
@testable import KuringMapsLink

final class KuringMapsLinkTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
    }
    
    func test_places() throws {
        let places = try Place.places
        print(places)
        XCTAssertFalse(places.isEmpty)
    }
    
    func test_placesFromServer() async throws {
        let places = try await KuringMapsLink.allPlaces
        print(places)
        XCTAssertFalse(places.isEmpty)
    }
}
