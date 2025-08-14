import Foundation
import UIKit
import PostHog

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let POSTHOG_API_KEY = "phc_gMVQxeaGPS4BOMQYTHPGKTZ4G4TGbxnev9yFZPe4BfU"
        let POSTHOG_HOST = "https://eu.i.posthog.com"

        let config = PostHogConfig(apiKey: POSTHOG_API_KEY, host: POSTHOG_HOST)
        PostHogSDK.shared.setup(config)

        // Test event to verify installation
        PostHogSDK.shared.capture("Test Event")

        return true
    }
}



