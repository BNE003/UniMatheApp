import Foundation
import SwiftUI
import Combine
import StoreKit

enum AppLanguage: String, CaseIterable, Codable {
    case german = "de"
    case english = "en"
    
    var displayName: String {
        switch self {
        case .german: return "Deutsch"
        case .english: return "English"
        }
    }
}

class SettingsModel: ObservableObject {
    static let shared = SettingsModel()
    
    @Published var language: AppLanguage {
        didSet {
            UserDefaults.standard.set(language.rawValue, forKey: "appLanguage")
        }
    }
    
    @Published var isDarkModeEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isDarkModeEnabled, forKey: "isDarkModeEnabled")
        }
    }
    
    @Published var useLargeText: Bool {
        didSet {
            UserDefaults.standard.set(useLargeText, forKey: "useLargeText")
        }
    }
    
    @Published var notificationsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
        }
    }
    
    @Published var accentColor: Color {
        didSet {
            if let colorData = try? NSKeyedArchiver.archivedData(withRootObject: UIColor(accentColor), requiringSecureCoding: false) {
                UserDefaults.standard.set(colorData, forKey: "accentColor")
            }
        }
    }
    
    // App Rating Properties
    private var appLaunchCount: Int = 0
    private var appUsageTime: TimeInterval = 0
    private var appStartTime: Date?
    private var hasAskedForReview: Bool = false
    
    private init() {
        // Load saved settings or use defaults
        if let savedLanguage = UserDefaults.standard.string(forKey: "appLanguage"),
           let language = AppLanguage(rawValue: savedLanguage) {
            self.language = language
        } else {
            // Try to use system language preference first
            if let preferredLanguage = Locale.current.languageCode {
                if preferredLanguage.starts(with: "de") {
                    self.language = .german
                } else {
                    self.language = .english
                }
            } else {
                self.language = .german // Default language if we can't detect
            }
        }
        
        self.isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
        self.useLargeText = UserDefaults.standard.bool(forKey: "useLargeText")
        self.notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        
        // Default accent color is blue
        if let colorData = UserDefaults.standard.data(forKey: "accentColor"),
           let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
            self.accentColor = Color(color)
        } else {
            self.accentColor = .blue
        }
        
        // Load app rating data
        self.appLaunchCount = UserDefaults.standard.integer(forKey: "appLaunchCount")
        self.appUsageTime = UserDefaults.standard.double(forKey: "appUsageTime")
        self.hasAskedForReview = UserDefaults.standard.bool(forKey: "hasAskedForReview")
        
        // Register for app lifecycle notifications
        setupAppLifecycleObservers()
    }
    
    // MARK: - Language Settings
    
    func setLanguage(_ language: AppLanguage) {
        self.language = language
        UserDefaults.standard.set(true, forKey: "hasSelectedLanguage")
    }
    
    // MARK: - App Rating Methods
    
    func trackAppLaunch() {
        if !hasAskedForReview {
            appLaunchCount += 1
            UserDefaults.standard.set(appLaunchCount, forKey: "appLaunchCount")
            appStartTime = Date()
            
            // Check if we should ask for review based on launch count
            if appLaunchCount >= 2 {
                requestAppReview()
            }
        }
    }
    
    func trackAppDidEnterBackground() {
        if let startTime = appStartTime {
            let sessionTime = Date().timeIntervalSince(startTime)
            appUsageTime += sessionTime
            UserDefaults.standard.set(appUsageTime, forKey: "appUsageTime")
            
            // Check if we should ask for review based on usage time
            if appUsageTime >= 5 * 60 && !hasAskedForReview { // 5 minutes in seconds
                requestAppReview()
            }
            
            appStartTime = nil
        }
    }
    
    func trackAppWillEnterForeground() {
        appStartTime = Date()
    }
    
    private func requestAppReview() {
        guard !hasAskedForReview else { return }
        
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
                self.hasAskedForReview = true
                UserDefaults.standard.set(true, forKey: "hasAskedForReview")
            }
        }
    }
    
    private func setupAppLifecycleObservers() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.trackAppDidEnterBackground()
        }
        
        NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.trackAppWillEnterForeground()
        }
    }
} 