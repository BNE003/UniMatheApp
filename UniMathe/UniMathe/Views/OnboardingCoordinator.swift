import SwiftUI

// MARK: - Main Onboarding Coordinator
struct OnboardingCoordinator: View {
    @EnvironmentObject var onboardingManager: OnboardingManager
    
    var body: some View {
        ZStack {
            // Solid Background to prevent any bleed-through
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.appBackground,
                    Color.appBackgroundSecondary
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
                case .themeSelection:
                    ThemeSelectionOnboardingView()
                case .learningTopics:
                    LearningTopicsOnboardingView()
                case .stepByStep:
                    StepByStepOnboardingView()
                case .exams:
                    ExamsOnboardingView()
                case .exercises:
                    ExercisesOnboardingView()
                case .matrixMethods:
                    MatrixMethodsOnboardingView()
                case .learningPlan:
                    LearningPlanOnboardingView()
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
                            Color.appBackground,
                            Color.appBackgroundSecondary
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
                    // App logo with animation
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .scaleEffect(showWelcome ? 1.0 : 0.3)
                        .animation(.spring(response: 1.2, dampingFraction: 0.6).delay(0.4), value: showWelcome)
                    
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
                            selectedLanguage == language ? Color.blue : Color.secondary.opacity(0.3),
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
                        color: selectedLanguage == language ? Color.blue.opacity(0.2) : Color.appShadow.opacity(0.8),
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

// MARK: - Theme Selection for Onboarding
struct ThemeSelectionOnboardingView: View {
    @ObservedObject private var settings = SettingsModel.shared
    @State private var selectedDarkMode = false
    @State private var showContent = false
    @State private var previewScale: CGFloat = 1.0
    @State private var previewFlashOpacity: Double = 0.0
    @State private var modeCardRotation: Double = 0.0
    @State private var modeCardOffsetX: CGFloat = 0.0
    @State private var modeCardDepthScale: CGFloat = 1.0
    @State private var iconRotation: Double = 0.0
    @State private var ringSpins = false
    
    private var isGerman: Bool {
        settings.language == .german
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AnimatedBackground()
                
                if selectedDarkMode {
                    DarkModeTwinkleStars()
                        .transition(.opacity)
                }
                
                VStack(spacing: geometry.size.height < 700 ? 24 : 34) {
                    VStack(spacing: geometry.size.height < 700 ? 10 : 14) {
                        Text(isGerman ? "Look & Feel wählen" : "Choose Your Look")
                            .font(.system(size: geometry.size.height < 700 ? 30 : 36, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.primary)
                        
                        Text(
                            isGerman
                            ? "Du kannst jederzeit in den Einstellungen wechseln."
                            : "You can switch anytime in settings."
                        )
                        .font(.system(size: geometry.size.height < 700 ? 14 : 16, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 18)
                    .animation(.easeOut(duration: 0.7), value: showContent)
                    
                    ZStack {
                        VStack(spacing: 18) {
                            ZStack {
                                Circle()
                                    .trim(from: 0.16, to: 0.88)
                                    .stroke(
                                        selectedDarkMode ? Color.cyan.opacity(0.55) : Color.orange.opacity(0.55),
                                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                                    )
                                    .frame(width: 96, height: 96)
                                    .rotationEffect(.degrees(ringSpins ? 360 : 0))
                                    .animation(
                                        .linear(duration: 11).repeatForever(autoreverses: false),
                                        value: ringSpins
                                    )
                                
                                Image(systemName: selectedDarkMode ? "moon.fill" : "sun.max.fill")
                                    .font(.system(size: 34, weight: .medium))
                                    .foregroundColor(selectedDarkMode ? Color.cyan : Color.orange)
                                    .rotationEffect(.degrees(iconRotation))
                                    .scaleEffect(previewScale)
                                    .shadow(
                                        color: selectedDarkMode ? Color.cyan.opacity(0.35) : Color.orange.opacity(0.35),
                                        radius: 10
                                    )
                                    .overlay(
                                        Image(systemName: selectedDarkMode ? "moon.fill" : "sun.max.fill")
                                            .font(.system(size: 34, weight: .medium))
                                            .foregroundColor(selectedDarkMode ? Color.cyan : Color.orange)
                                            .opacity(previewFlashOpacity)
                                            .scaleEffect(previewScale * 1.18)
                                    )
                            }
                            
                            Text(
                                selectedDarkMode
                                ? (isGerman ? "Dunkelmodus aktiv" : "Dark mode enabled")
                                : (isGerman ? "Hellmodus aktiv" : "Light mode enabled")
                            )
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(selectedDarkMode ? .white : Color(red: 0.16, green: 0.24, blue: 0.45))
                        }
                        .padding(.vertical, geometry.size.height < 700 ? 24 : 30)
                    }
                    .frame(height: geometry.size.height < 700 ? 220 : 260)
                    .rotation3DEffect(
                        .degrees(modeCardRotation),
                        axis: (x: 0, y: 1, z: 0),
                        anchor: modeCardRotation >= 0 ? .leading : .trailing,
                        perspective: 0.7
                    )
                    .offset(x: modeCardOffsetX)
                    .scaleEffect(modeCardDepthScale)
                    .scaleEffect(showContent ? 1.0 : 0.9)
                    .opacity(showContent ? 1.0 : 0.0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.82).delay(0.15), value: showContent)
                    
                    VStack(spacing: 14) {
                        themeOptionButton(
                            title: isGerman ? "Hellmodus" : "Light Mode",
                            subtitle: isGerman ? "Klar und freundlich" : "Clean and bright",
                            icon: "sun.max.fill",
                            color: .orange,
                            isSelected: !selectedDarkMode
                        ) {
                            selectTheme(isDark: false)
                        }
                        
                        themeOptionButton(
                            title: isGerman ? "Dunkelmodus" : "Dark Mode",
                            subtitle: isGerman ? "Augenfreundlich am Abend" : "Easy on your eyes",
                            icon: "moon.fill",
                            color: .cyan,
                            isSelected: selectedDarkMode
                        ) {
                            selectTheme(isDark: true)
                        }
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 28)
                    .animation(.spring(response: 0.8, dampingFraction: 0.86).delay(0.3), value: showContent)
                    
                    Spacer(minLength: 90)
                }
                .padding(.horizontal, geometry.size.width < 400 ? 18 : 26)
                .padding(.top, geometry.size.height < 700 ? 20 : 34)
            }
        }
        .onAppear {
            selectedDarkMode = settings.isDarkModeEnabled
            showContent = true
            ringSpins = true
        }
        .onChange(of: selectedDarkMode) { isDark in
            settings.isDarkModeEnabled = isDark
        }
        .animation(.easeInOut(duration: 0.3), value: selectedDarkMode)
    }
    
    private func selectTheme(isDark: Bool) {
        guard isDark != selectedDarkMode else { return }
        
        let direction: CGFloat = isDark ? 1 : -1
        
        withAnimation(.none) {
            modeCardRotation = -55 * Double(direction)
            modeCardOffsetX = 160 * direction
            modeCardDepthScale = 0.88
            previewScale = 0.78
            selectedDarkMode = isDark
            previewFlashOpacity = 0.0
        }
        
        withAnimation(.spring(response: 0.72, dampingFraction: 0.82)) {
            modeCardRotation = 0
            modeCardOffsetX = 0
            modeCardDepthScale = 1.0
            iconRotation += isDark ? 360 : -360
            previewFlashOpacity = 0.22
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.74)) {
                previewScale = 1.0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) {
            withAnimation(.easeOut(duration: 0.35)) {
                previewFlashOpacity = 0.0
            }
        }
    }
    
    private func themeOptionButton(
        title: String,
        subtitle: String,
        icon: String,
        color: Color,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(isSelected ? 0.22 : 0.12))
                        .frame(width: 46, height: 46)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(isSelected ? color : Color.secondary.opacity(0.45))
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .animation(.spring(response: 0.45, dampingFraction: 0.75), value: isSelected)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .strokeBorder(isSelected ? color.opacity(0.45) : Color.clear, lineWidth: 1.5)
                    )
                    .shadow(
                        color: isSelected ? color.opacity(0.22) : Color.appShadow.opacity(0.65),
                        radius: isSelected ? 16 : 8,
                        x: 0,
                        y: isSelected ? 8 : 4
                    )
            )
            .scaleEffect(isSelected ? 1.015 : 1.0)
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isSelected)
        }
    }
}

