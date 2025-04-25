import Foundation
import SwiftUI
import Combine

class LearningContentViewModel: ObservableObject {
    @Published var learningContents: [LearningContent] = []
    @Published var selectedContent: LearningContent?
    @Published var isLoading = false
    @Published var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadLearningContents()
    }
    
    func loadLearningContents() {
        isLoading = true
        
        // Beispiel-Lerninhalte
        let contents = [
            LearningContent(
                title: "Mengen und Abbildungen",
                description: "Grundlegende Konzepte der Mengenlehre und Abbildungen zwischen Mengen.",
                category: .sets,
                content: [
                    ContentSection(
                        title: "Mengen",
                        text: "Eine Menge ist eine Zusammenfassung von unterscheidbaren Objekten zu einem Ganzen. Die Objekte einer Menge heißen Elemente der Menge.",
                        formulas: [
                            Formula(
                                expression: "A = {a, b, c}",
                                explanation: "Menge A mit den Elementen a, b und c"
                            ),
                            Formula(
                                expression: "x ∈ A",
                                explanation: "x ist Element der Menge A"
                            )
                        ]
                    ),
                    ContentSection(
                        title: "Abbildungen",
                        text: "Eine Abbildung f von einer Menge A in eine Menge B ist eine Vorschrift, die jedem Element a ∈ A genau ein Element f(a) ∈ B zuordnet.",
                        formulas: [
                            Formula(
                                expression: "f: A → B",
                                explanation: "Abbildung von A nach B"
                            ),
                            Formula(
                                expression: "f(a) = b",
                                explanation: "Element a wird auf Element b abgebildet"
                            )
                        ]
                    )
                ],
                examples: [
                    Example(
                        title: "Beispiel: Mengenoperationen",
                        description: "Gegeben sind die Mengen A = {1, 2, 3, 4} und B = {3, 4, 5, 6}. Berechne A ∩ B, A ∪ B und A \\ B.",
                        solution: [
                            SolutionStep(
                                description: "Schnittmenge A ∩ B",
                                explanation: "Die Schnittmenge enthält alle Elemente, die in beiden Mengen vorkommen.",
                                formula: "A ∩ B = {3, 4}"
                            ),
                            SolutionStep(
                                description: "Vereinigungsmenge A ∪ B",
                                explanation: "Die Vereinigungsmenge enthält alle Elemente, die in mindestens einer der Mengen vorkommen.",
                                formula: "A ∪ B = {1, 2, 3, 4, 5, 6}"
                            ),
                            SolutionStep(
                                description: "Differenzmenge A \\ B",
                                explanation: "Die Differenzmenge enthält alle Elemente, die in A, aber nicht in B vorkommen.",
                                formula: "A \\ B = {1, 2}"
                            )
                        ]
                    )
                ]
            )
        ]
        
        self.learningContents = contents
        isLoading = false
    }
    
    func selectContent(_ content: LearningContent) {
        selectedContent = content
    }
} 