//
//  ContentView.swift
//  UniMathe
//
//  Created by Benedikt Held on 24.04.25.
//

import SwiftUI

// MARK: - Model Definitions
struct InteractiveExample: Codable, Identifiable {
    let id: UUID
    let title: String
    let description: String
    let steps: [InteractiveExampleStep]
    let topic: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, steps, topic
    }
    
    init(id: UUID = UUID(), title: String, description: String, steps: [InteractiveExampleStep], topic: String) {
        self.id = id
        self.title = title
        self.description = description
        self.steps = steps
        self.topic = topic
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        steps = try container.decode([InteractiveExampleStep].self, forKey: .steps)
        topic = try container.decode(String.self, forKey: .topic)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(steps, forKey: .steps)
        try container.encode(topic, forKey: .topic)
    }
}

struct InteractiveExampleStep: Codable, Identifiable {
    let id: UUID
    let text: String
    let formula: String?
    let explanation: String?
    
    enum CodingKeys: String, CodingKey {
        case id, text, formula, explanation
    }
    
    init(id: UUID = UUID(), text: String, formula: String? = nil, explanation: String? = nil) {
        self.id = id
        self.text = text
        self.formula = formula
        self.explanation = explanation
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        text = try container.decode(String.self, forKey: .text)
        formula = try container.decodeIfPresent(String.self, forKey: .formula)
        explanation = try container.decodeIfPresent(String.self, forKey: .explanation)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(text, forKey: .text)
        try container.encodeIfPresent(formula, forKey: .formula)
        try container.encodeIfPresent(explanation, forKey: .explanation)
    }
}

// MARK: - Hilfsfunktion für normierte Dateinamen
func normalizedFileName(from title: String) -> String {
    var fileName = title.lowercased()
    fileName = fileName.replacingOccurrences(of: "ä", with: "ae")
    fileName = fileName.replacingOccurrences(of: "ö", with: "oe")
    fileName = fileName.replacingOccurrences(of: "ü", with: "ue")
    fileName = fileName.replacingOccurrences(of: "ß", with: "ss")
    let allowed = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789_")
    fileName = fileName.replacingOccurrences(of: " ", with: "_")
    fileName = String(fileName.unicodeScalars.filter { allowed.contains($0) })
    return fileName
}

// MARK: - ContentView
struct ContentView: View {
    @State private var topics: [MathTopic] = []
    @State private var isLoading = true
    @State private var error: Error?
    
