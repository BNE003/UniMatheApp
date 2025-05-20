import SwiftUI

struct SubTopicsView: View {
    let topic: MathTopic
    @State private var subTopics: [MathTopic] = []
    @State private var isLoading = true
    @State private var error: Error?
    
    var body: some View {
        ZStack {
            // Modern abstract background
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
                    // Large blue circle
                    Circle()
                        .fill(Color.blue.opacity(0.05))
                        .frame(width: geometry.size.width * 1.2)
                        .offset(x: -geometry.size.width * 0.2, y: -geometry.size.height * 0.1)
                    
                    // Medium purple circle
                    Circle()
                        .fill(Color.purple.opacity(0.03))
                        .frame(width: geometry.size.width * 0.8)
                        .offset(x: geometry.size.width * 0.3, y: geometry.size.height * 0.3)
                    
                    // Small blue circle
                    Circle()
                        .fill(Color.blue.opacity(0.04))
                        .frame(width: geometry.size.width * 0.4)
                        .offset(x: -geometry.size.width * 0.3, y: geometry.size.height * 0.4)
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
                    Text(SettingsModel.shared.language == .english ? "Error loading data" : "Fehler beim Laden der Daten")
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
                    VStack(spacing: 20) {
                        // Learning content section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Lerninhalte")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ], spacing: 16) {
                                ForEach(subTopics) { subTopic in
                                    NavigationLink(destination: ContentSelectionView(topic: subTopic)) {
                                        SubTopicCard(topic: subTopic)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            loadSubTopics()
        }
    }
    
    private func loadSubTopics() {
        // Get localized index file
        let language = SettingsModel.shared.language
        let languageSuffix = language == .english ? "_en" : ""
        let indexName = "index" + languageSuffix
        var indexUrl: URL?
        
        // Debug prints to diagnose bundle issues
        print("🔍 SUBTOPICS DEBUG: Current language: \(language.rawValue)")
        print("🔍 SUBTOPICS DEBUG: Loading subtopics for topic ID: \(topic.id) with title: \(topic.title)")
        
        // First try with language suffix
        if let url = Bundle.main.url(forResource: indexName, withExtension: "json") {
            print("🔍 SUBTOPICS DEBUG: Found index with language suffix at root")
            indexUrl = url
        }
        // Fallback to base name
        else if let url = Bundle.main.url(forResource: "index", withExtension: "json") {
            print("🔍 SUBTOPICS DEBUG: Found index at root level")
            indexUrl = url
        }
        else {
            // Try inside lerninhalt folder
            if let url = Bundle.main.url(forResource: indexName, withExtension: "json", subdirectory: "lerninhalt") {
                print("🔍 SUBTOPICS DEBUG: Found index with language suffix in lerninhalt/")
                indexUrl = url
            } 
            else if let url = Bundle.main.url(forResource: "index", withExtension: "json", subdirectory: "lerninhalt") {
                print("🔍 SUBTOPICS DEBUG: Found index in lerninhalt/")
                indexUrl = url
            }
            // Try inside language folders
            else if let url = Bundle.main.url(forResource: indexName, withExtension: "json", subdirectory: "lerninhalt/\(language.rawValue)") {
                print("🔍 SUBTOPICS DEBUG: Found index with language suffix in lerninhalt/\(language.rawValue)/")
                indexUrl = url
            }
            else if let url = Bundle.main.url(forResource: "index", withExtension: "json", subdirectory: "lerninhalt/\(language.rawValue)") {
                print("🔍 SUBTOPICS DEBUG: Found index in lerninhalt/\(language.rawValue)/")
                indexUrl = url
            }
            else {
                print("🔍 SUBTOPICS DEBUG: Could not find any index file")
                let errorMessage = language == .english ? 
                    "Index file not found in bundle" : 
                    "Index-Datei nicht im Bundle gefunden"
                error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                isLoading = false
                return
            }
        }
        
        do {
            print("🔍 SUBTOPICS DEBUG: Loading from URL: \(indexUrl!)")
            let indexData = try Data(contentsOf: indexUrl!)
            let indexResponse = try JSONDecoder().decode(IndexResponse.self, from: indexData)
            
            // Find the current topic in the index
            if let topicIndex = indexResponse.topics.first(where: { $0.id == topic.id }),
               let subTopicIndices = topicIndex.subTopics {
                
                print("🔍 SUBTOPICS DEBUG: Found matching topic with ID: \(topicIndex.id)")
                var loadedSubTopics: [MathTopic] = []
                
                // Load each subtopic from its individual file
                for subTopicIndex in subTopicIndices {
                    print("🔍 SUBTOPICS DEBUG: Loading subtopic: \(subTopicIndex.title) with ID: \(subTopicIndex.id)")
                    
                    // Get the filename without extension
                    let filenameWithoutExtension = subTopicIndex.filename.replacingOccurrences(of: ".json", with: "")
                    
                    // Add language suffix for non-German languages
                    let localizedFilename = filenameWithoutExtension + languageSuffix
                    let subTopicUrl: URL?
                    
                    // Try to find the content file - prioritize files in the root with language suffix
                    if let url = Bundle.main.url(forResource: localizedFilename, withExtension: "json") {
                        print("🔍 SUBTOPICS DEBUG: Found subtopic \(localizedFilename) at root level")
                        subTopicUrl = url
                    }
                    // Fallback to the original filename at root
                    else if let url = Bundle.main.url(forResource: filenameWithoutExtension, withExtension: "json") {
                        print("🔍 SUBTOPICS DEBUG: Found subtopic \(filenameWithoutExtension) at root level")
                        subTopicUrl = url
                    }
                    // Then try inside lerninhalt folder
                    else if let url = Bundle.main.url(forResource: localizedFilename, withExtension: "json", subdirectory: "lerninhalt") {
                        print("🔍 SUBTOPICS DEBUG: Found subtopic \(localizedFilename) in lerninhalt/")
                        subTopicUrl = url
                    }
                    else if let url = Bundle.main.url(forResource: filenameWithoutExtension, withExtension: "json", subdirectory: "lerninhalt") {
                        print("🔍 SUBTOPICS DEBUG: Found subtopic \(filenameWithoutExtension) in lerninhalt/")
                        subTopicUrl = url
                    }
                    // Finally try in language-specific folders
                    else if let url = Bundle.main.url(forResource: localizedFilename, withExtension: "json", subdirectory: "lerninhalt/\(language.rawValue)") {
                        print("🔍 SUBTOPICS DEBUG: Found subtopic \(localizedFilename) in lerninhalt/\(language.rawValue)/")
                        subTopicUrl = url
                    }
                    else if let url = Bundle.main.url(forResource: filenameWithoutExtension, withExtension: "json", subdirectory: "lerninhalt/\(language.rawValue)") {
                        print("🔍 SUBTOPICS DEBUG: Found subtopic \(filenameWithoutExtension) in lerninhalt/\(language.rawValue)/")
                        subTopicUrl = url
                    }
                    else {
                        let errorMessage = language == .english ? 
                            "Could not find file for subtopic" : 
                            "Datei für Unterthema nicht gefunden"
                        print("\(errorMessage): \(subTopicIndex.title) with ID: \(subTopicIndex.id), filename: \(subTopicIndex.filename)")
                        continue
                    }
                    
                    do {
                        let subTopicData = try Data(contentsOf: subTopicUrl!)
                        let subTopic = try JSONDecoder().decode(MathTopic.self, from: subTopicData)
                        loadedSubTopics.append(subTopic)
                        print("🔍 SUBTOPICS DEBUG: Successfully loaded subtopic: \(subTopic.title)")
                    } catch {
                        print("Error loading subtopic \(subTopicIndex.title): \(error)")
                        continue
                    }
                }
                
                subTopics = loadedSubTopics
            } else {
                // If no subtopics are found in the index, use the ones from the topic object if available
                if let existingSubTopics = topic.subTopics {
                    subTopics = existingSubTopics
                    print("🔍 SUBTOPICS DEBUG: Using existing subtopics from topic object")
                } else {
                    print("🔍 SUBTOPICS DEBUG: No subtopics found for topic: \(topic.title)")
                }
            }
            isLoading = false
        } catch {
            print("Error loading index: \(error)")
            self.error = error
            isLoading = false
        }
    }
}

struct SubTopicCard: View {
    let topic: MathTopic
    
    var body: some View {
        VStack {
            if topic.title == "Integralrechnung" || topic.title == "Integral Calculus" {
                Image("integral")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 45, height: 45)
                    .padding(9.5)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.blue,
                                        Color.blue.opacity(0.8)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    )
                    .padding()
            } else if topic.title == "Mehrdimensionale Analysis" || topic.title == "Multidimensional Calculus" {
                Image("mehrdimensionale_analysis")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 45, height: 45)
                    .padding(9.5)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.blue,
                                        Color.blue.opacity(0.8)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    )
                    .padding()
            } else if topic.title == "Differentialrechnung" || topic.title == "Differential Calculus" {
                Image("differentialrechnung")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 45, height: 45)
                    .padding(9.5)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.blue,
                                        Color.blue.opacity(0.8)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    )
                    .padding()
            } else if topic.title == "Matrizen" || topic.title == "Matrices" {
                Image("matrizen")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 45, height: 45)
                    .padding(9.5)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.blue,
                                        Color.blue.opacity(0.8)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    )
                    .padding()
            } else if topic.title == "Vektorräume" || topic.title == "Vector Spaces" {
                Image("vektor")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 45, height: 45)
                    .padding(9.5)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.blue,
                                        Color.blue.opacity(0.8)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    )
                    .padding()
            } else if topic.title == "Lineare Abbildungen" || topic.title == "Linear Mappings" {
                Image("abbildung")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 45, height: 45)
                    .padding(9.5)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.blue,
                                        Color.blue.opacity(0.8)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    )
                    .padding()
            } else if topic.title == "Determinanten" || topic.title == "Determinants" {
                Image("determinante")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 45, height: 45)
                    .padding(9.5)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.blue,
                                        Color.blue.opacity(0.8)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    )
                    .padding()
            } else if topic.title == "Eigenwerte und Eigenvektoren" || topic.title == "Eigenvalues and Eigenvectors" {
                Image("eigenwerte")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 45, height: 45)
                    .padding(9.5)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.blue,
                                        Color.blue.opacity(0.8)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    )
                    .padding()
            } else {
                Image(systemName: topic.icon)
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                    .frame(width: 64, height: 64)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.blue,
                                        Color.blue.opacity(0.8)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    )
                    .padding()
            }
            
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

