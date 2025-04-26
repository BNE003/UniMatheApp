import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ComplexNumbersViewModel()
    
    var body: some View {
        TabView {
            NavigationView {
                ScrollView {
                    if let content = viewModel.content {
                        VStack(spacing: 20) {
                            // Main Content Card
                            ContentCard(
                                title: content.title,
                                icon: content.icon,
                                description: content.description
                            )
                            
                            // Theory Sections
                            ForEach(content.content.sections) { section in
                                TheorySectionCard(section: section)
                            }
                            
                            // Examples
                            ForEach(content.content.examples) { example in
                                ExampleCard(example: example)
                            }
                            
                            // Exercise Cards
                            ForEach(content.exercises) { exercise in
                                ExerciseCard(exercise: exercise)
                            }
                        }
                        .padding()
                    } else if viewModel.isLoading {
                        ProgressView("Loading content...")
                    } else if viewModel.error != nil {
                        VStack {
                            Text("Failed to load content")
                                .foregroundColor(.red)
                            Button("Retry") {
                                Task {
                                    await viewModel.loadContent()
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Lerninhalte")
            }
            .tabItem {
                Label("Lerninhalte", systemImage: "book.fill")
            }
            
            Text("Statistik")
                .tabItem {
                    Label("Statistik", systemImage: "chart.bar.fill")
                }
            
            Text("Einstellungen")
                .tabItem {
                    Label("Einstellungen", systemImage: "gear")
                }
        }
        .task {
            await viewModel.loadContent()
        }
    }
}

// MARK: - Supporting Views

struct ContentCard: View {
    let title: String
    let icon: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title)
                Text(title)
                    .font(.title2)
                    .bold()
            }
            
            Text(description)
                .font(.body)
                .lineLimit(3)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
}

struct TheorySectionCard: View {
    let section: ComplexNumbersContent.Content.Section
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(section.title)
                .font(.headline)
            
            Text(section.content)
                .font(.body)
            
            ForEach(section.formulas, id: \.expression) { formula in
                VStack(alignment: .leading, spacing: 4) {
                    Text(formula.expression)
                        .font(.system(.body, design: .monospaced))
                    Text(formula.explanation)
                        .font(.caption)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
    }
}

struct ExampleCard: View {
    let example: ComplexNumbersContent.Content.Example
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(example.title)
                .font(.headline)
            
            Text(example.description)
                .font(.body)
            
            ForEach(example.solution, id: \.step) { step in
                VStack(alignment: .leading, spacing: 4) {
                    Text(step.step)
                        .font(.subheadline)
                    Text(step.explanation)
                        .font(.caption)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }
}

struct ExerciseCard: View {
    let exercise: ComplexNumbersContent.ComplexExercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(exercise.title)
                .font(.headline)
            
            Text(exercise.description)
                .font(.subheadline)
                .lineLimit(2)
            
            HStack {
                Text("Difficulty: \(exercise.difficulty)")
                    .font(.caption)
                Spacer()
                Text("Points: \(exercise.points)")
                    .font(.caption)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.purple.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    ContentView()
} 