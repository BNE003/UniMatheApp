import SwiftUI
import Foundation

// MARK: - Learning Topics Onboarding Screen
struct LearningTopicsOnboardingView: View {
    @ObservedObject private var settings = SettingsModel.shared
    @State private var animateHeader = false
    @State private var animateCategories = false
    @State private var animateCounter = false
    @State private var currentTopicCount = 0
    @State private var selectedCategory: Int? = nil
    
    // Real topic data from the app
    private var topicCategories: [(String, String, String, Color, [(String, String)])] {
        if settings.language == .german {
            return [
                ("Grundlagen der Höheren Mathematik", "graduationcap.circle.fill", "9 Themen", Color.blue, [
                    ("Mengen und Abbildungen", "circle.grid.2x2.fill"),
                    ("Logik", "brain.head.profile"),
                    ("Vollständige Induktion", "arrow.up.circle.fill"),
                    ("Binomische Formeln", "plus.forwardslash.minus"),
                    ("Größter gemeinsamer Teiler", "divide.circle.fill"),
                    ("Gruppen", "grid.circle.fill"),
                    ("Ringe", "circle.circle.fill"),
                    ("Körper", "diamond.fill"),
                    ("Komplexe Zahlen", "infinity.circle.fill")
                ]),
                ("Analysis", "function", "5 Themen", Color.purple, [
                    ("Folgen und Reihen", "chart.line.uptrend.xyaxis"),
                    ("Grenzwerte", "target"),
                    ("Differentialrechnung", "waveform.path"),
                    ("Integralrechnung", "chart.bar.fill"),
                    ("Mehrdimensionale Analysis", "cube.fill")
                ]),
                ("Lineare Algebra", "grid", "5 Themen", Color.green, [
                    ("Vektorräume", "arrow.up.right"),
                    ("Matrizen", "square.grid.3x3.fill"),
                    ("Lineare Abbildungen", "arrow.right.arrow.left"),
                    ("Determinanten", "square.grid.2x2"),
                    ("Eigenwerte und Eigenvektoren", "diamond")
                ])
            ]
        } else {
            return [
                ("Foundations of Higher Mathematics", "graduationcap.circle.fill", "9 Topics", Color.blue, [
                    ("Sets and Mappings", "circle.grid.2x2.fill"),
                    ("Logic", "brain.head.profile"),
                    ("Mathematical Induction", "arrow.up.circle.fill"),
                    ("Binomial Formulas", "plus.forwardslash.minus"),
                    ("Greatest Common Divisor", "divide.circle.fill"),
                    ("Groups", "grid.circle.fill"),
                    ("Rings", "circle.circle.fill"),
                    ("Fields", "diamond.fill"),
                    ("Complex Numbers", "infinity.circle.fill")
                ]),
                ("Calculus", "function", "5 Topics", Color.purple, [
                    ("Sequences and Series", "chart.line.uptrend.xyaxis"),
                    ("Limits", "target"),
                    ("Differential Calculus", "waveform.path"),
                    ("Integral Calculus", "chart.bar.fill"),
                    ("Multidimensional Analysis", "cube.fill")
                ]),
                ("Linear Algebra", "grid", "5 Topics", Color.green, [
                    ("Vector Spaces", "arrow.up.right"),
                    ("Matrices", "square.grid.3x3.fill"),
                    ("Linear Mappings", "arrow.right.arrow.left"),
                    ("Determinants", "square.grid.2x2"),
                    ("Eigenvalues and Eigenvectors", "diamond")
                ])
            ]
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                AnimatedBackground()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: geometry.size.height < 700 ? 25 : 40) {
                        // Enhanced Header with counter
                        VStack(spacing: geometry.size.height < 700 ? 12 : 20) {

                            
                            VStack(spacing: geometry.size.height < 700 ? 8 : 12) {
                        Text(settings.language == .german ? "Alle Themen meistern" : "Master All Topics")
                                    .font(.system(size: geometry.size.height < 700 ? 26 : 34, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                                    .opacity(animateHeader ? 1 : 0)
                                    .offset(y: animateHeader ? 0 : 20)
                                    .animation(.easeOut(duration: 0.8).delay(0.6), value: animateHeader)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                
                                // Animated counter
                                HStack(spacing: 6) {
                                    Text("\(currentTopicCount)")
                                        .font(.system(size: geometry.size.height < 700 ? 22 : 28, weight: .bold, design: .rounded))
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [.blue, .purple],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .contentTransition(.numericText())
                                    
                                    Text(settings.language == .german ? "Themen verfügbar" : "topics available")
                                        .font(.system(size: geometry.size.height < 700 ? 14 : 18, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                .opacity(animateCounter ? 1 : 0)
                                .scaleEffect(animateCounter ? 1.0 : 0.8)
                                .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.8), value: animateCounter)
                        
                        Text(settings.language == .german ? 
                                     "Von Grundlagen bis zu fortgeschrittenen Themen - umfassende Mathematikausbildung" :
                                     "From basics to advanced topics - comprehensive mathematics education")
                                    .font(.system(size: geometry.size.height < 700 ? 14 : 16, weight: .medium))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                                    .lineLimit(geometry.size.height < 700 ? 3 : nil)
                                    .opacity(animateHeader ? 1 : 0)
                                    .offset(y: animateHeader ? 0 : 20)
                                    .animation(.easeOut(duration: 0.8).delay(1.0), value: animateHeader)
                            }
                        }
                        .padding(.horizontal, geometry.size.width < 400 ? 20 : 32)
                        .padding(.top, geometry.size.height < 700 ? 10 : 20)
                        
                        // Enhanced Topic Categories
                        LazyVStack(spacing: geometry.size.height < 700 ? 16 : 25) {
                            ForEach(Array(topicCategories.enumerated()), id: \.offset) { categoryIndex, category in
                                EnhancedTopicCategoryView(
                                    title: category.0,
                                    icon: category.1,
                                    topicCount: category.2,
                                    color: category.3,
                                    subtopics: category.4,
                                    isSelected: selectedCategory == categoryIndex,
                                    isAnimated: animateCategories,
                                    animationDelay: Double(categoryIndex) * 0.3,
                                    isCompact: geometry.size.height < 700,
                                    onTap: {
                                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                            selectedCategory = selectedCategory == categoryIndex ? nil : categoryIndex
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, geometry.size.width < 400 ? 16 : 24)
                        
                        Spacer(minLength: geometry.size.height < 700 ? 80 : 100)
                    }
                }
            }
        }
        .onAppear {
            // Start animations with proper delays
            animateHeader = true
            
            // Animate counter
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                animateCounter = true
                startCounterAnimation()
            }
            
            // Animate categories
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                animateCategories = true
            }
        }
    }
    
    private func startCounterAnimation() {
        let totalTopics = topicCategories.reduce(0) { sum, category in
            sum + category.4.count
        }
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if currentTopicCount < totalTopics {
                currentTopicCount += 1
            } else {
                timer.invalidate()
            }
        }
    }
}


// MARK: - Enhanced Topic Category View
struct EnhancedTopicCategoryView: View {
    let title: String
    let icon: String
    let topicCount: String
    let color: Color
    let subtopics: [(String, String)]
    let isSelected: Bool
    let isAnimated: Bool
    let animationDelay: Double
    let isCompact: Bool
    let onTap: () -> Void
    
