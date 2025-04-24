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
                            
                            if currentStep < getSolutionSteps(for: exercise).count - 1 {
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
    
    private func getSolutionSteps(for exercise: Exercise) -> [String] {
        switch exercise.id {
        case 1: // Mengenoperationen (einfach)
            return [
                "Schritt 1: Bestimme die Vereinigung A ∪ B",
                "Schritt 2: Bestimme den Durchschnitt A ∩ B",
                "Schritt 3: Bestimme die Differenz A \\ B",
                "Schritt 4: Bestimme die Differenz B \\ A"
            ]
        case 2: // Teilmengen (einfach)
            return [
                "Schritt 1: Überprüfe die Definition einer Teilmenge",
                "Schritt 2: Analysiere jede Aussage einzeln",
                "Schritt 3: Bestimme die wahren Aussagen"
            ]
        case 4: // Abbildungseigenschaften (mittel)
            return [
                "Schritt 1: Definition von Injektivität",
                "Schritt 2: Überprüfung der Injektivität",
                "Schritt 3: Definition von Surjektivität",
                "Schritt 4: Überprüfung der Surjektivität",
                "Schritt 5: Zusammenfassung"
            ]
        case 5: // Komposition von Abbildungen (mittel)
            return [
                "Schritt 1: Definition der Komposition",
                "Schritt 2: Berechnung von f∘g",
                "Schritt 3: Berechnung von g∘f",
                "Schritt 4: Vergleich der Ergebnisse"
            ]
        case 6: // Mengenidentitäten (mittel)
            return [
                "Schritt 1: Formulierung der Distributivgesetze",
                "Schritt 2: Beweis des ersten Distributivgesetzes",
                "Schritt 3: Beweis des zweiten Distributivgesetzes",
                "Schritt 4: Zusammenfassung"
            ]
        case 7: // Bijektive Abbildungen (schwer)
            return [
                "Schritt 1: Überprüfung der Injektivität",
                "Schritt 2: Überprüfung der Surjektivität",
                "Schritt 3: Bestimmung der Umkehrabbildung",
                "Schritt 4: Verifikation"
            ]
        case 8: // Mächtigkeit von Mengen (schwer)
            return [
                "Schritt 1: Definition der Abzählbarkeit",
                "Schritt 2: Konstruktion einer Bijektion",
                "Schritt 3: Nachweis der Bijektivität",
                "Schritt 4: Zusammenfassung"
            ]
        case 9: // Äquivalenzrelationen (schwer)
            return [
                "Schritt 1: Definition der Äquivalenzrelation",
                "Schritt 2: Überprüfung der Reflexivität",
                "Schritt 3: Überprüfung der Symmetrie",
                "Schritt 4: Überprüfung der Transitivität",
                "Schritt 5: Zusammenfassung"
            ]
        default:
            return ["Schritt 1: Lösung"]
        }
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
            
            Text(getStepContent(for: step))
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
    
    private func getStepContent(for step: Int) -> String {
        switch exercise.id {
        case 1: // Mengenoperationen (einfach)
            switch step {
            case 0:
                return "A ∪ B = {1, 2, 3, 4, 5, 6}"
            case 1:
                return "A ∩ B = {3, 4}"
            case 2:
                return "A \\ B = {1, 2}"
            case 3:
                return "B \\ A = {5, 6}"
            default:
                return ""
            }
        case 2: // Teilmengen (einfach)
            switch step {
            case 0:
                return "Eine Menge A ist Teilmenge von B, wenn jedes Element von A auch in B enthalten ist."
            case 1:
                return "1. {1, 2} ⊆ {1, 2, 3} ist wahr\n2. {1, 2, 3} ⊆ {1, 2} ist falsch\n3. ∅ ⊆ {1, 2, 3} ist wahr\n4. {1, 2, 3} ⊆ ∅ ist falsch"
            case 2:
                return "Die wahren Aussagen sind 1 und 3."
            default:
                return ""
            }
        case 4: // Abbildungseigenschaften (mittel)
            switch step {
            case 0:
                return "Eine Abbildung f: A → B heißt injektiv, wenn verschiedene Elemente aus A auf verschiedene Elemente aus B abgebildet werden."
            case 1:
                return "Für f(x) = x²:\n- f(-1) = f(1) = 1\n- Also ist f nicht injektiv, da verschiedene Elemente auf denselben Wert abgebildet werden."
            case 2:
                return "Eine Abbildung f: A → B heißt surjektiv, wenn jedes Element aus B als Bild vorkommt."
            case 3:
                return "Für f(x) = x²:\n- Negative Zahlen kommen nicht als Bild vor\n- Also ist f nicht surjektiv auf ℝ"
            case 4:
                return "Zusammenfassung:\nDie Abbildung f(x) = x² ist weder injektiv noch surjektiv auf ℝ."
            default:
                return ""
            }
        case 5: // Komposition von Abbildungen (mittel)
            switch step {
            case 0:
                return "Die Komposition f∘g ist definiert durch (f∘g)(x) = f(g(x))."
            case 1:
                return "(f∘g)(x) = f(g(x)) = f(x²) = 2x² + 1"
            case 2:
                return "(g∘f)(x) = g(f(x)) = g(2x + 1) = (2x + 1)² = 4x² + 4x + 1"
            case 3:
                return "Vergleich:\n- f∘g ≠ g∘f\n- Die Komposition von Abbildungen ist im Allgemeinen nicht kommutativ."
            default:
                return ""
            }
        case 6: // Mengenidentitäten (mittel)
            switch step {
            case 0:
                return "Zu beweisen sind die Distributivgesetze:\n1. A ∩ (B ∪ C) = (A ∩ B) ∪ (A ∩ C)\n2. A ∪ (B ∩ C) = (A ∪ B) ∩ (A ∪ C)"
            case 1:
                return "Beweis des ersten Distributivgesetzes:\nSei x ∈ A ∩ (B ∪ C). Dann gilt x ∈ A und x ∈ B ∪ C."
            case 2:
                return "Fortsetzung des Beweises:\n- Falls x ∈ B, dann x ∈ A ∩ B\n- Falls x ∈ C, dann x ∈ A ∩ C\n- Also x ∈ (A ∩ B) ∪ (A ∩ C)"
            case 3:
                return "Zusammenfassung:\nDie Distributivgesetze zeigen, wie sich Durchschnitt und Vereinigung gegenseitig beeinflussen."
            default:
                return ""
            }
        case 7: // Bijektive Abbildungen (schwer)
            switch step {
            case 0:
                return "Überprüfung der Injektivität von f(x) = x³ + 2x:\n- f'(x) = 3x² + 2 > 0 für alle x ∈ ℝ\n- Also ist f streng monoton steigend und damit injektiv."
            case 1:
                return "Überprüfung der Surjektivität:\n- lim_{x → -∞} f(x) = -∞\n- lim_{x → ∞} f(x) = ∞\n- Nach dem Zwischenwertsatz ist f surjektiv."
            case 2:
                return "Bestimmung der Umkehrabbildung:\n- y = x³ + 2x\n- Auflösen nach x ergibt die Umkehrabbildung"
            case 3:
                return "Verifikation:\n- f(f⁻¹(y)) = y\n- f⁻¹(f(x)) = x"
            default:
                return ""
            }
        case 8: // Mächtigkeit von Mengen (schwer)
            switch step {
            case 0:
                return "Eine Menge heißt abzählbar unendlich, wenn sie bijektiv auf ℕ abgebildet werden kann."
            case 1:
                return "Konstruktion einer Bijektion ℚ → ℕ:\n- Anordnung der rationalen Zahlen in einem unendlichen Gitter\n- Diagonalabzählung nach Cantor"
            case 2:
                return "Nachweis der Bijektivität:\n- Jede rationale Zahl wird genau einmal getroffen\n- Jeder natürlichen Zahl wird genau eine rationale Zahl zugeordnet"
            case 3:
                return "Zusammenfassung:\nDie Menge der rationalen Zahlen ist abzählbar unendlich, da sie sich bijektiv auf ℕ abbilden lässt."
            default:
                return ""
            }
        case 9: // Äquivalenzrelationen (schwer)
            switch step {
            case 0:
                return "Eine Relation R auf einer Menge M heißt Äquivalenzrelation, wenn sie reflexiv, symmetrisch und transitiv ist."
            case 1:
                return "Überprüfung der Reflexivität:\n- Für jede Menge A ∈ P(M) gilt |A| = |A|\n- Also (A,A) ∈ R"
            case 2:
                return "Überprüfung der Symmetrie:\n- Wenn (A,B) ∈ R, dann |A| = |B|\n- Also |B| = |A| und (B,A) ∈ R"
            case 3:
                return "Überprüfung der Transitivität:\n- Wenn (A,B) ∈ R und (B,C) ∈ R, dann |A| = |B| und |B| = |C|\n- Also |A| = |C| und (A,C) ∈ R"
            case 4:
                return "Zusammenfassung:\nDie Relation R ist eine Äquivalenzrelation, da sie reflexiv, symmetrisch und transitiv ist."
            default:
                return ""
            }
        default:
            return "Lösungsschritt \(step + 1)"
        }
    }
}

#Preview {
    NavigationView {
        ExerciseDetailView(exercise: Exercise(
            id: 1,
            title: "Mengenoperationen",
            description: "Gegeben sind die Mengen A = {1, 2, 3, 4} und B = {3, 4, 5, 6}. Bestimmen Sie:\n1. A ∪ B\n2. A ∩ B\n3. A \\ B\n4. B \\ A",
            difficulty: .easy,
            points: 5
        ))
    }
} 