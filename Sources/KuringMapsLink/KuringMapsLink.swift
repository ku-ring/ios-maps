public class KuringMapsLink {
    private static let antenna = Antenna()
    
    public static var allPlaces: [Place] {
        get async throws {
            try await antenna.allPlaces
        }
    }
}
