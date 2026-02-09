import SwiftUI

struct ÜbungsklausurenView: View {
    @ObservedObject private var settings = SettingsModel.shared
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var animateCards = false
    
    let examTopics = [
        ExamTopic(
            title: "Analysis I",
            titleEnglish: "Calculus I",
            subtitle: "Grenzwerte, Ableitungen, Integrale",
            subtitleEnglish: "Limits, Derivatives, Integrals",
            duration: 120,
            questions: 6,
            icon: "function",
            color: Color(red: 0.2, green: 0.5, blue: 0.9),
            examFilename: "analysis_1_anfaenger"
        ),
        ExamTopic(
            title: "Lineare Algebra I",
            titleEnglish: "Linear Algebra I",
            subtitle: "Grundlagen der linearen Algebra",
            subtitleEnglish: "Fundamentals of Linear Algebra",
            duration: 120,
            questions: 6,
            icon: "grid",
            color: Color(red: 0.0, green: 0.7, blue: 0.4),
            examFilename: "lineare_algebra_1_anfaenger"
        ),
        ExamTopic(
            title: "Mathematik I",
            titleEnglish: "Mathematics I",
            subtitle: "Lineare Algebra und abstrakte Algebra",
            subtitleEnglish: "Linear Algebra and Abstract Algebra",
            duration: 120,
            questions: 8,
            icon: "number.circle",
            color: Color(red: 0.8, green: 0.3, blue: 0.6),
            examFilename: "mathematik_1_anfaenger"
        ),
        ExamTopic(
            title: "Mathematik I",
            titleEnglish: "Mathematics I",
            subtitle: "Klausur A: Lineare Algebra & Algebra-Grundlagen",
            subtitleEnglish: "Exam A: Linear Algebra & Algebra Basics",
            duration: 120,
            questions: 6,
            icon: "number.circle",
            color: Color(red: 0.8, green: 0.3, blue: 0.6),
            examFilename: "mathematik_1_klausur_1"
        ),
        ExamTopic(
            title: "Statistik I",
            titleEnglish: "Statistics I",
            subtitle: "Grundlagen der Wahrscheinlichkeitsrechnung",
            subtitleEnglish: "Fundamentals of Probability Theory",
            duration: 120,
            questions: 6,
            icon: "chart.bar.fill",
            color: Color(red: 0.8, green: 0.2, blue: 0.4),
            examFilename: "statistik_anfaenger"
        ),
        ExamTopic(
            title: "Mathematik I",
            titleEnglish: "Mathematics I",
            subtitle: "Erweiterte lineare und abstrakte Algebra",
            subtitleEnglish: "Advanced Linear and Abstract Algebra",
            duration: 90,
            questions: 10,
            icon: "number.circle",
            color: Color(red: 0.8, green: 0.3, blue: 0.6),
            examFilename: "mathematik_1_fortgeschritten"
        ),
        ExamTopic(
            title: "Mathematik I",
            titleEnglish: "Mathematics I",
            subtitle: "Klausur B: Algebra, Induktion, Lineare Algebra",
            subtitleEnglish: "Exam B: Algebra, Induction, Linear Algebra",
            duration: 120,
            questions: 6,
            icon: "number.circle",
            color: Color(red: 0.8, green: 0.3, blue: 0.6),
            examFilename: "mathematik_1_klausur_2"
        ),
        ExamTopic(
            title: "Lineare Algebra I",
            titleEnglish: "Linear Algebra I",
            subtitle: "Eigenwerte, Diagonalisierung und lineare Räume",
            subtitleEnglish: "Eigenvalues, Diagonalization and Linear Spaces",
            duration: 90,
            questions: 10,
            icon: "grid",
            color: Color(red: 0.0, green: 0.7, blue: 0.4),
            examFilename: "lineare_algebra_fortgeschritten"
        ),
        ExamTopic(
            title: "Mathematik I",
            titleEnglish: "Mathematics I",
            subtitle: "Fortgeschrittene abstrakte und lineare Algebra",
            subtitleEnglish: "Advanced Abstract and Linear Algebra",
            duration: 90,
            questions: 10,
            icon: "number.circle",
            color: Color(red: 0.8, green: 0.3, blue: 0.6),
            examFilename: "mathematik_1_experte"
        ),
        ExamTopic(
            title: "Lineare Algebra I",
            titleEnglish: "Linear Algebra I",
            subtitle: "Fortgeschrittene Theorie und Anwendungen",
            subtitleEnglish: "Advanced Theory and Applications",
            duration: 90,
            questions: 10,
            icon: "grid",
            color: Color(red: 0.0, green: 0.7, blue: 0.4),
            examFilename: "lineare_algebra_experte"
        ),
        ExamTopic(
            title: "Analysis II",
            titleEnglish: "Calculus II",
            subtitle: "Mehrdimensionale Analysis",
            subtitleEnglish: "Multivariable Calculus",
            duration: 90,
            questions: 11,
            icon: "cube",
            color: Color(red: 0.6, green: 0.3, blue: 0.8),
            examFilename: "analysis_2_experte"
        ),
        ExamTopic(
            title: "Mathematik II",
            titleEnglish: "Mathematics II",
            subtitle: "Klausur A: Reihen, Taylor, Mehrdimensionale Analysis",
            subtitleEnglish: "Exam A: Series, Taylor, Multivariable Calculus",
            duration: 120,
            questions: 5,
            icon: "sum",
            color: Color(red: 0.3, green: 0.4, blue: 0.9),
            examFilename: "mathematik_2_klausur_1"
        ),
        ExamTopic(
            title: "Differentialgleichungen",
            titleEnglish: "Differential Equations",
            subtitle: "Gewöhnliche und partielle DGL",
            subtitleEnglish: "Ordinary and Partial Differential Equations",
            duration: 90,
            questions: 6,
            icon: "waveform.path",
            color: Color(red: 0.9, green: 0.4, blue: 0.1),
            examFilename: "differentialgleichungen_experte"
        ),
        ExamTopic(
            title: "Mathematik II",
            titleEnglish: "Mathematics II",
            subtitle: "Klausur B: Potenzreihen, Vektoranalysis, DGL",
            subtitleEnglish: "Exam B: Power Series, Vector Calculus, ODE",
            duration: 120,
            questions: 5,
            icon: "sum",
            color: Color(red: 0.3, green: 0.4, blue: 0.9),
            examFilename: "mathematik_2_klausur_2"
        ),
        ExamTopic(
            title: "Statistik I",
            titleEnglish: "Statistics I",
            subtitle: "Wahrscheinlichkeitstheorie",
            subtitleEnglish: "Probability Theory",
            duration: 90,
            questions: 6,
            icon: "chart.bar.fill",
            color: Color(red: 0.8, green: 0.2, blue: 0.4),
            examFilename: "statistik_fortgeschritten"
        ),
        ExamTopic(
            title: "Statistik I",
            titleEnglish: "Statistics I",
            subtitle: "Klausur B: Deskriptive Statistik & Tests",
            subtitleEnglish: "Exam B: Descriptive Statistics & Tests",
            duration: 90,
            questions: 5,
            icon: "chart.bar.fill",
            color: Color(red: 0.8, green: 0.2, blue: 0.4),
            examFilename: "statistik_klausur_2"
        ),
        ExamTopic(
            title: "Numerische Mathematik",
            titleEnglish: "Numerical Mathematics",
            subtitle: "Algorithmen und Approximation",
            subtitleEnglish: "Algorithms and Approximation",
            duration: 90,
            questions: 5,
            icon: "function",
            color: Color(red: 0.0, green: 0.6, blue: 0.7),
            examFilename: "numerische_mathematik_experte"
        ),
        ExamTopic(
            title: "Numerische Mathematik",
            titleEnglish: "Numerical Mathematics",
            subtitle: "Klausur B: Iterative Verfahren & ODE",
            subtitleEnglish: "Exam B: Iterative Methods & ODE",
            duration: 90,
            questions: 5,
            icon: "function",
            color: Color(red: 0.0, green: 0.6, blue: 0.7),
            examFilename: "numerische_mathematik_klausur_2"
        )
    ]
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Elegant gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.98, green: 0.99, blue: 1.0),
                        Color(red: 0.94, green: 0.97, blue: 0.99),
                        Color(red: 0.96, green: 0.98, blue: 1.0)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Subtle decorative elements
                GeometryReader { geometry in
                    ZStack {
                        // Refined decorative circle
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color.blue.opacity(0.06),
                                        Color.purple.opacity(0.03),
                                        Color.clear
                                    ]),
                                    center: .center,
                                    startRadius: 80,
                                    endRadius: 220
                                )
                            )
                            .frame(width: geometry.size.width * 0.7)
                            .offset(x: -geometry.size.width * 0.25, y: -geometry.size.height * 0.15)
                        
                        // Secondary subtle element
                        RoundedRectangle(cornerRadius: 80)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.pink.opacity(0.04),
                                        Color.orange.opacity(0.02)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.3)
                            .offset(x: geometry.size.width * 0.35, y: geometry.size.height * 0.25)
                            .rotationEffect(.degrees(20))
                    }
                }
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        // Elegant Header Section
                        VStack(alignment: .leading, spacing: 0) {
                            Text(settings.language == .english ? "Exams" : "Klausuren")
                                .font(.custom("Nexa Bold", size: horizontalSizeClass == .regular ? 54 : 42))
                                .foregroundColor(.blue)
                                .overlay(
                                    Text(settings.language == .english ? "Exams" : "Klausuren")
                                        .font(.custom("Nexa Bold", size: horizontalSizeClass == .regular ? 54 : 42))
                                        .foregroundColor(.blue)
                                        .opacity(0.3)
                                        .offset(x: 0.5, y: 0.5)
                                )
                                .shadow(color: Color.blue.opacity(0.15), radius: 4, x: 0, y: 2)
                                .padding(.bottom, 8)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                        
                        
                        // Elegant Exam Cards
                        LazyVGrid(
                            columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: horizontalSizeClass == .regular ? 2 : 1),
                            spacing: 24
                        ) {
                            ForEach(Array(examTopics.enumerated()), id: \.element.id) { index, exam in
                                ExamCard(exam: exam)
                                    .scaleEffect(animateCards ? 1.0 : 0.9)
                                    .opacity(animateCards ? 1.0 : 0.0)
                                    .animation(
                                        .spring(response: 0.7, dampingFraction: 0.8)
                                        .delay(Double(index) * 0.08),
                                        value: animateCards
                                    )
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // Bottom spacing for tab bar
                        Spacer(minLength: 120)
                    }
                }
            }
        }
        .onAppear {
            withAnimation {
                animateCards = true
            }
        }
    }
}

