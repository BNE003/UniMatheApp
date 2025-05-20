import Foundation
import SwiftUI

struct Exercise: Identifiable, Codable {
    let id: Int
    let topic: String
    let title: String
    let description: String
    let difficulty: String
    let points: Int
    let solutionSteps: [String]
    
    var difficultyEnum: Difficulty {
        switch difficulty {
        case "easy": return .easy
        case "medium": return .medium
        case "hard": return .hard
        default: return .easy
        }
    }
}

struct ExercisesResponse: Codable {
    let exercises: [Exercise]
}

enum Difficulty: String, Codable {
    case easy
    case medium
    case hard
    
    var color: Color {
        switch self {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
    
    var text: String {
        let language = SettingsModel.shared.language
        
        switch self {
        case .easy:
            return language == .english ? "Easy" : "Einfach"
        case .medium:
            return language == .english ? "Medium" : "Mittel"
        case .hard:
            return language == .english ? "Hard" : "Schwer"
        }
    }
} 