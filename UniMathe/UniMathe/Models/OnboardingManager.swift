import SwiftUI
import Foundation
import PostHog

// MARK: - Onboarding Manager
class OnboardingManager: ObservableObject {
    @Published var currentScreen: OnboardingScreen = .languageSelection
    @Published var isOnboardingComplete = false
    @Published var showOnboarding = false
    @Published var shouldShowPaywall = false
    
    init() {
        // Check if user has completed onboarding before
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        self.isOnboardingComplete = hasCompletedOnboarding
        self.showOnboarding = !hasCompletedOnboarding
        
        // If not completed, start with language selection
        if !hasCompletedOnboarding {
            self.currentScreen = .languageSelection
        }
    }
    
    func nextScreen() {
        let previousScreen = currentScreen
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            switch currentScreen {
            case .languageSelection:
                currentScreen = .learningTopics
            case .learningTopics:
                currentScreen = .stepByStep
            case .stepByStep:
                currentScreen = .exams
            case .exams:
                currentScreen = .exercises
            case .exercises:
                currentScreen = .monthlyUpdates
            case .monthlyUpdates:
                // Show paywall when "Fertig" is clicked
                shouldShowPaywall = true
            }
        }
        
        PostHogSDK.shared.capture("onboarding_screen_advanced", properties: [
            "from_screen": previousScreen.title,
            "to_screen": currentScreen.title,
            "language": SettingsModel.shared.language.rawValue
        ])
    }
    
    func previousScreen() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            switch currentScreen {
            case .learningTopics:
                currentScreen = .languageSelection
            case .stepByStep:
                currentScreen = .learningTopics
            case .exams:
                currentScreen = .stepByStep
            case .exercises:
                currentScreen = .exams
            case .monthlyUpdates:
                currentScreen = .exercises

            default:
                break
            }
        }
    }
    
    func completeOnboarding() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.9)) {
            isOnboardingComplete = true
            showOnboarding = false
        }
        
        PostHogSDK.shared.capture("onboarding_completed", properties: [
            "language": SettingsModel.shared.language.rawValue
        ])
        
        // Save completion state
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
    
    func resetOnboarding() {
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        currentScreen = .languageSelection
        isOnboardingComplete = false
        showOnboarding = true
    }
    
    var screenProgress: Double {
        let allScreens = OnboardingScreen.allCases
        let progressScreens = allScreens.filter { $0 != .languageSelection }

        guard let currentIndex = progressScreens.firstIndex(of: currentScreen) else {
            return 0.0
        }
        
        let totalSteps = progressScreens.count
        return Double(currentIndex + 1) / Double(totalSteps)
    }
    
    var isFirstScreen: Bool {
        currentScreen == .languageSelection
    }
    
    var isLastScreen: Bool {
        currentScreen == .monthlyUpdates
    }
}

// MARK: - Onboarding Screens Enum
enum OnboardingScreen: CaseIterable {
    case languageSelection
    case learningTopics
    case stepByStep
    case exams
    case exercises
    case monthlyUpdates
    
    var title: String {
        switch self {
        case .languageSelection:
            return "Sprache wählen"
        case .learningTopics:
            return "Alle Themen meistern"
        case .stepByStep:
            return "Schritt für Schritt"
        case .exams:
            return "Klausuren üben"
        case .exercises:
            return "300+ Aufgaben"
        case .monthlyUpdates:
            return "Immer aktuell bleiben"
        }
    }
    
    var englishTitle: String {
        switch self {
        case .languageSelection:
            return "Choose Language"
        case .learningTopics:
            return "Master All Topics"
        case .stepByStep:
            return "Step by Step"
        case .exams:
            return "Practice Exams"
        case .exercises:
            return "300+ Problems"
        case .monthlyUpdates:
            return "Stay Up to Date"
        }
    }
    
    var description: String {
        switch self {
        case .languageSelection:
            return "Wählen Sie Ihre bevorzugte Sprache für das beste Lernerlebnis"
        case .learningTopics:
            return "Von Grundlagen bis zu fortgeschrittenen Themen - alles an einem Ort"
        case .stepByStep:
            return "Detaillierte Erklärungen und Lösungswege für jede Aufgabe"
        case .exams:
            return "Bereiten Sie sich optimal auf Ihre Klausuren vor"
        case .exercises:
            return "Über 300 sorgfältig ausgewählte Übungsaufgaben"
        case .monthlyUpdates:
            return "Jeden Monat neue Inhalte, Übungen und Prüfungen"
        }
    }
    
    var englishDescription: String {
        switch self {
        case .languageSelection:
            return "Choose your preferred language for the best learning experience"
        case .learningTopics:
            return "From basics to advanced topics - everything in one place"
        case .stepByStep:
            return "Detailed explanations and solution paths for every problem"
        case .exams:
            return "Prepare optimally for your exams"
        case .exercises:
            return "Over 300 carefully selected practice problems"
        case .monthlyUpdates:
            return "New content, exercises and exams every month"
        }
    }
    
    var iconName: String {
        switch self {
        case .languageSelection:
            return "globe"
        case .learningTopics:
            return "book.fill"
        case .stepByStep:
            return "list.number"
        case .exams:
            return "graduationcap.fill"
        case .exercises:
            return "checkmark.circle.fill"
        case .monthlyUpdates:
            return "calendar.badge.plus"
        }
    }
    
    var color: Color {
        switch self {
        case .languageSelection:
            return Color.blue
        case .learningTopics:
            return Color.green
        case .stepByStep:
            return Color.orange
        case .exams:
            return Color.purple
        case .exercises:
            return Color.red
        case .monthlyUpdates:
            return Color.mint
        }
    }
} 