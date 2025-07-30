import SwiftUI

// MARK: - Main Onboarding Coordinator
struct OnboardingCoordinator: View {
    @EnvironmentObject var onboardingManager: OnboardingManager
    @ObservedObject private var settings = SettingsModel.shared
    @State private var showLanguageSelection = true
    
    var body: some View {
        ZStack {
            // Solid Background to prevent any bleed-through
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.98, green: 0.99, blue: 1.0),
                    Color(red: 0.94, green: 0.97, blue: 0.99)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(.all)
            
            // Content based on current screen with seamless transitions
            Group {
                switch onboardingManager.currentScreen {
                case .languageSelection:
                    EnhancedLanguageSelectionView()
                case .learningTopics:
                    LearningTopicsOnboardingView()
                case .stepByStep:
                    StepByStepOnboardingView()
                case .exams:
                    ExamsOnboardingView()
                case .exercises:
                    ExercisesOnboardingView()
                case .monthlyUpdates:
                    MonthlyUpdatesOnboardingView()
                }
            }
            .transition(
                .asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity).combined(with: .scale(scale: 0.95)),
                    removal: .move(edge: .leading).combined(with: .opacity).combined(with: .scale(scale: 1.05))
                )
            )
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: onboardingManager.currentScreen)
            
            // Navigation Controls (except for language selection) - Fixed to bottom
            if onboardingManager.currentScreen != .languageSelection {
                VStack(spacing: 0) {
                    Spacer()
                    
                    OnboardingNavigationControls(onboardingManager: onboardingManager)
                }
                .ignoresSafeArea(.all, edges: .bottom)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: onboardingManager.currentScreen)
            }
        }
    }
}

// MARK: - Enhanced Language Selection for Onboarding
struct EnhancedLanguageSelectionView: View {
    @EnvironmentObject var onboardingManager: OnboardingManager
    @ObservedObject private var settings = SettingsModel.shared
    @State private var selectedLanguage: AppLanguage = .german
    @State private var animateBackground = false
    @State private var showWelcome = false
    
