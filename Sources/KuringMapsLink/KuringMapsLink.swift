public class KuringMapsLink {
    private static let antenna = Antenna()
    
    public static var placesInKonkukUniv: [Place] {
        get async throws {
            try await antenna.places(parentId: "konkuk")
        }
    }
}
