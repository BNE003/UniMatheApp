import Foundation

// MARK: - Learning Content Model
struct LearningContent: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let category: ContentCategory
    let content: [ContentSection]
    let examples: [Example]
    let visualizations: [Visualization]?
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        category: ContentCategory,
        content: [ContentSection],
        examples: [Example],
        visualizations: [Visualization]? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.content = content
        self.examples = examples
        self.visualizations = visualizations
    }
}

// MARK: - Content Section
struct ContentSection: Identifiable, Codable {
    let id: UUID
    let title: String
    let text: String
    let formulas: [Formula]?
    
    init(
        id: UUID = UUID(),
        title: String,
        text: String,
        formulas: [Formula]? = nil
    ) {
        self.id = id
        self.title = title
        self.text = text
        self.formulas = formulas
    }
}

// MARK: - Formula
struct Formula: Identifiable, Codable {
    let id: UUID
    let expression: String
    let explanation: String
    
    init(
        id: UUID = UUID(),
        expression: String,
        explanation: String
    ) {
        self.id = id
        self.expression = expression
        self.explanation = explanation
    }
}

// MARK: - Example
struct Example: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let solution: [SolutionStep]
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        solution: [SolutionStep]
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.solution = solution
    }
}

// MARK: - Solution Step
struct SolutionStep: Identifiable, Codable {
    let id: UUID
    let description: String
    let explanation: String
    let formula: String?
    
    init(
        id: UUID = UUID(),
        description: String,
        explanation: String,
        formula: String? = nil
    ) {
        self.id = id
        self.description = description
        self.explanation = explanation
        self.formula = formula
    }
}

// MARK: - Visualization
struct Visualization: Identifiable, Codable {
    let id: UUID
    let type: VisualizationType
    let data: String // JSON-String für die Visualisierungsdaten
    
    init(
        id: UUID = UUID(),
        type: VisualizationType,
        data: String
    ) {
        self.id = id
        self.type = type
        self.data = data
    }
}

// MARK: - Visualization Type
enum VisualizationType: String, Codable {
    case graph
    case diagram
    case plot
    case matrix
}

// MARK: - Content Category
enum ContentCategory: String, Codable {
    case sets = "Mengen"
    case functions = "Funktionen"
    case calculus = "Analysis"
    case linearAlgebra = "Lineare Algebra"
    case statistics = "Statistik"
    
    var icon: String {
        switch self {
        case .sets: return "circle.grid.2x2"
        case .functions: return "function"
        case .calculus: return "chart.xyaxis.line"
        case .linearAlgebra: return "matrix"
        case .statistics: return "chart.bar"
        }
    }
} 