    @State private var showSubtopics = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Main category header
            Button(action: onTap) {
                HStack(spacing: isCompact ? 12 : 16) {
                    // Icon with animated background
                    ZStack {
                        Circle()
                            .fill(color.opacity(0.15))
                            .frame(width: isCompact ? 45 : 60, height: isCompact ? 45 : 60)
                            .scaleEffect(isSelected ? 1.1 : 1.0)
                            .overlay(
                                Circle()
                                    .strokeBorder(color.opacity(0.3), lineWidth: isSelected ? 2 : 0)
                            )
                        
                        Image(systemName: icon)
                            .font(.system(size: isCompact ? 18 : 24, weight: .medium))
                            .foregroundColor(color)
                            .scaleEffect(isSelected ? 1.1 : 1.0)
                    }
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isSelected)
                    
                    VStack(alignment: .leading, spacing: isCompact ? 2 : 4) {
                        Text(title)
                            .font(.system(size: isCompact ? 16 : 20, weight: .bold))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(isCompact ? 2 : nil)
                        
                        Text(topicCount)
                            .font(.system(size: isCompact ? 12 : 14, weight: .medium))
                            .foregroundColor(color)
                    }
                    
                    Spacer()
                    
                    // Expand/collapse indicator
                    Image(systemName: isSelected ? "chevron.up" : "chevron.down")
                        .font(.system(size: isCompact ? 12 : 14, weight: .semibold))
                        .foregroundColor(color)
                        .rotationEffect(.degrees(isSelected ? 180 : 0))
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isSelected)
                }
                .padding(isCompact ? 14 : 20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(
                                    isSelected ? color.opacity(0.5) : Color.clear,
                                    lineWidth: 2
                                )
                        )
                        .shadow(
                            color: isSelected ? color.opacity(0.3) : Color.appShadow.opacity(0.8),
                            radius: isSelected ? 20 : 10,
                            x: 0,
                            y: isSelected ? 10 : 5
                        )
                )
                .scaleEffect(isSelected ? 1.02 : 1.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isSelected)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Subtopics with cascading animation
            if isSelected {
                VStack(spacing: isCompact ? 8 : 12) {
                    ForEach(Array(subtopics.enumerated()), id: \.offset) { index, subtopic in
                        SubtopicRowView(
                            title: subtopic.0,
                            icon: subtopic.1,
                            color: color,
                            isAnimated: showSubtopics,
                            animationDelay: Double(index) * 0.1,
                            isCompact: isCompact
                        )
                    }
                }
                .padding(.horizontal, isCompact ? 14 : 20)
                .padding(.bottom, isCompact ? 14 : 20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(color.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(color.opacity(0.2), lineWidth: 1)
                        )
                )
                .padding(.top, -10)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .transition(.move(edge: .top).combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        showSubtopics = true
                    }
                }
                .onDisappear {
                    showSubtopics = false
                }
            }
        }
        .scaleEffect(isAnimated ? 1.0 : 0.8)
        .opacity(isAnimated ? 1 : 0)
        .offset(y: isAnimated ? 0 : 30)
        .animation(
            .spring(response: 0.8, dampingFraction: 0.8)
                .delay(animationDelay),
            value: isAnimated
        )
    }
}

// MARK: - Subtopic Row View
struct SubtopicRowView: View {
    let title: String
    let icon: String
    let color: Color
    let isAnimated: Bool
    let animationDelay: Double
    let isCompact: Bool
    
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: isCompact ? 8 : 12) {
            Image(systemName: icon)
                .font(.system(size: isCompact ? 14 : 16, weight: .medium))
                .foregroundColor(color)
                .frame(width: isCompact ? 26 : 32, height: isCompact ? 26 : 32)
                .background(
                    Circle()
                        .fill(color.opacity(0.1))
                )
            
            Text(title)
                .font(.system(size: isCompact ? 14 : 16, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .lineLimit(isCompact ? 2 : nil)
            
            Spacer()
            
            Image(systemName: "arrow.right")
                .font(.system(size: isCompact ? 10 : 12, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(.vertical, isCompact ? 8 : 12)
        .padding(.horizontal, isCompact ? 12 : 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .shadow(
                    color: isPressed ? color.opacity(0.2) : Color.appShadow.opacity(0.5),
                    radius: isPressed ? 8 : 4,
                    x: 0,
                    y: isPressed ? 4 : 2
                )
        )
        .scaleEffect(isPressed ? 1.02 : 1.0)
        .scaleEffect(isAnimated ? 1.0 : 0.8)
        .opacity(isAnimated ? 1 : 0)
        .offset(x: isAnimated ? 0 : 30)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        .animation(
            .spring(response: 0.6, dampingFraction: 0.8)
                .delay(animationDelay),
            value: isAnimated
        )
        .onTapGesture {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
                    isPressed = false
                }
            }
        }
    }
}

// MARK: - Step by Step Onboarding Screen
struct StepByStepOnboardingView: View {
    @ObservedObject private var settings = SettingsModel.shared
    @State private var currentStep = 0
    @State private var animateElements = false
    @State private var showDemo = false
    
    private var learningSteps: [LearningStep] {
        if settings.language == .german {
            return [
                LearningStep(
                    title: "Was ist ein Vektor?",
                    explanation: "Ein Vektor ist eine Größe mit Richtung und Betrag. Er wird durch Koordinaten dargestellt.",
                    formula: "⃗v = (x, y)",
                    simpleExplanation: "Stelle dir einen Pfeil vor: Er zeigt in eine bestimmte Richtung und hat eine bestimmte Länge. Das ist ein Vektor!"
                ),
                LearningStep(
                    title: "Vektorlänge berechnen",
                    explanation: "Die Länge (der Betrag) eines Vektors wird mit dem Satz des Pythagoras berechnet.",
                    formula: "|⃗v| = √(x² + y²)",
                    simpleExplanation: "Die Länge des Pfeils findest du mit dem Satz des Pythagoras - wie bei einem rechtwinkligen Dreieck."
                ),
                LearningStep(
                    title: "Vektoren addieren",
                    explanation: "Vektoren werden komponentenweise addiert. Das Ergebnis ist wieder ein Vektor.",
                    formula: "(2,3) + (1,4) = (3,7)",
                    simpleExplanation: "Du addierst einfach die x-Werte zusammen und die y-Werte zusammen. Ganz einfach!"
                )
            ]
        } else {
            return [
                LearningStep(
                    title: "What is a vector?",
                    explanation: "A vector is a quantity with direction and magnitude, represented by coordinates.",
                    formula: "⃗v = (x, y)",
                    simpleExplanation: "Think of an arrow: It points in a certain direction and has a certain length. That's a vector!"
                ),
                LearningStep(
                    title: "Calculate vector length",
                    explanation: "The length (magnitude) of a vector is calculated using the Pythagorean theorem.",
                    formula: "|⃗v| = √(x² + y²)",
                    simpleExplanation: "You find the length of the arrow using the Pythagorean theorem - like with a right triangle."
                ),
                LearningStep(
                    title: "Adding vectors",
                    explanation: "Vectors are added component-wise. The result is another vector.",
                    formula: "(2,3) + (1,4) = (3,7)",
                    simpleExplanation: "You simply add the x-values together and the y-values together. Easy!"
                )
            ]
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: geometry.size.height < 700 ? 12 : 16) {
                        Text(settings.language == .german ? "Schritt für Schritt Erklärungen" : "Step by Step Explanations")
                            .font(.system(size: geometry.size.height < 700 ? 28 : 34, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .opacity(animateElements ? 1 : 0)
                            .animation(.easeOut(duration: 0.8).delay(0.2), value: animateElements)
                        
                        Text(settings.language == .german ?
                             "Komplexe Lerninhalte werden verständlich erklärt" :
                             "Complex topics explained step by step")
                            .font(.system(size: geometry.size.height < 700 ? 14 : 16, weight: .medium))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .opacity(animateElements ? 1 : 0)
                            .animation(.easeOut(duration: 0.8).delay(0.4), value: animateElements)
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, geometry.size.height < 700 ? 10 : 20)
                    
                    // Learning Content Demo (moved higher up)
                    if showDemo {
                        LearningContentDemo(
                            isCompact: geometry.size.height < 700,
                            currentStep: currentStep
                        )
                        .opacity(animateElements ? 1 : 0)
                        .animation(.easeOut(duration: 0.8).delay(0.6), value: animateElements)
                        .padding(.horizontal, 28)
                        .padding(.top, geometry.size.height < 700 ? 10 : 20)
                    }
                    
                    Spacer(minLength: geometry.size.height < 700 ? 5 : 15)
                    
                    // Simple message
                    VStack(spacing: geometry.size.height < 700 ? 6 : 10) {
                        Text(settings.language == .german ? 
                             "Von komplex zu einfach" :
                             "From complex to simple")
                            .font(.system(size: geometry.size.height < 700 ? 15 : 18, weight: .semibold))
                            .foregroundColor(.blue)
                            .multilineTextAlignment(.center)
                            .opacity(animateElements ? 1 : 0)
                            .animation(.easeOut(duration: 0.8).delay(1.2), value: animateElements)
                        
                        Text(settings.language == .german ? 
                             "Schritt für Schritt zum Verständnis" :
                             "Step by step to understanding")
                            .font(.system(size: geometry.size.height < 700 ? 11 : 14, weight: .medium))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .opacity(animateElements ? 1 : 0)
                            .animation(.easeOut(duration: 0.8).delay(1.4), value: animateElements)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, geometry.size.height < 700 ? 15 : 30)
                }
            }
        }
        .onAppear {
            startDemo()
        }
    }
    
        private func startDemo() {
        // Start main animations
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
            animateElements = true
        }
        
        // Show demo after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                showDemo = true
            }
        }
        
        // Simple automatic progression
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { timer in
                guard showDemo else {
                    timer.invalidate()
                    return
                }
                
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    currentStep = (currentStep + 1) % learningSteps.count
                }
            }
        }
    }
}

