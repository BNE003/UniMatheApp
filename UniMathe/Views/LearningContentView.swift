import SwiftUI

struct LearningContentView: View {
    @StateObject private var viewModel = LearningContentViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.learningContents) { content in
                    NavigationLink(destination: LearningContentDetailView(content: content)) {
                        LearningContentRowView(content: content)
                    }
                }
            }
            .navigationTitle("Lerninhalte")
            .searchable(text: $searchText, prompt: "Suche nach Lerninhalten")
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
        }
    }
}

struct LearningContentRowView: View {
    let content: LearningContent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: content.category.icon)
                    .foregroundColor(.blue)
                Text(content.title)
                    .font(.headline)
            }
            
            Text(content.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            Text(content.category.rawValue)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
        }
        .padding(.vertical, 8)
    }
}

struct LearningContentDetailView: View {
    let content: LearningContent
    @State private var selectedSection: ContentSection?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(content.title)
                    .font(.title)
                    .bold()
                
                Text(content.description)
                    .font(.body)
                
                Text(content.category.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                
                ForEach(content.content) { section in
                    ContentSectionView(section: section)
                }
                
                if !content.examples.isEmpty {
                    Text("Beispiele")
                        .font(.title2)
                        .bold()
                        .padding(.top)
                    
                    ForEach(content.examples) { example in
                        ExampleView(example: example)
                    }
                }
                
                if let visualizations = content.visualizations {
                    Text("Visualisierungen")
                        .font(.title2)
                        .bold()
                        .padding(.top)
                    
                    ForEach(visualizations) { visualization in
                        VisualizationView(visualization: visualization)
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContentSectionView: View {
    let section: ContentSection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(section.title)
                .font(.title2)
                .bold()
            
            Text(section.text)
                .font(.body)
            
            if let formulas = section.formulas {
                ForEach(formulas) { formula in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(formula.expression)
                            .font(.system(.body, design: .monospaced))
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        
                        Text(formula.explanation)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(10)
    }
}

struct ExampleView: View {
    let example: Example
    @State private var showingSolution = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(example.title)
                .font(.headline)
            
            Text(example.description)
                .font(.body)
            
            Button(action: { showingSolution.toggle() }) {
                Text(showingSolution ? "Lösung ausblenden" : "Lösung anzeigen")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            if showingSolution {
                ForEach(example.solution) { step in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(step.description)
                            .font(.headline)
                        
                        if let formula = step.formula {
                            Text(formula)
                                .font(.system(.body, design: .monospaced))
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                        
                        Text(step.explanation)
                            .font(.body)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct VisualizationView: View {
    let visualization: Visualization
    
    var body: some View {
        VStack {
            Text("Visualisierung")
                .font(.title2)
                .bold()
            
            // Hier später: Implementierung der verschiedenen Visualisierungstypen
            Text("Visualisierungstyp: \(visualization.type.rawValue)")
                .font(.caption)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    LearningContentView()
} 