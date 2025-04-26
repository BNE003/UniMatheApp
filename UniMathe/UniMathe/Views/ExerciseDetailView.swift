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
        case 3: // Kartesisches Produkt (einfach)
            return [
                "Schritt 1: Definition des kartesischen Produkts",
                "Schritt 2: Bestimmung aller möglichen Paare",
                "Schritt 3: Aufstellung des kartesischen Produkts"
            ]
        case 10: // Potenzmenge (einfach)
            return [
                "Schritt 1: Definition der Potenzmenge",
                "Schritt 2: Bestimmung aller Teilmengen",
                "Schritt 3: Aufstellung der Potenzmenge"
            ]
        case 11: // Mengengleichheit (einfach)
            return [
                "Schritt 1: Definition der Mengengleichheit",
                "Schritt 2: Überprüfung der Elemente",
                "Schritt 3: Begründung der Antwort"
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
        case 12: // Inverse Abbildungen (mittel)
            return [
                "Schritt 1: Bestimmung der Umkehrabbildung",
                "Schritt 2: Überprüfung von f⁻¹∘f = id",
                "Schritt 3: Überprüfung von f∘f⁻¹ = id",
                "Schritt 4: Zusammenfassung"
            ]
        case 13: // Mengenoperationen mit Intervallen (mittel)
            return [
                "Schritt 1: Bestimmung des Durchschnitts",
                "Schritt 2: Bestimmung der Vereinigung",
                "Schritt 3: Bestimmung der Differenz",
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
        case 14: // Kardinalität von Mengen (schwer)
            return [
                "Schritt 1: Einführung des Cantorschen Diagonalarguments",
                "Schritt 2: Konstruktion einer reellen Zahl",
                "Schritt 3: Widerspruchsbeweis",
                "Schritt 4: Zusammenfassung"
            ]
        case 15: // Komplexe Mengenoperationen (schwer)
            return [
                "Schritt 1: Formulierung der De Morganschen Gesetze",
                "Schritt 2: Beweis des ersten Gesetzes",
                "Schritt 3: Beweis des zweiten Gesetzes",
                "Schritt 4: Zusammenfassung"
            ]
        case 20: // Komplexe Zahlen (erweitert)
            return [
                "Aufgabe 1: Addition und Subtraktion komplexer Zahlen",
                "Aufgabe 2: Multiplikation und Division komplexer Zahlen",
                "Aufgabe 3: Betrag und Konjugation einer komplexen Zahl",
                "Aufgabe 4: Umrechnung in Polarform",
                "Aufgabe 5: Bestimmung der Argumente komplexer Zahlen",
                "Aufgabe 6: Komplexe Zahlen potenzieren",
                "Aufgabe 7: Komplexe Gleichungen lösen",
                "Aufgabe 8: Multiplikation komplexer Zahlen in Polarform",
                "Aufgabe 9: Division komplexer Zahlen in Polarform",
                "Aufgabe 10: Anwendung der De-Moivre-Formel",
                "Zusammenfassung der wichtigsten Eigenschaften"
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
        case 3: // Kartesisches Produkt (einfach)
            switch step {
            case 0:
                return "Das kartesische Produkt A × B ist die Menge aller geordneten Paare (a,b) mit a ∈ A und b ∈ B."
            case 1:
                return "Mögliche Paare:\n- (a,1), (a,2)\n- (b,1), (b,2)"
            case 2:
                return "A × B = {(a,1), (a,2), (b,1), (b,2)}"
            default:
                return ""
            }
        case 10: // Potenzmenge (einfach)
            switch step {
            case 0:
                return "Die Potenzmenge P(A) ist die Menge aller Teilmengen von A."
            case 1:
                return "Teilmengen von A = {1, 2, 3}:\n- ∅\n- {1}, {2}, {3}\n- {1,2}, {1,3}, {2,3}\n- {1,2,3}"
            case 2:
                return "P(A) = {∅, {1}, {2}, {3}, {1,2}, {1,3}, {2,3}, {1,2,3}}"
            default:
                return ""
            }
        case 11: // Mengengleichheit (einfach)
            switch step {
            case 0:
                return "Zwei Mengen sind gleich, wenn sie die gleichen Elemente enthalten, unabhängig von der Reihenfolge."
            case 1:
                return "A = {1, 2, 3} und B = {3, 2, 1} enthalten die gleichen Elemente: 1, 2 und 3."
            case 2:
                return "Die Mengen sind gleich, da sie die gleichen Elemente enthalten. Die Reihenfolge spielt bei Mengen keine Rolle."
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
        case 12: // Inverse Abbildungen (mittel)
            switch step {
            case 0:
                return "Umkehrabbildung von f(x) = 3x - 2:\n- y = 3x - 2\n- x = (y + 2)/3\n- Also f⁻¹(y) = (y + 2)/3"
            case 1:
                return "Überprüfung von f⁻¹∘f = id:\n- f⁻¹(f(x)) = f⁻¹(3x - 2) = ((3x - 2) + 2)/3 = x"
            case 2:
                return "Überprüfung von f∘f⁻¹ = id:\n- f(f⁻¹(y)) = f((y + 2)/3) = 3((y + 2)/3) - 2 = y"
            case 3:
                return "Zusammenfassung:\nDie Umkehrabbildung ist korrekt, da beide Kompositionen die Identität ergeben."
            default:
                return ""
            }
        case 13: // Mengenoperationen mit Intervallen (mittel)
            switch step {
            case 0:
                return "A ∩ B = [1, 2]"
            case 1:
                return "A ∪ B = [0, 3]"
            case 2:
                return "A \\ B = [0, 1)"
            case 3:
                return "Zusammenfassung:\nDie Intervalle zeigen, wie sich Mengenoperationen auf kontinuierliche Mengen anwenden lassen."
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
        case 14: // Kardinalität von Mengen (schwer)
            switch step {
            case 0:
                return "Das Cantorsche Diagonalargument zeigt, dass ℝ überabzählbar ist, indem es eine reelle Zahl konstruiert, die nicht in einer gegebenen Abzählung vorkommt."
            case 1:
                return "Konstruktion einer reellen Zahl:\n- Nehme die n-te Dezimalstelle der n-ten Zahl\n- Ändere diese Stelle\n- Die resultierende Zahl kann nicht in der Abzählung vorkommen"
            case 2:
                return "Widerspruchsbeweis:\n- Angenommen, ℝ wäre abzählbar\n- Dann gäbe es eine Abzählung\n- Aber die konstruierte Zahl widerspricht dieser Annahme"
            case 3:
                return "Zusammenfassung:\nDie Menge der reellen Zahlen ist überabzählbar, da sie sich nicht bijektiv auf ℕ abbilden lässt."
            default:
                return ""
            }
        case 15: // Komplexe Mengenoperationen (schwer)
            switch step {
            case 0:
                return "Die De Morganschen Gesetze für Mengen:\n1. (A ∪ B)ᶜ = Aᶜ ∩ Bᶜ\n2. (A ∩ B)ᶜ = Aᶜ ∪ Bᶜ"
            case 1:
                return "Beweis des ersten Gesetzes:\n- x ∈ (A ∪ B)ᶜ ⇔ x ∉ A ∪ B\n- ⇔ x ∉ A und x ∉ B\n- ⇔ x ∈ Aᶜ und x ∈ Bᶜ\n- ⇔ x ∈ Aᶜ ∩ Bᶜ"
            case 2:
                return "Beweis des zweiten Gesetzes:\n- x ∈ (A ∩ B)ᶜ ⇔ x ∉ A ∩ B\n- ⇔ x ∉ A oder x ∉ B\n- ⇔ x ∈ Aᶜ oder x ∈ Bᶜ\n- ⇔ x ∈ Aᶜ ∪ Bᶜ"
            case 3:
                return "Zusammenfassung:\nDie De Morganschen Gesetze zeigen den Zusammenhang zwischen Komplement, Vereinigung und Durchschnitt."
            default:
                return ""
            }
        case 20:
            switch step {
            case 0:
                return """
Aufgabe 1: Addition und Subtraktion komplexer Zahlen

Gegeben: z₁ = 2 + 5i und z₂ = 3 - 2i

Addition:
(2+5i) + (3-2i) = (2+3) + (5-2)i = 5 + 3i

Subtraktion:
(2+5i) - (3-2i) = (2-3) + (5-(-2))i = -1 + 7i
"""
            case 1:
                return """
Aufgabe 2: Multiplikation und Division komplexer Zahlen

Multiplikation:
(2+5i)(3-2i) = 2×3 + 2×(-2i) + 5i×3 + 5i×(-2i)
= 6 -4i + 15i -10(i²)
= 6 +11i +10
= 16 +11i

Division:
\\[
\\frac{2+5i}{3-2i} = \\frac{(2+5i)(3+2i)}{(3-2i)(3+2i)} = \\frac{6+4i+15i+10i²}{9+4} = \\frac{-4+19i}{13} = -\\frac{4}{13} + \\frac{19}{13}i
\\]
"""
            case 2:
                return """
Aufgabe 3: Betrag und Konjugation einer komplexen Zahl

Gegeben: z = 4 - 3i

Betrag:
|z| = √(4² + (-3)²) = √(16+9) = √25 = 5

Konjugierte Zahl:
\\[
\\overline{z} = 4 + 3i
\\]
"""
            case 3:
                return """
Aufgabe 4: Umrechnung in Polarform

Gegeben: z = 1 + √3 i

Betrag:
\\[
r = |z| = \\sqrt{1^2 + (\\sqrt{3})^2} = \\sqrt{1+3} = 2
\\]

Winkel:
\\[
\\varphi = \\arctan\\left(\\frac{\\sqrt{3}}{1}\\right) = \\frac{\\pi}{3}
\\]

Polarform:
\\[
z = 2 \\left( \\cos\\left(\\frac{\\pi}{3}\\right) + i \\sin\\left(\\frac{\\pi}{3}\\right) \\right)
\\]
"""
            case 4:
                return """
Aufgabe 5: Bestimmung der Argumente komplexer Zahlen

Gegeben: z = -1 + i

Argument:
\\[
\\varphi = \\arctan\\left(\\frac{1}{-1}\\right) = \\arctan(-1) = -\\frac{\\pi}{4}
\\]
Da z im 2. Quadranten liegt, ist das Argument:
\\[
\\varphi = \\pi - \\frac{\\pi}{4} = \\frac{3\\pi}{4}
\\]
"""
            case 5:
                return """
Aufgabe 6: Komplexe Zahlen potenzieren

Gegeben: z = 2e^{i\\frac{\\pi}{6}}, n = 3

Potenzieren:
\\[
z^3 = 2^3 e^{i 3 \\frac{\\pi}{6}} = 8 e^{i\\frac{\\pi}{2}} = 8i
\\]
"""
            case 6:
                return """
Aufgabe 7: Komplexe Gleichungen lösen

Löse: z^2 = 1 + i

Schreibe 1 + i in Polarform:
Betrag: \\( r = \\sqrt{2} \\), Winkel: \\( \\varphi = \\frac{\\pi}{4} \\)

Lösungen:
\\[
z = \\sqrt{\\sqrt{2}} \\cdot e^{i(\\frac{\\pi}{8} + k\\pi)},\\quad k = 0,1
\\]
"""
            case 7:
                return """
Aufgabe 8: Multiplikation komplexer Zahlen in Polarform

Gegeben: z₁ = r₁ e^{i\\varphi_1}, z₂ = r₂ e^{i\\varphi_2}

Multiplikation:
\\[
z₁ z₂ = r₁ r₂ e^{i(\\varphi_1 + \\varphi_2)}
\\]
Beispiel: r₁=2, \\(\\varphi_1=\\frac{\\pi}{6}\\), r₂=3, \\(\\varphi_2=\\frac{\\pi}{4}\\)
\\[
z₁ z₂ = 6 e^{i(\\frac{\\pi}{6} + \\frac{\\pi}{4})} = 6 e^{i\\frac{5\\pi}{12}}
\\]
"""
            case 8:
                return """
Aufgabe 9: Division komplexer Zahlen in Polarform

Gegeben: z₁ = r₁ e^{i\\varphi_1}, z₂ = r₂ e^{i\\varphi_2}

Division:
\\[
\\frac{z₁}{z₂} = \\frac{r₁}{r₂} e^{i(\\varphi_1 - \\varphi_2)}
\\]
Beispiel: r₁=4, \\(\\varphi_1=\\frac{3\\pi}{8}\\), r₂=2, \\(\\varphi_2=\\frac{\\pi}{8}\\)
\\[
\\frac{z₁}{z₂} = 2 e^{i(\\frac{3\\pi}{8} - \\frac{\\pi}{8})} = 2 e^{i\\frac{\\pi}{4}}
\\]
"""
            case 9:
                return """
Aufgabe 10: Anwendung der De-Moivre-Formel

Gegeben: z = r e^{i\\varphi}, n ∈ \\mathbb{N}

De-Moivre-Formel:
\\[
z^n = r^n e^{i n\\varphi}
\\]
Beispiel: z = 2 e^{i\\frac{\\pi}{3}}, n=4
\\[
z^4 = 16 e^{i\\frac{4\\pi}{3}}
\\]
"""
            case 10:
                return """
Zusammenfassung der wichtigsten Eigenschaften

- Komplexe Zahlen lassen sich in der Form a+bi oder r·e^{i\\varphi} schreiben.
- Addition/Subtraktion: Komponentenweise.
- Multiplikation/Division: Am besten in Polarform.
- Betrag: |z| = \\sqrt{a^2 + b^2}
- Konjugierte: \\overline{z} = a - bi
- De-Moivre-Formel: Potenzen und Wurzeln in Polarform.
"""
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