// MARK: - Learning Content Demo Components

struct LearningStep {
    let title: String
    let explanation: String
    let formula: String
    let simpleExplanation: String
}

struct LearningContentDemo: View {
    let isCompact: Bool
    let currentStep: Int
    @ObservedObject private var settings = SettingsModel.shared
    
    private var learningSteps: [LearningStep] {
        if settings.language == .german {
            return [
                LearningStep(
                    title: "Was ist ein Vektor?",
                    explanation: "Ein Vektor ist eine Größe mit Richtung und Betrag. Er wird durch Koordinaten dargestellt.",
                    formula: "⃗v = (x, y)",
                    simpleExplanation: "Stelle dir einen Pfeil vor: Er zeigt in eine bestimmte Richtung und hat eine bestimmte Länge. Das ist ein Vektor!"
                ),
                LearningStep(
                    title: "Vektorlänge berechnen",
                    explanation: "Die Länge (der Betrag) eines Vektors wird mit dem Satz des Pythagoras berechnet.",
                    formula: "|⃗v| = √(x² + y²)",
                    simpleExplanation: "Die Länge des Pfeils findest du mit dem Satz des Pythagoras - wie bei einem rechtwinkligen Dreieck."
                ),
                LearningStep(
                    title: "Vektoren addieren",
                    explanation: "Vektoren werden komponentenweise addiert. Das Ergebnis ist wieder ein Vektor.",
                    formula: "(2,3) + (1,4) = (3,7)",
                    simpleExplanation: "Du addierst einfach die x-Werte zusammen und die y-Werte zusammen. Ganz einfach!"
                )
            ]
        } else {
            return [
                LearningStep(
                    title: "What is a vector?",
                    explanation: "A vector is a quantity with direction and magnitude, represented by coordinates.",
                    formula: "⃗v = (x, y)",
                    simpleExplanation: "Think of an arrow: It points in a certain direction and has a certain length. That's a vector!"
                ),
                LearningStep(
                    title: "Calculate vector length",
                    explanation: "The length (magnitude) of a vector is calculated using the Pythagorean theorem.",
                    formula: "|⃗v| = √(x² + y²)",
                    simpleExplanation: "You find the length of the arrow using the Pythagorean theorem - like with a right triangle."
                ),
                LearningStep(
                    title: "Adding vectors",
                    explanation: "Vectors are added component-wise. The result is another vector.",
                    formula: "(2,3) + (1,4) = (3,7)",
                    simpleExplanation: "You simply add the x-values together and the y-values together. Easy!"
                )
            ]
        }
    }
    
    var body: some View {
        VStack(spacing: isCompact ? 12 : 16) {
            // Step indicator
            HStack(spacing: 8) {
                ForEach(0..<learningSteps.count, id: \.self) { index in
                    Circle()
                        .fill(index <= currentStep ? Color.blue : Color.secondary.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(index == currentStep ? 1.4 : 1.0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: currentStep)
                }
            }
            
            // Learning content card (like in the image)
            VStack(spacing: 0) {
                // Header with brain icon and title (like in the image)
                HStack(spacing: isCompact ? 10 : 14) {
                    // Brain icon in white circle
                    ZStack {
                        Circle()
                            .fill(Color.appSurface)
                            .frame(width: isCompact ? 40 : 50, height: isCompact ? 40 : 50)
                            .shadow(color: Color.appShadow.opacity(0.8), radius: 4, x: 0, y: 2)
                        
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: isCompact ? 18 : 22, weight: .medium))
                            .foregroundColor(.blue)
                    }
                    
                    // Title
                    Text(learningSteps[currentStep].title)
                        .font(.system(size: isCompact ? 16 : 18, weight: .bold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(2)
                }
                .padding(.horizontal, isCompact ? 14 : 18)
                .padding(.top, isCompact ? 12 : 16)
                
                // Explanation text
                Text(learningSteps[currentStep].explanation)
                    .font(.system(size: isCompact ? 13 : 15, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(isCompact ? 2 : 3)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, isCompact ? 14 : 18)
                    .padding(.top, isCompact ? 8 : 12)
                
                // Formula in blue box (like in the image)
                Text(learningSteps[currentStep].formula)
                    .font(.system(size: isCompact ? 15 : 17, weight: .semibold, design: .monospaced))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, isCompact ? 10 : 14)
                    .padding(.horizontal, isCompact ? 14 : 18)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue.opacity(0.15))
                    )
                    .padding(.horizontal, isCompact ? 14 : 18)
                    .padding(.top, isCompact ? 10 : 14)
                
                // Simple explanation in gray box (like in the image)
                Text(learningSteps[currentStep].simpleExplanation)
                    .font(.system(size: isCompact ? 12 : 14, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(isCompact ? 3 : 4)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, isCompact ? 10 : 12)
                    .padding(.horizontal, isCompact ? 14 : 18)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.secondary.opacity(0.1))
                    )
                    .padding(.horizontal, isCompact ? 14 : 18)
                    .padding(.top, isCompact ? 8 : 10)
                    .padding(.bottom, isCompact ? 12 : 16)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .shadow(color: Color.appShadow.opacity(0.7), radius: 12, x: 0, y: 6)
            )
        }
        .transition(.scale(scale: 0.95).combined(with: .opacity))
        .animation(.spring(response: 0.7, dampingFraction: 0.8), value: currentStep)
    }
}

// MARK: - Exams Onboarding Screen
struct ExamsOnboardingView: View {
    @ObservedObject private var settings = SettingsModel.shared
    @State private var animateExams = false
    @State private var selectedExam = 0
    
    private let exams = [
        ("Analysis I", "function", "120 min", "6 Aufgaben", Color.blue),
        ("Lineare Algebra", "grid", "90 min", "12 Aufgaben", Color.green),
        ("Analysis II", "cube", "150 min", "18 Aufgaben", Color.purple)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                AnimatedBackground()
                
                VStack(spacing: 40) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "graduationcap.fill")
                            .font(.system(size: 60, weight: .light))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.purple, .pink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .scaleEffect(animateExams ? 1.0 : 0.3)
                            .rotationEffect(.degrees(animateExams ? 0 : 360))
                            .animation(.spring(response: 1.2, dampingFraction: 0.6).delay(0.2), value: animateExams)
                        
                        Text(settings.language == .german ? "Klausuren üben" : "Practice Exams")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                            .opacity(animateExams ? 1 : 0)
                            .animation(.easeOut(duration: 0.8).delay(0.4), value: animateExams)
                        