    var body: some View {
        NavigationView {
            ZStack {
                // Subtle gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.98, green: 0.98, blue: 1.0),
                        Color(red: 0.95, green: 0.97, blue: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Subtle color elements
                GeometryReader { geometry in
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.05))
                            .frame(width: geometry.size.width * 0.8)
                            .offset(x: -geometry.size.width * 0.3, y: -geometry.size.height * 0.2)
                        
                        Circle()
                            .fill(Color.purple.opacity(0.05))
                            .frame(width: geometry.size.width * 0.6)
                            .offset(x: geometry.size.width * 0.3, y: geometry.size.height * 0.2)
                    }
                }
                
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if let error = error {
                    VStack {
                        Text("Fehler beim Laden der Daten")
                            .font(.headline)
                            .foregroundColor(.red)
                        Text(error.localizedDescription)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                } else {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(topics) { topic in
                            NavigationLink(destination: topic.subTopics != nil ? 
                                AnyView(SubTopicsView(topic: topic)) : 
                                AnyView(TopicDetailView(topic: topic))) {
                                TopicCard(topic: topic)
                            }
                        }
                    }
                    .padding(16)
                    }
                }
            }
            .navigationTitle("Höhere Mathematik")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            loadTopics()
        }
    }
    
    private func loadTopics() {
        // Lade die Dateien aus dem App-Bundle ("lerninhalt"-Unterordner) anstatt über absolute Dateipfade
        // Versuche zuerst im Unterordner "lerninhalt", fallback auf Bundle-Root falls die Dateien als Gruppe eingebunden wurden
        guard let indexUrl = Bundle.main.url(forResource: "index", withExtension: "json", subdirectory: "lerninhalt") ??
              Bundle.main.url(forResource: "index", withExtension: "json") else {
            error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Index file not found in bundle"])
            isLoading = false
            return
        }
        
        do {
            let indexData = try Data(contentsOf: indexUrl)
            let indexResponse = try JSONDecoder().decode(IndexResponse.self, from: indexData)
            
            // Create an array to store the loaded topics
            var loadedTopics: [MathTopic] = []
            
            // Load each topic from its individual file
            for topicIndex in indexResponse.topics {
                let filename = normalizedFileName(from: topicIndex.title)
                let fullFilename = "\(filename)_content.json" // enthält bereits die Endung
                
                // Datei aus dem Bundle holen
                guard let topicUrl = Bundle.main.url(forResource: fullFilename, withExtension: nil, subdirectory: "lerninhalt") ??
                                    Bundle.main.url(forResource: fullFilename, withExtension: nil) else {
                    print("Could not find file for topic: \(topicIndex.title) in bundle")
                    continue
                }
                
                let topicData = try Data(contentsOf: topicUrl)
                // Direkte Dekodierung des einzelnen MathTopic-Objekts (kein Array)
                let topic = try JSONDecoder().decode(MathTopic.self, from: topicData)
                loadedTopics.append(topic)
            }
            
            topics = loadedTopics
            isLoading = false
        } catch {
            print("Error loading topics: \(error)")
            self.error = error
            isLoading = false
        }
    }
}

struct TopicCard: View {
    let topic: MathTopic
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: topic.icon)
                .font(.system(size: 32))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(topic.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(topic.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.blue.opacity(0.1), lineWidth: 1)
        )
    }
}

// SubTopicsView has been moved to Views/SubTopicsView.swift

// ContentSelectionView has been moved to Views/SubTopicsView.swift

struct ExercisesView: View {
    let topic: MathTopic
    @State private var exercises: [Exercise] = []
    @State private var selectedDifficulty: Difficulty?
    @State private var isLoading = false
    @State private var error: Error?
    
    private var filteredExercises: [Exercise] {
        if let difficulty = selectedDifficulty {
            return exercises.filter { $0.difficultyEnum == difficulty }
        }
        return exercises
    }
    
    var body: some View {
        ZStack {
            // Modern gradient background with abstract shapes
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color(red: 0.98, green: 0.98, blue: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Abstract background elements
            GeometryReader { geometry in
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.03))
                        .frame(width: geometry.size.width * 1.2)
                        .offset(x: -geometry.size.width * 0.2, y: -geometry.size.height * 0.1)
                    
                    Circle()
                        .fill(Color.purple.opacity(0.03))
                        .frame(width: geometry.size.width * 0.8)
                        .offset(x: geometry.size.width * 0.3, y: geometry.size.height * 0.3)
                }
            }
            
