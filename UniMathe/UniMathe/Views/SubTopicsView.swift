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
        // Lade die Dateien aus dem App-Bundle ("lerninhalt"-Unterordner) statt über absolute Pfade
        guard let indexUrl = Bundle.main.url(forResource: "index", withExtension: "json", subdirectory: "lerninhalt") ??
              Bundle.main.url(forResource: "index", withExtension: "json") else {
            error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Index file not found in bundle"])
            isLoading = false
            return
        }
        
        do {
            let indexData = try Data(contentsOf: indexUrl)
            let indexResponse = try JSONDecoder().decode(IndexResponse.self, from: indexData)
            
            // Find the current topic in the index
            if let topicIndex = indexResponse.topics.first(where: { $0.id == topic.id }),
               let subTopicIndices = topicIndex.subTopics {
                
                var loadedSubTopics: [MathTopic] = []
                
                // Load each subtopic from its individual file
                for subTopicIndex in subTopicIndices {
                    guard let subTopicUrl = Bundle.main.url(forResource: subTopicIndex.filename, withExtension: nil, subdirectory: "lerninhalt") ??
                          Bundle.main.url(forResource: subTopicIndex.filename, withExtension: nil) else {
                        print("Could not find file for subtopic: \(subTopicIndex.title) in bundle")
                        continue
                    }
                    
                    let subTopicData = try Data(contentsOf: subTopicUrl)
                    let subTopic = try JSONDecoder().decode(MathTopic.self, from: subTopicData)
                    loadedSubTopics.append(subTopic)
                }
                
                subTopics = loadedSubTopics
            } else {
                // If no subtopics are found in the index, use the ones from the topic object if available
                if let existingSubTopics = topic.subTopics {
                    subTopics = existingSubTopics
                }
            }
            isLoading = false
        } catch {
            print("Error loading subtopics: \(error)")
            self.error = error
            isLoading = false
        }
    }
}

struct SubTopicCard: View {
    let topic: MathTopic
    
    var body: some View {
        VStack {
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
                VStack(spacing: 20) {
                    Text("Wählen Sie aus:")
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
                                title: "Lerninhalte",
                                icon: "book.fill",
                                description: "Zugang zu den Lernmaterialien und Erklärungen."
                            ))
                        }
                        
                        // Übungen tile
                        NavigationLink(destination: ExercisesView(topic: loadedTopic ?? topic)) {
                            SubTopicCard(topic: MathTopic(
                                id: "\(topic.id)_exercises",
                                title: "Übungen",
                                icon: "pencil.and.list.clipboard",
                                description: "Interaktive Übungen und Aufgaben zum Thema."
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
        // Convert topic title to filename
        let filename = normalizedFileName(from: topic.title)
        let fullFilename = "\(filename)_content.json"
        
        guard let url = Bundle.main.url(forResource: fullFilename, withExtension: nil, subdirectory: "lerninhalt") ??
              Bundle.main.url(forResource: fullFilename, withExtension: nil) else {
            error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Topic file not found in bundle"])
            isLoading = false
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let loadedTopic = try JSONDecoder().decode(MathTopic.self, from: data)
            self.loadedTopic = loadedTopic
            isLoading = false
        } catch {
            print("Error loading topic content: \(error)")
            self.error = error
            isLoading = false
        }
    }
}
