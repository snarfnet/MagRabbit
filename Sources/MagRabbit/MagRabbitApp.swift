import AppTrackingTransparency
import GoogleMobileAds
import SwiftUI

class MagRabbitAppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        if UIDevice.current.userInterfaceIdiom == .phone {
            DispatchQueue.main.async {
                MobileAds.shared.start()
            }
        }
        return true
    }
}

@main
struct MagRabbitApp: App {
    @UIApplicationDelegateAdaptor(MagRabbitAppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    try? await Task.sleep(nanoseconds: 1_500_000_000)
                    if #available(iOS 14, *) {
                        _ = await ATTrackingManager.requestTrackingAuthorization()
                    }
                }
        }
    }
}
