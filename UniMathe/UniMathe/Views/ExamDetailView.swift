import SwiftUI

struct ExamDetailView: View {
    let examFilename: String
    @State private var exam: Exam?
    @State private var isLoading = true
    @State private var currentExercise = 0
    @State private var showSolution = false
    @State private var currentStep = 0
    @State private var timeRemaining: Int = 0
    @State private var timer: Timer?
    @State private var isTimerRunning = false
    @State private var examStarted = false
    @State private var showEndExamAlert = false
    @State private var exerciseHeights: [CGFloat] = []
    @State private var solutionHeights: [CGFloat] = []
    @State private var exerciseContentHeight: CGFloat = 100
    @State private var stepHeights: [CGFloat] = []
    @ObservedObject private var settings = SettingsModel.shared
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var tabBarViewModel: TabBarViewModel
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color(red: 0.98, green: 0.98, blue: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
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
            tabBarViewModel.hideTabBar()
            loadExam()
        }
        .onDisappear {
            tabBarViewModel.showTabBar()
        }
        .navigationBarBackButtonHidden(examStarted)
        .toolbar {
            if examStarted {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        if isTimerRunning {
                            // Show alert for exam in progress
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
                        .foregroundColor(.blue)
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
    }
    
    @ViewBuilder
    private func examContent(exam: Exam) -> some View {
        VStack(spacing: 0) {
            // Exam Header
            if !examStarted {
                examIntroView(exam: exam)
            } else {
                // Timer and Progress Header
                examProgressHeader(exam: exam)
                
                // Main Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Current Exercise
                        if currentExercise < exam.exercises.count {
                            exerciseCard(exercise: exam.exercises[currentExercise], exerciseNumber: currentExercise + 1)
                        }
                        
                        // Solution Section
                        if showSolution {
                            solutionSection(exercise: exam.exercises[currentExercise])
                        }
                        
                        // Navigation Buttons
                        navigationButtons(exam: exam)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.vertical)
                }
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
                        .foregroundColor(.blue)
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
                    
                    examInfoCard(
                        icon: "chart.bar",
                        title: settings.language == .english ? "Level" : "Niveau",
                        value: exam.exam.difficulty.capitalized,
                        color: .purple
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
                        .fill(.white)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal, 24)
                
                // Start Button
                Button(action: startExam) {
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
                    .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 24)
                
                // Back Button
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text(settings.language == .english ? "Back to Exams" : "Zurück zu Klausuren")
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 2)
                    )
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
                .fill(.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
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
                .background(Color.blue.opacity(0.1))
                
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
                    .background(index % 2 == 0 ? Color.gray.opacity(0.05) : Color.clear)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            
            // Passing note
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                Text(settings.language == .english ? "Minimum 50% required to pass" : "Mindestens 50% zum Bestehen erforderlich")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    @ViewBuilder
    private func examProgressHeader(exam: Exam) -> some View {
        VStack(spacing: 16) {
            // Timer and Progress
            HStack {
                // Timer
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.blue)
                    Text(formatTime(timeRemaining))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .monospacedDigit()
                }
                
                Spacer()
                
                // Exercise Progress
                Text("\(currentExercise + 1) / \(exam.exercises.count)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 24)
            
            // Progress Bar
            ProgressView(value: Double(currentExercise + 1), total: Double(exam.exercises.count))
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .padding(.horizontal, 24)
        }
        .padding(.vertical, 16)
        .background(.ultraThinMaterial)
    }
    
    @ViewBuilder
    private func exerciseCard(exercise: ExamExercise, exerciseNumber: Int) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Exercise Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(settings.language == .english ? "Question" : "Aufgabe") \(exerciseNumber)")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text(exercise.topic)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        
                        Spacer()
                        
                        Text("\(exercise.points) \(settings.language == .english ? "points" : "Punkte")")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)
                    }
                }
            }
            
            Divider()
            
            // Exercise Content
            LaTeXView(
                content: "<span style='font-size:1.1em;font-weight:bold;'>" + addHtmlLineBreaks(exercise.title) + "</span><br><br>" + addHtmlLineBreaks(exercise.description),
                height: $exerciseContentHeight
            )
            .frame(height: exerciseContentHeight)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 24)
    }
    
    @ViewBuilder
    private func solutionSection(exercise: ExamExercise) -> some View {
        VStack(spacing: 16) {
            ForEach(0..<min(currentStep + 1, exercise.solutionSteps.count), id: \.self) { step in
                solutionStepCard(stepContent: exercise.solutionSteps[step], stepNumber: step + 1, stepIndex: step)
            }
            
            if currentStep < exercise.solutionSteps.count - 1 {
                Button(action: {
                    withAnimation(.spring()) {
                        currentStep += 1
                        // Ensure we have enough heights for all steps
                        if currentStep >= stepHeights.count {
                            stepHeights.append(100)
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.right")
                        Text(settings.language == .english ? "Next Step" : "Nächster Schritt")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    @ViewBuilder
    private func solutionStepCard(stepContent: String, stepNumber: Int, stepIndex: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("\(settings.language == .english ? "Step" : "Schritt") \(stepNumber)")
                    .font(.headline)
                    .foregroundColor(.green)
                Spacer()
            }
            
            if stepIndex < stepHeights.count {
                LaTeXView(content: addHtmlLineBreaks(stepContent), height: $stepHeights[stepIndex])
                    .frame(height: stepHeights[stepIndex])
            } else {
                LaTeXView(content: addHtmlLineBreaks(stepContent), height: .constant(100))
                    .frame(height: 100)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.green.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal, 24)
    }
    
    @ViewBuilder
    private func navigationButtons(exam: Exam) -> some View {
        VStack(spacing: 16) {
            // Show Solution Button
            if !showSolution {
                Button(action: {
                    withAnimation {
                        showSolution = true
                        currentStep = 0
                        // Initialize step heights when showing solution
                        guard let currentExam = self.exam, currentExercise < currentExam.exercises.count else { return }
                        stepHeights = Array(repeating: 100, count: currentExam.exercises[currentExercise].solutionSteps.count)
                    }
                }) {
                    HStack {
                        Image(systemName: "lightbulb")
                        Text(settings.language == .english ? "Show Solution" : "Lösung anzeigen")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(12)
                }
            }
            
            // Navigation Buttons Row
            HStack(spacing: 16) {
                // Previous Exercise Button
                if currentExercise > 0 {
                    Button(action: previousExercise) {
                        HStack {
                            Image(systemName: "arrow.left")
                            Text(settings.language == .english ? "Previous Question" : "Vorherige Aufgabe")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                        .background(Color.gray)
                        .cornerRadius(12)
                    }
                }
                
                // Next Exercise Button or Finish Button
                if currentExercise < exam.exercises.count - 1 {
                    Button(action: nextExercise) {
                        HStack {
                            Text(settings.language == .english ? "Next Question" : "Nächste Aufgabe")
                            Image(systemName: "arrow.right")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                } else {
                    Button(action: endExam) {
                        HStack {
                            Image(systemName: "checkmark")
                            Text(settings.language == .english ? "Finish Exam" : "Klausur beenden")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                        .background(Color.red)
                        .cornerRadius(12)
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Methods
    private func loadExam() {
        print("🔍 EXAM DETAIL: loadExam() called with filename: \(examFilename)")
        print("🔍 EXAM DETAIL: Current language: \(settings.language)")
        print("🔍 EXAM DETAIL: Language raw value: \(settings.language.rawValue)")
        
        DispatchQueue.global(qos: .userInitiated).async {
            let loadedExam = ExamRepository.shared.loadExam(filename: examFilename, language: settings.language)
            
            DispatchQueue.main.async {
                print("🔍 EXAM DETAIL: Exam loading completed")
                
                if let exam = loadedExam {
                    print("✅ EXAM DETAIL: Successfully loaded exam: \(exam.exam.title)")
                    self.exam = exam
                    self.timeRemaining = exam.exam.duration * 60 // Convert to seconds
                    self.exerciseHeights = Array(repeating: 100, count: exam.exercises.count)
                    self.solutionHeights = Array(repeating: 100, count: exam.exercises.count)
                    // Initialize step heights for first exercise
                    if !exam.exercises.isEmpty {
                        self.stepHeights = Array(repeating: 100, count: exam.exercises[0].solutionSteps.count)
                    }
                } else {
                    print("❌ EXAM DETAIL: Failed to load exam - exam is nil")
                    self.exam = nil
                }
                
                self.isLoading = false
            }
        }
    }
    
    private func startExam() {
        examStarted = true
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
    
    private func nextExercise() {
        withAnimation {
            currentExercise += 1
            showSolution = false
            currentStep = 0
            
            // Update step heights for new exercise
            guard let currentExam = self.exam, currentExercise < currentExam.exercises.count else { return }
            stepHeights = Array(repeating: 100, count: currentExam.exercises[currentExercise].solutionSteps.count)
        }
    }
    
    private func previousExercise() {
        withAnimation {
            currentExercise -= 1
            showSolution = false
            currentStep = 0
            
            // Update step heights for new exercise
            guard let currentExam = self.exam, currentExercise >= 0 && currentExercise < currentExam.exercises.count else { return }
            stepHeights = Array(repeating: 100, count: currentExam.exercises[currentExercise].solutionSteps.count)
        }
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

// Hilfsfunktion, um Zeilenumbrüche in <br> umzuwandeln
fileprivate func addHtmlLineBreaks(_ text: String) -> String {
    text.replacingOccurrences(of: "\n", with: "<br>")
}

#Preview {
    NavigationView {
        ExamDetailView(examFilename: "analysis_1_anfaenger")
    }
} 