    private let blueGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.1, green: 0.3, blue: 0.9),
            Color(red: 0.2, green: 0.5, blue: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        ZStack {
            // Enhanced Background with floating elements
            GeometryReader { geometry in
                ZStack {
                    // Base gradient
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.98, green: 0.99, blue: 1.0),
                            Color(red: 0.94, green: 0.97, blue: 0.99)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    // Floating mathematical symbols
                    Group {
                        Text("∫")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(.blue.opacity(0.1))
                            .offset(
                                x: animateBackground ? geometry.size.width * 0.1 : -geometry.size.width * 0.1,
                                y: geometry.size.height * 0.1
                            )
                            .rotationEffect(.degrees(animateBackground ? 360 : 0))
                            .animation(
                                Animation.linear(duration: 20).repeatForever(autoreverses: false),
                                value: animateBackground
                            )
                        
                        Text("Σ")
                            .font(.system(size: 50, weight: .light))
                            .foregroundColor(.purple.opacity(0.08))
                            .offset(
                                x: animateBackground ? -geometry.size.width * 0.2 : geometry.size.width * 0.2,
                                y: geometry.size.height * 0.6
                            )
                            .rotationEffect(.degrees(animateBackground ? -180 : 180))
                            .animation(
                                Animation.linear(duration: 15).repeatForever(autoreverses: true).delay(3),
                                value: animateBackground
                            )
                        
                        Text("π")
                            .font(.system(size: 40, weight: .light))
                            .foregroundColor(.green.opacity(0.1))
                            .offset(
                                x: animateBackground ? geometry.size.width * 0.3 : -geometry.size.width * 0.3,
                                y: geometry.size.height * 0.8
                            )
                            .animation(
                                Animation.easeInOut(duration: 18).repeatForever(autoreverses: true).delay(6),
                                value: animateBackground
                            )
                    }
                }
            }
            
            VStack(spacing: 60) {
                // Enhanced Header with app branding
                VStack(spacing: 20) {
                    // App logo placeholder with animation
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                            .scaleEffect(showWelcome ? 1.0 : 0.3)
                            .animation(.spring(response: 1.0, dampingFraction: 0.6).delay(0.2), value: showWelcome)
                        
                        Image(systemName: "function")
                            .font(.system(size: 40, weight: .light))
                            .foregroundColor(.white)
                            .scaleEffect(showWelcome ? 1.0 : 0.3)
                            .animation(.spring(response: 1.2, dampingFraction: 0.6).delay(0.4), value: showWelcome)
                    }
                    
                    VStack(spacing: 12) {
                        Text("UniMathe")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .opacity(showWelcome ? 1 : 0)
                            .offset(y: showWelcome ? 0 : 20)
                            .animation(.easeOut(duration: 0.8).delay(0.6), value: showWelcome)
                        
                        Text("Willkommen | Welcome")
                            .font(.system(size: 24, weight: .medium, design: .rounded))
                            .foregroundColor(.primary.opacity(0.8))
                            .opacity(showWelcome ? 1 : 0)
                            .offset(y: showWelcome ? 0 : 20)
                            .animation(.easeOut(duration: 0.8).delay(0.8), value: showWelcome)
                    }
                    
                    VStack(spacing: 8) {
                        Text("Bitte wählen Sie Ihre Sprache aus")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                            .opacity(showWelcome ? 1 : 0)
                            .animation(.easeOut(duration: 0.8).delay(1.0), value: showWelcome)
                        
                        Text("Please select your language")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                            .opacity(showWelcome ? 1 : 0)
                            .animation(.easeOut(duration: 0.8).delay(1.0), value: showWelcome)
                    }
                }
                .padding(.top, 40)
                
                // Enhanced Language Options
                VStack(spacing: 25) {
                    // German option
                    enhancedLanguageButton(
                        language: .german,
                        title: "Deutsch",
                        description: "Fortfahren auf Deutsch",
                        flagEmoji: "🇩🇪"
                    )
                    
                    // English option
                    enhancedLanguageButton(
                        language: .english,
                        title: "English",
                        description: "Continue in English",
                        flagEmoji: "🇬🇧"
                    )
                }
                .opacity(showWelcome ? 1 : 0)
                .offset(y: showWelcome ? 0 : 50)
                .animation(.spring(response: 1.0, dampingFraction: 0.8).delay(1.2), value: showWelcome)
                
                // Continue button with enhanced styling
                Button(action: {
                    settings.setLanguage(selectedLanguage)
                    
                    // Mark language as selected
                    UserDefaults.standard.set(true, forKey: "hasSelectedLanguage")
                    
                    // Continue to next onboarding screen
                    onboardingManager.nextScreen()
                }) {
                    HStack(spacing: 12) {
                        Text(selectedLanguage == .german ? "Weiter" : "Continue")
                            .font(.system(size: 18, weight: .semibold))
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(blueGradient)
                            .shadow(color: Color.blue.opacity(0.3), radius: 20, x: 0, y: 10)
                    )
                }
                .opacity(showWelcome ? 1 : 0)
                .offset(y: showWelcome ? 0 : 30)
                .animation(.spring(response: 1.0, dampingFraction: 0.8).delay(1.4), value: showWelcome)
                
                Spacer()
            }
            .padding(.horizontal, 32)
        }
        .onAppear {
            showWelcome = true
            animateBackground = true
        }
    }
    
    private func enhancedLanguageButton(
        language: AppLanguage,
        title: String,
        description: String,
        flagEmoji: String
    ) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                selectedLanguage = language
            }
        }) {
            HStack(spacing: 20) {
                // Flag with enhanced animation
                Text(flagEmoji)
                    .font(.system(size: 32))
                    .scaleEffect(selectedLanguage == language ? 1.2 : 1.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: selectedLanguage == language)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Selection indicator with animation
                ZStack {
                    Circle()
                        .strokeBorder(
                            selectedLanguage == language ? Color.blue : Color.gray.opacity(0.3),
                            lineWidth: 3
                        )
                        .frame(width: 28, height: 28)
                    
                    if selectedLanguage == language {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 16, height: 16)
                            .scaleEffect(selectedLanguage == language ? 1.0 : 0.1)
                            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: selectedLanguage == language)
                    }
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(
                                selectedLanguage == language ? Color.blue.opacity(0.5) : Color.clear,
                                lineWidth: 2
                            )
                    )
                    .shadow(
                        color: selectedLanguage == language ? Color.blue.opacity(0.2) : Color.black.opacity(0.1),
                        radius: selectedLanguage == language ? 20 : 10,
                        x: 0,
                        y: selectedLanguage == language ? 10 : 5
                    )
            )
            .scaleEffect(selectedLanguage == language ? 1.02 : 1.0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: selectedLanguage == language)
        }
    }
}

