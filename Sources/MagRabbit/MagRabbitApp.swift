import SwiftUI
import GoogleMobileAds

@main
struct MagRabbitApp: App {
    init() {
        MobileAds.shared.start { _ in }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