struct ContentSelectionView: View {
    let topic: MathTopic
    @State private var loadedTopic: MathTopic?
    @State private var isLoading = true
    @State private var error: Error?
    
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
                    Text(SettingsModel.shared.language == .english ? "Error loading data" : "Fehler beim Laden der Daten")
                        .font(.headline)
                        .foregroundColor(.red)
                    Text(error.localizedDescription)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            } else {
                VStack(spacing: 20) {
                    Text(SettingsModel.shared.language == .english ? "Choose:" : "Wählen Sie aus:")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 40)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        // Lerninhalte tile
                        NavigationLink(destination: TopicDetailView(topic: loadedTopic ?? topic)) {
                            SubTopicCard(topic: MathTopic(
                                id: "\(topic.id)_learn",
                                title: SettingsModel.shared.language == .english ? "Learning Content" : "Lerninhalte",
                                icon: "book.fill",
                                description: SettingsModel.shared.language == .english ? 
                                    "Access to learning materials and explanations." : 
                                    "Zugang zu den Lernmaterialien und Erklärungen."
                            ))
                        }
                        
                        // Übungen tile
                        NavigationLink(destination: ExercisesView(topic: loadedTopic ?? topic)) {
                            SubTopicCard(topic: MathTopic(
                                id: "\(topic.id)_exercises",
                                title: SettingsModel.shared.language == .english ? "Exercises" : "Übungen",
                                icon: "pencil.and.list.clipboard",
                                description: SettingsModel.shared.language == .english ? 
                                    "Interactive exercises and problems on the topic." : 
                                    "Interaktive Übungen und Aufgaben zum Thema."
                            ))
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
        }
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            loadTopicContent()
        }
    }
    
    private func loadTopicContent() {
        // Get localized index file
        let language = SettingsModel.shared.language
        let languageSuffix = language == .english ? "_en" : ""
        let indexName = "index" + languageSuffix
        var indexUrl: URL?
        
        // Debug prints to diagnose bundle issues
        print("🔍 TOPIC DEBUG: Current language: \(language.rawValue)")
        print("🔍 TOPIC DEBUG: Current topic: \(topic.title) with ID: \(topic.id)")
        
        // First try with language suffix
        if let url = Bundle.main.url(forResource: indexName, withExtension: "json") {
            print("🔍 TOPIC DEBUG: Found index with language suffix at root")
            indexUrl = url
        }
        // Fallback to base name
        else if let url = Bundle.main.url(forResource: "index", withExtension: "json") {
            print("🔍 TOPIC DEBUG: Found index at root level")
            indexUrl = url
        }
        else {
            // Try inside lerninhalt folder
            if let url = Bundle.main.url(forResource: indexName, withExtension: "json", subdirectory: "lerninhalt") {
                print("🔍 TOPIC DEBUG: Found index with language suffix in lerninhalt/")
                indexUrl = url
            } 
            else if let url = Bundle.main.url(forResource: "index", withExtension: "json", subdirectory: "lerninhalt") {
                print("🔍 TOPIC DEBUG: Found index in lerninhalt/")
                indexUrl = url
            }
            // Try inside language folders
            else if let url = Bundle.main.url(forResource: indexName, withExtension: "json", subdirectory: "lerninhalt/\(language.rawValue)") {
                print("🔍 TOPIC DEBUG: Found index with language suffix in lerninhalt/\(language.rawValue)/")
                indexUrl = url
            }
            else if let url = Bundle.main.url(forResource: "index", withExtension: "json", subdirectory: "lerninhalt/\(language.rawValue)") {
                print("🔍 TOPIC DEBUG: Found index in lerninhalt/\(language.rawValue)/")
                indexUrl = url
            }
            else {
                print("🔍 TOPIC DEBUG: Could not find any index file")
                let errorMessage = language == .english ? 
                    "Index file not found in bundle" : 
                    "Index-Datei nicht im Bundle gefunden"
                error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                isLoading = false
                return
            }
        }
        
        do {
            print("🔍 TOPIC DEBUG: Loading from URL: \(indexUrl!)")
            let indexData = try Data(contentsOf: indexUrl!)
            let indexResponse = try JSONDecoder().decode(IndexResponse.self, from: indexData)
            
            // Find the current topic in the index - use ID instead of title for comparison
            var filename: String?
            let topicID = topic.id
            
            // First extract the ID without any potential suffix (like "_learn" or "_exercises")
            let baseTopicID = topicID.split(separator: "_").first.map(String.init) ?? topicID
            print("🔍 TOPIC DEBUG: Looking for topic with base ID: \(baseTopicID)")
            
            // Search for the topic in the index by ID, not by title
            for topicIndex in indexResponse.topics {
                if let subTopics = topicIndex.subTopics {
                    if let subTopic = subTopics.first(where: { $0.id == baseTopicID }) {
                        filename = subTopic.filename
                        print("🔍 TOPIC DEBUG: Found matching subtopic with ID \(subTopic.id), filename: \(subTopic.filename)")
                        break
                    }
                }
            }
            
            guard let fullFilename = filename else {
                let errorMessage = language == .english ? 
                    "Topic not found in index" : 
                    "Thema nicht im Index gefunden"
                print("🔍 TOPIC DEBUG: Error - \(errorMessage) for ID: \(baseTopicID)")
                error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                isLoading = false
                return
            }
            
            // Get the filename without extension
            let filenameWithoutExtension = fullFilename.replacingOccurrences(of: ".json", with: "")
            
            // Add language suffix for non-German languages
            let localizedFilename = filenameWithoutExtension + languageSuffix
            var topicUrl: URL?
            
            // Try to find the content file - prioritize files in the root with language suffix
            if let url = Bundle.main.url(forResource: localizedFilename, withExtension: "json") {
                print("🔍 TOPIC DEBUG: Found topic \(localizedFilename) at root level")
                topicUrl = url
            }
            // Fallback to the original filename at root
            else if let url = Bundle.main.url(forResource: filenameWithoutExtension, withExtension: "json") {
                print("🔍 TOPIC DEBUG: Found topic \(filenameWithoutExtension) at root level")
                topicUrl = url
            }
            // Then try inside lerninhalt folder
            else if let url = Bundle.main.url(forResource: localizedFilename, withExtension: "json", subdirectory: "lerninhalt") {
                print("🔍 TOPIC DEBUG: Found topic \(localizedFilename) in lerninhalt/")
                topicUrl = url
            }
            else if let url = Bundle.main.url(forResource: filenameWithoutExtension, withExtension: "json", subdirectory: "lerninhalt") {
                print("🔍 TOPIC DEBUG: Found topic \(filenameWithoutExtension) in lerninhalt/")
                topicUrl = url
            }
            // Finally try in language-specific folders
            else if let url = Bundle.main.url(forResource: localizedFilename, withExtension: "json", subdirectory: "lerninhalt/\(language.rawValue)") {
                print("🔍 TOPIC DEBUG: Found topic \(localizedFilename) in lerninhalt/\(language.rawValue)/")
                topicUrl = url
            }
            else if let url = Bundle.main.url(forResource: filenameWithoutExtension, withExtension: "json", subdirectory: "lerninhalt/\(language.rawValue)") {
                print("🔍 TOPIC DEBUG: Found topic \(filenameWithoutExtension) in lerninhalt/\(language.rawValue)/")
                topicUrl = url
            }
            else {
                let errorMessage = language == .english ? 
                    "Topic file not found in bundle" : 
                    "Themendatei nicht im Bundle gefunden"
                print("🔍 TOPIC DEBUG: Error - \(errorMessage) for file: \(localizedFilename)")
                error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                isLoading = false
                return
            }
            
            do {
                print("🔍 TOPIC DEBUG: Loading topic data from: \(topicUrl!)")
                let data = try Data(contentsOf: topicUrl!)
                let loadedTopic = try JSONDecoder().decode(MathTopic.self, from: data)
                self.loadedTopic = loadedTopic
                isLoading = false
            } catch {
                print("Error loading topic data: \(error)")
                self.error = error
                isLoading = false
            }
        } catch {
            print("Error loading index: \(error)")
            self.error = error
            isLoading = false
        }
    }
}