// MARK: - Navigation Controls
struct OnboardingNavigationControls: View {
    @ObservedObject var onboardingManager: OnboardingManager
    @ObservedObject private var settings = SettingsModel.shared
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Color.clear
                
                // Glaseffekt Container - Edge to Edge
                VStack(spacing: geometry.size.height < 700 ? 16 : 20) {
                    // Progress Indicator
                    OnboardingProgressBar(progress: onboardingManager.screenProgress)
                    
                    // Navigation Buttons
                    HStack(spacing: 0) {
                        // Back Button
                        if !onboardingManager.isFirstScreen {
                            Button(action: {
                                onboardingManager.previousScreen()
                            }) {
                                HStack(spacing: geometry.size.width < 400 ? 6 : 8) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: geometry.size.width < 400 ? 12 : 14, weight: .semibold))
                                    Text(settings.language == .german ? "Zurück" : "Back")
                                        .font(.system(size: geometry.size.width < 400 ? 14 : 16, weight: .semibold))
                                }
                                .foregroundColor(.primary)
                                .padding(.horizontal, geometry.size.width < 400 ? 16 : 20)
                                .padding(.vertical, geometry.size.height < 700 ? 10 : 12)
                                .background(
                                    RoundedRectangle(cornerRadius: geometry.size.width < 400 ? 18 : 20)
                                        .fill(.thickMaterial)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: geometry.size.width < 400 ? 18 : 20)
                                                .strokeBorder(.white.opacity(0.2), lineWidth: 0.5)
                                        )
                                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                                )
                            }
                        } else {
                            // Placeholder to maintain layout consistency
                            Color.clear
                                .frame(width: geometry.size.width < 400 ? 80 : 100, 
                                      height: geometry.size.height < 700 ? 40 : 48)
                        }
                        
                        Spacer()
                        
                        // Next/Finish Button
                        Button(action: {
                            onboardingManager.nextScreen()
                        }) {
                            HStack(spacing: geometry.size.width < 400 ? 6 : 8) {
                                Text(onboardingManager.isLastScreen ? 
                                     (settings.language == .german ? "Fertig" : "Finish") :
                                     (settings.language == .german ? "Weiter" : "Next"))
                                    .font(.system(size: geometry.size.width < 400 ? 14 : 16, weight: .semibold))
                                
                                if !onboardingManager.isLastScreen {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: geometry.size.width < 400 ? 12 : 14, weight: .semibold))
                                }
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, geometry.size.width < 400 ? 16 : 20)
                            .padding(.vertical, geometry.size.height < 700 ? 10 : 12)
                            .background(
                                RoundedRectangle(cornerRadius: geometry.size.width < 400 ? 18 : 20)
                                    .fill(
                                        LinearGradient(
                                            colors: onboardingManager.isLastScreen ? [.green, .blue] : [.blue, .purple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: geometry.size.width < 400 ? 18 : 20)
                                            .strokeBorder(.white.opacity(0.3), lineWidth: 0.5)
                                    )
                                    .shadow(color: Color.blue.opacity(0.3), radius: 12, x: 0, y: 6)
                            )
                        }
                    }
                    .padding(.horizontal, geometry.size.width < 400 ? 16 : 20)
                }
                .padding(.top, geometry.size.height < 700 ? 16 : 20)
                .padding(.bottom, max(geometry.safeAreaInsets.bottom, geometry.size.height < 700 ? 16 : 20))
                .frame(maxWidth: .infinity)
                .background(
                    // Hochmoderner Glaseffekt - Edge to Edge
                    ZStack {
                        // Starker Material-Blur
                        Rectangle()
                            .fill(.ultraThickMaterial)
                            .ignoresSafeArea(.all)
                        
                        // Glasschimmer-Overlay
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.4),
                                        Color.white.opacity(0.15),
                                        Color.white.opacity(0.05),
                                        Color.clear
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .ignoresSafeArea(.all)
                        
                        // Zusätzliche Verstärkung für Glasoptik
                        Rectangle()
                            .fill(.thickMaterial)
                            .opacity(0.3)
                            .ignoresSafeArea(.all)
                        
                        // Subtiler Farbschimmer
                        Rectangle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color.blue.opacity(0.04),
                                        Color.purple.opacity(0.02),
                                        Color.clear
                                    ]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: geometry.size.width * 1.2
                                )
                            )
                            .ignoresSafeArea(.all)
                    }
                )
                .overlay(
                    // Leuchtender Glasrand oben - Edge to Edge
                    Rectangle()
                        .frame(height: 1.5)
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.6),
                                    Color.white.opacity(0.9),
                                    Color.blue.opacity(0.4),
                                    Color.white.opacity(0.9),
                                    Color.white.opacity(0.6)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .ignoresSafeArea(.all),
                    alignment: .top
                )
                .clipShape(RoundedRectangle(cornerRadius: 0))
                .shadow(color: Color.black.opacity(0.25), radius: 30, x: 0, y: -10)
                .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: -5)
                .shadow(color: Color.blue.opacity(0.1), radius: 20, x: 0, y: -8)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: UIScreen.main.bounds.height < 700 ? 110 : 130)
        .ignoresSafeArea(.all, edges: [.leading, .trailing, .bottom])
    }
}

