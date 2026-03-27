import SwiftUI
import Foundation

// MARK: - Onboarding Manager
class OnboardingManager: ObservableObject {
    private enum StorageKey {
        static let flowState = "onboardingFlowState_v2"
        static let currentScreen = "onboardingCurrentScreen_v2"
        static let legacyCompletion = "hasCompletedOnboarding"
    }
    
    private static let initialScreen: OnboardingScreen = .themeSelection
    
    private enum FlowState: String {
        case notStarted
        case inProgress
        case completed
    }
    
    @Published var currentScreen: OnboardingScreen = initialScreen
    @Published var isOnboardingComplete = false
    @Published var showOnboarding = false
    @Published var shouldShowPaywall = false
    
    init() {
        let flowState = loadFlowState()
        
        if flowState == .completed {
            self.isOnboardingComplete = true
            self.showOnboarding = false
            self.currentScreen = Self.initialScreen
        } else {
            self.isOnboardingComplete = false
            self.showOnboarding = true
            self.currentScreen = loadCurrentScreen()
            
            // Make sure onboarding starts on the first content screen on first open.
            if flowState == .notStarted {
                self.currentScreen = Self.initialScreen
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
                currentScreen = .problemActivation
            case .problemActivation:
                currentScreen = .examSelection
            case .examSelection:
                currentScreen = .examPreview
            case .examPreview:
                currentScreen = .miniDiagnosis
            case .miniDiagnosis:
                currentScreen = .topicsShowcase
            case .topicsShowcase:
                currentScreen = .stepByStep
            case .stepByStep:
                currentScreen = .personalizedPlan
            case .personalizedPlan:
                currentScreen = .premiumTrialOffer
            case .premiumTrialOffer:
                currentScreen = .trialReminder
            case .trialReminder:
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
                break
            case .problemActivation:
                currentScreen = .themeSelection
            case .examSelection:
                currentScreen = .problemActivation
            case .examPreview:
                currentScreen = .examSelection
            case .miniDiagnosis:
                currentScreen = .examPreview
            case .topicsShowcase:
                currentScreen = .miniDiagnosis
            case .stepByStep:
                currentScreen = .topicsShowcase
            case .personalizedPlan:
                currentScreen = .stepByStep
            case .premiumTrialOffer:
                currentScreen = .personalizedPlan
            case .trialReminder:
                currentScreen = .premiumTrialOffer
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
        currentScreen = Self.initialScreen
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
        currentScreen == Self.initialScreen
    }
    
    var isLastScreen: Bool {
        currentScreen == .trialReminder
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
            return Self.initialScreen
        }
        
        // Migrate legacy in-progress users off the removed language step.
        if screen == .languageSelection {
            return Self.initialScreen
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
    case problemActivation
    case examSelection
    case examPreview
    case miniDiagnosis
    case topicsShowcase
    case stepByStep
    case personalizedPlan
    case premiumTrialOffer
    case trialReminder
    
    var title: String {
        switch self {
        case .languageSelection:
            return "Sprache wählen"
        case .themeSelection:
            return "Willkommen"
        case .problemActivation:
            return "Mathe-Klausur bald?"
        case .examSelection:
            return "Welche Prüfung steht an?"
        case .examPreview:
            return "Perfekt"
        case .miniDiagnosis:
            return "Mini-Diagnose"
        case .topicsShowcase:
            return "Themen entdecken"
        case .stepByStep:
            return "Schritt für Schritt"
        case .personalizedPlan:
            return "Dein Lernplan"
        case .premiumTrialOffer:
            return "3 Tage gratis"
        case .trialReminder:
            return "Erinnerung vor Ablauf"
        }
    }
    
    var englishTitle: String {
        switch self {
        case .languageSelection:
            return "Choose Language"
        case .themeSelection:
            return "Welcome"
        case .problemActivation:
            return "Exam Soon?"
        case .examSelection:
            return "Which exam is coming up?"
        case .examPreview:
            return "Perfect"
        case .miniDiagnosis:
            return "Mini Diagnosis"
        case .topicsShowcase:
            return "Explore Topics"
        case .stepByStep:
            return "Step by Step"
        case .personalizedPlan:
            return "Your Study Plan"
        case .premiumTrialOffer:
            return "3 Days Free"
        case .trialReminder:
            return "Reminder Before Trial Ends"
        }
    }
    
    var description: String {
        switch self {
        case .languageSelection:
            return "Wählen Sie Ihre bevorzugte Sprache für das beste Lernerlebnis"
        case .themeSelection:
            return "Lerne die App in wenigen Schritten kennen und starte direkt"
        case .problemActivation:
            return "Wie fühlst du dich gerade?"
        case .examSelection:
            return "Wir passen deinen Lernplan darauf an."
        case .examPreview:
            return "Dein personalisierter Klausur-Start ist bereit."
        case .miniDiagnosis:
            return "Wir passen deinen Lernweg an deine Hürden an."
        case .topicsShowcase:
            return "Viele Themen und passende Inhalte warten auf dich."
        case .stepByStep:
            return "Lerne komplexe Inhalte über klare Einzelschritte."
        case .personalizedPlan:
            return "Dein Plan führt dich gezielt bis zur Prüfung."
        case .premiumTrialOffer:
            return "Drei Tage Premiumzugang ohne sofortige Zahlung."
        case .trialReminder:
            return "Wir erinnern dich vor Ablauf deines Testzeitraums."
        }
    }
    
    var englishDescription: String {
        switch self {
        case .languageSelection:
            return "Choose your preferred language for the best learning experience"
        case .themeSelection:
            return "Get to know the app in a few steps and start right away"
        case .problemActivation:
            return "How do you feel right now?"
        case .examSelection:
            return "We'll tailor your learning plan accordingly."
        case .examPreview:
            return "Your personalized exam start is ready."
        case .miniDiagnosis:
            return "We tailor your learning path to your biggest blockers."
        case .topicsShowcase:
            return "Plenty of topics and matching content are ready for you."
        case .stepByStep:
            return "Understand complex topics through clear step-by-step guidance."
        case .personalizedPlan:
            return "Your plan guides you to exam day with clear priorities."
        case .premiumTrialOffer:
            return "Three days of premium access without paying now."
        case .trialReminder:
            return "We'll remind you before your trial period ends."
        }
    }
    
    var iconName: String {
        switch self {
        case .languageSelection:
            return "globe"
        case .themeSelection:
            return "hand.wave.fill"
        case .problemActivation:
            return "person.crop.circle.badge.exclamationmark"
        case .examSelection:
            return "list.clipboard.fill"
        case .examPreview:
            return "sparkles.rectangle.stack.fill"
        case .miniDiagnosis:
            return "checklist"
        case .topicsShowcase:
            return "square.grid.3x3.fill"
        case .stepByStep:
            return "list.number"
        case .personalizedPlan:
            return "target"
        case .premiumTrialOffer:
            return "gift.fill"
        case .trialReminder:
            return "bell.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .languageSelection:
            return Color.blue
        case .themeSelection:
            return Color.onboardingBlue
        case .problemActivation:
            return Color.onboardingInk
        case .examSelection:
            return Color.onboardingBlue
        case .examPreview:
            return Color.onboardingBlue
        case .miniDiagnosis:
            return Color.onboardingBlue
        case .topicsShowcase:
            return Color.onboardingBlue
        case .stepByStep:
            return Color.onboardingBlue
        case .personalizedPlan:
            return Color.onboardingBlue
        case .premiumTrialOffer:
            return Color.onboardingBlue
        case .trialReminder:
            return Color.onboardingBlue
        }
    }
    
    static var progressScreens: [OnboardingScreen] {
        allCases.filter { $0 != .languageSelection }
    }
}
