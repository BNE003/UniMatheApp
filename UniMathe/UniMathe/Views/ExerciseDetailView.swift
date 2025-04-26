import SwiftUI

struct ExerciseDetailView: View {
    let exercise: Exercise
    @State private var currentStep = 0
    @State private var showSolution = false
    @Environment(\.colorScheme) var colorScheme
    
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
                        Text(exercise.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text(exercise.description)
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .lineSpacing(8)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    )
                    .padding(.horizontal)
                    
                    // Solution Section
                    if showSolution {
                        VStack(spacing: 16) {
                            ForEach(0..<currentStep + 1, id: \.self) { step in
                                SolutionStepView(step: step, exercise: exercise)
                            }
                            
                            if currentStep < exercise.solutionSteps.count - 1 {
                                Button(action: {
                                    withAnimation {
                                        currentStep += 1
                                    }
                                }) {
                                    Text("Nächster Schritt")
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
                            }
                        }) {
                            Text("Lösung anzeigen")
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
        .navigationTitle("Aufgabe")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct SolutionStepView: View {
    let step: Int
    let exercise: Exercise
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Schritt \(step + 1)")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(exercise.solutionSteps[step])
                .font(.body)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6))
        )
        .padding(.horizontal)
    }
}

#Preview {
    NavigationView {
        ExerciseDetailView(exercise: Exercise(
            id: 1,
            topic: "Mengen und Abbildungen",
            title: "Beispielaufgabe",
            description: "Dies ist eine Beispielaufgabe",
            difficulty: "easy",
            points: 5,
            solutionSteps: [
                "Schritt 1: Erste Lösung",
                "Schritt 2: Zweite Lösung",
                "Schritt 3: Dritte Lösung"
            ]
        ))
    }
} 