// MARK: - Progress Bar
struct OnboardingProgressBar: View {
    let progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: geometry.size.height < 700 ? 4 : 6)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: geometry.size.height < 700 ? 8 : 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: geometry.size.height < 700 ? 4 : 6)
                            .strokeBorder(.white.opacity(0.15), lineWidth: 0.5)
                    )
                
                // Progress with enhanced visual feedback
                RoundedRectangle(cornerRadius: geometry.size.height < 700 ? 4 : 6)
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(0, min(geometry.size.width * progress, geometry.size.width)), 
                           height: geometry.size.height < 700 ? 8 : 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: geometry.size.height < 700 ? 4 : 6)
                            .strokeBorder(.white.opacity(0.4), lineWidth: 0.5)
                    )
                    .shadow(color: Color.blue.opacity(0.5), radius: 6, x: 0, y: 3)
                    .animation(.spring(response: 0.8, dampingFraction: 0.9), value: progress)
                
                // Progress indicators (dots)
                HStack(spacing: geometry.size.width / 5 - 4) {
                    ForEach(0..<5, id: \.self) { index in
                        Circle()
                            .fill(progress > Double(index) * 0.2 ? Color.white : Color.gray.opacity(0.3))
                            .frame(width: 4, height: 4)
                            .animation(.easeInOut(duration: 0.3).delay(Double(index) * 0.1), value: progress)
                    }
                }
                .frame(width: geometry.size.width)
            }
        }
        .frame(height: UIScreen.main.bounds.height < 700 ? 8 : 10)
        .padding(.horizontal, UIScreen.main.bounds.width < 400 ? 16 : 20)
    }
}

// MARK: - Preview
#Preview {
    OnboardingCoordinator()
} 