// MARK: - Supporting Views


struct ExamCard: View {
    let exam: ExamTopic
    @ObservedObject private var settings = SettingsModel.shared
    @State private var isPressed = false
    
    var body: some View {
        NavigationLink(destination: 
            ExamDetailView(examFilename: settings.language == .english ? convertToEnglishFilename(exam.examFilename) : exam.examFilename)
                .navigationBarTitleDisplayMode(.inline)
        ) {
            examCardContent
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(TapGesture().onEnded {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        })
    }
    
    private var examCardContent: some View {
        VStack(alignment: .leading, spacing: 18) {
            // Header with icon and difficulty
            HStack {
                // Elegant icon background
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    exam.color.opacity(0.15),
                                    exam.color.opacity(0.08)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: exam.icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(exam.color)
                }
                
                Spacer()
                
            }
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 6) {
                Text(exam.localizedTitle(language: settings.language))
                    .font(.custom("SF Pro Display", size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(exam.localizedSubtitle(language: settings.language))
                    .font(.custom("SF Pro Display", size: 13))
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            // Elegant stats
            HStack(spacing: 24) {
                StatItem(icon: "clock.fill", value: "\(exam.duration) min", color: exam.color)
                StatItem(icon: "questionmark.circle.fill", value: "\(exam.questions)", color: exam.color)
            }
            
            // Refined start button
            HStack {
                Spacer()
                HStack(spacing: 6) {
                    Text(settings.language == .english ? "Start Exam" : "Klausur starten")
                        .font(.custom("SF Pro Display", size: 13))
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(exam.color)
            }
        }
        .padding(22)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.95),
                            Color.white.opacity(0.85)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: exam.color.opacity(0.15), radius: 12, x: 0, y: 6)
                .shadow(color: Color.black.opacity(0.04), radius: 3, x: 0, y: 1)
        )
        .scaleEffect(isPressed ? 0.97 : 1.0)
    }
}

