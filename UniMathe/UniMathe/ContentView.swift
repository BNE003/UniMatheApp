//
//  ContentView.swift
//  UniMathe
//
//  Created by Benedikt Held on 24.04.25.
//

import SwiftUI
import StoreKit
// Falls ProFeaturesView in einem anderen Modul/Ordner liegt:
// import UniMathe // oder das entsprechende Modul, falls nötig

// MARK: - Model Definitions
struct InteractiveExample: Codable, Identifiable {
    let id: UUID
    let steps: [InteractiveExampleStep]
    let topic: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case steps
        case topic
    }
    
    init(id: UUID = UUID(), steps: [InteractiveExampleStep], topic: String) {
        self.id = id
        self.steps = steps
        self.topic = topic
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        steps = try container.decode([InteractiveExampleStep].self, forKey: .steps)
        topic = try container.decode(String.self, forKey: .topic)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
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
    @ObservedObject private var storeManager = StoreKitManager.shared
    @ObservedObject private var settings = SettingsModel.shared
    @State private var topics: [MathTopic] = []
    @State private var isLoading = true
    @State private var error: Error?
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        NavigationStack {
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
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text(SettingsModel.shared.language == .english ? "Loading..." : "Wird geladen...")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                    }
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
                    VStack {
                        // Moderner App-Titel
                        VStack(alignment: .leading, spacing: 0) {
                            Text(SettingsModel.shared.language == .english ? "Advanced" : "Höhere")
                                .font(.custom("SF Pro Display", size: horizontalSizeClass == .regular ? 54 : 42))
                                .fontWeight(.black)
                                .foregroundColor(.blue)
                                .overlay(
                                    Text(SettingsModel.shared.language == .english ? "Advanced" : "Höhere")
                                        .font(.custom("SF Pro Display", size: horizontalSizeClass == .regular ? 54 : 42))
                                        .fontWeight(.black)
                                        .foregroundColor(.blue)
                                        .opacity(0.3)
                                        .offset(x: 0.5, y: 0.5)
                                )
                                .shadow(color: Color.blue.opacity(0.15), radius: 4, x: 0, y: 2)
                                .padding(.top, 24)
                            
                            Text(SettingsModel.shared.language == .english ? "Mathematics" : "Mathematik")
                                .font(.custom("SF Pro Display", size: horizontalSizeClass == .regular ? 54 : 42))
                                .fontWeight(.black)
                                .foregroundColor(.blue)
                                .overlay(
                                    Text(SettingsModel.shared.language == .english ? "Mathematics" : "Mathematik")
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
                            .frame(maxWidth: horizontalSizeClass == .regular ? .infinity : nil, alignment: .leading)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gear")
                                .font(.system(size: 22))
                                .foregroundColor(settings.accentColor)
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            loadTopics()
        }
        .onChange(of: settings.language) { _ in
            // Reload content when language changes
            loadTopics()
        }
        .preferredColorScheme(settings.isDarkModeEnabled ? .dark : .light)
    }
    
    private func loadTopics() {
        // Get the index file based on the current language
        let language = SettingsModel.shared.language
        let languageSuffix = language == .english ? "_en" : ""
        
        // Try to find the localized index file
        let indexName = "index" + languageSuffix
        var indexUrl: URL?
        
        // Debug prints to diagnose bundle issues
        print("🔍 BUNDLE DEBUG: Current language: \(language.rawValue)")
        print("🔍 BUNDLE DEBUG: Bundle path: \(Bundle.main.bundlePath)")
        print("🔍 BUNDLE DEBUG: Looking for index file: \(indexName).json")
        
        // First try with language suffix
        if let url = Bundle.main.url(forResource: indexName, withExtension: "json") {
            print("🔍 BUNDLE DEBUG: Found index with language suffix at root")
            indexUrl = url
        }
        // Fallback to base name
        else if let url = Bundle.main.url(forResource: "index", withExtension: "json") {
            print("🔍 BUNDLE DEBUG: Found index at root level")
            indexUrl = url
        }
        else {
            // Try inside lerninhalt folder
            if let url = Bundle.main.url(forResource: indexName, withExtension: "json", subdirectory: "lerninhalt") {
                print("🔍 BUNDLE DEBUG: Found index with language suffix in lerninhalt/")
                indexUrl = url
            } 
            else if let url = Bundle.main.url(forResource: "index", withExtension: "json", subdirectory: "lerninhalt") {
                print("🔍 BUNDLE DEBUG: Found index in lerninhalt/")
                indexUrl = url
            }
            // Try inside language folders
            else if let url = Bundle.main.url(forResource: indexName, withExtension: "json", subdirectory: "lerninhalt/\(language.rawValue)") {
                print("🔍 BUNDLE DEBUG: Found index with language suffix in lerninhalt/\(language.rawValue)/")
                indexUrl = url
            }
            else if let url = Bundle.main.url(forResource: "index", withExtension: "json", subdirectory: "lerninhalt/\(language.rawValue)") {
                print("🔍 BUNDLE DEBUG: Found index in lerninhalt/\(language.rawValue)/")
                indexUrl = url
            }
            else {
                print("🔍 BUNDLE DEBUG: Could not find any index file")
                let errorMessage = language == .english ? 
                    "Index file not found in bundle" : 
                    "Index-Datei nicht im Bundle gefunden"
                error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                isLoading = false
                return
            }
        }
        
        // Try to load the file content
        do {
            print("🔍 BUNDLE DEBUG: Loading from URL: \(indexUrl!)")
            let indexData = try Data(contentsOf: indexUrl!)
            let indexResponse = try JSONDecoder().decode(IndexResponse.self, from: indexData)
            print("🔍 BUNDLE DEBUG: Successfully loaded index with \(indexResponse.topics.count) main topics")
            
            // Create an array to store the loaded topics
            var loadedTopics: [MathTopic] = []
            
            // Load each topic from its individual file
            for topicIndex in indexResponse.topics {
                print("🔍 BUNDLE DEBUG: Loading topic: \(topicIndex.title) with ID: \(topicIndex.id)")
                
                // Get the filename without extension
                let filenameWithoutExtension = topicIndex.filename.replacingOccurrences(of: ".json", with: "")
                
                // Add language suffix for non-German languages
                let localizedFilename = filenameWithoutExtension + languageSuffix
                let topicUrl: URL?
                
                print("🔍 BUNDLE DEBUG: Looking for file: \(localizedFilename).json")
                
                // Try to find the content file - prioritize files in the root with language suffix
                if let url = Bundle.main.url(forResource: localizedFilename, withExtension: "json") {
                    print("🔍 BUNDLE DEBUG: Found topic \(localizedFilename) at root level")
                    topicUrl = url
                }
                // Fallback to the original filename at root
                else if let url = Bundle.main.url(forResource: filenameWithoutExtension, withExtension: "json") {
                    print("🔍 BUNDLE DEBUG: Found topic \(filenameWithoutExtension) at root level")
                    topicUrl = url
                }
                // Then try inside lerninhalt folder
                else if let url = Bundle.main.url(forResource: localizedFilename, withExtension: "json", subdirectory: "lerninhalt") {
                    print("🔍 BUNDLE DEBUG: Found topic \(localizedFilename) in lerninhalt/")
                    topicUrl = url
                }
                else if let url = Bundle.main.url(forResource: filenameWithoutExtension, withExtension: "json", subdirectory: "lerninhalt") {
                    print("🔍 BUNDLE DEBUG: Found topic \(filenameWithoutExtension) in lerninhalt/")
                    topicUrl = url
                }
                // Finally try in language-specific folders
                else if let url = Bundle.main.url(forResource: localizedFilename, withExtension: "json", subdirectory: "lerninhalt/\(language.rawValue)") {
                    print("🔍 BUNDLE DEBUG: Found topic \(localizedFilename) in lerninhalt/\(language.rawValue)/")
                    topicUrl = url
                }
                else if let url = Bundle.main.url(forResource: filenameWithoutExtension, withExtension: "json", subdirectory: "lerninhalt/\(language.rawValue)") {
                    print("🔍 BUNDLE DEBUG: Found topic \(filenameWithoutExtension) in lerninhalt/\(language.rawValue)/")
                    topicUrl = url
                }
                else {
                    let errorMessage = language == .english ? 
                        "Could not find file for topic" : 
                        "Datei für Thema nicht gefunden"
                    print("🔍 BUNDLE DEBUG: \(errorMessage): \(topicIndex.title), filename: \(topicIndex.filename)")
                    continue
                }
                
                do {
                    let topicData = try Data(contentsOf: topicUrl!)
                    // Decode the single MathTopic object
                    let topic = try JSONDecoder().decode(MathTopic.self, from: topicData)
                    loadedTopics.append(topic)
                    print("🔍 BUNDLE DEBUG: Successfully loaded topic: \(topic.title)")
                } catch {
                    print("🔍 BUNDLE DEBUG: Error loading topic \(topicIndex.title): \(error)")
                    continue
                }
            }
            
            topics = loadedTopics
            isLoading = false
            print("🔍 BUNDLE DEBUG: Finished loading all topics, count: \(loadedTopics.count)")
        } catch {
            print("🔍 BUNDLE DEBUG: Error loading index: \(error)")
            self.error = error
            isLoading = false
        }
    }
}

struct TopicCard: View {
    let topic: MathTopic
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        HStack(spacing: 16) {
            if topic.title == "Integralrechnung" || topic.title == "Integral Calculus" {
                Image("integral")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: horizontalSizeClass == .regular ? 60 : 45, height: horizontalSizeClass == .regular ? 60 : 45)
                    .padding(horizontalSizeClass == .regular ? 10 : 7.5)
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
            } else if topic.title == "Mehrdimensionale Analysis" || topic.title == "Multidimensional Calculus" {
                Image("mehrdimensionale_analysis")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: horizontalSizeClass == .regular ? 60 : 45, height: horizontalSizeClass == .regular ? 60 : 45)
                    .padding(horizontalSizeClass == .regular ? 10 : 7.5)
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
            } else if topic.title == "Differentialrechnung" || topic.title == "Differential Calculus" {
                Image("differentialrechnung")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: horizontalSizeClass == .regular ? 60 : 45, height: horizontalSizeClass == .regular ? 60 : 45)
                    .padding(horizontalSizeClass == .regular ? 10 : 7.5)
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
            } else if topic.title == "Matrizen" || topic.title == "Matrices" {
                Image("matrizen")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: horizontalSizeClass == .regular ? 60 : 45, height: horizontalSizeClass == .regular ? 60 : 45)
                    .padding(horizontalSizeClass == .regular ? 10 : 7.5)
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
            } else if topic.title == "Vektorräume" || topic.title == "Vector Spaces" {
                Image("vektor")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: horizontalSizeClass == .regular ? 60 : 45, height: horizontalSizeClass == .regular ? 60 : 45)
                    .padding(horizontalSizeClass == .regular ? 10 : 7.5)
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
            } else if topic.title == "Lineare Abbildungen" || topic.title == "Linear Mappings" {
                Image("abbildung")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: horizontalSizeClass == .regular ? 60 : 45, height: horizontalSizeClass == .regular ? 60 : 45)
                    .padding(horizontalSizeClass == .regular ? 10 : 7.5)
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
            } else if topic.title == "Determinanten" || topic.title == "Determinants" {
                Image("determinante")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: horizontalSizeClass == .regular ? 60 : 45, height: horizontalSizeClass == .regular ? 60 : 45)
                    .padding(horizontalSizeClass == .regular ? 10 : 7.5)
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
            } else if topic.title == "Eigenwerte und Eigenvektoren" || topic.title == "Eigenvalues and Eigenvectors" {
                Image("eigenwerte")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: horizontalSizeClass == .regular ? 60 : 45, height: horizontalSizeClass == .regular ? 60 : 45)
                    .padding(horizontalSizeClass == .regular ? 10 : 7.5)
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
            } else {
                Image(systemName: topic.icon)
                    .font(.system(size: horizontalSizeClass == .regular ? 40 : 32))
                    .foregroundColor(.white)
                    .frame(width: horizontalSizeClass == .regular ? 80 : 60, height: horizontalSizeClass == .regular ? 80 : 60)
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
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(topic.title)
                    .font(horizontalSizeClass == .regular ? .title2 : .headline)
                    .foregroundColor(.primary)
                
                Text(topic.description)
                    .font(horizontalSizeClass == .regular ? .body : .subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(horizontalSizeClass == .regular ? 3 : 2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: horizontalSizeClass == .regular ? 18 : 14, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .padding(horizontalSizeClass == .regular ? 28 : 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.blue.opacity(0.1), lineWidth: 1)
        )
        .frame(maxWidth: .infinity)
        .padding(.horizontal, horizontalSizeClass == .regular ? 32 : 0)
    }
}