struct DarkModeTwinkleStars: View {
    @State private var twinkle = false
    
    private let stars: [(x: CGFloat, y: CGFloat, size: CGFloat, delay: Double)] = [
        (0.11, 0.08, 10, 0.00),
        (0.24, 0.14, 7, 0.25),
        (0.36, 0.10, 9, 0.52),
        (0.62, 0.13, 8, 0.35),
        (0.78, 0.07, 11, 0.70),
        (0.89, 0.18, 6, 0.42),
        (0.17, 0.29, 8, 0.63),
        (0.73, 0.27, 7, 0.20),
        (0.86, 0.33, 9, 0.84),
        (0.08, 0.42, 7, 0.48),
        (0.29, 0.46, 6, 0.34),
        (0.92, 0.50, 8, 0.58)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(Array(stars.enumerated()), id: \.offset) { index, star in
                    Image(systemName: index.isMultiple(of: 3) ? "sparkle" : "star.fill")
                        .font(.system(size: star.size))
                        .foregroundColor(.white.opacity(twinkle ? 0.85 : 0.35))
                        .scaleEffect(twinkle ? 1.08 : 0.72)
                        .position(
                            x: geometry.size.width * star.x,
                            y: geometry.size.height * star.y
                        )
                        .animation(
                            .easeInOut(duration: 1.2)
                                .repeatForever(autoreverses: true)
                                .delay(star.delay),
                            value: twinkle
                        )
                }
            }
            .onAppear {
                twinkle = true
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
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
                    OnboardingProgressBar(
                        progress: onboardingManager.screenProgress,
                        totalSteps: onboardingManager.progressStepCount,
                        currentStep: onboardingManager.currentProgressStep
                    )
                    
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
                                        Color.appSurface.opacity(0.4),
                                        Color.appSurface.opacity(0.15),
                                        Color.appSurface.opacity(0.05),
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
                                    Color.appSurface.opacity(0.6),
                                    Color.appSurface.opacity(0.9),
                                    Color.blue.opacity(0.4),
                                    Color.appSurface.opacity(0.9),
                                    Color.appSurface.opacity(0.6)
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
    let totalSteps: Int
    let currentStep: Int
    
    var body: some View {
        GeometryReader { geometry in
            let safeTotalSteps = max(totalSteps, 1)
            let dotSize: CGFloat = 4
            let totalDotWidth = CGFloat(safeTotalSteps) * dotSize
            let availableSpacing = max(geometry.size.width - totalDotWidth, 0)
            let dotSpacing = safeTotalSteps > 1 ? availableSpacing / CGFloat(safeTotalSteps - 1) : 0
            
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: geometry.size.height < 700 ? 4 : 6)
                    .fill(Color.secondary.opacity(0.2))
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
                HStack(spacing: dotSpacing) {
                    ForEach(0..<safeTotalSteps, id: \.self) { index in
                        Circle()
                            .fill(index < currentStep ? Color.appSurfaceStrong : Color.secondary.opacity(0.3))
                            .frame(width: dotSize, height: dotSize)
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