            VStack(spacing: 20) {
                Text("Wählen Sie den Schwierigkeitsgrad:")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                HStack(spacing: 16) {
                    ForEach([Difficulty.easy, .medium, .hard], id: \.self) { difficulty in
                        Button(action: {
                            selectedDifficulty = difficulty
                        }) {
                            Text(difficulty.text)
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(difficulty.color)
                                        .shadow(color: difficulty.color.opacity(0.3), radius: 5, x: 0, y: 2)
                                )
                        }
                    }
                }
                .padding(.horizontal)
                
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if let error = error {
                    VStack {
                        Text("Fehler beim Laden der Übungen")
                            .font(.headline)
                            .foregroundColor(.red)
                        Text(error.localizedDescription)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                } else if let selectedDifficulty = selectedDifficulty {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(filteredExercises) { exercise in
                                ExerciseCard(exercise: exercise)
                            }
                        }
                        .padding()
                    }
                } else {
                    Spacer()
                    Text("Bitte wählen Sie einen Schwierigkeitsgrad aus")
                        .foregroundColor(.gray)
                        .font(.headline)
                    Spacer()
                }
            }
        }
        .navigationTitle("Übungen: \(topic.title)")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            loadExercises()
        }
    }
    //-------------------------AUFGABEN DATEI HIER HINZUFÜGEN-----------
    private func loadExercises() {
        do {
            // Load exercises from the relevant JSON file based on the topic
            var allExercises: [Exercise] = []
            let fileName: String
            
            // Determine which file to load based on the topic
            switch topic.title {
            case "Mengen und Abbildungen":
                fileName = "mengen_und_abbildungen"
            case "Logik":
                fileName = "logik"
            case "vollstaendige induktion":
                fileName = "vollstaendige_induktion"
            case "Binomische Formeln":
                fileName = "binomische_formeln"
            case "Größter gemeinsamer Teiler":
                fileName = "groesster_gemeinsamer_teiler"
            case "Gruppen":
                fileName = "gruppen"
            case "Ringe":
                fileName = "ringe"
            case "Körper":
                fileName = "koerper"
            case "Komplexe Zahlen":
                fileName = "komplexe_zahlen"
//Analyis:
                
            case "Folgen und Reihen":
                fileName = "folgen_und_reihen"
            case "Grenzwerte":
                fileName = "grenzwerte"
            case "Differentialrechnung":
                fileName = "differentialrechnung"
            case "Integralrechnung":
                fileName = "integralrechnung"
            case "Mehrdimensionale Analysis":
                fileName = "mehrdimensionale_analysis"
            
//Lineare Algebra
            case "Matrizen":
                fileName = "matrizen"
            case "Vektorräume":
                fileName = "vektorraeume"
            case "Determinanten":
                fileName = "determinanten"
            case "Lineare Abbildungen":
                fileName = "lineare_abbildungen"
            case "Eigenwerte und Eigenvektoren":
                fileName = "eigenwerte"
                
                
            default:
                error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Keine passende JSON-Datei für das Thema gefunden"])
                isLoading = false
                return
            }
//--------------------------------------------------------------
            
            // Load the specific JSON file
            if let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") {
                let data = try Data(contentsOf: fileURL)
                let response = try JSONDecoder().decode(ExercisesResponse.self, from: data)
                allExercises = response.exercises
                exercises = allExercises
                isLoading = false
            } else {
                error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "JSON-Datei nicht gefunden"])
                isLoading = false
            }
        } catch {
            self.error = error
            isLoading = false
        }
    }
}

struct ExerciseRow: View {
    let exercise: Exercise
    @State private var descriptionHeight: CGFloat = 100
    @State private var titleHeight: CGFloat = 20
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                LaTeXView(content: "<span style='font-size:1.2em;font-weight:bold;'>" + addHtmlLineBreaks(exercise.title) + "</span>", height: $titleHeight)
                    .frame(height: titleHeight)
                Spacer()
                Text("\(exercise.points) Punkte")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            
            LaTeXView(content: addHtmlLineBreaks(exercise.description), height: $descriptionHeight)
                .frame(height: descriptionHeight)
            
            HStack {
                Text(exercise.difficultyEnum.text)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(exercise.difficultyEnum.color)
                    .cornerRadius(4)
                
                Spacer()
                
                Text("Start")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.white)
    }
}

struct ExerciseCard: View {
    let exercise: Exercise
    @State private var descriptionHeight: CGFloat = 100
    @State private var titleHeight: CGFloat = 20
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                LaTeXView(content: "<span style='font-size:1.2em;font-weight:bold;'>" + addHtmlLineBreaks(exercise.title) + "</span>", height: $titleHeight)
                    .frame(height: titleHeight)
                Spacer()
                Text("\(exercise.points) Punkte")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            
            LaTeXView(content: addHtmlLineBreaks(exercise.description), height: $descriptionHeight)
                .frame(height: descriptionHeight)
            
