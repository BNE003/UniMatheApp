import SwiftUI
import PostHog

struct ÜbungsklausurenView: View {
    @ObservedObject private var settings = SettingsModel.shared
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var selectedDifficulty: ExamDifficulty = .beginner
    @State private var animateCards = false
    
    let examTopics = [
        ExamTopic(
            title: "Analysis I",
            subtitle: "Grenzwerte, Ableitungen, Integrale",
            difficulty: .beginner,
            duration: 120,
            questions: 6,
            icon: "function",
            color: Color(red: 0.2, green: 0.5, blue: 0.9)
        ),
        ExamTopic(
            title: "Lineare Algebra",
            subtitle: "Eigenwerte, Diagonalisierung und lineare Räume",
            difficulty: .intermediate,
            duration: 90,
            questions: 5,
            icon: "grid",
            color: Color(red: 0.0, green: 0.7, blue: 0.4)
        ),
        ExamTopic(
            title: "Analysis II",
            subtitle: "Mehrdimensionale Analysis",
            difficulty: .advanced,
            duration: 150,
            questions: 18,
            icon: "cube",
            color: Color(red: 0.6, green: 0.3, blue: 0.8)
        ),
        ExamTopic(
            title: "Differentialgleichungen",
            subtitle: "Gewöhnliche und partielle DGL",
            difficulty: .advanced,
            duration: 135,
            questions: 14,
            icon: "waveform.path",
            color: Color(red: 0.9, green: 0.4, blue: 0.1)
        ),
        ExamTopic(
            title: "Statistik",
            subtitle: "Wahrscheinlichkeitstheorie",
            difficulty: .intermediate,
            duration: 100,
            questions: 16,
            icon: "chart.bar.fill",
            color: Color(red: 0.8, green: 0.2, blue: 0.4)
        ),
        ExamTopic(
            title: "Numerische Mathematik",
            subtitle: "Algorithmen und Approximation",
            difficulty: .advanced,
            duration: 120,
            questions: 13,
            icon: "function",
            color: Color(red: 0.0, green: 0.6, blue: 0.7)
        )
    ]
    
    var filteredExams: [ExamTopic] {
        examTopics.filter { $0.difficulty == selectedDifficulty }
    }
    
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
                            Text(settings.language == .english ? "Practice" : "Übungs-")
                                .font(.custom("SF Pro Display", size: horizontalSizeClass == .regular ? 54 : 42))
                                .fontWeight(.black)
                                .foregroundColor(.blue)
                                .overlay(
                                    Text(settings.language == .english ? "Practice" : "Übungs-")
                                        .font(.custom("SF Pro Display", size: horizontalSizeClass == .regular ? 54 : 42))
                                        .fontWeight(.black)
                                        .foregroundColor(.blue)
                                        .opacity(0.3)
                                        .offset(x: 0.5, y: 0.5)
                                )
                                .shadow(color: Color.blue.opacity(0.15), radius: 4, x: 0, y: 2)
                            
                            Text(settings.language == .english ? "Exams" : "klausuren")
                                .font(.custom("SF Pro Display", size: horizontalSizeClass == .regular ? 54 : 42))
                                .fontWeight(.black)
                                .foregroundColor(.blue)
                                .overlay(
                                    Text(settings.language == .english ? "Exams" : "klausuren")
                                        .font(.custom("SF Pro Display", size: horizontalSizeClass == .regular ? 54 : 42))
                                        .fontWeight(.black)
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
                        
                        // Refined Difficulty Selector
                        DifficultySelector(selectedDifficulty: $selectedDifficulty)
                            .padding(.horizontal, 24)
                        
                        // Elegant Exam Cards
                        LazyVGrid(
                            columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: horizontalSizeClass == .regular ? 2 : 1),
                            spacing: 24
                        ) {
                            ForEach(Array(filteredExams.enumerated()), id: \.element.id) { index, exam in
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
            PostHogSDK.shared.capture("exams_view_appeared", properties: [
                "language": settings.language.rawValue
            ])
            withAnimation {
                animateCards = true
            }
        }
    }
}

// MARK: - Supporting Views

struct DifficultySelector: View {
    @Binding var selectedDifficulty: ExamDifficulty
    @ObservedObject private var settings = SettingsModel.shared
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(ExamDifficulty.allCases, id: \.self) { difficulty in
                Button(action: {
                    PostHogSDK.shared.capture("exam_difficulty_selected", properties: [
                        "difficulty": difficulty.rawValue,
                        "language": settings.language.rawValue
                    ])
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        selectedDifficulty = difficulty
                    }
                }) {
                    DifficultyButtonContent(
                        difficulty: difficulty,
                        isSelected: selectedDifficulty == difficulty
                    )
                }
            }
        }
    }
}

struct DifficultyButtonContent: View {
    let difficulty: ExamDifficulty
    let isSelected: Bool
    @ObservedObject private var settings = SettingsModel.shared
    
    var body: some View {
        Text(difficulty.localizedName(language: settings.language))
            .font(.custom("SF Pro Display", size: 13))
            .fontWeight(.semibold)
            .foregroundColor(isSelected ? .white : .secondary)
            .padding(.horizontal, 18)
            .padding(.vertical, 8)
            .background(
                Group {
                    if isSelected {
                        LinearGradient(
                            gradient: Gradient(colors: difficulty.colors),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    } else {
                        Color.gray.opacity(0.12)
                    }
                }
            )
            .clipShape(Capsule())
            .shadow(
                color: isSelected ? difficulty.colors.first!.opacity(0.3) : .clear,
                radius: isSelected ? 6 : 0,
                x: 0,
                y: 3
            )
    }
}

struct ExamCard: View {
    let exam: ExamTopic
    @ObservedObject private var settings = SettingsModel.shared
    @State private var isPressed = false
    
