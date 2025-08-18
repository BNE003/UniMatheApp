import SwiftUI

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
                            color: isSelected ? color.opacity(0.3) : Color.black.opacity(0.1),
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
                    color: isPressed ? color.opacity(0.2) : Color.black.opacity(0.05),
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
                        .fill(index <= currentStep ? Color.blue : Color.gray.opacity(0.3))
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
                            .fill(Color.white)
                            .frame(width: isCompact ? 40 : 50, height: isCompact ? 40 : 50)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        
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
                    .foregroundColor(.black)
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
                            .fill(Color.gray.opacity(0.1))
                    )
                    .padding(.horizontal, isCompact ? 14 : 18)
                    .padding(.top, isCompact ? 8 : 10)
                    .padding(.bottom, isCompact ? 12 : 16)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
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

// MARK: - Supporting Views

struct AnimatedBackground: View {
    @State private var animateBackground = false
    
    var body: some View {
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
                    .fill(isActive ? Color.orange : Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                
                if isActive {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                } else {
                    Text("\(index + 1)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.gray)
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
                    color: isSelected ? color.opacity(0.3) : Color.black.opacity(0.1),
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

