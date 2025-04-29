//
//  ContentView.swift
//  UniMathe
//
//  Created by Benedikt Held on 24.04.25.
//

import SwiftUI

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
                        GridItem(.flexible(), spacing: 16),
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
        // Direkter Zugriff auf die Dateien im Dateisystem statt über Bundle.main.url
        let lerninhaltsPath = "/Users/benediktheld/Desktop/app/UniMatheApp/UniMathe/UniMathe/lerninhalt"
        let indexUrl = URL(fileURLWithPath: "\(lerninhaltsPath)/index.json")
        
        guard FileManager.default.fileExists(atPath: indexUrl.path) else {
            error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Index file not found at \(indexUrl.path)"])
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
                let fullFilename = "\(filename)_content.json"
                
                // Direkter Zugriff auf die Dateien im Dateisystem
                let lerninhaltsPath = "Users/benediktheld/Desktop/app/UniMatheApp/UniMathe/UniMathe/lerninhalt"
                let topicUrl = URL(fileURLWithPath: "\(lerninhaltsPath)/\(fullFilename)")
                
                guard FileManager.default.fileExists(atPath: topicUrl.path) else {
                    print("Could not find file for topic: \(topicIndex.title) at \(topicUrl.path)")
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
        VStack {
            Image(systemName: topic.icon)
                .font(.system(size: 40))
                .foregroundColor(.blue)
                .padding()
            
            Text(topic.title)
                .font(.headline)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
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

struct TopicDetailView: View {
    let topic: MathTopic
    
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
                    // Large circle
                    Circle()
                        .fill(Color.blue.opacity(0.03))
                        .frame(width: geometry.size.width * 1.2)
                        .offset(x: -geometry.size.width * 0.2, y: -geometry.size.height * 0.1)
                    
                    // Medium circle
                    Circle()
                        .fill(Color.purple.opacity(0.03))
                        .frame(width: geometry.size.width * 0.8)
                        .offset(x: geometry.size.width * 0.3, y: geometry.size.height * 0.3)
                    
                    // Small circle
                    Circle()
                        .fill(Color.blue.opacity(0.02))
                        .frame(width: geometry.size.width * 0.4)
                        .offset(x: -geometry.size.width * 0.1, y: geometry.size.height * 0.6)
                }
            }
            
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
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.9))
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.blue.opacity(0.1), lineWidth: 1)
                )
                .padding(.horizontal)
            }
        }
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.large)
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
