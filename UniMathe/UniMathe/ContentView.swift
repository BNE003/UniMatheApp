//
//  ContentView.swift
//  UniMathe
//
//  Created by Benedikt Held on 24.04.25.
//

import SwiftUI

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
        guard let url = Bundle.main.url(forResource: "math_topics", withExtension: "json") else {
            error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "JSON file not found"])
            isLoading = false
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let response = try JSONDecoder().decode(MathTopicsResponse.self, from: data)
            topics = response.topics
            isLoading = false
        } catch {
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

struct SubTopicsView: View {
    let topic: MathTopic
    
    var body: some View {
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
                            ForEach(topic.subTopics ?? []) { subTopic in
                                NavigationLink(destination: ContentSelectionView(topic: subTopic)) {
                                    TopicCard(topic: subTopic)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ContentSelectionView: View {
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
                Text("Wählen Sie aus:")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 16) {
                    // Lerninhalte tile
                    NavigationLink(destination: TopicDetailView(topic: topic)) {
                        TopicCard(topic: MathTopic(
                            id: "\(topic.id)_learn",
                            title: "Lerninhalte",
                            icon: "book.fill",
                            description: "Zugang zu den Lernmaterialien und Erklärungen."
                        ))
                    }
                    
                    // Übungen tile
                    NavigationLink(destination: ExercisesView(topic: topic)) {
                        TopicCard(topic: MathTopic(
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
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ExercisesView: View {
    let topic: MathTopic
    @State private var selectedDifficulty: Difficulty?
    
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
                
                if let selectedDifficulty = selectedDifficulty {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(getExercises(for: topic.title, difficulty: selectedDifficulty), id: \.id) { exercise in
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
    }
    
    private func getExercises(for topic: String, difficulty: Difficulty) -> [Exercise] {
        switch topic {
        case "Mengen und Abbildungen":
            switch difficulty {
            case .easy:
                return [
                    Exercise(
                        id: 1,
                        title: "Mengenoperationen",
                        description: "Gegeben sind die Mengen A = {1, 2, 3, 4} und B = {3, 4, 5, 6}. Bestimmen Sie:\n1. A ∪ B\n2. A ∩ B\n3. A \\ B\n4. B \\ A",
                        difficulty: .easy,
                        points: 5
                    ),
                    Exercise(
                        id: 2,
                        title: "Teilmengen",
                        description: "Welche der folgenden Aussagen sind wahr?\n1. {1, 2} ⊆ {1, 2, 3}\n2. {1, 2, 3} ⊆ {1, 2}\n3. ∅ ⊆ {1, 2, 3}\n4. {1, 2, 3} ⊆ ∅",
                        difficulty: .easy,
                        points: 5
                    ),
                    Exercise(
                        id: 3,
                        title: "Kartesisches Produkt",
                        description: "Gegeben sind die Mengen A = {a, b} und B = {1, 2}. Bestimmen Sie A × B.",
                        difficulty: .easy,
                        points: 5
                    ),
                    Exercise(
                        id: 10,
                        title: "Potenzmenge",
                        description: "Bestimmen Sie die Potenzmenge P(A) für A = {1, 2, 3}.",
                        difficulty: .easy,
                        points: 5
                    ),
                    Exercise(
                        id: 11,
                        title: "Mengengleichheit",
                        description: "Sind die Mengen A = {1, 2, 3} und B = {3, 2, 1} gleich? Begründen Sie Ihre Antwort.",
                        difficulty: .easy,
                        points: 5
                    )
                ]
            case .medium:
                return [
                    Exercise(
                        id: 4,
                        title: "Abbildungseigenschaften",
                        description: "Untersuchen Sie die Abbildung f: ℝ → ℝ, f(x) = x² auf Injektivität und Surjektivität. Begründen Sie Ihre Antwort.",
                        difficulty: .medium,
                        points: 10
                    ),
                    Exercise(
                        id: 5,
                        title: "Komposition von Abbildungen",
                        description: "Gegeben sind die Abbildungen f: ℝ → ℝ, f(x) = 2x + 1 und g: ℝ → ℝ, g(x) = x².\nBestimmen Sie f∘g und g∘f.",
                        difficulty: .medium,
                        points: 10
                    ),
                    Exercise(
                        id: 6,
                        title: "Mengenidentitäten",
                        description: "Beweisen Sie die Distributivgesetze für Mengen:\n1. A ∩ (B ∪ C) = (A ∩ B) ∪ (A ∩ C)\n2. A ∪ (B ∩ C) = (A ∪ B) ∩ (A ∪ C)",
                        difficulty: .medium,
                        points: 10
                    ),
                    Exercise(
                        id: 12,
                        title: "Inverse Abbildungen",
                        description: "Gegeben ist die Abbildung f: ℝ → ℝ, f(x) = 3x - 2.\nBestimmen Sie die Umkehrabbildung f⁻¹ und zeigen Sie, dass f⁻¹∘f = id und f∘f⁻¹ = id gilt.",
                        difficulty: .medium,
                        points: 10
                    ),
                    Exercise(
                        id: 13,
                        title: "Mengenoperationen mit Intervallen",
                        description: "Gegeben sind die Intervalle A = [0, 2] und B = [1, 3].\nBestimmen Sie A ∩ B, A ∪ B und A \\ B.",
                        difficulty: .medium,
                        points: 10
                    )
                ]
            case .hard:
                return [
                    Exercise(
                        id: 7,
                        title: "Bijektive Abbildungen",
                        description: "Zeigen Sie, dass die Abbildung f: ℝ → ℝ, f(x) = x³ + 2x bijektiv ist. Bestimmen Sie die Umkehrabbildung f⁻¹.",
                        difficulty: .hard,
                        points: 15
                    ),
                    Exercise(
                        id: 8,
                        title: "Mächtigkeit von Mengen",
                        description: "Beweisen Sie, dass die Menge der rationalen Zahlen ℚ abzählbar unendlich ist.",
                        difficulty: .hard,
                        points: 15
                    ),
                    Exercise(
                        id: 9,
                        title: "Äquivalenzrelationen",
                        description: "Sei M eine nichtleere Menge. Zeigen Sie, dass die Relation R = {(A,B) ∈ P(M) × P(M) | |A| = |B|} eine Äquivalenzrelation auf der Potenzmenge P(M) ist.",
                        difficulty: .hard,
                        points: 15
                    ),
                    Exercise(
                        id: 14,
                        title: "Kardinalität von Mengen",
                        description: "Zeigen Sie, dass die Menge der reellen Zahlen ℝ überabzählbar ist, indem Sie das Cantorsche Diagonalargument verwenden.",
                        difficulty: .hard,
                        points: 15
                    ),
                    Exercise(
                        id: 15,
                        title: "Komplexe Mengenoperationen",
                        description: "Beweisen Sie die De Morganschen Gesetze für Mengen:\n1. (A ∪ B)ᶜ = Aᶜ ∩ Bᶜ\n2. (A ∩ B)ᶜ = Aᶜ ∪ Bᶜ",
                        difficulty: .hard,
                        points: 15
                    )
                ]
            }
        default:
            return [
                Exercise(
                    id: 1,
                    title: "Beispielaufgabe",
                    description: "Dies ist eine Beispielaufgabe zum Thema \(topic)",
                    difficulty: difficulty,
                    points: difficulty == .easy ? 5 : (difficulty == .medium ? 10 : 15)
                )
            ]
        }
    }
}

struct ExerciseCard: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(exercise.title)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("\(exercise.points) Punkte")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            
            Text(exercise.description)
                .font(.body)
                .foregroundColor(.gray)
                .lineSpacing(4)
            
            HStack {
                Text(exercise.difficulty.text)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(exercise.difficulty.color)
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

struct Exercise: Identifiable {
    let id: Int
    let title: String
    let description: String
    let difficulty: Difficulty
    let points: Int
}

enum Difficulty {
    case easy, medium, hard
    
    var color: Color {
        switch self {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
    
    var text: String {
        switch self {
        case .easy: return "Einfach"
        case .medium: return "Mittel"
        case .hard: return "Schwer"
        }
    }
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
                        LaTeXView(content: markdownContent)
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
