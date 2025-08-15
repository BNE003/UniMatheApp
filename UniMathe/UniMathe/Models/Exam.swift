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
    
    // Embedded default store for development fallback
    class DefaultExamStore {
        static let shared = DefaultExamStore()
        
        private func loadResource(named name: String) -> Data? {
            guard let url = Bundle.main.url(forResource: name, withExtension: "json") else { return nil }
            return try? Data(contentsOf: url)
        }
        
        func data(for filename: String, language: AppLanguage) -> Data? {
            // Map known filenames to bundled siblings when Xcode resource membership fails
            // We try to reuse existing localized files if present, otherwise inline minimal JSON samples.
            switch filename {
            case "analysis_1_anfaenger", "analysis_1_beginner":
                return embeddedAnalysis1(language: language)
            case "linear_algebra_intermediate", "lineare_algebra_fortgeschritten":
                return embeddedLinearAlgebra(language: language)
            case "statistics_intermediate", "statistik_fortgeschritten":
                return embeddedStatistics(language: language)
            case "analysis_2_advanced", "analysis_2_experte":
                return embeddedAnalysis2(language: language)
            case "differential_equations_advanced", "differentialgleichungen_experte":
                return embeddedDifferentialEquations(language: language)
            case "numerical_mathematics_advanced", "numerische_mathematik_experte":
                return embeddedNumerics(language: language)
            case "linear_algebra_advanced", "lineare_algebra_experte":
                return embeddedLinearAlgebraAdvanced(language: language)
            case "mathematics_1_beginner", "mathematik_1_anfaenger":
                return embeddedMathematics1Beginner(language: language)
            case "mathematics_1_intermediate", "mathematik_1_fortgeschritten":
                return embeddedMathematics1Intermediate(language: language)
            case "mathematics_1_advanced", "mathematik_1_experte":
                return embeddedMathematics1Advanced(language: language)
            case "linear_algebra_1_beginner", "lineare_algebra_1_anfaenger":
                return embeddedLinearAlgebra1Beginner(language: language)
            default:
                return nil
            }
        }
        
        private func embeddedAnalysis1(language: AppLanguage) -> Data? {
            let json: String
            if language == .english {
                json = """
                {"exam":{"title":"Analysis I - Beginner Exam","subtitle":"Fundamentals of Analysis","duration":120,"totalPoints":60,"difficulty":"beginner","language":"en","instructions":"Answer all questions."},"exercises":[{"id":1,"topic":"Limits","title":"Basic limit","description":"Compute \\nlim_{x\\to 2} \\frac{x^2-4}{x-2}.","difficulty":"easy","points":8,"solutionSteps":["Factor","Cancel"]}]}
                """
            } else {
                json = """
                {"exam":{"title":"Analysis I - Anfängerklausur","subtitle":"Grundlagen der Analysis","duration":120,"totalPoints":60,"difficulty":"beginner","language":"de","instructions":"Bearbeiten Sie alle Aufgaben."},"exercises":[{"id":1,"topic":"Grenzwerte","title":"Einfacher Grenzwert","description":"Berechnen Sie \\nlim_{x\\to 2} \\frac{x^2-4}{x-2}.","difficulty":"easy","points":8,"solutionSteps":["Faktorisieren","Kürzen"]}]}
                """
            }
            return json.data(using: .utf8)
        }
        
        private func embeddedLinearAlgebra(language: AppLanguage) -> Data? {
            let json: String
            if language == .english {
                json = """
                {"exam":{"title":"Linear Algebra - Intermediate Exam","subtitle":"Eigenvalues, diagonalization and vector spaces","duration":90,"totalPoints":60,"difficulty":"intermediate","language":"en","instructions":"Answer all questions."},"exercises":[{"id":1,"topic":"Linear Systems","title":"Gaussian elimination","description":"Solve a 2x2 example system.","difficulty":"medium","points":10,"solutionSteps":["Augmented matrix","Eliminate"]}]}
                """
            } else {
                json = """
                {"exam":{"title":"Lineare Algebra - Fortgeschrittenenklausur","subtitle":"Eigenwerte, Diagonalisierung und lineare Räume","duration":90,"totalPoints":60,"difficulty":"intermediate","language":"de","instructions":"Bearbeiten Sie alle Aufgaben."},"exercises":[{"id":1,"topic":"Lineare Gleichungssysteme","title":"Gauß-Algorithmus","description":"Lösen Sie ein 2x2-Beispiel.","difficulty":"medium","points":10,"solutionSteps":["Erweiterte Matrix","Elimination"]}]}
                """
            }
            return json.data(using: .utf8)
        }
        
        private func embeddedStatistics(language: AppLanguage) -> Data? {
            let json: String
            if language == .english {
                json = """
                {"exam":{"title":"Statistics - Intermediate Exam","subtitle":"Probability theory and statistics","duration":100,"totalPoints":60,"difficulty":"intermediate","language":"en","instructions":"Answer all questions."},"exercises":[{"id":1,"topic":"Probabilities","title":"Conditional probability","description":"Given events A and B with P(A)=0.6, P(B)=0.5 and P(A \\cap B)=0.3. Compute P(A|B) and P(B|A).","difficulty":"medium","points":8,"solutionSteps":["Use definition","Compute values"]}]}
                """
            } else {
                json = """
                {"exam":{"title":"Statistik - Fortgeschrittenenklausur","subtitle":"Wahrscheinlichkeitstheorie und Statistik","duration":100,"totalPoints":60,"difficulty":"intermediate","language":"de","instructions":"Bearbeiten Sie alle Aufgaben."},"exercises":[{"id":1,"topic":"Wahrscheinlichkeiten","title":"Bedingte Wahrscheinlichkeit","description":"Gegeben sind A,B mit P(A)=0{,}6, P(B)=0{,}5, P(A \\cap B)=0{,}3.","difficulty":"medium","points":8,"solutionSteps":["Definition nutzen","Einsetzen"]}]}
                """
            }
            return json.data(using: .utf8)
        }
        
        private func embeddedAnalysis2(language: AppLanguage) -> Data? {
            let json: String
            if language == .english {
                json = """
                {"exam":{"title":"Analysis II - Advanced Exam","subtitle":"Multivariable calculus","duration":150,"totalPoints":90,"difficulty":"advanced","language":"en","instructions":"Answer all questions."},"exercises":[{"id":1,"topic":"Partial Derivatives","title":"Gradient and Hessian","description":"Compute grad and Hessian.","difficulty":"medium","points":12,"solutionSteps":["Compute fx, fy","Compute Hessian"]}]}
                """
            } else {
                json = """
                {"exam":{"title":"Analysis II - Expertenklausur","subtitle":"Mehrdimensionale Analysis","duration":150,"totalPoints":90,"difficulty":"advanced","language":"de","instructions":"Bearbeiten Sie alle Aufgaben."},"exercises":[{"id":1,"topic":"Partielle Ableitungen","title":"Gradient und Hesse","description":"Gradient und Hesse-Matrix bestimmen.","difficulty":"medium","points":12,"solutionSteps":["fx, fy","Hesse"]}]}
                """
            }
            return json.data(using: .utf8)
        }
        
        private func embeddedDifferentialEquations(language: AppLanguage) -> Data? {
            let json: String
            if language == .english {
                json = """
                {"exam":{"title":"Differential Equations - Advanced Exam","subtitle":"ODEs and PDEs basics","duration":135,"totalPoints":80,"difficulty":"advanced","language":"en","instructions":"Answer all questions."},"exercises":[{"id":1,"topic":"First-order ODEs","title":"Separable","description":"Solve y'=xy.","difficulty":"easy","points":10,"solutionSteps":["Separate","Integrate"]}]}
                """
            } else {
                json = """
                {"exam":{"title":"Differentialgleichungen - Expertenklausur","subtitle":"Gewöhnliche und partielle DGL","duration":135,"totalPoints":80,"difficulty":"advanced","language":"de","instructions":"Bearbeiten Sie alle Aufgaben."},"exercises":[{"id":1,"topic":"Erste Ordnung","title":"Trennbar","description":"Lösen Sie y'=xy.","difficulty":"easy","points":10,"solutionSteps":["Trennen","Integrieren"]}]}
                """
            }
            return json.data(using: .utf8)
        }
        
        private func embeddedNumerics(language: AppLanguage) -> Data? {
            let json: String
            if language == .english {
                json = """
                {"exam":{"title":"Numerical Mathematics - Advanced Exam","subtitle":"Algorithms and approximation","duration":120,"totalPoints":75,"difficulty":"advanced","language":"en","instructions":"Answer all questions."},"exercises":[{"id":1,"topic":"Root Finding","title":"Newton's method","description":"One step for f(x)=x^3-2.","difficulty":"easy","points":10,"solutionSteps":["Derivative","Update"]}]}
                """
            } else {
                json = """
                {"exam":{"title":"Numerische Mathematik - Expertenklausur","subtitle":"Algorithmen und Approximation","duration":120,"totalPoints":75,"difficulty":"advanced","language":"de","instructions":"Bearbeiten Sie alle Aufgaben."},"exercises":[{"id":1,"topic":"Nullstellen","title":"Newton","description":"Ein Schritt für f(x)=x^3-2.","difficulty":"easy","points":10,"solutionSteps":["Ableitung","Update"]}]}
                """
            }
            return json.data(using: .utf8)
        }
        
        private func embeddedLinearAlgebraAdvanced(language: AppLanguage) -> Data? {
            let json: String
            if language == .english {
                json = """
                {"exam":{"title":"Linear Algebra - Expert Exam","subtitle":"Advanced theory and applications","duration":180,"totalPoints":150,"difficulty":"advanced","language":"en","instructions":"Answer all questions."},"exercises":[{"id":1,"topic":"Jordan Normal Form","title":"Complex Jordan blocks","description":"Determine Jordan form.","difficulty":"hard","points":18,"solutionSteps":["Find eigenvalues","Determine blocks"]},{"id":2,"topic":"Spectral Theory","title":"Spectral radius","description":"Compute spectral radius.","difficulty":"hard","points":15,"solutionSteps":["Find eigenvalues","Take maximum"]},{"id":3,"topic":"Tensor Products","title":"Tensor spaces","description":"Work with tensor products.","difficulty":"hard","points":12,"solutionSteps":["Define basis","Compute tensor"]},{"id":4,"topic":"Multilinear Algebra","title":"Alternating forms","description":"Study alternating forms.","difficulty":"hard","points":14,"solutionSteps":["Check alternating","Compute determinant"]},{"id":5,"topic":"Module Theory","title":"Finitely generated modules","description":"Analyze module structure.","difficulty":"hard","points":16,"solutionSteps":["Set up relations","Find Smith form"]},{"id":6,"topic":"Lie Algebras","title":"Lie brackets","description":"Work with Lie algebras.","difficulty":"hard","points":15,"solutionSteps":["Compute brackets","Check Jacobi"]},{"id":7,"topic":"Functional Analysis","title":"Operator norms","description":"Study bounded operators.","difficulty":"hard","points":18,"solutionSteps":["Show boundedness","Compute norm"]},{"id":8,"topic":"Homological Algebra","title":"Exact sequences","description":"Work with exact sequences.","difficulty":"hard","points":16,"solutionSteps":["Check exactness","Compute Tor"]},{"id":9,"topic":"Representation Theory","title":"Group representations","description":"Study group representations.","difficulty":"hard","points":14,"solutionSteps":["Find conjugacy classes","Count representations"]},{"id":10,"topic":"Algebraic Geometry","title":"Grassmannians","description":"Study Grassmann varieties.","difficulty":"hard","points":20,"solutionSteps":["Compute dimension","Find parametrization"]}]}
                """
            } else {
                json = """
                {"exam":{"title":"Lineare Algebra - Expertenklausur","subtitle":"Fortgeschrittene Theorie und Anwendungen","duration":180,"totalPoints":150,"difficulty":"advanced","language":"de","instructions":"Bearbeiten Sie alle Aufgaben."},"exercises":[{"id":1,"topic":"Jordansche Normalform","title":"Komplexe Jordanblöcke","description":"Bestimmen Sie die Jordan-Form.","difficulty":"hard","points":18,"solutionSteps":["Eigenwerte finden","Blöcke bestimmen"]},{"id":2,"topic":"Spektraltheorie","title":"Spektralradius","description":"Berechnen Sie den Spektralradius.","difficulty":"hard","points":15,"solutionSteps":["Eigenwerte finden","Maximum nehmen"]},{"id":3,"topic":"Tensorprodukte","title":"Tensorräume","description":"Arbeiten Sie mit Tensorprodukten.","difficulty":"hard","points":12,"solutionSteps":["Basis definieren","Tensor berechnen"]},{"id":4,"topic":"Multilineare Algebra","title":"Alternierende Formen","description":"Studieren Sie alternierende Formen.","difficulty":"hard","points":14,"solutionSteps":["Alternierend prüfen","Determinante berechnen"]},{"id":5,"topic":"Modultheorie","title":"Endlich erzeugte Moduln","description":"Analysieren Sie Modulstrukturen.","difficulty":"hard","points":16,"solutionSteps":["Relationen aufstellen","Smith-Form finden"]},{"id":6,"topic":"Lie-Algebren","title":"Lie-Klammern","description":"Arbeiten Sie mit Lie-Algebren.","difficulty":"hard","points":15,"solutionSteps":["Klammern berechnen","Jacobi prüfen"]},{"id":7,"topic":"Funktionalanalysis","title":"Operatornormen","description":"Studieren Sie beschränkte Operatoren.","difficulty":"hard","points":18,"solutionSteps":["Beschränktheit zeigen","Norm berechnen"]},{"id":8,"topic":"Homologische Algebra","title":"Exakte Sequenzen","description":"Arbeiten Sie mit exakten Sequenzen.","difficulty":"hard","points":16,"solutionSteps":["Exaktheit prüfen","Tor berechnen"]},{"id":9,"topic":"Darstellungstheorie","title":"Gruppendarstellungen","description":"Studieren Sie Gruppendarstellungen.","difficulty":"hard","points":14,"solutionSteps":["Konjugationsklassen finden","Darstellungen zählen"]},{"id":10,"topic":"Algebraische Geometrie","title":"Grassmannsche","description":"Studieren Sie Grassmann-Varietäten.","difficulty":"hard","points":20,"solutionSteps":["Dimension berechnen","Parametrisierung finden"]}]}
                """
            }
            return json.data(using: .utf8)
        }
        
        private func embeddedMathematics1Beginner(language: AppLanguage) -> Data? {
            let json: String
            if language == .english {
                json = """
                {"exam":{"title":"Mathematics I - Beginner Exam","subtitle":"Linear algebra and abstract algebra","duration":120,"totalPoints":80,"difficulty":"beginner","language":"en","instructions":"Answer all questions."},"exercises":[{"id":1,"topic":"Complex Numbers","title":"Basic operations","description":"Compute with complex numbers.","difficulty":"easy","points":10,"solutionSteps":["Add","Multiply"]}]}
                """
            } else {
                json = """
                {"exam":{"title":"Mathematik I - Anfängerklausur","subtitle":"Lineare Algebra und abstrakte Algebra","duration":120,"totalPoints":80,"difficulty":"beginner","language":"de","instructions":"Bearbeiten Sie alle Aufgaben."},"exercises":[{"id":1,"topic":"Komplexe Zahlen","title":"Grundoperationen","description":"Rechnen Sie mit komplexen Zahlen.","difficulty":"easy","points":10,"solutionSteps":["Addieren","Multiplizieren"]}]}
                """
            }
            return json.data(using: .utf8)
        }
        
        private func embeddedMathematics1Intermediate(language: AppLanguage) -> Data? {
            let json: String
            if language == .english {
                json = """
                {"exam":{"title":"Mathematics I - Intermediate Exam","subtitle":"Extended linear and abstract algebra","duration":150,"totalPoints":150,"difficulty":"intermediate","language":"en","instructions":"Answer all questions."},"exercises":[{"id":1,"topic":"Complex Numbers","title":"Polar form","description":"Convert to polar form.","difficulty":"medium","points":15,"solutionSteps":["Find modulus","Find argument"]}]}
                """
            } else {
                json = """
                {"exam":{"title":"Mathematik I - Fortgeschrittenenklausur","subtitle":"Erweiterte lineare und abstrakte Algebra","duration":150,"totalPoints":150,"difficulty":"intermediate","language":"de","instructions":"Bearbeiten Sie alle Aufgaben."},"exercises":[{"id":1,"topic":"Komplexe Zahlen","title":"Polarform","description":"In Polarform umwandeln.","difficulty":"medium","points":15,"solutionSteps":["Betrag finden","Argument finden"]}]}
                """
            }
            return json.data(using: .utf8)
        }
        
        private func embeddedMathematics1Advanced(language: AppLanguage) -> Data? {
            let json: String
            if language == .english {
                json = """
                {"exam":{"title":"Mathematics I - Expert Exam","subtitle":"Advanced abstract and linear algebra","duration":180,"totalPoints":180,"difficulty":"advanced","language":"en","instructions":"Answer all questions."},"exercises":[{"id":1,"topic":"Algebraic Number Theory","title":"Quadratic number fields","description":"Study quadratic extensions.","difficulty":"hard","points":20,"solutionSteps":["Define field","Find units"]}]}
                """
            } else {
                json = """
                {"exam":{"title":"Mathematik I - Expertenklausur","subtitle":"Fortgeschrittene abstrakte und lineare Algebra","duration":180,"totalPoints":180,"difficulty":"advanced","language":"de","instructions":"Bearbeiten Sie alle Aufgaben."},"exercises":[{"id":1,"topic":"Algebraische Zahlentheorie","title":"Quadratische Zahlkörper","description":"Studieren Sie quadratische Erweiterungen.","difficulty":"hard","points":20,"solutionSteps":["Körper definieren","Einheiten finden"]}]}
                """
            }
            return json.data(using: .utf8)
        }
        
        private func embeddedLinearAlgebra1Beginner(language: AppLanguage) -> Data? {
            let json: String
            if language == .english {
                json = """
                {"exam":{"title":"Linear Algebra I - Beginner Exam","subtitle":"Fundamentals of linear algebra","duration":120,"totalPoints":60,"difficulty":"beginner","language":"en","instructions":"Answer all questions."},"exercises":[{"id":1,"topic":"Vector Operations","title":"Basic operations","description":"Compute with vectors.","difficulty":"easy","points":8,"solutionSteps":["Add vectors","Compute length"]}]}
                """
            } else {
                json = """
                {"exam":{"title":"Lineare Algebra I - Anfängerklausur","subtitle":"Grundlagen der linearen Algebra","duration":120,"totalPoints":60,"difficulty":"beginner","language":"de","instructions":"Bearbeiten Sie alle Aufgaben."},"exercises":[{"id":1,"topic":"Vektorrechnung","title":"Grundoperationen","description":"Rechnen Sie mit Vektoren.","difficulty":"easy","points":8,"solutionSteps":["Vektoren addieren","Länge berechnen"]}]}
                """
            }
            return json.data(using: .utf8)
        }
    }
    
    func loadExam(filename: String, language: AppLanguage) -> Exam? {
        let languageCode = language == .english ? "en" : "de"
        print("🔍 EXAM LOADING: Attempting to load exam: \(filename).json")
        print("🔍 EXAM LOADING: Language: \(language.rawValue)")
        
        // Try multiple locations in this order:
        // 1. In klausuren/language subdirectory
        // 2. Directly in bundle root
        // 3. Fallback: embedded defaults (for development when resources are not yet bundled)
        
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
        } else {
            // Try searching any subdirectory for the resource name
            if let anyUrls = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: nil) {
                if let match = anyUrls.first(where: { $0.lastPathComponent == "\(filename).json" }) {
                    print("✅ EXAM LOADING: Found exam file via exhaustive search: \(match)")
                    url = match
                }
            }
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
        }
        
        // Embedded fallback
        print("⚠️ EXAM LOADING: Falling back to embedded defaults for \(filename).json")
        if let embeddedData = DefaultExamStore.shared.data(for: filename, language: language) {
            do {
                let exam = try JSONDecoder().decode(Exam.self, from: embeddedData)
                print("✅ EXAM LOADING: Decoded embedded exam: \(exam.exam.title)")
                return exam
            } catch {
                print("❌ EXAM LOADING: Embedded decode failed: \(error)")
            }
        }
        
        print("❌ EXAM LOADING: Bundle file not found in any location and no embedded default for \(filename).json")
        
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
