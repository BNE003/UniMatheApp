import Foundation
import SwiftUI
import Combine

class SettingsModel: ObservableObject {
    static let shared = SettingsModel()
    
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
    
    private init() {
        // Load saved settings or use defaults
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
    }
} 