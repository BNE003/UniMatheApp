import SwiftUI

// MARK: - Main Onboarding Coordinator
struct OnboardingCoordinator: View {
    @EnvironmentObject var onboardingManager: OnboardingManager
    @State private var showPaywall = false
    
    var body: some View {
        ZStack {
            // Solid Background to prevent any bleed-through
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.onboardingCanvas,
                    Color.onboardingBlue.opacity(0.14)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(.all)
            
            // Content based on current screen with seamless transitions
            Group {
                switch onboardingManager.currentScreen {
                case .languageSelection:
                    ThemeSelectionOnboardingView()
                case .themeSelection:
                    ThemeSelectionOnboardingView()
                case .problemActivation:
                    ProblemActivationOnboardingView()
                case .examSelection:
                    ExamSelectionOnboardingView()
                case .examPreview:
                    ExamPreviewOnboardingView()
                case .miniDiagnosis:
                    MiniDiagnosisOnboardingView()
                case .topicsShowcase:
                    TopicShowcaseOnboardingView()
                case .stepByStep:
                    StepByStepOnboardingView()
                case .personalizedPlan:
                    PersonalizedPlanOnboardingView()
                case .premiumTrialOffer:
                    PremiumTrialOfferOnboardingView()
                case .trialReminder:
                    TrialReminderOnboardingView()
                }
            }
            .transition(
                .asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity).combined(with: .scale(scale: 0.95)),
                    removal: .move(edge: .leading).combined(with: .opacity).combined(with: .scale(scale: 1.05))
                )
            )
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: onboardingManager.currentScreen)
            
        }
        .fullScreenCover(isPresented: $showPaywall) {
            PurchaseView(isPresented: $showPaywall)
                .onDisappear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        onboardingManager.completeOnboarding()
                    }
                }
        }
        .onReceive(onboardingManager.$shouldShowPaywall) { shouldShow in
            if shouldShow {
                showPaywall = true
                onboardingManager.shouldShowPaywall = false
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
            Color.onboardingBlue,
            Color.onboardingInk.opacity(0.82)
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
                            Color.onboardingCanvas,
                            Color.onboardingBlue.opacity(0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    // Floating mathematical symbols
                    Group {
                        Text("∫")
                            .font(.onboarding(size: 60, weight: .light))
                            .foregroundColor(Color.onboardingBlue.opacity(0.14))
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
                            .font(.onboarding(size: 50, weight: .light))
                            .foregroundColor(Color.onboardingInk.opacity(0.08))
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
                            .font(.onboarding(size: 40, weight: .light))
                            .foregroundColor(Color.onboardingGray.opacity(0.15))
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
                            .font(.onboarding(size: 42, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.onboardingBlue, .onboardingInk],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .opacity(showWelcome ? 1 : 0)
                            .offset(y: showWelcome ? 0 : 20)
                            .animation(.easeOut(duration: 0.8).delay(0.6), value: showWelcome)
                        
                        Text("Willkommen | Welcome")
                            .font(.onboarding(size: 24, weight: .medium))
                            .foregroundColor(.primary.opacity(0.8))
                            .opacity(showWelcome ? 1 : 0)
                            .offset(y: showWelcome ? 0 : 20)
                            .animation(.easeOut(duration: 0.8).delay(0.8), value: showWelcome)
                    }
                    
                    VStack(spacing: 8) {
                        Text("Bitte wählen Sie Ihre Sprache aus")
                            .font(.onboarding(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                            .opacity(showWelcome ? 1 : 0)
                            .animation(.easeOut(duration: 0.8).delay(1.0), value: showWelcome)
                        
                        Text("Please select your language")
                            .font(.onboarding(size: 16, weight: .medium))
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
                            .font(.onboarding(size: 18, weight: .semibold))
                        
                        Image(systemName: "arrow.right")
                            .font(.onboarding(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(blueGradient)
                            .shadow(color: Color.onboardingBlue.opacity(0.3), radius: 20, x: 0, y: 10)
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
                    .font(.onboarding(size: 32))
                    .scaleEffect(selectedLanguage == language ? 1.2 : 1.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: selectedLanguage == language)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.onboarding(size: 22, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.onboarding(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Selection indicator with animation
                ZStack {
                    Circle()
                        .strokeBorder(
                            selectedLanguage == language ? Color.onboardingBlue : Color.secondary.opacity(0.3),
                            lineWidth: 3
                        )
                        .frame(width: 28, height: 28)
                    
                    if selectedLanguage == language {
                        Circle()
                            .fill(Color.onboardingBlue)
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
                                selectedLanguage == language ? Color.onboardingBlue.opacity(0.5) : Color.clear,
                                lineWidth: 2
                            )
                    )
                    .shadow(
                        color: selectedLanguage == language ? Color.onboardingBlue.opacity(0.2) : Color.appShadow.opacity(0.8),
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
    @EnvironmentObject var onboardingManager: OnboardingManager
    @ObservedObject private var settings = SettingsModel.shared
    @State private var showContent = false
    @State private var floatArtwork = false
    
    private var isGerman: Bool {
        settings.language == .german
    }

    private var stepLabel: String {
        if isGerman {
            return "Schritt \(onboardingManager.currentProgressStep) von \(onboardingManager.progressStepCount)"
        }
        return "Step \(onboardingManager.currentProgressStep) of \(onboardingManager.progressStepCount)"
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AnimatedBackground()
                
                Circle()
                    .fill(Color.onboardingBlue.opacity(0.12))
                    .frame(width: geometry.size.width * 0.9)
                    .offset(x: geometry.size.width * 0.36, y: -geometry.size.height * 0.28)
                    .blur(radius: 2)

                Circle()
                    .fill(Color.onboardingBlue.opacity(0.08))
                    .frame(width: geometry.size.width * 0.58)
                    .offset(x: -geometry.size.width * 0.42, y: geometry.size.height * 0.56)
                    .blur(radius: 2)

                VStack(alignment: .leading, spacing: geometry.size.height < 700 ? 18 : 24) {
                    HStack(spacing: 12) {
                        Text(stepLabel)
                            .font(.onboarding(size: geometry.size.height < 700 ? 14 : 16, weight: .medium))
                            .foregroundColor(Color.onboardingGrayStrong)

                        Spacer()

                        Text("Onboarding")
                            .font(.onboarding(size: geometry.size.height < 700 ? 13 : 15, weight: .semibold))
                            .foregroundColor(Color.onboardingInk)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 9)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.92))
                                    .overlay(
                                        Capsule()
                                            .strokeBorder(Color.onboardingGray.opacity(0.22), lineWidth: 1)
                                    )
                            )
                    }

                    segmentedProgress(
                        totalSteps: onboardingManager.progressStepCount,
                        currentStep: onboardingManager.currentProgressStep
                    )

                    VStack(alignment: .leading, spacing: geometry.size.height < 700 ? 10 : 14) {
                        Text(isGerman ? "Willkommen bei UniMathe" : "Welcome to UniMathe")
                            .font(.onboarding(size: geometry.size.height < 700 ? 30 : 34, weight: .bold))
                            .foregroundColor(Color.onboardingInk)
                            .lineLimit(2)

                        Text(
                            isGerman
                            ? "Lerne Mathematik klar, strukturiert und effizient. In wenigen Schritten bist du startklar."
                            : "Learn mathematics with clarity and structure. You will be ready in just a few steps."
                        )
                        .font(.onboarding(size: geometry.size.height < 700 ? 14 : 16, weight: .medium))
                        .foregroundColor(Color.onboardingGrayStrong)
                        .lineSpacing(4)
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 14)
                    .animation(.easeOut(duration: 0.5).delay(0.1), value: showContent)

                    Spacer(minLength: 18)

                    Image("0")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: min(geometry.size.width * 0.86, 460))
                        .frame(maxWidth: .infinity)
                        .offset(y: floatArtwork ? -5 : 6)
                        .opacity(showContent ? 1 : 0)
                        .animation(
                            .spring(response: 0.75, dampingFraction: 0.82).delay(0.18),
                            value: showContent
                        )
                        .animation(
                            .easeInOut(duration: 3.0).repeatForever(autoreverses: true),
                            value: floatArtwork
                        )

                    Spacer(minLength: geometry.size.height < 700 ? 126 : 144)
                }
                .padding(.horizontal, geometry.size.width < 400 ? 18 : 24)
                .padding(.top, geometry.size.height < 700 ? 16 : 22)
            }
            .overlay(alignment: .bottom) {
                VStack(spacing: 0) {
                    Button(action: {
                        onboardingManager.nextScreen()
                    }) {
                        HStack(spacing: 8) {
                            Text(isGerman ? "Weiter" : "Continue")
                                .font(.onboarding(size: 18, weight: .semibold))
                            Image(systemName: "arrow.right")
                                .font(.onboarding(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.onboardingBlue, Color.onboardingInk.opacity(0.88)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: Color.onboardingBlue.opacity(0.28), radius: 10, x: 0, y: 5)
                        )
                    }
                    .padding(.horizontal, geometry.size.width < 400 ? 18 : 24)
                    .padding(.top, 10)
                    .padding(.bottom, loweredOnboardingBottomButtonPadding(for: geometry))
                }
                .background(
                    LinearGradient(
                        colors: [
                            Color.onboardingCanvas.opacity(0.0),
                            Color.onboardingCanvas.opacity(0.92),
                            Color.onboardingCanvas
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea(edges: .bottom)
                )
            }
        }
        .onAppear {
            showContent = true
            floatArtwork = true
        }
    }

    private func segmentedProgress(totalSteps: Int, currentStep: Int) -> some View {
        let safeTotalSteps = max(totalSteps, 1)

        return HStack(spacing: 8) {
            ForEach(0..<safeTotalSteps, id: \.self) { index in
                Capsule()
                    .fill(
                        index < currentStep
                        ? Color.onboardingBlue
                        : Color.onboardingGray.opacity(0.25)
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 7)
            }
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
                        .font(.onboarding(size: star.size))
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

// MARK: - Preview
#Preview {
    OnboardingCoordinator()
} 
