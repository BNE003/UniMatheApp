import Foundation
import RevenueCat

enum RevenueCatManager {
    // Public SDK key from RevenueCat (safe to use in app code).
    private static let publicAppleAPIKey = "appl_LiTyWSwKQKgXYkEikgwqLgrjvit"
    private static let hasSyncedOnLaunchKey = "revenuecat_has_synced_on_launch_v1"

    static var isConfigured: Bool {
        Purchases.isConfigured
    }

    static func configure() {
        guard !publicAppleAPIKey.isEmpty else {
            print("RevenueCat: Missing public Apple API key. Skipping configuration.")
            return
        }

#if DEBUG
        Purchases.logLevel = .debug
#endif

        Purchases.configure(
            with: .init(withAPIKey: publicAppleAPIKey)
                .with(purchasesAreCompletedBy: .myApp, storeKitVersion: .storeKit2)
        )
    }

    static func syncPurchasesIfNeededOnLaunch() {
        guard isConfigured else { return }
        guard !UserDefaults.standard.bool(forKey: hasSyncedOnLaunchKey) else { return }

        Purchases.shared.syncPurchases { _, error in
            if let error {
                print("RevenueCat initial sync failed: \(error.localizedDescription)")
                return
            }

            UserDefaults.standard.set(true, forKey: hasSyncedOnLaunchKey)
            print("RevenueCat initial sync completed.")
        }
    }

    static func syncPurchasesAfterTransaction() {
        guard isConfigured else { return }

        Purchases.shared.syncPurchases { _, error in
            if let error {
                print("RevenueCat sync after transaction failed: \(error.localizedDescription)")
            }
        }
    }
}
