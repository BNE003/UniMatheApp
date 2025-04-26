import Foundation

struct ComplexNumbersContent: Codable {
    let title: String
    let icon: String
    let description: String
    let content: Content
    let exercises: [ComplexExercise]
    
    struct Content: Codable {
        let sections: [Section]
        let examples: [Example]
        
        struct Section: Codable, Identifiable {
            let id = UUID()
            let title: String
            let content: String
            let formulas: [Formula]
            
            struct Formula: Codable {
                let expression: String
                let explanation: String
            }
        }
        
        struct Example: Codable, Identifiable {
            let id = UUID()
            let title: String
            let description: String
            let solution: [SolutionStep]
            
            struct SolutionStep: Codable {
                let step: String
                let explanation: String
            }
        }
    }
    
    struct ComplexExercise: Codable, Identifiable {
        let id: Int
        let title: String
        let description: String
        let difficulty: String
        let points: Int
        let steps: [ExerciseStep]
        
        struct ExerciseStep: Codable {
            let title: String
            let content: String
        }
    }
}

// Helper class to load the content
class ComplexNumbersLoader {
    static func loadComplexNumbers() throws -> ComplexNumbersContent {
        guard let url = Bundle.main.url(forResource: "komplexe_zahlen", withExtension: "json") else {
            throw LoadingError.fileNotFound
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(ComplexNumbersContent.self, from: data)
        } catch {
            throw LoadingError.decodingError(error)
        }
    }
    
    enum LoadingError: Error {
        case fileNotFound
        case decodingError(Error)
    }
} 