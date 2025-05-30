import SwiftUI

struct ExerciseDetailView: View {
    let exercise: Exercise
    @State private var currentStep = 0
    @State private var showSolution = false
    @State private var descriptionHeight: CGFloat = 100
    @State private var solutionHeights: [CGFloat] = []
    @State private var titleHeight: CGFloat = 32
    @ObservedObject private var settings = SettingsModel.shared
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color(red: 0.98, green: 0.98, blue: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Exercise Card
                    VStack(alignment: .leading, spacing: 16) {
                        LaTeXView(content: "<span style='font-size:1.2em;font-weight:bold;'>" + addHtmlLineBreaks(exercise.title) + "</span>", height: $titleHeight)
                            .frame(height: titleHeight)
                        LaTeXView(content: addHtmlLineBreaks(exercise.description), height: $descriptionHeight)
                            .frame(height: descriptionHeight)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    )
                    .padding(.horizontal)
                    
                    // Solution Section
                    if showSolution {
                        VStack(spacing: 16) {
                            ForEach(0..<currentStep + 1, id: \.self) { step in
                                SolutionStepView(step: step, exercise: exercise, height: $solutionHeights[step])
                            }
                            
                            if currentStep < exercise.solutionSteps.count - 1 {
                                Button(action: {
                                    withAnimation {
                                        currentStep += 1
                                        if solutionHeights.count <= currentStep {
                                            solutionHeights.append(100)
                                        }
                                    }
                                }) {
                                    Text(settings.language == .english ? "Next Step" : "Nächster Schritt")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.blue)
                                        .cornerRadius(12)
                                }
                                .padding(.horizontal)
                            }
                        }
                    } else {
                        Button(action: {
                            withAnimation {
                                showSolution = true
                                solutionHeights = Array(repeating: 100, count: exercise.solutionSteps.count)
                            }
                        }) {
                            Text(settings.language == .english ? "Show Solution" : "Lösung anzeigen")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
        .navigationTitle(settings.language == .english ? "Exercise" : "Aufgabe")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct SolutionStepView: View {
    let step: Int
    let exercise: Exercise
    @Binding var height: CGFloat
    @ObservedObject private var settings = SettingsModel.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(settings.language == .english ? "Step \(step + 1)" : "Schritt \(step + 1)")
                .font(.headline)
                .foregroundColor(.primary)
            
            LaTeXView(content: addHtmlLineBreaks(exercise.solutionSteps[step]), height: $height)
                .frame(height: height)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
        .padding(.horizontal)
    }
}

// Hilfsfunktion, um Zeilenumbrüche in <br> umzuwandeln
fileprivate func addHtmlLineBreaks(_ text: String) -> String {
    text.replacingOccurrences(of: "\n", with: "<br>")
}

#Preview {
    NavigationView {
        ExerciseDetailView(exercise: Exercise(
            id: 1,
            topic: "Mengen und Abbildungen",
            title: "Beispielaufgabe",
            description: "Gegeben sind die Mengen $A = \\{1, 2, 3, 4\\}$ und $B = \\{3, 4, 5, 6\\}$. Bestimmen Sie:\n1. $A \\cup B$\n2. $A \\cap B$\n3. $A \\setminus B$\n4. $B \\setminus A$",
            difficulty: "easy",
            points: 5,
            solutionSteps: [
                "Schritt 1: Bestimme die Vereinigung $A \\cup B$",
                "$A \\cup B = \\{1, 2, 3, 4, 5, 6\\}$",
                "Schritt 2: Bestimme den Durchschnitt $A \\cap B$",
                "$A \\cap B = \\{3, 4\\}$",
                "Schritt 3: Bestimme die Differenz $A \\setminus B$",
                "$A \\setminus B = \\{1, 2\\}$",
                "Schritt 4: Bestimme die Differenz $B \\setminus A$",
                "$B \\setminus A = \\{5, 6\\}$"
            ]
        ))
    }
} 
