import SwiftUI

struct ComplexNumbersView: View {
    @StateObject private var viewModel = ComplexNumbersViewModel()
    
    var body: some View {
        ScrollView {
            if let content = viewModel.content {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack {
                        Image(systemName: content.icon)
                            .font(.largeTitle)
                        Text(content.title)
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Text(content.description)
                        .font(.body)
                    
                    // Theory Sections
                    ForEach(content.content.sections) { section in
                        TheorySectionView(section: section)
                    }
                    
                    // Examples
                    ForEach(content.content.examples) { example in
                        ExampleView(example: example)
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
        .task {
            await viewModel.loadContent()
        }
    }
}

// Supporting Views
struct TheorySectionView: View {
    let section: ComplexNumbersContent.Content.Section
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(section.title)
                .font(.title2)
                .bold()
            
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
    }
}

struct ExampleView: View {
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
    }
}

#Preview {
    ComplexNumbersView()
} 