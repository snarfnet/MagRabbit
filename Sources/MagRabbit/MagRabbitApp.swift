import SwiftUI
import GoogleMobileAds

@main
struct MagRabbitApp: App {
    init() {
        // Initialize Google Mobile Ads SDK
        GADMobileAds.sharedInstance().start()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