// SubTopicsView has been moved to Views/SubTopicsView.swift

// ContentSelectionView has been moved to Views/SubTopicsView.swift

struct ExercisesView: View {
    let topic: MathTopic
    @State private var exercises: [Exercise] = []
    @State private var selectedDifficulty: String?
    @State private var isLoading = true
    @State private var error: Error?
    @State private var showProSheet = false
    @ObservedObject private var storeManager = StoreKitManager.shared
    
    private var filteredExercises: [Exercise] {
        guard let difficulty = selectedDifficulty else { return [] }
        return exercises.filter { $0.difficulty == difficulty }
    }
    
    private var freeExercises: [Exercise] {
        guard let difficulty = selectedDifficulty else { return [] }
        let exercisesForDifficulty = exercises.filter { $0.difficulty == difficulty }
        return Array(exercisesForDifficulty.prefix(2))
    }
    
    private var proExercises: [Exercise] {
        guard let difficulty = selectedDifficulty else { return [] }
        let exercisesForDifficulty = exercises.filter { $0.difficulty == difficulty }
        return Array(exercisesForDifficulty.dropFirst(2))
    }
    
    var body: some View {
        VStack {
            // Schwierigkeitsgrad-Auswahl
            HStack(spacing: 16) {
                ForEach(["easy", "medium", "hard"], id: \.self) { difficulty in
                    Button(action: {
                        withAnimation {
                            selectedDifficulty = difficulty
                        }
                    }) {
                        Text(SettingsModel.shared.language == .english ? 
                             (difficulty == "easy" ? "Easy" : 
                              difficulty == "medium" ? "Medium" : "Hard") :
                             (difficulty == "easy" ? "Leicht" : 
                              difficulty == "medium" ? "Mittel" : "Schwer"))
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(difficulty == "easy" ? Color.green :
                                          difficulty == "medium" ? Color.orange : Color.red)
                                    .shadow(color: (difficulty == "easy" ? Color.green :
                                                  difficulty == "medium" ? Color.orange : Color.red).opacity(0.3),
                                           radius: 5, x: 0, y: 2)
                            )
                    }
                }
            }
            .padding()
            
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            } else if let error = error {
                VStack {
                    Text(SettingsModel.shared.language == .english ? "Error loading exercises" : "Fehler beim Laden der Übungen")
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
                        if !storeManager.purchasedProductIDs.isEmpty {
                            // PRO: Alle Übungen sichtbar
                            ForEach(filteredExercises) { exercise in
                                ExerciseCard(exercise: exercise)
                            }
                        } else {
                            // FREE: 2 frei, Rest geblurrt
                            ForEach(freeExercises) { exercise in
                                ExerciseCard(exercise: exercise)
                            }
                            if !proExercises.isEmpty {
                                VStack(spacing: 16) {
                                    ForEach(proExercises) { exercise in
                                        ZStack {
                                            ExerciseCard(exercise: exercise)
                                                .blur(radius: 3)
                                            VStack {
                                                Image(systemName: "lock.fill")
                                                    .font(.system(size: 30))
                                                    .foregroundColor(.blue)
                                                Text(SettingsModel.shared.language == .english ? "Unlock Pro" : "Pro freischalten")
                                                    .font(.headline)
                                                    .foregroundColor(.blue)
                                            }
                                            .padding()
                                            .background(Color.white.opacity(0.9))
                                            .cornerRadius(12)
                                        }
                                        .onTapGesture {
                                            showProSheet = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            } else {
                Spacer()
                Text(SettingsModel.shared.language == .english ? 
                     "Please select a difficulty level" : 
                     "Bitte wählen Sie einen Schwierigkeitsgrad aus")
                    .foregroundColor(.gray)
                    .font(.headline)
                Spacer()
            }
        }
        .navigationTitle(SettingsModel.shared.language == .english ? 
                         "Exercises: \(topic.title)" : 
                         "Übungen: \(topic.title)")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showProSheet) {
            if UIDevice.current.userInterfaceIdiom == .pad {
                iPadProFeaturesView()
                    .presentationDetents([.height(900), .large])
                    .presentationContentInteraction(.scrolls)
                    .presentationCornerRadius(16)
            } else {
                ProFeaturesView()
            }
        }
        .onAppear {
            loadExercises()
        }
    }
    
    private func loadExercises() {
        do {
            var allExercises: [Exercise] = []
            let fileName: String
            
            switch topic.title {
            case "Mengen und Abbildungen", "Sets and Mappings":
                fileName = "mengen_und_abbildungen"
            case "Logik", "Logic":
                fileName = "logik"
            case "Vollständige Induktion", "Mathematical Induction":
                fileName = "vollstaendige_induktion"
            case "Binomische Formeln", "Binomial Formulas":
                fileName = "binomische_formeln"
            case "Größter gemeinsamer Teiler", "Greatest Common Divisor":
                fileName = "groesster_gemeinsamer_teiler"
            case "Gruppen", "Groups":
                fileName = "gruppen"
            case "Ringe", "Rings":
                fileName = "ringe"
            case "Körper", "Fields":
                fileName = "koerper"
            case "Komplexe Zahlen", "Complex Numbers":
                fileName = "komplexe_zahlen"
            case "Folgen und Reihen", "Sequences and Series":
                fileName = "folgen_und_reihen"
            case "Grenzwerte", "Limits":
                fileName = "grenzwerte"
            case "Differentialrechnung", "Differential Calculus":
                fileName = "differentialrechnung"
            case "Integralrechnung", "Integral Calculus":
                fileName = "integralrechnung"
            case "Mehrdimensionale Analysis", "Multidimensional Calculus":
                fileName = "mehrdimensionale_analysis"
            case "Matrizen", "Matrices":
                fileName = "matrizen"
            case "Vektorräume", "Vector Spaces":
                fileName = "vektorraeume"
            case "Determinanten", "Determinants":
                fileName = "determinanten"
            case "Lineare Abbildungen", "Linear Mappings":
                fileName = "lineare_abbildungen"
            case "Eigenwerte", "Eigenvalues", "Eigenwerte und Eigenvektoren", "Eigenvalues and Eigenvectors":
                fileName = "eigenwerte"
            default:
                let errorMessage = SettingsModel.shared.language == .english ? 
                    "No matching JSON file found for this topic" : 
                    "Keine passende JSON-Datei für das Thema gefunden"
                error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                isLoading = false
                return
            }
            
            // Determine language folder and file name
            let language = SettingsModel.shared.language
            let langFolder = language == .english ? "en" : "de"
            
            // For English, use the _en suffix; for German, use the base name
            let localizedFileName = language == .english ? fileName + "_en" : fileName
            
            print("🔍 EXERCISE DEBUG: Current language: \(language.rawValue)")
            print("🔍 EXERCISE DEBUG: Looking for file: \(localizedFileName).json in folder aufgaben/\(langFolder)")
            
            // We'll try loading files in this order:
            // 1. First try specific language folder with correct filename convention
            // 2. Then try specific language folder with any filename
            // 3. Then try the root aufgaben folder
            // 4. Finally, try the root bundle
            
            var fileURL: URL?
            
            // 1. Try with language-specific filename in language subfolder
            if let url = Bundle.main.url(forResource: localizedFileName, withExtension: "json", subdirectory: "aufgaben/\(langFolder)") {
                print("🔍 EXERCISE DEBUG: Found file with language suffix in language folder: \(url.path)")
                fileURL = url
            }
            // 2. Try with base filename in language subfolder (fallback for either language)
            else if let url = Bundle.main.url(forResource: fileName, withExtension: "json", subdirectory: "aufgaben/\(langFolder)") {
                print("🔍 EXERCISE DEBUG: Found base filename in language folder: \(url.path)")
                fileURL = url
            }
            // 3. Try in the root aufgaben folder with language suffix
            else if let url = Bundle.main.url(forResource: localizedFileName, withExtension: "json", subdirectory: "aufgaben") {
                print("🔍 EXERCISE DEBUG: Found file with language suffix in root aufgaben folder: \(url.path)")
                fileURL = url
            }
            // 4. Try in the root aufgaben folder with base filename
            else if let url = Bundle.main.url(forResource: fileName, withExtension: "json", subdirectory: "aufgaben") {
                print("🔍 EXERCISE DEBUG: Found base filename in root aufgaben folder: \(url.path)")
                fileURL = url
            }
            // 5. Try in the root bundle
            else if let url = Bundle.main.url(forResource: localizedFileName, withExtension: "json") {
                print("🔍 EXERCISE DEBUG: Found file with language suffix in root bundle: \(url.path)")
                fileURL = url
            }
            else if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
                print("🔍 EXERCISE DEBUG: Found base filename in root bundle: \(url.path)")
                fileURL = url
            }
            
            // If no file was found, show an error
            guard let foundURL = fileURL else {
                let errorMessage = SettingsModel.shared.language == .english ? 
                    "Exercise file not found" : 
                    "Übungsdatei nicht gefunden"
                print("🔍 EXERCISE DEBUG: No exercise file found for \(fileName) in any location")
                error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                isLoading = false
                return
            }
            
            print("🔍 EXERCISE DEBUG: Loading exercise file from: \(foundURL.path)")
            
            let data = try Data(contentsOf: foundURL)
            let response = try JSONDecoder().decode(ExercisesResponse.self, from: data)
            allExercises = response.exercises
            
            print("🔍 EXERCISE DEBUG: Successfully loaded \(allExercises.count) exercises")
            if let firstExercise = allExercises.first {
                print("🔍 EXERCISE DEBUG: First exercise title: \(firstExercise.title)")
            }
            
            exercises = allExercises
            isLoading = false
            
        } catch {
            print("🔍 EXERCISE DEBUG: Error loading file: \(error)")
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
            
            Text(SettingsModel.shared.language == .english ? 
                 "Step \(currentStep + 1) of \(totalSteps)" : 
                 "Schritt \(currentStep + 1) von \(totalSteps)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .transition(.opacity.combined(with: .scale))
        }
        .padding()
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct ExplanationContent: View {
    let step: InteractiveExampleStep
    let showCurrentStep: Bool
    @State private var formulaHeight: CGFloat = 50
    @Environment(\.locale) private var locale
    @ObservedObject private var settings = SettingsModel.shared
    
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
                let language = SettingsModel.shared.language
                Text(currentStep < totalSteps - 1 ? 
                    (language == .english ? "Continue" : "Weiter") : 
                    (language == .english ? "Back to Overview" : "Zurück zur Übersicht"))
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
    @State private var showProSheet = false
    @State private var blurBackground = false
    @ObservedObject private var storeManager = StoreKitManager.shared
    
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
                        .padding(.top, 16) // Zusätzliches Padding oben, nachdem ContentHeader entfernt wurde
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
                .blur(radius: blurBackground ? 5 : 0)
            }
        }
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            loadExample()
        }
        .onChange(of: currentStep) { newStep in
            if newStep >= 4 && storeManager.purchasedProductIDs.isEmpty {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    withAnimation {
                        blurBackground = true
                    }
                }
                showProSheet = true
            }
        }
        .sheet(isPresented: $showProSheet, onDismiss: {
            if currentStep >= 4 && storeManager.purchasedProductIDs.isEmpty {
                currentStep = 3
                if UIDevice.current.userInterfaceIdiom == .pad {
                    withAnimation {
                        blurBackground = false
                    }
                }
            }
        }) {
            if UIDevice.current.userInterfaceIdiom == .pad {
                iPadProFeaturesView()
                    .presentationDetents([.height(900), .large])
                    .presentationContentInteraction(.scrolls)
                    .presentationCornerRadius(16)
            } else {
                ProFeaturesView()
            }
        }
    }
    
