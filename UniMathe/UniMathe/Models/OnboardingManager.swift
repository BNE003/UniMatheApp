import SwiftUI
import Foundation

// MARK: - Onboarding Manager
class OnboardingManager: ObservableObject {
    private enum StorageKey {
        static let flowState = "onboardingFlowState_v2"
        static let currentScreen = "onboardingCurrentScreen_v2"
        static let legacyCompletion = "hasCompletedOnboarding"
    }
    
    private enum FlowState: String {
        case notStarted
        case inProgress
        case completed
    }
    
    @Published var currentScreen: OnboardingScreen = .languageSelection
    @Published var isOnboardingComplete = false
    @Published var showOnboarding = false
    @Published var shouldShowPaywall = false
    
    init() {
        let flowState = loadFlowState()
        
        if flowState == .completed {
            self.isOnboardingComplete = true
            self.showOnboarding = false
            self.currentScreen = .languageSelection
        } else {
            self.isOnboardingComplete = false
            self.showOnboarding = true
            self.currentScreen = loadCurrentScreen()
            
            // Make sure onboarding always starts at the language step on the first open.
            if flowState == .notStarted {
                self.currentScreen = .languageSelection
            }
        }
    }
    
    func nextScreen() {
        persistFlowState(.inProgress)
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            switch currentScreen {
            case .languageSelection:
                currentScreen = .themeSelection
            case .themeSelection:
                currentScreen = .learningTopics
            case .learningTopics:
                currentScreen = .stepByStep
            case .stepByStep:
                currentScreen = .exams
            case .exams:
                currentScreen = .exercises
            case .exercises:
                currentScreen = .matrixMethods
            case .matrixMethods:
                currentScreen = .learningPlan
            case .learningPlan:
                currentScreen = .monthlyUpdates
            case .monthlyUpdates:
                // Show paywall when "Fertig" is clicked
                shouldShowPaywall = true
            }
        }
        
        persistCurrentScreen()
    }
    
    func previousScreen() {
        persistFlowState(.inProgress)
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            switch currentScreen {
            case .themeSelection:
                currentScreen = .languageSelection
            case .learningTopics:
                currentScreen = .themeSelection
            case .stepByStep:
                currentScreen = .learningTopics
            case .exams:
                currentScreen = .stepByStep
            case .exercises:
                currentScreen = .exams
            case .learningPlan:
                currentScreen = .matrixMethods
            case .matrixMethods:
                currentScreen = .exercises
            case .monthlyUpdates:
                currentScreen = .learningPlan

            default:
                break
            }
        }
        
        persistCurrentScreen()
    }
    
    func completeOnboarding() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.9)) {
            isOnboardingComplete = true
            showOnboarding = false
        }
        
        persistFlowState(.completed)
        UserDefaults.standard.set(true, forKey: StorageKey.legacyCompletion)
        UserDefaults.standard.removeObject(forKey: StorageKey.currentScreen)
    }
    
    func resetOnboarding() {
        UserDefaults.standard.set(false, forKey: StorageKey.legacyCompletion)
        persistFlowState(.notStarted)
        UserDefaults.standard.removeObject(forKey: StorageKey.currentScreen)
        currentScreen = .languageSelection
        isOnboardingComplete = false
        showOnboarding = true
    }
    
    var screenProgress: Double {
        let progressScreens = OnboardingScreen.progressScreens
        guard let currentIndex = progressScreens.firstIndex(of: currentScreen) else {
            return 0.0
        }
        
        let totalSteps = progressScreens.count
        guard totalSteps > 0 else { return 0.0 }
        
        return Double(currentIndex + 1) / Double(totalSteps)
    }
    
    var currentProgressStep: Int {
        guard let currentIndex = OnboardingScreen.progressScreens.firstIndex(of: currentScreen) else {
            return 0
        }
        
        return currentIndex + 1
    }
    
    var progressStepCount: Int {
        OnboardingScreen.progressScreens.count
    }
    
    var isFirstScreen: Bool {
        currentScreen == .languageSelection
    }
    
    var isLastScreen: Bool {
        currentScreen == .monthlyUpdates
    }
    
    private func loadFlowState() -> FlowState {
        if let rawValue = UserDefaults.standard.string(forKey: StorageKey.flowState),
           let flowState = FlowState(rawValue: rawValue) {
            return flowState
        }
        
        UserDefaults.standard.set(FlowState.notStarted.rawValue, forKey: StorageKey.flowState)
        return .notStarted
    }
    
    private func loadCurrentScreen() -> OnboardingScreen {
        guard let rawValue = UserDefaults.standard.string(forKey: StorageKey.currentScreen),
              let screen = OnboardingScreen(rawValue: rawValue) else {
            return .languageSelection
        }
        
        return screen
    }
    
    private func persistFlowState(_ flowState: FlowState) {
        UserDefaults.standard.set(flowState.rawValue, forKey: StorageKey.flowState)
    }
    
    private func persistCurrentScreen() {
        guard !isOnboardingComplete else { return }
        UserDefaults.standard.set(currentScreen.rawValue, forKey: StorageKey.currentScreen)
    }
}