            HStack {
                Text(exercise.difficultyEnum.text)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(exercise.difficultyEnum.color)
                    .cornerRadius(4)
                
                Spacer()
                
                NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                    Text("Start")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue.opacity(0.1), lineWidth: 1)
        )
    }
}

// Hilfsfunktion, um Zeilenumbrüche in <br> umzuwandeln
fileprivate func addHtmlLineBreaks(_ text: String) -> String {
    text.replacingOccurrences(of: "\n", with: "<br>")
}

// MARK: - Interactive Learning Components
struct ProgressHeader: View {
    let currentStep: Int
    let totalSteps: Int
    let showProgress: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            if showProgress {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                            .frame(width: geometry.size.width * CGFloat(currentStep + 1) / CGFloat(totalSteps), height: 8)
                    }
                }
                .frame(height: 8)
                .transition(.opacity.combined(with: .scale))
            }
            
            Text("Schritt \(currentStep + 1) von \(totalSteps)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .transition(.opacity.combined(with: .scale))
        }
        .padding()
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct ContentHeader: View {
    let title: String
    let description: String
    let opacity: Double
    let slideOffset: CGFloat
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.top)
        .opacity(opacity)
        .offset(y: slideOffset)
    }
}

struct ExplanationContent: View {
    let step: InteractiveExampleStep
    let showCurrentStep: Bool
    @State private var formulaHeight: CGFloat = 50
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(step.text)
                .font(.body)
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                )
                .fixedSize(horizontal: false, vertical: true)
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.8).combined(with: .opacity),
                    removal: .scale(scale: 0.8).combined(with: .opacity)
                ))
            
            if let formula = step.formula {
                LaTeXView(content: "$$" + formula + "$$", height: $formulaHeight)
                    .frame(maxWidth: .infinity)
                    .frame(height: formulaHeight)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue.opacity(0.1))
                    )
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.8).combined(with: .opacity),
                        removal: .scale(scale: 0.8).combined(with: .opacity)
                    ))
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.2), value: showCurrentStep)
            }
            
            if let explanation = step.explanation {
                Text(explanation)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.1))
                    )
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.8).combined(with: .opacity),
                        removal: .scale(scale: 0.8).combined(with: .opacity)
                    ))
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.4), value: showCurrentStep)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 8)
    }
}

struct BotAvatar: View {
    let showCurrentStep: Bool
    
    var body: some View {
        Image(systemName: "brain.head.profile")
            .font(.system(size: 40))
            .foregroundColor(.blue)
            .padding()
            .background(
                Circle()
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
    }
}

struct ContinueButton: View {
    let currentStep: Int
    let totalSteps: Int
    let showCurrentStep: Bool
    let action: () -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            if currentStep >= totalSteps - 1 {
                presentationMode.wrappedValue.dismiss()
            } else {
                action()
            }
        }) {
            HStack {
                Text(currentStep < totalSteps - 1 ? "Weiter" : "Zurück zur Übersicht")
                Image(systemName: currentStep < totalSteps - 1 ? "arrow.right" : "arrow.left")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue)
                    .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 2)
            )
        }
        .padding(.horizontal)
        .scaleEffect(showCurrentStep ? 1 : 0.95)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showCurrentStep)
    }
}