                        Text(settings.language == .german ?
                             "Bereiten Sie sich optimal auf Ihre Klausuren vor" :
                             "Prepare optimally for your exams")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .opacity(animateExams ? 1 : 0)
                            .animation(.easeOut(duration: 0.8).delay(0.6), value: animateExams)
                    }
                    .padding(.horizontal, 32)
                    
                    // Exam Cards
                    VStack(spacing: 20) {
                        ForEach(Array(exams.enumerated()), id: \.offset) { index, exam in
                            OnboardingExamCard(
                                title: exam.0,
                                icon: exam.1,
                                duration: exam.2,
                                questions: exam.3,
                                color: exam.4,
                                isSelected: selectedExam == index,
                                isAnimated: animateExams,
                                delay: Double(index) * 0.2
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    selectedExam = index
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                }
                .padding(.top, 60)
            }
        }
        .onAppear {
            animateExams = true
            startExamRotation()
        }
    }
    
    private func startExamRotation() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                selectedExam = (selectedExam + 1) % exams.count
            }
        }
    }
}

// MARK: - Exercises Onboarding Screen
struct ExercisesOnboardingView: View {
    @ObservedObject private var settings = SettingsModel.shared
    @State private var animateCounter = false
    @State private var currentCount = 0
    @State private var animateFeatures = false
    
    private let features = [
        ("Vielfältige Themen", "books.vertical.fill", Color.blue),
        ("Verschiedene Schwierigkeiten", "chart.line.uptrend.xyaxis", Color.green),
        ("Ausführliche Lösungen", "checkmark.seal.fill", Color.orange),
        ("Regelmäßige Updates", "arrow.clockwise", Color.purple)
    ]
    
    private let englishFeatures = [
        ("Diverse Topics", "books.vertical.fill", Color.blue),
        ("Various Difficulties", "chart.line.uptrend.xyaxis", Color.green),
        ("Detailed Solutions", "checkmark.seal.fill", Color.orange),
        ("Regular Updates", "arrow.clockwise", Color.purple)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                AnimatedBackground()
                
                VStack(spacing: 40) {
                    // Header
                    VStack(spacing: 16) {
                        HStack(spacing: 0) {
                            Text("\(currentCount)")
                                .font(.system(size: geometry.size.width < 400 ? 30 : 36, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.green, .blue, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .contentTransition(.numericText())
                            
                            Text(settings.language == .german ? "+ Aufgaben" : "+ Problems")
                                .font(.system(size: geometry.size.width < 400 ? 30 : 36, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                        }
                        .opacity(animateCounter ? 1 : 0)
                        .scaleEffect(animateCounter ? 1.0 : 0.5)
                        .animation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.2), value: animateCounter)
                        .fixedSize(horizontal: true, vertical: false)
                        .minimumScaleFactor(0.8)
                        
                        Text(settings.language == .german ?
                             "Über 300 sorgfältig ausgewählte Übungsaufgaben" :
                             "Over 300 carefully selected practice problems")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .opacity(animateCounter ? 1 : 0)
                            .animation(.easeOut(duration: 0.8).delay(0.4), value: animateCounter)
                    }
                    .padding(.horizontal, 32)
                    
                    // Features
                    VStack(spacing: 16) {
                        let currentFeatures = settings.language == .german ? features : englishFeatures
                        ForEach(Array(currentFeatures.enumerated()), id: \.offset) { index, feature in
                            OnboardingFeatureRow(
                                title: feature.0,
                                icon: feature.1,
                                color: feature.2,
                                isAnimated: animateFeatures,
                                delay: Double(index) * 0.1
                            )
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                }
                .padding(.top, 60)
            }
        }
        .onAppear {
            animateCounter = true
            animateFeatures = true
            startCounterAnimation()
        }
    }
    
    private func startCounterAnimation() {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            if currentCount < 300 {
                currentCount += 5
            } else {
                timer.invalidate()
            }
        }
    }
}

// MARK: - Matrix Methods Onboarding Screen
struct MatrixMethodsOnboardingView: View {
    @ObservedObject private var settings = SettingsModel.shared
    @State private var animateElements = false
    
    private var methods: [MatrixMethod] {
        if settings.language == .german {
            return [
                MatrixMethod(
                    title: "Gauss-Verfahren",
                    subtitle: "Schrittweise Lösung",
                    color: Color.blue,
                    icon: "square.grid.3x3.fill",
                    accent: "arrow.triangle.2.circlepath"
                ),
                MatrixMethod(
                    title: "Determinante",
                    subtitle: "Schnell berechnen",
                    color: Color.orange,
                    icon: "pause",
                    accent: "bolt.fill"
                ),
                MatrixMethod(
                    title: "Matrixprodukt",
                    subtitle: "Produkt schnell berechnen",
                    color: Color.purple,
                    icon: "multiply.circle.fill",
                    accent: "sparkles"
                )
            ]
        }
        
        return [
            MatrixMethod(
                title: "Gaussian Elimination",
                subtitle: "Step-by-step solution",
                color: Color.blue,
                icon: "square.grid.3x3.fill",
                accent: "arrow.triangle.2.circlepath"
            ),
            MatrixMethod(
                title: "Determinant",
                subtitle: "Compute quickly",
                color: Color.orange,
                icon: "pause",
                accent: "bolt.fill"
            ),
            MatrixMethod(
                title: "Matrix Product",
                subtitle: "Compute product fast",
                color: Color.purple,
                icon: "multiply.circle.fill",
                accent: "sparkles"
            )
        ]
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AnimatedBackground()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: geometry.size.height < 700 ? 18 : 24) {
                        headerSection(geometry: geometry)
                        
                        ForEach(Array(methods.enumerated()), id: \.offset) { index, method in
                            let direction: CGFloat = index % 2 == 0 ? -1 : 1
                            MatrixMethodCard(
                                method: method,
                                isCompact: geometry.size.height < 700,
                                animate: animateElements,
                                delay: Double(index) * 0.18,
                                entryDirection: direction
                            )
                        }
                        
                        calculatorNote(geometry: geometry)
                        
                        Spacer(minLength: geometry.size.height < 700 ? 90 : 110)
                    }
                    .padding(.horizontal, geometry.size.width < 400 ? 16 : 24)
                    .padding(.top, geometry.size.height < 700 ? 10 : 20)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                animateElements = true
            }
        }
    }
    
    private func headerSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: geometry.size.height < 700 ? 10 : 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.teal.opacity(0.9), .blue.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: geometry.size.height < 700 ? 52 : 64,
                           height: geometry.size.height < 700 ? 52 : 64)
                    .shadow(color: Color.teal.opacity(0.25), radius: 12, x: 0, y: 8)
                
                Image(systemName: "tablecells.fill")
                    .font(.system(size: geometry.size.height < 700 ? 22 : 28, weight: .medium))
                    .foregroundColor(.white)
            }
            .scaleEffect(animateElements ? 1.0 : 0.6)
            .opacity(animateElements ? 1 : 0)
            .animation(.spring(response: 0.9, dampingFraction: 0.7), value: animateElements)
            
            VStack(spacing: geometry.size.height < 700 ? 4 : 8) {
                Text(settings.language == .german ? "Matrixrechner" : "Matrix calculators")
                    .font(.system(size: geometry.size.height < 700 ? 22 : 28, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .opacity(animateElements ? 1 : 0)
                    .offset(y: animateElements ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: animateElements)
                
                Text(settings.language == .german ? "Gauss · Determinante · Matrixprodukt" : "Gauss · Determinant · Matrix product")
                    .font(.system(size: geometry.size.height < 700 ? 12 : 14, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(animateElements ? 1 : 0)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: animateElements)
            }
        }
    }
    
    private func calculatorNote(geometry: GeometryProxy) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "calculator")
                .font(.system(size: geometry.size.height < 700 ? 18 : 20))
                .foregroundColor(.teal)
            Text(settings.language == .german ? "Inklusive Matrix-Rechner" : "Includes matrix calculators")
                .font(.system(size: geometry.size.height < 700 ? 12 : 14, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.appShadow.opacity(0.6), radius: 8, x: 0, y: 4)
        )
        .opacity(animateElements ? 1 : 0)
        .offset(y: animateElements ? 0 : 16)
        .animation(.easeOut(duration: 0.8).delay(0.6), value: animateElements)
    }
}

