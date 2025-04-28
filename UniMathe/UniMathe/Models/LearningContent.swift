import Foundation

struct LearningContent: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let category: ContentCategory
    let content: [ContentSection]
    let examples: [Example]
    let visualizations: [Visualization]?
    
    init(
        title: String,
        description: String,
        category: ContentCategory,
        content: [ContentSection],
        examples: [Example] = [],
        visualizations: [Visualization]? = nil
    ) {
        self.title = title
        self.description = description
        self.category = category
        self.content = content
        self.examples = examples
        self.visualizations = visualizations
    }
}

struct ContentSection: Identifiable {
    let id = UUID()
    let title: String
    let text: String
    let formulas: [Formula]
    
    init(
        title: String,
        text: String,
        formulas: [Formula] = []
    ) {
        self.title = title
        self.text = text
        self.formulas = formulas
    }
}

struct Formula: Identifiable {
    let id = UUID()
    let expression: String
    let explanation: String
    
    init(
        expression: String,
        explanation: String
    ) {
        self.expression = expression
        self.explanation = explanation
    }
}

struct Example: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let solution: [SolutionStep]
    
    init(
        title: String,
        description: String,
        solution: [SolutionStep]
    ) {
        self.title = title
        self.description = description
        self.solution = solution
    }
}

struct SolutionStep: Identifiable {
    let id = UUID()
    let description: String
    let explanation: String
    let formula: String?
    
    init(
        description: String,
        explanation: String,
        formula: String? = nil
    ) {
        self.description = description
        self.explanation = explanation
        self.formula = formula
    }
}

struct Visualization: Identifiable {
    let id = UUID()
    let type: VisualizationType
    let data: String // JSON-String für die Visualisierungsdaten
    
    init(
        type: VisualizationType,
        data: String
    ) {
        self.type = type
        self.data = data
    }
}

enum VisualizationType: String {
    case graph
    case diagram
    case plot
    case matrix
}

enum ContentCategory: String {
    case sets = "Mengenlehre"
    case analysis = "Analysis"
    case linearAlgebra = "Lineare Algebra"
    
    var icon: String {
        switch self {
        case .sets:
            return "circle.grid.2x2.fill"
        case .analysis:
            return "function"
        case .linearAlgebra:
            return "square.grid.2x2"
        }
    }
} 