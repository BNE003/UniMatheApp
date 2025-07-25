import Foundation

// MARK: - Exam Model
struct Exam: Codable, Identifiable {
    let exam: ExamInfo
    let exercises: [ExamExercise]
    
    var id: String { exam.title }
}

struct ExamInfo: Codable {
    let title: String
    let subtitle: String
    let duration: Int // in minutes
    let totalPoints: Int
    let difficulty: String
    let language: String
    let instructions: String
}

struct ExamExercise: Codable, Identifiable {
    let id: Int
    let topic: String
    let title: String
    let description: String
    let difficulty: String
    let points: Int
    let solutionSteps: [String]
}

// MARK: - Exam Repository
class ExamRepository: ObservableObject {
    static let shared = ExamRepository()
    
    func loadExam(filename: String, language: AppLanguage) -> Exam? {
        let languageCode = language == .english ? "en" : "de"
        print("🔍 EXAM LOADING: Attempting to load exam: \(filename).json")
        print("🔍 EXAM LOADING: Language: \(language.rawValue)")
        
        // Try multiple locations in this order:
        // 1. In klausuren/language subdirectory
        // 2. Directly in bundle root
        
        var url: URL?
        
        // First try the proper subdirectory structure
        if let subUrl = Bundle.main.url(forResource: filename, withExtension: "json", subdirectory: "klausuren/\(languageCode)") {
            print("✅ EXAM LOADING: Found exam file in subdirectory: \(subUrl)")
            url = subUrl
        }
        // Then try directly in bundle root
        else if let rootUrl = Bundle.main.url(forResource: filename, withExtension: "json") {
            print("✅ EXAM LOADING: Found exam file in bundle root: \(rootUrl)")
            url = rootUrl
        }
        
        if let foundUrl = url {
            do {
                let data = try Data(contentsOf: foundUrl)
                print("✅ EXAM LOADING: Successfully loaded data, size: \(data.count) bytes")
                let exam = try JSONDecoder().decode(Exam.self, from: data)
                print("✅ EXAM LOADING: Successfully decoded exam: \(exam.exam.title)")
                return exam
            } catch {
                print("❌ EXAM LOADING: Error loading/decoding exam: \(error)")
            }
        } else {
            print("❌ EXAM LOADING: Bundle file not found in any location for \(filename).json")
        }
        
        // No fallback - return nil if file not found
        print("❌ EXAM LOADING: No exam file found for \(filename)")
        return nil
    }
    
    func loadAvailableExams(language: AppLanguage) -> [String] {
        let languageCode = language == .english ? "en" : "de"
        
        guard let resourcePath = Bundle.main.resourcePath else { return [] }
        let examPath = "\(resourcePath)/klausuren/\(languageCode)"
        
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: examPath)
            return files.compactMap { file in
                if file.hasSuffix(".json") {
                    return String(file.dropLast(5)) // Remove .json extension
                }
                return nil
            }
        } catch {
            print("Error reading exam directory: \(error)")
            return []
        }
    }
} 