struct MatrixMethod {
    let title: String
    let subtitle: String
    let color: Color
    let icon: String
    let accent: String
}

struct MatrixMethodCard: View {
    let method: MatrixMethod
    let isCompact: Bool
    let animate: Bool
    let delay: Double
    let entryDirection: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: isCompact ? 10 : 12) {
            HStack(spacing: isCompact ? 10 : 12) {
                ZStack {
                    Circle()
                        .fill(method.color.opacity(0.15))
                        .frame(width: isCompact ? 38 : 44, height: isCompact ? 38 : 44)
                    
                    Image(systemName: method.icon)
                        .font(.system(size: isCompact ? 18 : 20, weight: .semibold))
                        .foregroundColor(method.color)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(method.title)
                        .font(.system(size: isCompact ? 16 : 18, weight: .bold))
                        .scaleEffect(animate ? 1.0 : 0.92)
                        .opacity(animate ? 1 : 0)
                        .animation(.spring(response: 0.7, dampingFraction: 0.7).delay(delay), value: animate)
                    Text(method.subtitle)
                        .font(.system(size: isCompact ? 12 : 13, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(isCompact ? 14 : 18)
        .frame(maxWidth: .infinity, minHeight: isCompact ? 92 : 108, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.appShadow.opacity(0.7), radius: 10, x: 0, y: 6)
        )
        .opacity(animate ? 1 : 0)
        .offset(x: animate ? 0 : (entryDirection * (isCompact ? 26 : 34)),
                y: animate ? 0 : 14)
        .rotationEffect(.degrees(animate ? 0 : (entryDirection < 0 ? -5 : 5)))
        .animation(.spring(response: 0.75, dampingFraction: 0.65).delay(delay), value: animate)
    }
}

// MARK: - Learning Plan Onboarding Screen
struct LearningPlanOnboardingView: View {
    @ObservedObject private var settings = SettingsModel.shared
    @ObservedObject private var planManager = LearningPlanManager.shared
    @State private var topics: [MathTopic] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var selectedTopicIDs: Set<String> = []
    @State private var includeExercises = true
    @State private var includeSteps = true
    @State private var includeExams = true
    @State private var searchText = ""
    @State private var animateContent = false
    @State private var animateCards = false
    @State private var showSavedBadge = false
    @State private var exerciseTotalCount = 0
    @State private var examTotalCount = 0
    @State private var exerciseCountCache: [String: Int] = [:]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AnimatedBackground()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: geometry.size.height < 700 ? 20 : 28) {
                        headerSection(geometry: geometry)

                        if isLoading {
                            ProgressView()
                                .scaleEffect(1.2)
                                .padding(.top, 20)
                        } else if let errorMessage {
                            Text(errorMessage)
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                        } else {
                            optionsCard(geometry: geometry)
                            topicsCard(geometry: geometry)
                            createButton(geometry: geometry)
                            summaryCard(geometry: geometry)
                        }

                        Spacer(minLength: geometry.size.height < 700 ? 90 : 110)
                    }
                    .padding(.horizontal, geometry.size.width < 400 ? 16 : 24)
                    .padding(.top, geometry.size.height < 700 ? 10 : 20)
                }
            }
        }
        .onAppear {
            animateContent = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                animateCards = true
            }
            loadTopics()
            hydrateFromPlan()
            updateExamTotal()
        }
        .onChange(of: settings.language) { _ in
            loadTopics()
            hydrateFromPlan()
            exerciseCountCache = [:]
            updateExamTotal()
        }
        .onChange(of: selectedTopicIDs) { _ in
            showSavedBadge = false
            updateExerciseTotal()
        }
        .onChange(of: includeExercises) { _ in showSavedBadge = false }
        .onChange(of: includeSteps) { _ in showSavedBadge = false }
        .onChange(of: includeExams) { _ in showSavedBadge = false }
        .onDisappear {
            createPlan(showFeedback: false)
        }
    }

    private func headerSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: geometry.size.height < 700 ? 10 : 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.9), .purple.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: geometry.size.height < 700 ? 52 : 64,
                           height: geometry.size.height < 700 ? 52 : 64)
                    .shadow(color: Color.blue.opacity(0.25), radius: 12, x: 0, y: 8)

                Image(systemName: "sparkles.rectangle.stack.fill")
                    .font(.system(size: geometry.size.height < 700 ? 22 : 28, weight: .medium))
                    .foregroundColor(.white)
            }
            .scaleEffect(animateContent ? 1.0 : 0.6)
            .opacity(animateContent ? 1 : 0)
            .animation(.spring(response: 0.9, dampingFraction: 0.7), value: animateContent)

            VStack(spacing: geometry.size.height < 700 ? 6 : 10) {
                Text(settings.language == .german ? "Dein persönlicher Lernplan" : "Your personal learning plan")
                    .font(.system(size: geometry.size.height < 700 ? 22 : 28, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)

            }
        }
        .padding(.horizontal, geometry.size.width < 400 ? 10 : 16)
    }

    private func summaryCard(geometry: GeometryProxy) -> some View {
        glassCard {
            VStack(alignment: .leading, spacing: 10) {
                Text(settings.language == .german ? "Plan auf einen Blick" : "Plan at a glance")
                    .font(.system(size: geometry.size.height < 700 ? 15 : 16, weight: .bold))

                HStack(spacing: 10) {
                    summaryPill(
                        title: settings.language == .german ? "Themen" : "Topics",
                        value: "\(selectedTopicIDs.count)",
                        color: .blue
                    )
                    summaryPill(
                        title: settings.language == .german ? "Schritte" : "Steps",
                        value: "\(includeSteps ? selectedTopicIDs.count : 0)",
                        color: .purple
                    )
                    summaryPill(
                        title: settings.language == .german ? "Übungen" : "Exercises",
                        value: "\(includeExercises ? exerciseTotalCount : 0)",
                        color: .green
                    )
                    summaryPill(
                        title: settings.language == .german ? "Klausuren" : "Exams",
                        value: "\(includeExams ? examTotalCount : 0)",
                        color: .orange
                    )
                }
            }
        }
        .opacity(animateCards ? 1 : 0)
        .offset(y: animateCards ? 0 : 20)
        .animation(.easeOut(duration: 0.8).delay(0.2), value: animateCards)
    }

    private func optionsCard(geometry: GeometryProxy) -> some View {
        glassCard {
            VStack(alignment: .leading, spacing: 12) {
                Text(settings.language == .german ? "Bausteine auswählen" : "Choose building blocks")
                    .font(.system(size: geometry.size.height < 700 ? 15 : 16, weight: .bold))

                VStack(spacing: 10) {
                    optionSwitch(
                        title: settings.language == .german ? "Schritt-für-Schritt" : "Step by step",
                        subtitle: settings.language == .german ? "Geführte Erklärungen" : "Guided explanations",
                        icon: "list.number",
                        color: .purple,
                        isOn: $includeSteps
                    )
                    optionSwitch(
                        title: settings.language == .german ? "Übungen" : "Exercises",
                        subtitle: settings.language == .german ? "Direkt anwenden" : "Apply instantly",
                        icon: "checkmark.circle.fill",
                        color: .green,
                        isOn: $includeExercises
                    )
                    optionSwitch(
                        title: settings.language == .german ? "Klausuren" : "Exams",
                        subtitle: settings.language == .german ? "Am Ende testen" : "Test at the end",
                        icon: "graduationcap.fill",
                        color: .orange,
                        isOn: $includeExams
                    )
                }

                if !hasAnyContentSelected {
                    Text(settings.language == .german ? "Bitte mindestens einen Baustein aktivieren." : "Please enable at least one block.")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
        .opacity(animateCards ? 1 : 0)
        .offset(y: animateCards ? 0 : 20)
        .animation(.easeOut(duration: 0.8).delay(0.3), value: animateCards)
    }

    private func topicsCard(geometry: GeometryProxy) -> some View {
        glassCard {
            VStack(alignment: .leading, spacing: 12) {
                Text(settings.language == .german ? "Themen wählen" : "Pick your topics")
                    .font(.system(size: geometry.size.height < 700 ? 16 : 18, weight: .bold))

                TextField(settings.language == .german ? "Themen suchen" : "Search topics", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: geometry.size.width < 400 ? 120 : 150), spacing: 12)],
                    spacing: 12
                ) {
                    ForEach(filteredTopics) { topic in
                        topicChip(
                            title: topic.title,
                            isSelected: selectedTopicIDs.contains(topic.id),
                            color: .blue
                        ) {
                            toggleTopic(topic.id)
                        }
                    }
                }
            }
        }
        .opacity(animateCards ? 1 : 0)
        .offset(y: animateCards ? 0 : 20)
        .animation(.easeOut(duration: 0.8).delay(0.4), value: animateCards)
    }

    private func createButton(geometry: GeometryProxy) -> some View {
        VStack(spacing: 8) {
            Button(action: {
                createPlan(showFeedback: true)
            }) {
                HStack {
                    Image(systemName: "sparkles")
                    Text(settings.language == .german ? "Lernplan erstellen" : "Create learning plan")
                        .font(.system(size: geometry.size.height < 700 ? 16 : 18, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, geometry.size.height < 700 ? 12 : 14)
                .background(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(18)
                .shadow(color: Color.blue.opacity(0.3), radius: 12, x: 0, y: 8)
            }
            .disabled(selectedTopicIDs.isEmpty || !hasAnyContentSelected)
            .opacity(selectedTopicIDs.isEmpty || !hasAnyContentSelected ? 0.6 : 1.0)

            if showSavedBadge {
                Text(settings.language == .german ? "Gespeichert ✓" : "Saved ✓")
                    .font(.caption)
                    .foregroundColor(.green)
                    .transition(.opacity)
            } else if selectedTopicIDs.isEmpty {
                Text(settings.language == .german ? "Bitte wähle mindestens ein Thema." : "Please choose at least one topic.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .opacity(animateCards ? 1 : 0)
        .offset(y: animateCards ? 0 : 20)
        .animation(.easeOut(duration: 0.8).delay(0.5), value: animateCards)
    }

    private var filteredTopics: [MathTopic] {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return selectableTopics
        }
        let term = trimmed.lowercased()
        return selectableTopics.filter { $0.title.lowercased().contains(term) || $0.description.lowercased().contains(term) }
    }

    private var selectableTopics: [MathTopic] {
        leafTopics(from: topics)
    }

    private var hasAnyContentSelected: Bool {
        includeExercises || includeSteps || includeExams
    }

    private func toggleTopic(_ id: String) {
        if selectedTopicIDs.contains(id) {
            selectedTopicIDs.remove(id)
        } else {
            selectedTopicIDs.insert(id)
        }
    }

    private func createPlan(showFeedback: Bool) {
        guard !selectedTopicIDs.isEmpty else { return }
        guard hasAnyContentSelected else { return }
        planManager.generatePlan(
            topics: topics,
            selectedTopicIDs: selectedTopicIDs,
            includeExercises: includeExercises,
            includeExams: includeExams,
            includeSteps: includeSteps
        )
        if showFeedback {
            withAnimation(.easeInOut(duration: 0.2)) {
                showSavedBadge = true
            }
        }
    }

    private func hydrateFromPlan() {
        guard let plan = planManager.plan else { return }
        selectedTopicIDs = Set(plan.selectedTopicIDs)
        includeExercises = plan.includeExercises
        includeExams = plan.includeExams
        includeSteps = plan.includeSteps
    }

    private func ensureDefaultSelection() {
        if selectedTopicIDs.isEmpty {
            let defaults = selectableTopics.prefix(3).map { $0.id }
            selectedTopicIDs = Set(defaults)
        }
    }

    private func loadTopics() {
        let language = settings.language
        let languageSuffix = language == .english ? "_en" : ""
        let indexName = "index" + languageSuffix
        var indexUrl: URL?

        if let url = Bundle.main.url(forResource: indexName, withExtension: "json") {
            indexUrl = url
        } else if let url = Bundle.main.url(forResource: "index", withExtension: "json") {
            indexUrl = url
        } else if let url = Bundle.main.url(forResource: indexName, withExtension: "json", subdirectory: "lerninhalt") {
            indexUrl = url
        } else if let url = Bundle.main.url(forResource: "index", withExtension: "json", subdirectory: "lerninhalt") {
            indexUrl = url
        } else if let url = Bundle.main.url(forResource: indexName, withExtension: "json", subdirectory: "lerninhalt/\(language.rawValue)") {
            indexUrl = url
        } else if let url = Bundle.main.url(forResource: "index", withExtension: "json", subdirectory: "lerninhalt/\(language.rawValue)") {
            indexUrl = url
        } else {
            errorMessage = settings.language == .english ?
                "Index file not found in bundle" :
                "Index-Datei nicht im Bundle gefunden"
            isLoading = false
            return
        }

        do {
            let indexData = try Data(contentsOf: indexUrl!)
            let indexResponse = try JSONDecoder().decode(IndexResponse.self, from: indexData)
            var loadedTopics: [MathTopic] = []

            for topicIndex in indexResponse.topics {
                let filenameWithoutExtension = topicIndex.filename.replacingOccurrences(of: ".json", with: "")
                let localizedFilename = filenameWithoutExtension + languageSuffix
                let topicUrl: URL?

                if let url = Bundle.main.url(forResource: localizedFilename, withExtension: "json") {
                    topicUrl = url
                } else if let url = Bundle.main.url(forResource: filenameWithoutExtension, withExtension: "json") {
                    topicUrl = url
                } else if let url = Bundle.main.url(forResource: localizedFilename, withExtension: "json", subdirectory: "lerninhalt") {
                    topicUrl = url
                } else if let url = Bundle.main.url(forResource: filenameWithoutExtension, withExtension: "json", subdirectory: "lerninhalt") {
                    topicUrl = url
                } else if let url = Bundle.main.url(forResource: localizedFilename, withExtension: "json", subdirectory: "lerninhalt/\(language.rawValue)") {
                    topicUrl = url
                } else if let url = Bundle.main.url(forResource: filenameWithoutExtension, withExtension: "json", subdirectory: "lerninhalt/\(language.rawValue)") {
                    topicUrl = url
                } else {
                    continue
                }

                do {
                    let topicData = try Data(contentsOf: topicUrl!)
                    let topic = try JSONDecoder().decode(MathTopic.self, from: topicData)
                    loadedTopics.append(topic)
                } catch {
                    continue
                }
            }

            topics = loadedTopics
            isLoading = false
            exerciseCountCache = [:]
            ensureDefaultSelection()
            updateExerciseTotal()
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    private func updateExamTotal() {
        let repo = ExamRepository.shared
        let available = repo.loadAvailableExams(language: settings.language)
        if !available.isEmpty {
            examTotalCount = available.count
            return
        }

        let englishFallback = [
            "analysis_1_beginner",
            "linear_algebra_intermediate",
            "statistics_intermediate",
            "analysis_2_advanced",
            "differential_equations_advanced",
            "numerical_mathematics_advanced",
            "linear_algebra_advanced",
            "linear_algebra_expert",
            "mathematics_1_beginner",
            "mathematics_1_intermediate",
            "mathematics_1_advanced",
            "linear_algebra_1_beginner",
            "linear_algebra_beginner",
            "statistics_beginner"
        ]

        let germanFallback = [
            "analysis_1_anfaenger",
            "lineare_algebra_fortgeschritten",
            "statistik_fortgeschritten",
            "analysis_2_experte",
            "differentialgleichungen_experte",
            "numerische_mathematik_experte",
            "lineare_algebra_experte",
            "mathematik_1_anfaenger",
            "mathematik_1_fortgeschritten",
            "mathematik_1_experte",
            "lineare_algebra_1_anfaenger",
            "statistik_anfaenger"
        ]

        examTotalCount = (settings.language == .english ? englishFallback.count : germanFallback.count)
    }

    private func updateExerciseTotal() {
        let selectedTopics = selectableTopics.filter { selectedTopicIDs.contains($0.id) }
        var total = 0
        for topic in selectedTopics {
            if let cached = exerciseCountCache[topic.id] {
                total += cached
                continue
            }
            let count = loadExerciseCount(for: topic)
            exerciseCountCache[topic.id] = count
            total += count
        }
        exerciseTotalCount = total
    }

    private func loadExerciseCount(for topic: MathTopic) -> Int {
        guard let baseFileName = exerciseBaseFileName(for: topic.title) else { return 0 }
        let language = settings.language
        let langFolder = language == .english ? "en" : "de"
        let localizedFileName = language == .english ? baseFileName + "_en" : baseFileName

        var fileURL: URL?
        if let url = Bundle.main.url(forResource: localizedFileName, withExtension: "json", subdirectory: "aufgaben/\(langFolder)") {
            fileURL = url
        } else if let url = Bundle.main.url(forResource: baseFileName, withExtension: "json", subdirectory: "aufgaben/\(langFolder)") {
            fileURL = url
        } else if let url = Bundle.main.url(forResource: localizedFileName, withExtension: "json", subdirectory: "aufgaben") {
            fileURL = url
        } else if let url = Bundle.main.url(forResource: baseFileName, withExtension: "json", subdirectory: "aufgaben") {
            fileURL = url
        } else if let url = Bundle.main.url(forResource: localizedFileName, withExtension: "json") {
            fileURL = url
        } else if let url = Bundle.main.url(forResource: baseFileName, withExtension: "json") {
            fileURL = url
        }

        guard let foundURL = fileURL else { return 0 }
        do {
            let data = try Data(contentsOf: foundURL)
            let response = try JSONDecoder().decode(ExercisesResponse.self, from: data)
            return response.exercises.count
        } catch {
            return 0
        }
    }

    private func exerciseBaseFileName(for topicTitle: String) -> String? {
        switch topicTitle {
        case "Mengen und Abbildungen", "Sets and Mappings":
            return "mengen_und_abbildungen"
        case "Logik", "Logic":
            return "logik"
        case "Vollständige Induktion", "Mathematical Induction":
            return "vollstaendige_induktion"
        case "Binomische Formeln", "Binomial Formulas":
            return "binomische_formeln"
        case "Größter gemeinsamer Teiler", "Greatest Common Divisor":
            return "groesster_gemeinsamer_teiler"
        case "Gruppen", "Groups":
            return "gruppen"
        case "Ringe", "Rings":
            return "ringe"
        case "Körper", "Fields":
            return "koerper"
        case "Komplexe Zahlen", "Complex Numbers":
            return "komplexe_zahlen"
        case "Folgen und Reihen", "Sequences and Series":
            return "folgen_und_reihen"
        case "Grenzwerte", "Limits":
            return "grenzwerte"
        case "Differentialrechnung", "Differential Calculus":
            return "differentialrechnung"
        case "Integralrechnung", "Integral Calculus":
            return "integralrechnung"
        case "Mehrdimensionale Analysis", "Multidimensional Calculus":
            return "mehrdimensionale_analysis"
        case "Matrizen", "Matrices":
            return "matrizen"
        case "Vektorräume", "Vector Spaces":
            return "vektorraeume"
        case "Determinanten", "Determinants":
            return "determinanten"
        case "Lineare Abbildungen", "Linear Mappings":
            return "lineare_abbildungen"
        case "Eigenwerte", "Eigenvalues", "Eigenwerte und Eigenvektoren", "Eigenvalues and Eigenvectors":
            return "eigenwerte"
        default:
            return nil
        }
    }

    private func leafTopics(from topics: [MathTopic]) -> [MathTopic] {
        var result: [MathTopic] = []
        for topic in topics {
            if let subTopics = topic.subTopics, !subTopics.isEmpty {
                result.append(contentsOf: leafTopics(from: subTopics))
            } else {
                result.append(topic)
            }
        }
        return result
    }

    private func glassCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .strokeBorder(Color.appSurface.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: Color.appShadow.opacity(0.7), radius: 16, x: 0, y: 8)
            )
    }

    private func summaryPill(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(color)
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(color.opacity(0.12))
        )
    }

    private func optionToggle(title: String, subtitle: String, icon: String, color: Color, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(color)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(color)
        }
    }

    private func optionSwitch(title: String, subtitle: String, icon: String, color: Color, isOn: Binding<Bool>) -> some View {
        Button(action: { isOn.wrappedValue.toggle() }) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(0.15))
                        .frame(width: 42, height: 42)
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(color)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                ZStack {
                    Capsule()
                        .fill(isOn.wrappedValue ? color : Color.secondary.opacity(0.25))
                        .frame(width: 44, height: 26)
                    Circle()
                        .fill(Color.appSurface)
                        .frame(width: 20, height: 20)
                        .offset(x: isOn.wrappedValue ? 9 : -9)
                        .shadow(color: Color.appShadow.opacity(0.8), radius: 3, x: 0, y: 2)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.appSurface.opacity(0.9))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .strokeBorder(color.opacity(isOn.wrappedValue ? 0.5 : 0.2), lineWidth: 1)
                    )
                    .shadow(color: Color.appShadow.opacity(0.5), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(.plain)
    }

    private func topicChip(title: String, isSelected: Bool, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(isSelected ? .white : .primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, minHeight: 54, maxHeight: 54)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? color : Color.appSurface.opacity(0.7))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(color.opacity(isSelected ? 0.8 : 0.2), lineWidth: 1)
                    )
            )
        }
    }
}

