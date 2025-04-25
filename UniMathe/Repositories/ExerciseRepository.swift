import Foundation

class ExerciseRepository {
    static let shared = ExerciseRepository()
    
    private init() {}
    
    // Sample data for testing
    static let sampleExercises: [Exercise] = [
        Exercise(
            title: "Mengenoperationen",
            description: "Berechne die Schnittmenge, Vereinigungsmenge und Differenzmenge der gegebenen Mengen.",
            difficulty: .easy,
            category: .setTheory,
            content: ExerciseContent(
                problem: "Gegeben sind die Mengen A = {1, 2, 3, 4} und B = {3, 4, 5, 6}. Berechne A ∩ B, A ∪ B und A \\ B.",
                givenData: [
                    "A": [1, 2, 3, 4],
                    "B": [3, 4, 5, 6]
                ],
                requirements: [
                    "Berechne die Schnittmenge A ∩ B",
                    "Berechne die Vereinigungsmenge A ∪ B",
                    "Berechne die Differenzmenge A \\ B"
                ]
            ),
            solution: Solution(
                steps: [
                    Solution.SolutionStep(
                        description: "Schnittmenge A ∩ B",
                        calculation: "A ∩ B = {3, 4}",
                        explanation: "Die Schnittmenge enthält alle Elemente, die in beiden Mengen vorkommen."
                    ),
                    Solution.SolutionStep(
                        description: "Vereinigungsmenge A ∪ B",
                        calculation: "A ∪ B = {1, 2, 3, 4, 5, 6}",
                        explanation: "Die Vereinigungsmenge enthält alle Elemente, die in mindestens einer der Mengen vorkommen."
                    ),
                    Solution.SolutionStep(
                        description: "Differenzmenge A \\ B",
                        calculation: "A \\ B = {1, 2}",
                        explanation: "Die Differenzmenge enthält alle Elemente, die in A, aber nicht in B vorkommen."
                    )
                ],
                hints: [
                    "Die Schnittmenge enthält nur die Elemente, die in beiden Mengen vorkommen",
                    "Die Vereinigungsmenge enthält alle Elemente aus beiden Mengen",
                    "Die Differenzmenge enthält nur die Elemente, die in der ersten Menge, aber nicht in der zweiten Menge vorkommen"
                ],
                finalAnswer: "A ∩ B = {3, 4}\nA ∪ B = {1, 2, 3, 4, 5, 6}\nA \\ B = {1, 2}"
            ),
            visualization: Visualization(
                type: .diagram,
                data: [
                    "type": "venn",
                    "sets": [
                        ["name": "A", "elements": [1, 2, 3, 4]],
                        ["name": "B", "elements": [3, 4, 5, 6]]
                    ]
                ]
            )
        )
    ]
    
    func saveExercise(_ exercise: Exercise) {
        // TODO: Implement saving to persistent storage
    }
    
    func loadExercises() -> [Exercise] {
        // TODO: Implement loading from persistent storage
        return ExerciseRepository.sampleExercises
    }
    
    func deleteExercise(_ exercise: Exercise) {
        // TODO: Implement deletion from persistent storage
    }
} 