struct StatItem: View {
    let icon: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(color)
            
            Text(value)
                .font(.custom("SF Pro Display", size: 11))
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Models

struct ExamTopic: Identifiable {
    let id = UUID()
    let title: String
    let titleEnglish: String
    let subtitle: String
    let subtitleEnglish: String
    let duration: Int // in minutes
    let questions: Int
    let icon: String
    let color: Color
    let examFilename: String
    
    func localizedTitle(language: AppLanguage) -> String {
        return language == .english ? titleEnglish : title
    }
    
    func localizedSubtitle(language: AppLanguage) -> String {
        return language == .english ? subtitleEnglish : subtitle
    }
}

// Helper function to convert German filename to English
private func convertToEnglishFilename(_ germanFilename: String) -> String {
    switch germanFilename {
    case "analysis_1_anfaenger":
        return "analysis_1_beginner"
    case "lineare_algebra_1_anfaenger":
        return "linear_algebra_1_beginner"
    case "mathematik_1_anfaenger":
        return "mathematics_1_beginner"
    case "mathematik_1_klausur_1":
        return "mathematics_1_exam_1"
    case "statistik_anfaenger":
        return "statistics_beginner"
    case "mathematik_1_fortgeschritten":
        return "mathematics_1_intermediate"
    case "mathematik_1_klausur_2":
        return "mathematics_1_exam_2"
    case "lineare_algebra_fortgeschritten":
        return "linear_algebra_intermediate"
    case "mathematik_1_experte":
        return "mathematics_1_advanced"
    case "lineare_algebra_experte":
        return "linear_algebra_advanced"
    case "analysis_2_experte":
        return "analysis_2_advanced"
    case "mathematik_2_klausur_1":
        return "mathematics_2_exam_1"
    case "differentialgleichungen_experte":
        return "differential_equations_advanced"
    case "mathematik_2_klausur_2":
        return "mathematics_2_exam_2"
    case "statistik_fortgeschritten":
        return "statistics_intermediate"
    case "statistik_klausur_2":
        return "statistics_exam_2"
    case "numerische_mathematik_experte":
        return "numerical_mathematics_advanced"
    case "numerische_mathematik_klausur_2":
        return "numerical_mathematics_exam_2"
    default:
        return germanFilename // fallback to original
    }
}

#Preview {
    ÜbungsklausurenView()
} 