struct InteractiveLearningView: View {
    let topic: MathTopic
    @State private var currentStep = 0
    @State private var showNextStep = false
    @State private var example: InteractiveExample?
    @State private var isLoading = true
    @State private var error: Error?
    @State private var showCurrentStep = false
    @State private var showProgress = false
    @State private var slideOffset: CGFloat = 50
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            // Hintergrund
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
                ProgressView()
                    .scaleEffect(1.5)
            } else if let error = error {
                VStack {
                    Text("Fehler beim Laden des Beispiels")
                        .font(.headline)
                        .foregroundColor(.red)
                    Text(error.localizedDescription)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            } else if let example = example {
                VStack(spacing: 0) {
                    ProgressHeader(
                        currentStep: currentStep,
                        totalSteps: example.steps.count,
                        showProgress: showProgress
                    )
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 24) {
                            ContentHeader(
                                title: example.title,
                                description: example.description,
                                opacity: opacity,
                                slideOffset: slideOffset
                            )
                            
                            HStack(alignment: .top, spacing: 16) {
                                BotAvatar(showCurrentStep: showCurrentStep)
                                
                                if showCurrentStep {
                                    ExplanationContent(
                                        step: example.steps[currentStep],
                                        showCurrentStep: showCurrentStep
                                    )
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.bottom, 100) // Extra padding for the button
                    }
                    
                    // Fixed button at bottom
                    VStack {
                        ContinueButton(
                            currentStep: currentStep,
                            totalSteps: example.steps.count,
                            showCurrentStep: showCurrentStep
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                if currentStep < example.steps.count - 1 {
                                    showCurrentStep = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        currentStep += 1
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                            showCurrentStep = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .background(
                        Rectangle()
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, y: -2)
                    )
                }
            }
        }
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            loadExample()
        }
    }
    
    private func loadExample() {
        let fileName = normalizedFileName(from: topic.title) + "_beispiel"
        print("Versuche Datei zu laden: \(fileName).json")
        
        if let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json", subdirectory: "beispiele") {
            print("Datei gefunden in beispiele/\(fileName).json")
            do {
                let data = try Data(contentsOf: fileURL)
                print("Daten erfolgreich geladen, Größe: \(data.count) bytes")
                example = try JSONDecoder().decode(InteractiveExample.self, from: data)
                print("JSON erfolgreich dekodiert")
                isLoading = false
                
                withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
                    showProgress = true
                }
                
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.6)) {
                    showCurrentStep = true
                    opacity = 1
                    slideOffset = 0
                }
            } catch {
                print("Fehler beim Laden/Dekodieren: \(error)")
                self.error = error
                isLoading = false
            }
        } else if let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") {
            print("Datei gefunden im Hauptverzeichnis: \(fileName).json")
            do {
                let data = try Data(contentsOf: fileURL)
                print("Daten erfolgreich geladen, Größe: \(data.count) bytes")
                example = try JSONDecoder().decode(InteractiveExample.self, from: data)
                print("JSON erfolgreich dekodiert")
                isLoading = false
                
                withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
                    showProgress = true
                }
                
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.6)) {
                    showCurrentStep = true
                    opacity = 1
                    slideOffset = 0
                }
            } catch {
                print("Fehler beim Laden/Dekodieren: \(error)")
                self.error = error
                isLoading = false
            }
        } else {
            print("Datei nicht gefunden: \(fileName).json")
            error = NSError(domain: "", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Beispieldatei nicht gefunden: \(fileName).json"
            ])
            isLoading = false
        }
    }
}

struct TopicDetailView: View {
    let topic: MathTopic
    @State private var showExampleButton = false
    @State private var scrollPosition: CGFloat = 0
    
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
            
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 0) {
                            if let markdownContent = topic.markdownContent {
                                LaTeXView(content: markdownContent, height: .constant(0))
                                    .frame(minHeight: UIScreen.main.bounds.height - 100)
                            } else {
                                Text(topic.description)
                                    .font(.body)
                                    .foregroundColor(.black)
                                    .lineSpacing(8)
                                    .padding()
                            }
                        }
                        .background(
                            GeometryReader { geometry in
                                Color.clear
                                    .preference(key: ScrollOffsetPreferenceKey.self,
                                              value: geometry.frame(in: .named("scrollView")).minY)
                            }
                        )
                    }
                    .coordinateSpace(name: "scrollView")
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        scrollPosition = value
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showExampleButton = value < -10
                        }
                    }
                }
                
                // Example Button
                if showExampleButton {
                    NavigationLink(destination: InteractiveLearningView(topic: topic)) {
                        HStack {
                            Image(systemName: "brain.head.profile")
                            Text("MathAssistance")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            // Ensure button appears after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    showExampleButton = true
                }
            }
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    ContentView()
}