// MARK: - Onboarding Screens Enum
enum OnboardingScreen: String, CaseIterable {
    case languageSelection
    case themeSelection
    case learningTopics
    case stepByStep
    case exams
    case exercises
    case matrixMethods
    case learningPlan
    case monthlyUpdates
    
    var title: String {
        switch self {
        case .languageSelection:
            return "Sprache wählen"
        case .themeSelection:
            return "Hell oder Dunkel"
        case .learningTopics:
            return "Alle Themen meistern"
        case .stepByStep:
            return "Schritt für Schritt"
        case .exams:
            return "Klausuren üben"
        case .exercises:
            return "400+ Aufgaben"
        case .matrixMethods:
            return "Matrix-Rechnen"
        case .learningPlan:
            return "Dein Lernplan"
        case .monthlyUpdates:
            return "Immer aktuell bleiben"
        }
    }
    
    var englishTitle: String {
        switch self {
        case .languageSelection:
            return "Choose Language"
        case .themeSelection:
            return "Choose Theme"
        case .learningTopics:
            return "Master All Topics"
        case .stepByStep:
            return "Step by Step"
        case .exams:
            return "Practice Exams"
        case .exercises:
            return "400+ Problems"
        case .matrixMethods:
            return "Matrix Skills"
        case .learningPlan:
            return "Your Learning Plan"
        case .monthlyUpdates:
            return "Stay Up to Date"
        }
    }
    
    var description: String {
        switch self {
        case .languageSelection:
            return "Wählen Sie Ihre bevorzugte Sprache für das beste Lernerlebnis"
        case .themeSelection:
            return "Stellen Sie direkt Ihr bevorzugtes Erscheinungsbild ein"
        case .learningTopics:
            return "Von Grundlagen bis zu fortgeschrittenen Themen - alles an einem Ort"
        case .stepByStep:
            return "Detaillierte Erklärungen und Lösungswege für jede Aufgabe"
        case .exams:
            return "Bereiten Sie sich optimal auf Ihre Klausuren vor"
        case .exercises:
            return "Über 400 sorgfältig ausgewählte Übungsaufgaben"
        case .matrixMethods:
            return "Gauss, Determinanten und Matrixrechnung mit Rechenweg"
        case .learningPlan:
            return "Stelle deinen persönlichen Lernplan zusammen"
        case .monthlyUpdates:
            return "Jeden Monat neue Inhalte, Übungen und Prüfungen"
        }
    }
    
    var englishDescription: String {
        switch self {
        case .languageSelection:
            return "Choose your preferred language for the best learning experience"
        case .themeSelection:
            return "Pick your preferred appearance right away"
        case .learningTopics:
            return "From basics to advanced topics - everything in one place"
        case .stepByStep:
            return "Detailed explanations and solution paths for every problem"
        case .exams:
            return "Prepare optimally for your exams"
        case .exercises:
            return "Over 400 carefully selected practice problems"
        case .matrixMethods:
            return "Gauss, determinants, and matrix calculations with steps"
        case .learningPlan:
            return "Build your personal learning plan"
        case .monthlyUpdates:
            return "New content, exercises and exams every month"
        }
    }
    
    var iconName: String {
        switch self {
        case .languageSelection:
            return "globe"
        case .themeSelection:
            return "circle.lefthalf.filled"
        case .learningTopics:
            return "book.fill"
        case .stepByStep:
            return "list.number"
        case .exams:
            return "graduationcap.fill"
        case .exercises:
            return "checkmark.circle.fill"
        case .matrixMethods:
            return "tablecells.fill"
        case .learningPlan:
            return "sparkles.rectangle.stack.fill"
        case .monthlyUpdates:
            return "calendar.badge.plus"
        }
    }
    
    var color: Color {
        switch self {
        case .languageSelection:
            return Color.blue
        case .themeSelection:
            return Color.indigo
        case .learningTopics:
            return Color.green
        case .stepByStep:
            return Color.orange
        case .exams:
            return Color.purple
        case .exercises:
            return Color.red
        case .matrixMethods:
            return Color.teal
        case .learningPlan:
            return Color.blue
        case .monthlyUpdates:
            return Color.mint
        }
    }
    
    static var progressScreens: [OnboardingScreen] {
        allCases.filter { $0 != .languageSelection }
    }
}
