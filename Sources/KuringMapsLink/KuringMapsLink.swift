//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

public class KuringMapsLink {
    private static let antenna = Antenna()
    
    public static var linkHost: String = ""
    public static var libraryHost: String = ""
    
    public static var placesInKonkukUniv: [Place] {
        get async throws {
            try await antenna.places(parentId: "konkuk")
        }
    }
}