// MARK: - Supporting Views

struct AnimatedBackground: View {
    @State private var animateBackground = false
    
    var body: some View {
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
                
                // Floating shapes
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: geometry.size.width * 0.6)
                    .offset(
                        x: animateBackground ? geometry.size.width * 0.3 : -geometry.size.width * 0.3,
                        y: -geometry.size.height * 0.2
                    )
                    .animation(
                        Animation.easeInOut(duration: 20)
                            .repeatForever(autoreverses: true),
                        value: animateBackground
                    )
                
                Circle()
                    .fill(Color.purple.opacity(0.08))
                    .frame(width: geometry.size.width * 0.8)
                    .offset(
                        x: animateBackground ? -geometry.size.width * 0.2 : geometry.size.width * 0.2,
                        y: geometry.size.height * 0.3
                    )
                    .animation(
                        Animation.easeInOut(duration: 15)
                            .repeatForever(autoreverses: true)
                            .delay(5),
                        value: animateBackground
                    )
            }
        }
        .onAppear {
            animateBackground = true
        }
    }
}

struct OnboardingTopicCard: View {
    let title: String
    let icon: String
    let color: Color
    let delay: Double
    let isAnimated: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 32, weight: .light))
                .foregroundColor(color)
                .frame(width: 60, height: 60)
                .background(color.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 120, height: 120)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: color.opacity(0.3), radius: 20, x: 0, y: 10)
        )
        .scaleEffect(isAnimated ? 1.0 : 0.3)
        .opacity(isAnimated ? 1 : 0)
        .rotation3DEffect(
            .degrees(isAnimated ? 0 : 180),
            axis: (x: 1, y: 1, z: 0)
        )
        .animation(
            .spring(response: 1.0, dampingFraction: 0.8)
                .delay(delay),
            value: isAnimated
        )
    }
}

