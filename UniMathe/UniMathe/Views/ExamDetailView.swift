import SwiftUI

struct ExamDetailView: View {
    let examFilename: String
    @State private var exam: Exam?
    @State private var isLoading = true
    @State private var timeRemaining: Int = 0
    @State private var timer: Timer?
    @State private var isTimerRunning = false
    @State private var examStarted = false
    @State private var showEndExamAlert = false
    @State private var titleHeights: [CGFloat] = []
    @State private var exerciseHeights: [CGFloat] = []
    @State private var showSolutions: [Bool] = []
    @State private var currentSteps: [Int] = []
    // Dynamic heights for solution steps to auto-fit content without inner scrolling
    @State private var solutionHeights: [String: CGFloat] = [:]
    @State private var showPaywall = false
    @ObservedObject private var settings = SettingsModel.shared
    @ObservedObject private var storeManager = StoreKitManager.shared
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var tabBarManager = TabBarManager.shared
    
    var body: some View {
        ZStack {
            // Modern gradient background with subtle patterns
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.appBackground,
                    Color.appBackgroundSecondary,
                    Color.appBackground
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Subtle decorative elements for modern look
            GeometryReader { geometry in
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    Color.appAccentBlue.opacity(0.04),
                                    Color.purple.opacity(0.02),
                                    Color.clear
                                ]),
                                center: .center,
                                startRadius: 80,
                                endRadius: 200
                            )
                        )
                        .frame(width: geometry.size.width * 0.6)
                        .offset(x: -geometry.size.width * 0.2, y: -geometry.size.height * 0.1)
                    
                    RoundedRectangle(cornerRadius: 60)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.orange.opacity(0.03),
                                    Color.pink.opacity(0.02)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.25)
                        .offset(x: geometry.size.width * 0.4, y: geometry.size.height * 0.3)
                        .rotationEffect(.degrees(15))
                }
            }
            
            if isLoading {
                ProgressView(settings.language == .english ? "Loading exam..." : "Klausur wird geladen...")
                    .font(.headline)
            } else if let currentExam = exam {
                examContent(exam: currentExam)
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 48))
                        .foregroundColor(.orange)
                    
                    Text(settings.language == .english ? "Exam not found" : "Klausur nicht gefunden")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Button(settings.language == .english ? "Go back" : "Zurück") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .onAppear {
            print("🔥 EXAM DETAIL: ExamDetailView appeared with filename: \(examFilename)")
            tabBarManager.hide()
            loadExam()
        }
        .onDisappear {
            tabBarManager.show()
        }
        .navigationBarBackButtonHidden(examStarted)
        .toolbar {
            if examStarted {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        if isTimerRunning {
                            showEndExamAlert = true
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text(settings.language == .english ? "Back" : "Zurück")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(.appAccentBlue)
                    }
                }
            }
        }
        .alert(settings.language == .english ? "Exam in Progress" : "Klausur läuft", isPresented: $showEndExamAlert) {
            Button(settings.language == .english ? "End Exam" : "Klausur beenden") {
                endExam()
            }
            Button(settings.language == .english ? "Continue" : "Fortfahren") {
                showEndExamAlert = false
            }
        } message: {
            Text(settings.language == .english ? 
                 "Are you sure you want to end the exam?" : 
                 "Sind Sie sicher, dass Sie die Klausur beenden möchten?")
        }
        .fullScreenCover(isPresented: $showPaywall) {
            PurchaseView(isPresented: $showPaywall)
        }
    }
    
    @ViewBuilder
    private func examContent(exam: Exam) -> some View {
        VStack(spacing: 0) {
            if !examStarted {
                examIntroView(exam: exam)
            } else {
                modernExamPaperView(exam: exam)
            }
        }
    }
    
    @ViewBuilder
    private func examIntroView(exam: Exam) -> some View {
        ScrollView {
            VStack(spacing: 32) {
                // Exam Title Section
                VStack(alignment: .leading, spacing: 16) {
                    Text(exam.exam.title)
                        .font(.custom("SF Pro Display", size: horizontalSizeClass == .regular ? 42 : 34))
                        .fontWeight(.black)
                        .foregroundColor(colorScheme == .dark ? .white : .appAccentBlue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(exam.exam.subtitle)
                        .font(.custom("SF Pro Display", size: horizontalSizeClass == .regular ? 20 : 18))
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                // Exam Info Cards
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    examInfoCard(
                        icon: "clock",
                        title: settings.language == .english ? "Duration" : "Dauer",
                        value: "\(exam.exam.duration) min",
                        color: .blue
                    )
                    
                    examInfoCard(
                        icon: "star.fill",
                        title: settings.language == .english ? "Points" : "Punkte",
                        value: "\(exam.exam.totalPoints)",
                        color: .orange
                    )
                    
                    examInfoCard(
                        icon: "doc.text",
                        title: settings.language == .english ? "Questions" : "Aufgaben",
                        value: "\(exam.exercises.count)",
                        color: .green
                    )
                    
                }
                .padding(.horizontal, 24)
                
                // Grading Table
                gradingTable(totalPoints: exam.exam.totalPoints)
                    .padding(.horizontal, 24)
                
                // Instructions
                VStack(alignment: .leading, spacing: 12) {
                    Text(settings.language == .english ? "Instructions" : "Anweisungen")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(exam.exam.instructions)
                        .font(.body)
                        .lineSpacing(4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.appSurface)
                        .shadow(color: Color.appShadow.opacity(0.5), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal, 24)
                
                // Start Button
                Button(action: {
                    // Check if user has premium access
                    if storeManager.purchasedProductIDs.isEmpty {
                        showPaywall = true
                    } else {
                        startExam()
                    }
                }) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text(settings.language == .english ? "Start Exam" : "Klausur starten")
                    }
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: Color.appAccentBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }
    
    @ViewBuilder
    private func examInfoCard(icon: String, title: String, value: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appSurface)
                .shadow(color: Color.appShadow.opacity(0.5), radius: 5, x: 0, y: 2)
        )
    }
    
    @ViewBuilder
    private func gradingTable(totalPoints: Int) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(settings.language == .english ? "Grading Scale" : "Bewertungstabelle")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text(settings.language == .english ? "Grade" : "Note")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(settings.language == .english ? "Points" : "Punkte")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text(settings.language == .english ? "Percentage" : "Prozent")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(Color.appAccentBlue.opacity(0.1))
                
                // Grading rows
                ForEach(Array(getGradingScale(totalPoints: totalPoints).enumerated()), id: \.offset) { index, gradeInfo in
                    HStack {
                        Text(gradeInfo.grade)
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(gradeInfo.isPassing ? .primary : .red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(gradeInfo.pointRange)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text(gradeInfo.percentageRange)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .background(index % 2 == 0 ? Color.secondary.opacity(0.05) : Color.clear)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.appSurface)
                    .shadow(color: Color.appShadow.opacity(0.5), radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
            )
            
            // Passing note
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.appAccentBlue)
                Text(settings.language == .english ? "Minimum 50% required to pass" : "Mindestens 50% zum Bestehen erforderlich")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.appSurface)
                .shadow(color: Color.appShadow.opacity(0.5), radius: 10, x: 0, y: 5)
        )
    }
    
    @ViewBuilder
    private func modernExamPaperView(exam: Exam) -> some View {
        VStack(spacing: 0) {
            // Modern Exam Header
            modernExamHeader(exam: exam)
            
            // Main Exam Content - Optimized for smooth scrolling
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Exam Paper Title
                    VStack(alignment: .leading, spacing: 8) {
                        Text(exam.exam.title)
                            .font(.custom("SF Pro Display", size: horizontalSizeClass == .regular ? 32 : 28))
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                        
                        Text(exam.exam.subtitle)
                            .font(.custom("SF Pro Display", size: horizontalSizeClass == .regular ? 18 : 16))
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Divider()
                            .background(Color.appAccentBlue.opacity(0.3))
                            .padding(.vertical, 8)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    // All Exercises - Optimized VStack
                    VStack(spacing: 20) {
                        ForEach(Array(exam.exercises.enumerated()), id: \.element.id) { index, exercise in
                            optimizedExerciseCard(
                                exercise: exercise,
                                exerciseNumber: index + 1,
                                exerciseIndex: index
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Finish Exam Button
                    modernFinishButton()
                        .padding(.horizontal, 24)
                        .padding(.top, 32)
                    
                    Spacer(minLength: 120)
                }
                .padding(.vertical)
            }
        }
    }
    
    @ViewBuilder
    private func modernExamHeader(exam: Exam) -> some View {
        VStack(spacing: 16) {
            HStack {
                // Timer
                HStack(spacing: 8) {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.appAccentBlue)
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text(formatTime(timeRemaining))
                        .font(.custom("SF Pro Display", size: 18))
                        .fontWeight(.bold)
                        .monospacedDigit()
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .shadow(color: Color.appShadow.opacity(0.8), radius: 10, x: 0, y: 5)
                )
                
                Spacer()
                
                // Points Info
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text("\(exam.exam.totalPoints) \(settings.language == .english ? "pts" : "Pkt")")
                        .font(.custom("SF Pro Display", size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .shadow(color: Color.appShadow.opacity(0.8), radius: 10, x: 0, y: 5)
                )
            }
            .padding(.horizontal, 24)
        }
        .padding(.vertical, 16)
        .background(.ultraThinMaterial)
    }
    
    @ViewBuilder
    private func optimizedExerciseCard(exercise: ExamExercise, exerciseNumber: Int, exerciseIndex: Int) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Exercise Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(settings.language == .english ? "Question" : "Aufgabe") \(exerciseNumber)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 12) {
                        Text(exercise.topic)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.appAccentBlue)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.appAccentBlue.opacity(0.1))
                            .clipShape(Capsule())
                        
                        Spacer()
                        
                        Text("\(exercise.points) \(settings.language == .english ? "pts" : "Pkt")")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.orange.opacity(0.1))
                            .clipShape(Capsule())
                    }
                }
            }
            
            Divider()
            
            // Exercise Content
            VStack(alignment: .leading, spacing: 8) {
                LaTeXView(
                    content: "<span style='font-size:1.05em;font-weight:600;'>" + addHtmlLineBreaks(exercise.title) + "</span>",
                    height: Binding<CGFloat>(
                        get: {
                            if titleHeights.indices.contains(exerciseIndex) && titleHeights[exerciseIndex] > 0 {
                                return titleHeights[exerciseIndex]
                            } else {
                                return estimateTitleHeight(for: exercise.title)
                            }
                        },
                        set: { newHeight in
                            if titleHeights.indices.contains(exerciseIndex) {
                                titleHeights[exerciseIndex] = newHeight
                            } else {
                                while titleHeights.count <= exerciseIndex { titleHeights.append(0) }
                                titleHeights[exerciseIndex] = newHeight
                            }
                        }
                    )
                )
                .frame(height: {
                    if titleHeights.indices.contains(exerciseIndex) && titleHeights[exerciseIndex] > 0 {
                        return titleHeights[exerciseIndex]
                    } else {
                        return estimateTitleHeight(for: exercise.title)
                    }
                }())
                
                // LaTeX with adaptive height based on content length
                LaTeXView(
                    content: addHtmlLineBreaks(exercise.description),
                    height: Binding<CGFloat>(
                        get: {
                            if exerciseHeights.indices.contains(exerciseIndex) && exerciseHeights[exerciseIndex] > 0 {
                                return exerciseHeights[exerciseIndex]
                            } else {
                                return estimateContentHeight(for: exercise.description)
                            }
                        },
                        set: { newHeight in
                            if exerciseHeights.indices.contains(exerciseIndex) {
                                exerciseHeights[exerciseIndex] = newHeight
                            } else {
                                while exerciseHeights.count <= exerciseIndex { exerciseHeights.append(0) }
                                exerciseHeights[exerciseIndex] = newHeight
                            }
                        }
                    )
                )
                .frame(height: {
                    if exerciseHeights.indices.contains(exerciseIndex) && exerciseHeights[exerciseIndex] > 0 {
                        return exerciseHeights[exerciseIndex]
                    } else {
                        return estimateContentHeight(for: exercise.description)
                    }
                }())
            }
            
            // Solution Button
            optimizedSolutionButton(exerciseIndex: exerciseIndex)
            
            // Solution Section
            if showSolutions.indices.contains(exerciseIndex) && showSolutions[exerciseIndex] {
                optimizedSolutionSection(exercise: exercise, exerciseIndex: exerciseIndex)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.appSurface)
                .shadow(color: Color.appShadow.opacity(0.5), radius: 8, x: 0, y: 4)
        )
    }
    
    @ViewBuilder
    private func optimizedSolutionButton(exerciseIndex: Int) -> some View {
        Button(action: {
            if storeManager.purchasedProductIDs.isEmpty {
                showPaywall = true
                return
            }
            // Ensure arrays are properly sized
            while showSolutions.count <= exerciseIndex {
                showSolutions.append(false)
            }
            while currentSteps.count <= exerciseIndex {
                currentSteps.append(0)
            }
            
            showSolutions[exerciseIndex].toggle()
            
            if showSolutions[exerciseIndex] {
                currentSteps[exerciseIndex] = 0
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: showSolutions.indices.contains(exerciseIndex) && showSolutions[exerciseIndex] ? "eye.slash.fill" : "lightbulb.fill")
                    .font(.system(size: 14, weight: .semibold))
                
                Text(showSolutions.indices.contains(exerciseIndex) && showSolutions[exerciseIndex] ? 
                     (settings.language == .english ? "Hide Solution" : "Lösung ausblenden") :
                     (settings.language == .english ? "Show Solution" : "Lösung anzeigen"))
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.orange)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    @ViewBuilder
    private func optimizedSolutionSection(exercise: ExamExercise, exerciseIndex: Int) -> some View {
        VStack(spacing: 12) {
            // Solution Header
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 16, weight: .semibold))
                
                Text(settings.language == .english ? "Solution" : "Lösung")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
                Spacer()
            }
            
            // Solution Steps
            let currentStepCount = currentSteps.indices.contains(exerciseIndex) ? currentSteps[exerciseIndex] : 0
            
            ForEach(0..<min(currentStepCount + 1, exercise.solutionSteps.count), id: \.self) { stepIndex in
                optimizedSolutionStep(
                    stepContent: exercise.solutionSteps[stepIndex],
                    stepNumber: stepIndex + 1,
                    exerciseIndex: exerciseIndex
                )
            }
            
            // Next Step Button
            if currentStepCount < exercise.solutionSteps.count - 1 {
                Button(action: {
                    if currentSteps.indices.contains(exerciseIndex) {
                        currentSteps[exerciseIndex] += 1
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 14, weight: .semibold))
                        
                        Text(settings.language == .english ? "Next Step" : "Nächster Schritt")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appSurfaceStrong)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.green.opacity(0.28), lineWidth: 1)
                )
        )
    }
    
    @ViewBuilder
    private func optimizedSolutionStep(stepContent: String, stepNumber: Int, exerciseIndex: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(settings.language == .english ? "Step" : "Schritt") \(stepNumber)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
                Spacer()
                
                Circle()
                    .fill(Color.green)
                    .frame(width: 6, height: 6)
            }
            
            // LaTeX with adaptive height based on content length
            LaTeXView(
                content: addHtmlLineBreaks(stepContent),
                height: Binding<CGFloat>(
                    get: {
                        let key = "\(stepNumberKey(exerciseIndex: exerciseIndex, stepIndex: stepNumber - 1))"
                        return solutionHeights[key] ?? estimateContentHeight(for: stepContent)
                    },
                    set: { newHeight in
                        let key = "\(stepNumberKey(exerciseIndex: exerciseIndex, stepIndex: stepNumber - 1))"
                        solutionHeights[key] = newHeight
                    }
                )
            )
            .frame(height: {
                let key = stepNumberKey(exerciseIndex: exerciseIndex, stepIndex: stepNumber - 1)
                return solutionHeights[key] ?? estimateContentHeight(for: stepContent)
            }())
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.appSurface)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    @ViewBuilder
    private func modernFinishButton() -> some View {
        Button(action: endExam) {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20, weight: .semibold))
                
                Text(settings.language == .english ? "Finish Exam" : "Klausur beenden")
                    .font(.custom("SF Pro Display", size: 18))
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.red,
                        Color.red.opacity(0.8)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.red.opacity(0.3), radius: 12, x: 0, y: 6)
        }
    }
    
    // MARK: - Methods
    private func loadExam() {
        print("🔍 EXAM DETAIL: loadExam() called with filename: \(examFilename)")
        
        DispatchQueue.global(qos: .userInitiated).async {
            let loadedExam = ExamRepository.shared.loadExam(filename: examFilename, language: settings.language)
            
            DispatchQueue.main.async {
                if let exam = loadedExam {
                    print("✅ EXAM DETAIL: Successfully loaded exam: \(exam.exam.title)")
                    self.exam = exam
                    self.timeRemaining = exam.exam.duration * 60
                    
                    // Initialize arrays with estimated heights for better content fitting
                    self.titleHeights = exam.exercises.map { exercise in
                        self.estimateTitleHeight(for: exercise.title)
                    }
                    self.exerciseHeights = exam.exercises.map { exercise in
                        self.estimateContentHeight(for: exercise.description)
                    }
                    self.showSolutions = Array(repeating: false, count: exam.exercises.count)
                    self.currentSteps = Array(repeating: 0, count: exam.exercises.count)
                } else {
                    print("❌ EXAM DETAIL: Failed to load exam")
                    self.exam = nil
                }
                
                self.isLoading = false
            }
        }
    }
    
    private func startExam() {
        examStarted = true
        
        // Initialize arrays for performance
        if let currentExam = exam {
            showSolutions = Array(repeating: false, count: currentExam.exercises.count)
            currentSteps = Array(repeating: 0, count: currentExam.exercises.count)
            titleHeights = currentExam.exercises.map { exercise in
                estimateTitleHeight(for: exercise.title)
            }
            exerciseHeights = currentExam.exercises.map { exercise in
                estimateContentHeight(for: exercise.description)
            }
        }
        
        startTimer()
    }
    
    private func startTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                endExam()
            }
        }
    }
    
    private func endExam() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
        presentationMode.wrappedValue.dismiss()
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secs = seconds % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, secs)
        } else {
            return String(format: "%02d:%02d", minutes, secs)
        }
    }
    
    // MARK: - Content Height Estimation
    private func estimateTitleHeight(for content: String) -> CGFloat {
        let baseHeight: CGFloat = 26
        let characterCount = content.count
        let lineBreaks = content.components(separatedBy: "\n").count - 1
        let mathExpressions = content.components(separatedBy: "$").count / 2
        
        var estimatedHeight = baseHeight
        estimatedHeight += CGFloat(characterCount / 40) * 16
        estimatedHeight += CGFloat(lineBreaks) * 18
        estimatedHeight += CGFloat(mathExpressions) * 10
        
        let minHeight: CGFloat = 22
        let maxHeight: CGFloat = 90
        
        return max(minHeight, min(maxHeight, estimatedHeight))
    }

    private func estimateContentHeight(for content: String) -> CGFloat {
        // Base height for minimal content
        let baseHeight: CGFloat = 50
        
        // Estimate height based on content characteristics
        let characterCount = content.count
        let lineBreaks = content.components(separatedBy: "\n").count - 1
        let mathExpressions = content.components(separatedBy: "$").count / 2 // LaTeX math expressions
        
        // Calculate estimated height more conservatively
        var estimatedHeight = baseHeight
        
        // Add height based on character count (roughly 50 characters per line for better density)
        estimatedHeight += CGFloat(characterCount / 50) * 18
        
        // Add extra height for line breaks (reduced from 25 to 20)
        estimatedHeight += CGFloat(lineBreaks) * 20
        
        // Add extra height for math expressions (reduced from 15 to 12)
        estimatedHeight += CGFloat(mathExpressions) * 12
        
        // Set more conservative bounds - especially for solution steps
        let minHeight: CGFloat = 50
        let maxHeight: CGFloat = 200  // Reduced from 300 to 200
        
        return max(minHeight, min(maxHeight, estimatedHeight))
    }

    // Key builder for mapping dynamic heights of solution steps
    private func stepNumberKey(exerciseIndex: Int, stepIndex: Int) -> String {
        "ex\(exerciseIndex)_step\(stepIndex)"
    }
    
    // MARK: - Grading System
    private func getGradingScale(totalPoints: Int) -> [GradeInfo] {
        let grades = [
            (grade: "1,0", minPercent: 95, maxPercent: 100),
            (grade: "1,3", minPercent: 90, maxPercent: 94),
            (grade: "1,7", minPercent: 85, maxPercent: 89),
            (grade: "2,0", minPercent: 80, maxPercent: 84),
            (grade: "2,3", minPercent: 75, maxPercent: 79),
            (grade: "2,7", minPercent: 70, maxPercent: 74),
            (grade: "3,0", minPercent: 65, maxPercent: 69),
            (grade: "3,3", minPercent: 60, maxPercent: 64),
            (grade: "3,7", minPercent: 55, maxPercent: 59),
            (grade: "4,0", minPercent: 50, maxPercent: 54),
            (grade: "5,0", minPercent: 0, maxPercent: 49)
        ]
        
        return grades.map { grade in
            let minPoints = max(1, Int(ceil(Double(totalPoints) * Double(grade.minPercent) / 100.0)))
            let maxPoints = Int(ceil(Double(totalPoints) * Double(grade.maxPercent) / 100.0))
            
            let pointRange: String
            if grade.grade == "5,0" {
                pointRange = "0 - \(Int(floor(Double(totalPoints) * 0.49)))"
            } else if grade.grade == "1,0" {
                pointRange = "\(minPoints) - \(totalPoints)"
            } else {
                pointRange = "\(minPoints) - \(maxPoints)"
            }
            
            let percentageRange = "\(grade.minPercent) - \(grade.maxPercent)%"
            
            return GradeInfo(
                grade: grade.grade,
                pointRange: pointRange,
                percentageRange: percentageRange,
                isPassing: grade.grade != "5,0"
            )
        }
    }
}

struct GradeInfo {
    let grade: String
    let pointRange: String
    let percentageRange: String
    let isPassing: Bool
}

// Helper function for HTML line breaks
fileprivate func addHtmlLineBreaks(_ text: String) -> String {
    text.replacingOccurrences(of: "\n", with: "<br>")
}

#Preview {
    NavigationView {
        ExamDetailView(examFilename: "analysis_1_anfaenger")
    }
}