    var body: some View {
        Group {
            if exam.title == "Analysis I" {
                NavigationLink(destination: 
                    ExamDetailView(examFilename: settings.language == .english ? "analysis_1_beginner" : "analysis_1_anfaenger")
                        .navigationBarTitleDisplayMode(.inline)
                ) {
                    examCardContent
                }
                .buttonStyle(PlainButtonStyle())
                .simultaneousGesture(TapGesture().onEnded {
                    PostHogSDK.shared.capture("exam_started", properties: [
                        "exam_title": exam.title,
                        "exam_difficulty": exam.difficulty.rawValue,
                        "exam_duration": exam.duration,
                        "exam_questions": exam.questions,
                        "language": settings.language.rawValue
                    ])
                    // Haptic feedback when tapping the exam card
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                })
            } else if exam.title == "Lineare Algebra" {
                NavigationLink(destination: 
                    ExamDetailView(examFilename: settings.language == .english ? "linear_algebra_intermediate" : "lineare_algebra_fortgeschritten")
                        .navigationBarTitleDisplayMode(.inline)
                ) {
                    examCardContent
                }
                .buttonStyle(PlainButtonStyle())
                .simultaneousGesture(TapGesture().onEnded {
                    PostHogSDK.shared.capture("exam_started", properties: [
                        "exam_title": exam.title,
                        "exam_difficulty": exam.difficulty.rawValue,
                        "exam_duration": exam.duration,
                        "exam_questions": exam.questions,
                        "language": settings.language.rawValue
                    ])
                    // Haptic feedback when tapping the exam card
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                })
			} else if exam.title == "Analysis II" {
				NavigationLink(destination:
					ExamDetailView(examFilename: settings.language == .english ? "analysis_2_advanced" : "analysis_2_experte")
						.navigationBarTitleDisplayMode(.inline)
				) {
					examCardContent
				}
				.buttonStyle(PlainButtonStyle())
				.simultaneousGesture(TapGesture().onEnded {
					PostHogSDK.shared.capture("exam_started", properties: [
						"exam_title": exam.title,
						"exam_difficulty": exam.difficulty.rawValue,
						"exam_duration": exam.duration,
						"exam_questions": exam.questions,
						"language": settings.language.rawValue
					])
					let impactFeedback = UIImpactFeedbackGenerator(style: .light)
					impactFeedback.impactOccurred()
				})
			} else if exam.title == "Differentialgleichungen" {
				NavigationLink(destination:
					ExamDetailView(examFilename: settings.language == .english ? "differential_equations_advanced" : "differentialgleichungen_experte")
						.navigationBarTitleDisplayMode(.inline)
				) {
					examCardContent
				}
				.buttonStyle(PlainButtonStyle())
				.simultaneousGesture(TapGesture().onEnded {
					PostHogSDK.shared.capture("exam_started", properties: [
						"exam_title": exam.title,
						"exam_difficulty": exam.difficulty.rawValue,
						"exam_duration": exam.duration,
						"exam_questions": exam.questions,
						"language": settings.language.rawValue
					])
					let impactFeedback = UIImpactFeedbackGenerator(style: .light)
					impactFeedback.impactOccurred()
				})
			} else if exam.title == "Statistik" {
				NavigationLink(destination:
					ExamDetailView(examFilename: settings.language == .english ? "statistics_intermediate" : "statistik_fortgeschritten")
						.navigationBarTitleDisplayMode(.inline)
				) {
					examCardContent
				}
				.buttonStyle(PlainButtonStyle())
				.simultaneousGesture(TapGesture().onEnded {
					PostHogSDK.shared.capture("exam_started", properties: [
						"exam_title": exam.title,
						"exam_difficulty": exam.difficulty.rawValue,
						"exam_duration": exam.duration,
						"exam_questions": exam.questions,
						"language": settings.language.rawValue
					])
					let impactFeedback = UIImpactFeedbackGenerator(style: .light)
					impactFeedback.impactOccurred()
				})
			} else if exam.title == "Numerische Mathematik" {
				NavigationLink(destination:
					ExamDetailView(examFilename: settings.language == .english ? "numerical_mathematics_advanced" : "numerische_mathematik_experte")
						.navigationBarTitleDisplayMode(.inline)
				) {
					examCardContent
				}
				.buttonStyle(PlainButtonStyle())
				.simultaneousGesture(TapGesture().onEnded {
					PostHogSDK.shared.capture("exam_started", properties: [
						"exam_title": exam.title,
						"exam_difficulty": exam.difficulty.rawValue,
						"exam_duration": exam.duration,
						"exam_questions": exam.questions,
						"language": settings.language.rawValue
					])
					let impactFeedback = UIImpactFeedbackGenerator(style: .light)
					impactFeedback.impactOccurred()
				})
            } else {
                Button(action: {
                    // Action for starting exam
                    print("Starting exam: \(exam.title)")
                }) {
                    examCardContent
                }
            }
        }
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
                
                // Refined difficulty badge
                Text(exam.difficulty.localizedName(language: settings.language))
                    .font(.custom("SF Pro Display", size: 11))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: exam.difficulty.colors),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
            }
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 6) {
                Text(exam.title)
                    .font(.custom("SF Pro Display", size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(exam.subtitle)
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

// MARK: - Models are now in Models/Models.swift

#Preview {
    ÜbungsklausurenView()
} 