struct StepRow: View {
    let step: String
    let index: Int
    let isActive: Bool
    let isAnimated: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Step indicator
            ZStack {
                Circle()
                    .fill(isActive ? Color.orange : Color.secondary.opacity(0.3))
                    .frame(width: 40, height: 40)
                
                if isActive {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                } else {
                    Text("\(index + 1)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.secondary)
                }
            }
            .scaleEffect(isActive ? 1.1 : 1.0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isActive)
            
            // Step text
            Text(step)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(isActive ? .primary : .secondary)
                .animation(.easeInOut(duration: 0.3), value: isActive)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isActive ? Color.orange.opacity(0.1) : Color.clear)
        )
        .scaleEffect(isAnimated ? 1.0 : 0.8)
        .opacity(isAnimated ? 1 : 0)
        .animation(
            .spring(response: 0.8, dampingFraction: 0.8)
                .delay(Double(index) * 0.1),
            value: isAnimated
        )
    }
}

struct OnboardingExamCard: View {
    let title: String
    let icon: String
    let duration: String
    let questions: String
    let color: Color
    let isSelected: Bool
    let isAnimated: Bool
    let delay: Double
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .light))
                .foregroundColor(color)
                .frame(width: 50, height: 50)
                .background(color.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                
                HStack(spacing: 16) {
                    Label(duration, systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Label(questions, systemImage: "doc.text")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(color)
                    .scaleEffect(1.2)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            isSelected ? color : Color.clear,
                            lineWidth: 2
                        )
                )
                .shadow(
                    color: isSelected ? color.opacity(0.3) : Color.appShadow.opacity(0.8),
                    radius: isSelected ? 20 : 10,
                    x: 0,
                    y: isSelected ? 10 : 5
                )
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .scaleEffect(isAnimated ? 1.0 : 0.8)
        .opacity(isAnimated ? 1 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isSelected)
        .animation(
            .spring(response: 0.8, dampingFraction: 0.8)
                .delay(delay),
            value: isAnimated
        )
    }
}

