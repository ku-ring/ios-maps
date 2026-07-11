import SwiftUI
import KuringMapsUI
import KuringMapsLink

@main
struct KuringMapsExampleApp: App {
    var body: some Scene {
        WindowGroup {
            KuringMap(
                linkConfig: .init(host: ""),
                libConfig: .init(host: "")
            )
            .environment(\.mapAppearance, Appearance())
        }
    }
}