    private func loadExample() {
        let language = SettingsModel.shared.language
        let langFolder = language == .english ? "en" : "de"
        
        // For debugging
        print("📘 DEBUG: Current topic title: '\(topic.title)'")
        
        // Convert the topic title to a filename based on language
        var fileName: String
        
        // English topic names need special mapping
        if language == .english {
            // Map English topic titles to their correct filenames
            switch topic.title {
            case "Sets and Mappings":
                fileName = "sets_and_mappings"
            case "Logic":
                fileName = "logic"
            case "Mathematical Induction":
                fileName = "mathematical_induction"
            case "Binomial Formulas":
                fileName = "binomial_formulas"
            case "Greatest Common Divisor":
                fileName = "greatest_common_divisor"
            case "Groups":
                fileName = "groups"
            case "Rings":
                fileName = "rings"
            case "Fields":
                fileName = "fields"
            case "Complex Numbers":
                fileName = "complex_numbers"
            case "Sequences and Series":
                fileName = "sequences_and_series"
            case "Limits":
                fileName = "limits"
            case "Differential Calculus":
                fileName = "differential_calculus"
            case "Integral Calculus":
                fileName = "integral_calculus"
            case "Multidimensional Calculus":
                fileName = "multidimensional_calculus"
            case "Matrices":
                fileName = "matrices"
            case "Vector Spaces":
                fileName = "vector_spaces"
            case "Determinants":
                fileName = "determinants"
            case "Linear Mappings":
                fileName = "linear_mappings"
            case "Eigenvalues and Eigenvectors":
                fileName = "eigenvalues_and_eigenvectors"
            default:
                // Fallback to normalized name if not in the map
                fileName = normalizedFileName(from: topic.title)
            }
        } else {
            // German topics - use the normalized title
            if topic.title == "Determinanten" {
                fileName = "determinanten" // Ensure correct German filename
            } else {
                fileName = normalizedFileName(from: topic.title)
            }
        }
        
        // Always append "_beispiel" to match the file naming convention
        fileName = fileName + "_beispiel"
        print("📘 DEBUG: Final filename: '\(fileName).json'")
        
        // Try several approaches to load the file
        
        // First try to load from language-specific folder
        let path1 = "beispiele/\(langFolder)/\(fileName).json"
        let path2 = "beispiele/\(fileName).json"
        let path3 = "\(fileName).json"
        
        print("📘 DEBUG: Trying to load from: \(path1)")
        
        // Approach 1: Try language-specific folder
        if let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json", subdirectory: "beispiele/\(langFolder)") {
            print("📘 DEBUG: Found file at path1: \(fileURL)")
            loadExampleFromURL(fileURL)
        }
        // Approach 2: Try with _fixed suffix (temporary fix for encoding issues)
        else if language == .english, let fileURL = Bundle.main.url(forResource: fileName + "_fixed", withExtension: "json", subdirectory: "beispiele/\(langFolder)") {
            print("📘 DEBUG: Found file with _fixed suffix: \(fileURL)")
            loadExampleFromURL(fileURL)
        }
        // Approach 3: Try root beispiele folder
        else if let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json", subdirectory: "beispiele") {
            print("📘 DEBUG: Found file at path2: \(fileURL)")
            loadExampleFromURL(fileURL)
        }
        // Approach 4: Try root bundle
        else if let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") {
            print("📘 DEBUG: Found file at path3: \(fileURL)")
            loadExampleFromURL(fileURL)
        }
        // Approach 5: Direct file path (last resort)
        else {
            let bundlePath = Bundle.main.bundlePath
            let filePath = bundlePath + "/beispiele/\(langFolder)/\(fileName).json"
            
            if FileManager.default.fileExists(atPath: filePath) {
                print("📘 DEBUG: Found file using direct path: \(filePath)")
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
                    do {
                        example = try JSONDecoder().decode(InteractiveExample.self, from: data)
                        print("📘 DEBUG: Successfully decoded example")
                        isLoading = false
                        
                        withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
                            showProgress = true
                        }
                        
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.6)) {
                            showCurrentStep = true
                        }
                    } catch {
                        print("📘 DEBUG: JSON decode error: \(error)")
                        self.error = error
                        isLoading = false
                    }
                } catch {
                    handleExampleNotFound(fileName: fileName, language: language)
                }
            } else {
                handleExampleNotFound(fileName: fileName, language: language)
            }
        }
    }
    
    // Helper method to load and decode an example from a URL
    private func loadExampleFromURL(_ fileURL: URL) {
        do {
            let data = try Data(contentsOf: fileURL)
            print("Daten erfolgreich geladen, Größe: \(data.count) bytes")
            
            do {
                example = try JSONDecoder().decode(InteractiveExample.self, from: data)
                print("JSON erfolgreich dekodiert")
                isLoading = false
                
                withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
                    showProgress = true
                }
                
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.6)) {
                    showCurrentStep = true
                }
            } catch {
                print("📘 DEBUG: JSON decode error: \(error)")
                self.error = error
                isLoading = false
            }
        } catch {
            print("Fehler beim Laden/Dekodieren: \(error)")
            self.error = error
            isLoading = false
        }
    }
    
    // Helper method to handle file not found
    private func handleExampleNotFound(fileName: String, language: AppLanguage) {
        print("Datei nicht gefunden: \(fileName).json in keinem Verzeichnis")
        print("📘 DEBUG: File not found in any location")
        
        let errorMessage = language == .english ? 
            "Example file not found: \(fileName).json" : 
            "Beispieldatei nicht gefunden: \(fileName).json"
        error = NSError(domain: "", code: -1, userInfo: [
            NSLocalizedDescriptionKey: errorMessage
        ])
        isLoading = false
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
                            Text(SettingsModel.shared.language == .english ? "Step by Step Explanation" : "Schritt für Schritt Erklärung")
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

// MARK: - iPadProFeaturesView - Optimiert für Sheet-Darstellung
struct iPadProFeaturesView: View {
    @StateObject private var storeManager = StoreKitManager.shared
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @ObservedObject private var settings = SettingsModel.shared
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding(.trailing, 20)
                        .padding(.top, 16)
                }
            }
            
            ScrollView {
                VStack(spacing: 15) {
                    // Header mit reduziertem Abstand
                    HStack(spacing: 20) {
                        // Logo
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .shadow(color: Color.blue.opacity(0.2), radius: 6, x: 0, y: 3)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            // Titel
                            Text(settings.language == .english ? "University Math Pro" : "Höhere Mathematik Pro")
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.9))
                            
                            // Untertitel
                            Text(settings.language == .english ? "Unlock all content" : "Schalte alle Inhalte frei")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color.gray.opacity(0.8))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    // Features in Grid-Layout für bessere Platznutzung
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 300, maximum: 400), spacing: 16)
                    ], spacing: 16) {
                        FeatureRow(icon: "checkmark.circle.fill", 
                                   text: settings.language == .english ? "Unlock all interactive lessons" : "Alle interaktiven Lektionen freischalten")
                        FeatureRow(icon: "books.vertical.fill", 
                                   text: settings.language == .english ? "Full access to over 300 exercises" : "Vollen Zugriff auf über 300 Aufgaben")
                        FeatureRow(icon: "list.bullet.rectangle.fill", 
                                  text: settings.language == .english ? "Detailed solution steps" : "Detaillierte Lösungschritte")
                        FeatureRow(icon: "star.fill", 
                                  text: settings.language == .english ? "Support ongoing development" : "Unterstütze die Weiterentwicklung")
                    }
                    .padding(.horizontal, 20)
                    
                    // Kaufoptionen
                    if storeManager.purchasedProductIDs.contains("unimathe.pro.lifetime") {
                        VStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.3))
                            
                            Text(settings.language == .english ? "You are already enjoying all Pro features!" : "Du genießt bereits alle Pro-Features!")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.3))
                        }
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 0.9, green: 1.0, blue: 0.95))
                                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
                        )
                        .padding(.horizontal, 20)
                    } else {
                        VStack(spacing: 16) {
                            ForEach(storeManager.products.filter { $0.id == "unimathe.pro.lifetime" }) { product in
                                PurchaseButton(product: product)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Restore Purchases
                    Button(action: {
                        Task {
                            await storeManager.updatePurchasedProducts()
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 14))
                            Text(settings.language == .english ? "Restore Purchases" : "Käufe wiederherstellen")
                                .fontWeight(.medium)
                        }
                        .font(.subheadline)
                        .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.9))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background(Color.blue.opacity(0.06))
                        .cornerRadius(14)
                    }
                }
                .padding(.bottom, 15)
            }
        }
        .background(Color.white)
        .cornerRadius(16)
        .frame(maxWidth: horizontalSizeClass == .regular ? 900 : .infinity)
        .frame(height: horizontalSizeClass == .regular ? 900 : nil)
    }
}

