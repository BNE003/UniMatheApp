import Foundation
import SwiftUI

// This file makes the Models directory a proper Swift module
// All model files in this directory will be accessible through this module

// MARK: - Exam Difficulty
enum ExamDifficulty: String, CaseIterable {
    case beginner = "beginner"
    case intermediate = "intermediate"
    case advanced = "advanced"
    
    func localizedName(language: AppLanguage) -> String {
        switch self {
        case .beginner:
            return language == .english ? "Beginner" : "Anfänger"
        case .intermediate:
            return language == .english ? "Intermediate" : "Fortgeschritten"
        case .advanced:
            return language == .english ? "Advanced" : "Experte"
        }
    }
    
    var colors: [Color] {
        switch self {
        case .beginner:
            return [Color.green, Color.mint]
        case .intermediate:
            return [Color.orange, Color.yellow]
        case .advanced:
            return [Color.red, Color.pink]
        }
    }
}

// MARK: - Exam Topic
struct ExamTopic: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let difficulty: ExamDifficulty
    let duration: Int
    let questions: Int
    let icon: String
    let color: Color
} 