struct OnboardingFeatureRow: View {
    let title: String
    let icon: String
    let color: Color
    let isAnimated: Bool
    let delay: Double
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
        .scaleEffect(isAnimated ? 1.0 : 0.8)
        .opacity(isAnimated ? 1 : 0)
        .offset(x: isAnimated ? 0 : 50)
        .animation(
            .spring(response: 0.8, dampingFraction: 0.8)
                .delay(delay),
            value: isAnimated
        )
    }
} 

// MARK: - Monthly Updates Onboarding Screen
struct MonthlyUpdatesOnboardingView: View {
    @EnvironmentObject var onboardingManager: OnboardingManager
    @ObservedObject private var settings = SettingsModel.shared
    @State private var animateContent = false
    @State private var animateFeatures = false
    @State private var currentFeatureIndex = 0
    @State private var showPaywall = false
    
    private let updateFeatures = [
        ("Neue Aufgaben", "plus.circle.fill", "Jeden Monat 20+ neue Übungsaufgaben", Color.blue),
        ("Aktuelle Klausuren", "doc.text.fill", "Frische Prüfungsaufgaben aus deutschen Unis", Color.green),
        ("Erweiterte Inhalte", "book.fill", "Zusätzliche Themen und Vertiefungen", Color.purple),
        ("Sofortige Updates", "bolt.fill", "Automatische App-Updates mit neuen Features", Color.orange)
    ]
    
    private let englishUpdateFeatures = [
        ("New Problems", "plus.circle.fill", "20+ new practice problems every month", Color.blue),
        ("Current Exams", "doc.text.fill", "Fresh exam problems from German universities", Color.green),
        ("Extended Content", "book.fill", "Additional topics and deep dives", Color.purple),
        ("Instant Updates", "bolt.fill", "Automatic app updates with new features", Color.orange)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                AnimatedBackground()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: geometry.size.height < 700 ? 30 : 40) {
                        // Header
                        VStack(spacing: geometry.size.height < 700 ? 16 : 24) {
                            // Animated Calendar Icon
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.mint, .cyan, .blue],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: geometry.size.height < 700 ? 80 : 100, 
                                           height: geometry.size.height < 700 ? 80 : 100)
                                    .shadow(color: Color.mint.opacity(0.4), radius: 20, x: 0, y: 10)
                                    .scaleEffect(animateContent ? 1.0 : 0.3)
                                    .rotationEffect(.degrees(animateContent ? 0 : 360))
                                    .animation(.spring(response: 1.2, dampingFraction: 0.6).delay(0.2), value: animateContent)
                                
                                Image(systemName: "calendar.badge.plus")
                                    .font(.system(size: geometry.size.height < 700 ? 32 : 40, weight: .medium))
                                    .foregroundColor(.white)
                                    .scaleEffect(animateContent ? 1.0 : 0.3)
                                    .animation(.spring(response: 1.4, dampingFraction: 0.6).delay(0.4), value: animateContent)
                            }
                            
                            VStack(spacing: geometry.size.height < 700 ? 8 : 12) {
                                Text(settings.language == .german ? "Immer up-to-date" : "Always up-to-date")
                                    .font(.system(size: geometry.size.height < 700 ? 28 : 36, weight: .bold, design: .rounded))
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)
                                    .opacity(animateContent ? 1 : 0)
                                    .offset(y: animateContent ? 0 : 20)
                                    .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
                                
                                Text(settings.language == .german ? 
                                     "Monatlich neue Inhalte für Ihren Erfolg" :
                                     "Monthly new content for your success")
                                    .font(.system(size: geometry.size.height < 700 ? 16 : 18, weight: .medium))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .opacity(animateContent ? 1 : 0)
                                    .offset(y: animateContent ? 0 : 20)
                                    .animation(.easeOut(duration: 0.8).delay(0.8), value: animateContent)
                            }
                        }
                        .padding(.horizontal, geometry.size.width < 400 ? 20 : 32)
                        .padding(.top, geometry.size.height < 700 ? 20 : 40)
                        
                        // Features List
                        VStack(spacing: geometry.size.height < 700 ? 16 : 20) {
                            let features = settings.language == .german ? updateFeatures : englishUpdateFeatures
                            ForEach(Array(features.enumerated()), id: \.offset) { index, feature in
                                MonthlyUpdateFeatureCard(
                                    title: feature.0,
                                    icon: feature.1,
                                    description: feature.2,
                                    color: feature.3,
                                    isAnimated: animateFeatures,
                                    animationDelay: Double(index) * 0.2,
                                    isCompact: geometry.size.height < 700
                                )
                            }
                        }
                        .padding(.horizontal, geometry.size.width < 400 ? 16 : 24)
                        
                        
                        Spacer(minLength: geometry.size.height < 700 ? 80 : 100)
                    }
                }
            }
        }
        .onAppear {
            animateContent = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                animateFeatures = true
            }
        }
        .fullScreenCover(isPresented: $showPaywall) {
            PurchaseView(isPresented: $showPaywall)
                .onDisappear {
                    // Complete onboarding after paywall is dismissed
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

// MARK: - Monthly Update Feature Card
struct MonthlyUpdateFeatureCard: View {
    let title: String
    let icon: String
    let description: String
    let color: Color
    let isAnimated: Bool
    let animationDelay: Double
    let isCompact: Bool
    
    var body: some View {
        HStack(spacing: isCompact ? 12 : 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: isCompact ? 50 : 60, height: isCompact ? 50 : 60)
                
                Image(systemName: icon)
                    .font(.system(size: isCompact ? 20 : 24, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: isCompact ? 4 : 6) {
                Text(title)
                    .font(.system(size: isCompact ? 16 : 18, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.system(size: isCompact ? 13 : 15, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(isCompact ? 2 : 3)
            }
            
            Spacer()
            
            // "New" Badge
            Text("NEW")
                .font(.system(size: isCompact ? 10 : 12, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, isCompact ? 6 : 8)
                .padding(.vertical, isCompact ? 2 : 4)
                .background(
                    RoundedRectangle(cornerRadius: isCompact ? 8 : 10)
                        .fill(color)
                )
        }
        .padding(isCompact ? 16 : 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(color.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: color.opacity(0.2), radius: 15, x: 0, y: 8)
        )
        .scaleEffect(isAnimated ? 1.0 : 0.8)
        .opacity(isAnimated ? 1 : 0)
        .offset(x: isAnimated ? 0 : 50)
        .animation(
            .spring(response: 0.8, dampingFraction: 0.8)
                .delay(animationDelay),
            value: isAnimated
        )
    }
} 
