import Foundation

struct MathSolution: Codable {
    let aufgabe: String
    let loesung_schritte: [String]
}

class MathSolver {
    
    static func solveMathProblem(_ problem: String) -> MathSolution {
        var steps: [String] = []
        
        // Add the original problem as the first step
        steps.append("Aufgabe: \(problem)")
        
        // Check for different types of math problems and solve accordingly
        if problem.contains("Schnittmenge") {
            steps.append(contentsOf: solveSetIntersection(problem))
        } else if problem.contains("Vereinigungsmenge") {
            steps.append(contentsOf: solveSetUnion(problem))
        } else if problem.contains("Differenzmenge") {
            steps.append(contentsOf: solveSetDifference(problem))
        } else {
            steps.append("Diese Art von Aufgabe wird noch nicht unterstützt.")
        }
        
        return MathSolution(aufgabe: problem, loesung_schritte: steps)
    }
    
    private static func solveSetIntersection(_ problem: String) -> [String] {
        var steps: [String] = []
        
        // Extract sets from the problem
        if let rangeA = problem.range(of: "A = \\{.*?\\}", options: .regularExpression),
           let rangeB = problem.range(of: "B = \\{.*?\\}", options: .regularExpression) {
            let setA = problem[rangeA].replacingOccurrences(of: "A = ", with: "")
            let setB = problem[rangeB].replacingOccurrences(of: "B = ", with: "")
            
            steps.append("Gegeben sind die Mengen:")
            steps.append("A = \(setA)")
            steps.append("B = \(setB)")
            
            // Parse the sets
            let elementsA = parseSet(setA)
            let elementsB = parseSet(setB)
            
            // Find intersection
            let intersection = elementsA.filter { elementsB.contains($0) }
            
            steps.append("Die Schnittmenge A ∩ B enthält alle Elemente, die in beiden Mengen vorkommen.")
            steps.append("A ∩ B = {\(intersection.joined(separator: ", "))}")
        }
        
        return steps
    }
    
    private static func solveSetUnion(_ problem: String) -> [String] {
        var steps: [String] = []
        
        if let rangeA = problem.range(of: "A = \\{.*?\\}", options: .regularExpression),
           let rangeB = problem.range(of: "B = \\{.*?\\}", options: .regularExpression) {
            let setA = problem[rangeA].replacingOccurrences(of: "A = ", with: "")
            let setB = problem[rangeB].replacingOccurrences(of: "B = ", with: "")
            
            steps.append("Gegeben sind die Mengen:")
            steps.append("A = \(setA)")
            steps.append("B = \(setB)")
            
            let elementsA = parseSet(setA)
            let elementsB = parseSet(setB)
            
            // Find union (remove duplicates)
            let union = Array(Set(elementsA + elementsB)).sorted()
            
            steps.append("Die Vereinigungsmenge A ∪ B enthält alle Elemente, die in mindestens einer der beiden Mengen vorkommen.")
            steps.append("A ∪ B = {\(union.joined(separator: ", "))}")
        }
        
        return steps
    }
    
    private static func solveSetDifference(_ problem: String) -> [String] {
        var steps: [String] = []
        
        if let rangeA = problem.range(of: "A = \\{.*?\\}", options: .regularExpression),
           let rangeB = problem.range(of: "B = \\{.*?\\}", options: .regularExpression) {
            let setA = problem[rangeA].replacingOccurrences(of: "A = ", with: "")
            let setB = problem[rangeB].replacingOccurrences(of: "B = ", with: "")
            
            steps.append("Gegeben sind die Mengen:")
            steps.append("A = \(setA)")
            steps.append("B = \(setB)")
            
            let elementsA = parseSet(setA)
            let elementsB = parseSet(setB)
            
            // Find difference
            let difference = elementsA.filter { !elementsB.contains($0) }
            
            steps.append("Die Differenzmenge A \\ B enthält alle Elemente, die in A, aber nicht in B vorkommen.")
            steps.append("A \\ B = {\(difference.joined(separator: ", "))}")
        }
        
        return steps
    }
    
    private static func parseSet(_ setString: String) -> [String] {
        // Remove curly braces and split by comma
        let cleanString = setString.replacingOccurrences(of: "[{}]", with: "", options: .regularExpression)
        return cleanString.components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
} 