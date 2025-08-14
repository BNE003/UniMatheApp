import Foundation
import UIKit
import PostHog

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let POSTHOG_API_KEY = "phc_gMVQxeaGPS4BOMQYTHPGKTZ4G4TGbxnev9yFZPe4BfU"
        let POSTHOG_HOST = "https://eu.i.posthog.com"

        let config = PostHogConfig(apiKey: POSTHOG_API_KEY, host: POSTHOG_HOST)
        
        // Basic tracking
        config.captureApplicationLifecycleEvents = true
        config.captureScreenViews = true
        
        // Performance optimizations
        config.flushAt = 20 // Batch size
        config.flushIntervalSeconds = 30 // Flush interval
        config.maxQueueSize = 1000
        config.maxBatchSize = 50
        
        // Privacy & User Management
        config.personProfiles = .identifiedOnly // Cost-efficient: only identified users get profiles
        
        // Optional features (enable as needed)
        config.sessionReplay = true // Session recordings aktiviert
        config.sendFeatureFlagEvent = true // For A/B testing
        config.preloadFeatureFlags = true
        
        // Debug (disable in production)
        #if DEBUG
        config.debug = true
        #else
        config.debug = false
        #endif
        
        // BeforeSend Block für Session Replay Optimierung
        config.setBeforeSend { event in
            // Nur wichtige Sessions aufzeichnen (z.B. nicht bei kurzen App-Öffnungen)
            if event.event == "$session_id" {
                // Beispiel: Nur Sessions > 30 Sekunden aufzeichnen
                return event
            }
            return event
        }
        
        PostHogSDK.shared.setup(config)

        // Track app launch
        PostHogSDK.shared.capture("app_launched", properties: [
            "platform": "iOS",
            "app_version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown",
            "session_replay_enabled": true
        ])

        return true
    }
}



