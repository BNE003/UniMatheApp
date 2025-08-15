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
            case "linear_algebra_advanced", "lineare_algebra_experte", "linear_algebra_expert":
                return embeddedLinearAlgebraAdvanced(language: language)
            case "mathematics_1_beginner", "mathematik_1_anfaenger":
                return embeddedMathematics1Beginner(language: language)
            case "mathematics_1_intermediate", "mathematik_1_fortgeschritten":
                return embeddedMathematics1Intermediate(language: language)
            case "mathematics_1_advanced", "mathematik_1_experte":
                return embeddedMathematics1Advanced(language: language)
            case "linear_algebra_1_beginner", "lineare_algebra_1_anfaenger":
                return embeddedLinearAlgebra1Beginner(language: language)
            case "linear_algebra_beginner":
                return embeddedLinearAlgebraBeginner(language: language)
            case "statistics_beginner", "statistik_anfaenger":
                return embeddedStatisticsBeginner(language: language)
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
                {"exam":{"title":"Linear Algebra - Expert Exam","subtitle":"Advanced Theory and Applications","duration":180,"totalPoints":150,"difficulty":"advanced","language":"en","instructions":"Complete all tasks. Show complete solution approach for all calculations. Proofs must be complete and rigorous. Permitted aids: calculator without programming function. Good luck!"},"exercises":[{"id":1,"topic":"Jordan Normal Form","title":"Complex Jordan Blocks","description":"Given is the matrix $A = \\\\begin{pmatrix} 2 & 1 & 0 & 0 \\\\\\\\ 0 & 2 & 1 & 0 \\\\\\\\ 0 & 0 & 2 & 0 \\\\\\\\ 0 & 0 & 0 & 3 \\\\end{pmatrix}$.\\n\\na) Determine the Jordan normal form of $A$\\nb) Calculate the minimal polynomial of $A$\\nc) Determine a transformation matrix $P$ with $P^{-1}AP = J$","difficulty":"hard","points":18,"solutionSteps":["Step 1: Determine eigenvalues\\nSince $A$ is an upper triangular matrix, the eigenvalues are the diagonal entries:\\n$\\\\lambda_1 = 2$ (triple), $\\\\lambda_2 = 3$ (simple)\\nCharacteristic polynomial: $\\\\chi_A(\\\\lambda) = (\\\\lambda - 2)^3(\\\\lambda - 3)$","Step 2: Determine geometric multiplicity\\n$(A - 2I) = \\\\begin{pmatrix} 0 & 1 & 0 & 0 \\\\\\\\ 0 & 0 & 1 & 0 \\\\\\\\ 0 & 0 & 0 & 0 \\\\\\\\ 0 & 0 & 0 & 1 \\\\end{pmatrix}$\\n$\\\\text{rank}(A - 2I) = 3$\\nGeometric multiplicity of $\\\\lambda = 2$: $\\\\dim(\\\\ker(A - 2I)) = 4 - 3 = 1$","Step 3: Determine nilpotency index\\n$(A - 2I)^2 = \\\\begin{pmatrix} 0 & 0 & 1 & 0 \\\\\\\\ 0 & 0 & 0 & 0 \\\\\\\\ 0 & 0 & 0 & 0 \\\\\\\\ 0 & 0 & 0 & 0 \\\\end{pmatrix}$\\n$(A - 2I)^3 = 0$\\nNilpotency index: 3, since $(A - 2I)^2 \\\\neq 0$ but $(A - 2I)^3 = 0$","Step 4: Jordan normal form\\nSince the geometric multiplicity is 1 and the nilpotency index is 3, there is one $3 \\\\times 3$ Jordan block for $\\\\lambda = 2$ and one $1 \\\\times 1$ block for $\\\\lambda = 3$:\\n$J = \\\\begin{pmatrix} 2 & 1 & 0 & 0 \\\\\\\\ 0 & 2 & 1 & 0 \\\\\\\\ 0 & 0 & 2 & 0 \\\\\\\\ 0 & 0 & 0 & 3 \\\\end{pmatrix}$\\nThis is already the given matrix $A$.","Step 5: Minimal polynomial\\nThe minimal polynomial is $(\\\\lambda - 2)^s(\\\\lambda - 3)^t$, where $s$ is the size of the largest Jordan block for $\\\\lambda = 2$ and $t$ is the size of the largest Jordan block for $\\\\lambda = 3$.\\n$s = 3$, $t = 1$\\n$m_A(\\\\lambda) = (\\\\lambda - 2)^3(\\\\lambda - 3)$","Step 6: Transformation matrix\\nSince $A$ is already in Jordan normal form, $P = I$ (identity matrix) is a possible transformation matrix.\\n$P^{-1}AP = IAI = A = J$"]},{"id":2,"topic":"Spectral Theory","title":"Spectral Radius and Matrix Powers","description":"Let $B = \\\\begin{pmatrix} 0.5 & 0.3 \\\\\\\\ 0.2 & 0.4 \\\\end{pmatrix}$.\\n\\na) Calculate the spectral radius $\\\\rho(B)$\\nb) Show that $\\\\lim_{n \\\\to \\\\infty} B^n$ exists\\nc) Determine the limit $\\\\lim_{n \\\\to \\\\infty} B^n$","difficulty":"hard","points":15,"solutionSteps":["Step 1: Calculate eigenvalues of B\\n$\\\\det(B - \\\\lambda I) = (0.5-\\\\lambda)(0.4-\\\\lambda) - 0.3 \\\\cdot 0.2 = \\\\lambda^2 - 0.9\\\\lambda + 0.14$\\n$\\\\lambda_{1,2} = \\\\frac{0.9 \\\\pm \\\\sqrt{0.81 - 0.56}}{2} = \\\\frac{0.9 \\\\pm 0.5}{2}$\\n$\\\\lambda_1 = 0.7$, $\\\\lambda_2 = 0.2$","Step 2: Spectral radius\\n$\\\\rho(B) = \\\\max\\\\{|\\\\lambda_1|, |\\\\lambda_2|\\\\} = \\\\max\\\\{0.7, 0.2\\\\} = 0.7 < 1$","Step 3: Convergence of $B^n$\\nSince $\\\\rho(B) = 0.7 < 1$, $B^n$ converges for $n \\\\to \\\\infty$ to a matrix.\\nThis follows from the spectral radius theorem.","Step 4: Calculate limit\\nFor the limit $L = \\\\lim_{n \\\\to \\\\infty} B^n$, we have $BL = L$.\\nSince $\\\\rho(B) = 0.7 < 1$, $\\\\lambda = 1$ is not an eigenvalue, so $L = 0$."]},{"id":3,"topic":"Tensor Products","title":"Tensor Product of Vector Spaces","description":"Let $V = \\\\mathbb{R}^2$ and $W = \\\\mathbb{R}^3$ with bases $\\\\{e_1, e_2\\\\}$ and $\\\\{f_1, f_2, f_3\\\\}$ respectively.\\n\\na) Determine a basis for $V \\\\otimes W$\\nb) Express $v \\\\otimes w$ with $v = \\\\begin{pmatrix} 2 \\\\\\\\ 1 \\\\end{pmatrix}$ and $w = \\\\begin{pmatrix} 1 \\\\\\\\ 0 \\\\\\\\ -1 \\\\end{pmatrix}$ as a linear combination of the basis\\nc) Show that $\\\\dim(V \\\\otimes W) = \\\\dim(V) \\\\cdot \\\\dim(W)$","difficulty":"hard","points":12,"solutionSteps":["Step 1: Basis for $V \\\\otimes W$\\nA basis for the tensor product $V \\\\otimes W$ is formed by the tensor products of the basis elements:\\n$\\\\{e_1 \\\\otimes f_1, e_1 \\\\otimes f_2, e_1 \\\\otimes f_3, e_2 \\\\otimes f_1, e_2 \\\\otimes f_2, e_2 \\\\otimes f_3\\\\}$\\nThese are 6 basis elements.","Step 2: Representation of $v \\\\otimes w$\\n$v = 2e_1 + 1e_2$, $w = 1f_1 + 0f_2 + (-1)f_3$\\n$v \\\\otimes w = (2e_1 + e_2) \\\\otimes (f_1 - f_3)$\\n$= 2e_1 \\\\otimes f_1 - 2e_1 \\\\otimes f_3 + e_2 \\\\otimes f_1 - e_2 \\\\otimes f_3$","Step 3: Dimension of tensor product\\n$\\\\dim(V \\\\otimes W) = |\\\\text{Basis}| = 6 = 2 \\\\cdot 3 = \\\\dim(V) \\\\cdot \\\\dim(W)$"]},{"id":4,"topic":"Multilinear Algebra","title":"Alternating Forms and Determinants","description":"Let $\\\\omega: \\\\mathbb{R}^3 \\\\times \\\\mathbb{R}^3 \\\\times \\\\mathbb{R}^3 \\\\to \\\\mathbb{R}$ be the alternating 3-form given by $\\\\omega(x, y, z) = \\\\det(x, y, z)$.\\n\\na) Show that $\\\\omega$ is alternating\\nb) Calculate $\\\\omega$ for three given vectors\\nc) Determine the dimension of the space of all alternating 3-forms on $\\\\mathbb{R}^3$","difficulty":"hard","points":14,"solutionSteps":["Step 1: Show alternating property\\nA multilinear form is alternating if it changes sign when two arguments are swapped.\\nFor the determinant: $\\\\det(x, y, z) = -\\\\det(y, x, z)$ (swapping the first two columns)","Step 2: Perform calculation\\nFor concrete vectors, the determinant is calculated using the usual rules.","Step 3: Determine dimension\\nThe space of alternating $k$-forms on $\\\\mathbb{R}^n$ has dimension $\\\\binom{n}{k}$.\\nFor $k = 3$ and $n = 3$: $\\\\dim = \\\\binom{3}{3} = 1$"]},{"id":5,"topic":"Module Theory","title":"Finitely Generated Modules","description":"Let $M$ be a finitely generated $\\\\mathbb{Z}$-module with generators $\\\\{m_1, m_2, m_3\\\\}$ and relations $2m_1 + 3m_2 = 0$, $m_1 + m_3 = 0$, $4m_2 + 2m_3 = 0$.\\n\\na) Set up the relation matrix\\nb) Determine the Smith normal form\\nc) Give the structure of $M$ as a direct sum of cyclic modules","difficulty":"hard","points":16,"solutionSteps":["Step 1: Set up relation matrix\\nThe relation matrix $R = \\\\begin{pmatrix} 2 & 3 & 0 \\\\\\\\ 1 & 0 & 1 \\\\\\\\ 0 & 4 & 2 \\\\end{pmatrix}$","Step 2: Calculate Smith normal form\\nThrough elementary row and column operations we obtain the Smith normal form.","Step 3: Determine structure\\nBy the structure theorem for finitely generated modules over principal ideal domains, the structure follows from the invariants."]},{"id":6,"topic":"Lie Algebras","title":"Lie Bracket and Jacobi Identity","description":"Consider the Lie algebra $\\\\mathfrak{sl}_2(\\\\mathbb{R})$ of traceless $2 \\\\times 2$ matrices with the Lie bracket $[X,Y] = XY - YX$.\\n\\na) Show that the matrices $H$, $E$, $F$ form a basis\\nb) Calculate all Lie brackets\\nc) Verify the Jacobi identity","difficulty":"hard","points":15,"solutionSteps":["Step 1: Verify basis\\nThe three matrices are linearly independent and span the 3-dimensional space.","Step 2: Calculate Lie brackets\\n$[H,E] = 2E$, $[H,F] = -2F$, $[E,F] = H$","Step 3: Check Jacobi identity\\n$[X,[Y,Z]] + [Y,[Z,X]] + [Z,[X,Y]] = 0$ for all combinations"]},{"id":7,"topic":"Functional Analysis","title":"Operator Norms and Compactness","description":"Let $T: \\\\ell^2 \\\\to \\\\ell^2$ be the linear operator defined by $(Tx)_n = \\\\frac{x_n}{n}$.\\n\\na) Show that $T$ is bounded\\nb) Calculate the operator norm $\\\\|T\\\\|$\\nc) Investigate whether $T$ is compact","difficulty":"hard","points":18,"solutionSteps":["Step 1: Show boundedness\\n$\\\\|Tx\\\\|_2^2 = \\\\sum_{n=1}^\\\\infty \\\\frac{|x_n|^2}{n^2} \\\\leq \\\\sum_{n=1}^\\\\infty |x_n|^2 = \\\\|x\\\\|_2^2$","Step 2: Calculate operator norm\\n$\\\\|T\\\\| = \\\\sup_{\\\\|x\\\\|_2 \\\\leq 1} \\\\|Tx\\\\|_2 = 1$","Step 3: Investigate compactness\\nSince $\\\\frac{1}{n} \\\\to 0$, $T$ is compact by the theorem on compact operators."]},{"id":8,"topic":"Homological Algebra","title":"Exact Sequences and Tor Functors","description":"Consider the short exact sequence: $0 \\\\to \\\\mathbb{Z} \\\\xrightarrow{\\\\cdot 2} \\\\mathbb{Z} \\\\xrightarrow{\\\\pi} \\\\mathbb{Z}/2\\\\mathbb{Z} \\\\to 0$\\n\\na) Verify exactness\\nb) Calculate $\\\\text{Tor}_1^\\\\mathbb{Z}(\\\\mathbb{Z}/2\\\\mathbb{Z}, \\\\mathbb{Z}/3\\\\mathbb{Z})$\\nc) Interpret the result","difficulty":"hard","points":16,"solutionSteps":["Step 1: Verify exactness\\n$\\\\ker(\\\\pi) = 2\\\\mathbb{Z} = \\\\text{im}(\\\\cdot 2)$","Step 2: Calculate Tor functor\\nUse the projective resolution and tensor with $\\\\mathbb{Z}/3\\\\mathbb{Z}$.","Step 3: Interpretation\\nThe vanishing of $\\\\text{Tor}_1$ means that the modules are 'coprime'."]},{"id":9,"topic":"Representation Theory","title":"Irreducible Representations","description":"Consider the group $GL_2(\\\\mathbb{F}_2)$ of invertible $2 \\\\times 2$ matrices over $\\\\mathbb{F}_2$.\\n\\na) Determine the order of $GL_2(\\\\mathbb{F}_2)$\\nb) Find all conjugacy classes\\nc) Determine the number of irreducible representations","difficulty":"hard","points":14,"solutionSteps":["Step 1: Determine order\\n$|GL_2(\\\\mathbb{F}_2)| = (2^2 - 1)(2^2 - 2^1) = 3 \\\\cdot 2 = 6$","Step 2: Find conjugacy classes\\nThere are 3 conjugacy classes corresponding to the matrix types.","Step 3: Irreducible representations\\nNumber = Number of conjugacy classes = 3"]},{"id":10,"topic":"Algebraic Geometry","title":"Linear Varieties and Grassmannians","description":"Consider the Grassmannian $Gr(2,4)$ of 2-dimensional subspaces of $\\\\mathbb{C}^4$.\\n\\na) Determine the dimension of $Gr(2,4)$\\nb) Parametrize an open part\\nc) Show that $Gr(2,4)$ is an algebraic variety","difficulty":"hard","points":20,"solutionSteps":["Step 1: Determine dimension\\n$\\\\dim(Gr(2,4)) = 2(4-2) = 4$","Step 2: Plücker embedding\\nEach 2-dimensional subspace is parametrized by Plücker coordinates.","Step 3: Algebraic variety\\n$Gr(2,4)$ is an algebraic variety as the zero set of the Plücker relations."]}]}
                """
            } else {
                json = """
                {"exam":{"title":"Lineare Algebra - Expertenklausur","subtitle":"Fortgeschrittene Theorie und Anwendungen","duration":180,"totalPoints":150,"difficulty":"advanced","language":"de","instructions":"Bearbeiten Sie alle Aufgaben. Geben Sie bei allen Berechnungen den vollständigen Lösungsweg an. Beweise müssen vollständig und rigoros geführt werden. Hilfsmittel: Taschenrechner ohne Programmierfunktion. Viel Erfolg!"},"exercises":[{"id":1,"topic":"Jordansche Normalform","title":"Komplexe Jordanblöcke","description":"Gegeben ist die Matrix $A = \\\\begin{pmatrix} 2 & 1 & 0 & 0 \\\\\\\\ 0 & 2 & 1 & 0 \\\\\\\\ 0 & 0 & 2 & 0 \\\\\\\\ 0 & 0 & 0 & 3 \\\\end{pmatrix}$.\\n\\na) Bestimmen Sie die Jordansche Normalform von $A$\\nb) Berechnen Sie das Minimalpolynom von $A$\\nc) Bestimmen Sie eine Transformationsmatrix $P$ mit $P^{-1}AP = J$","difficulty":"hard","points":18,"solutionSteps":["Schritt 1: Eigenwerte bestimmen\\nDa $A$ eine obere Dreiecksmatrix ist, sind die Eigenwerte die Diagonaleinträge:\\n$\\\\lambda_1 = 2$ (dreifach), $\\\\lambda_2 = 3$ (einfach)\\nCharakteristisches Polynom: $\\\\chi_A(\\\\lambda) = (\\\\lambda - 2)^3(\\\\lambda - 3)$","Schritt 2: Geometrische Vielfachheit bestimmen\\n$(A - 2I) = \\\\begin{pmatrix} 0 & 1 & 0 & 0 \\\\\\\\ 0 & 0 & 1 & 0 \\\\\\\\ 0 & 0 & 0 & 0 \\\\\\\\ 0 & 0 & 0 & 1 \\\\end{pmatrix}$\\n$\\\\text{rang}(A - 2I) = 3$\\nGeometrische Vielfachheit von $\\\\lambda = 2$: $\\\\dim(\\\\ker(A - 2I)) = 4 - 3 = 1$","Schritt 3: Nilpotenz-Index bestimmen\\n$(A - 2I)^2 = \\\\begin{pmatrix} 0 & 0 & 1 & 0 \\\\\\\\ 0 & 0 & 0 & 0 \\\\\\\\ 0 & 0 & 0 & 0 \\\\\\\\ 0 & 0 & 0 & 0 \\\\end{pmatrix}$\\n$(A - 2I)^3 = 0$\\nNilpotenz-Index: 3, da $(A - 2I)^2 \\\\neq 0$ aber $(A - 2I)^3 = 0$","Schritt 4: Jordansche Normalform\\nDa die geometrische Vielfachheit 1 ist und der Nilpotenz-Index 3, gibt es einen $3 \\\\times 3$ Jordanblock für $\\\\lambda = 2$ und einen $1 \\\\times 1$ Block für $\\\\lambda = 3$:\\n$J = \\\\begin{pmatrix} 2 & 1 & 0 & 0 \\\\\\\\ 0 & 2 & 1 & 0 \\\\\\\\ 0 & 0 & 2 & 0 \\\\\\\\ 0 & 0 & 0 & 3 \\\\end{pmatrix}$\\nDies ist bereits die gegebene Matrix $A$.","Schritt 5: Minimalpolynom\\nDas Minimalpolynom ist $(\\\\lambda - 2)^s(\\\\lambda - 3)^t$, wobei $s$ die Größe des größten Jordanblocks zu $\\\\lambda = 2$ und $t$ die Größe des größten Jordanblocks zu $\\\\lambda = 3$ ist.\\n$s = 3$, $t = 1$\\n$m_A(\\\\lambda) = (\\\\lambda - 2)^3(\\\\lambda - 3)$","Schritt 6: Transformationsmatrix\\nDa $A$ bereits in Jordanscher Normalform ist, ist $P = I$ (Einheitsmatrix) eine mögliche Transformationsmatrix.\\n$P^{-1}AP = IAI = A = J$"]},{"id":2,"topic":"Spektraltheorie","title":"Spektralradius und Matrixpotenzen","description":"Sei $B = \\\\begin{pmatrix} 0.5 & 0.3 \\\\\\\\ 0.2 & 0.4 \\\\end{pmatrix}$.\\n\\na) Berechnen Sie den Spektralradius $\\\\rho(B)$\\nb) Zeigen Sie, dass $\\\\lim_{n \\\\to \\\\infty} B^n$ existiert\\nc) Bestimmen Sie den Grenzwert $\\\\lim_{n \\\\to \\\\infty} B^n$","difficulty":"hard","points":15,"solutionSteps":["Schritt 1: Eigenwerte von B berechnen\\n$\\\\det(B - \\\\lambda I) = (0.5-\\\\lambda)(0.4-\\\\lambda) - 0.3 \\\\cdot 0.2 = \\\\lambda^2 - 0.9\\\\lambda + 0.14$\\n$\\\\lambda_{1,2} = \\\\frac{0.9 \\\\pm \\\\sqrt{0.81 - 0.56}}{2} = \\\\frac{0.9 \\\\pm 0.5}{2}$\\n$\\\\lambda_1 = 0.7$, $\\\\lambda_2 = 0.2$","Schritt 2: Spektralradius\\n$\\\\rho(B) = \\\\max\\\\{|\\\\lambda_1|, |\\\\lambda_2|\\\\} = \\\\max\\\\{0.7, 0.2\\\\} = 0.7 < 1$","Schritt 3: Konvergenz von $B^n$\\nDa $\\\\rho(B) = 0.7 < 1$, konvergiert $B^n$ für $n \\\\to \\\\infty$ gegen eine Matrix.\\nDies folgt aus dem Spektralradius-Theorem.","Schritt 4: Grenzwert berechnen\\nFür den Grenzwert $L = \\\\lim_{n \\\\to \\\\infty} B^n$ gilt $BL = L$.\\nDa $\\\\rho(B) = 0.7 < 1$, ist $\\\\lambda = 1$ kein Eigenwert, also $L = 0$."]},{"id":3,"topic":"Tensorprodukte","title":"Tensorprodukt von Vektorräumen","description":"Seien $V = \\\\mathbb{R}^2$ und $W = \\\\mathbb{R}^3$ mit Basen $\\\\{e_1, e_2\\\\}$ bzw. $\\\\{f_1, f_2, f_3\\\\}$.\\n\\na) Bestimmen Sie eine Basis für $V \\\\otimes W$\\nb) Stellen Sie $v \\\\otimes w$ mit $v = \\\\begin{pmatrix} 2 \\\\\\\\ 1 \\\\end{pmatrix}$ und $w = \\\\begin{pmatrix} 1 \\\\\\\\ 0 \\\\\\\\ -1 \\\\end{pmatrix}$ als Linearkombination der Basis dar\\nc) Zeigen Sie, dass $\\\\dim(V \\\\otimes W) = \\\\dim(V) \\\\cdot \\\\dim(W)$","difficulty":"hard","points":12,"solutionSteps":["Schritt 1: Basis für $V \\\\otimes W$\\nEine Basis für das Tensorprodukt $V \\\\otimes W$ wird durch die Tensorprodukte der Basiselemente gebildet:\\n$\\\\{e_1 \\\\otimes f_1, e_1 \\\\otimes f_2, e_1 \\\\otimes f_3, e_2 \\\\otimes f_1, e_2 \\\\otimes f_2, e_2 \\\\otimes f_3\\\\}$\\nDies sind 6 Basiselemente.","Schritt 2: Darstellung von $v \\\\otimes w$\\n$v = 2e_1 + 1e_2$, $w = 1f_1 + 0f_2 + (-1)f_3$\\n$v \\\\otimes w = (2e_1 + e_2) \\\\otimes (f_1 - f_3)$\\n$= 2e_1 \\\\otimes f_1 - 2e_1 \\\\otimes f_3 + e_2 \\\\otimes f_1 - e_2 \\\\otimes f_3$","Schritt 3: Dimension des Tensorprodukts\\n$\\\\dim(V \\\\otimes W) = |\\\\text{Basis}| = 6 = 2 \\\\cdot 3 = \\\\dim(V) \\\\cdot \\\\dim(W)$"]},{"id":4,"topic":"Multilineare Algebra","title":"Alternierende Formen und Determinanten","description":"Sei $\\\\omega: \\\\mathbb{R}^3 \\\\times \\\\mathbb{R}^3 \\\\times \\\\mathbb{R}^3 \\\\to \\\\mathbb{R}$ die alternierende 3-Form gegeben durch $\\\\omega(x, y, z) = \\\\det(x, y, z)$.\\n\\na) Zeigen Sie, dass $\\\\omega$ alternierend ist\\nb) Berechnen Sie $\\\\omega$ für drei gegebene Vektoren\\nc) Bestimmen Sie die Dimension des Raums aller alternierenden 3-Formen auf $\\\\mathbb{R}^3$","difficulty":"hard","points":14,"solutionSteps":["Schritt 1: Alternierende Eigenschaft zeigen\\nEine multilineare Form ist alternierend, wenn sie bei Vertauschung zweier Argumente das Vorzeichen wechselt.\\nFür die Determinante gilt: $\\\\det(x, y, z) = -\\\\det(y, x, z)$ (Vertauschung der ersten beiden Spalten)","Schritt 2: Berechnung durchführen\\nFür konkrete Vektoren wird die Determinante nach den üblichen Regeln berechnet.","Schritt 3: Dimension bestimmen\\nDer Raum der alternierenden $k$-Formen auf $\\\\mathbb{R}^n$ hat Dimension $\\\\binom{n}{k}$.\\nFür $k = 3$ und $n = 3$: $\\\\dim = \\\\binom{3}{3} = 1$"]},{"id":5,"topic":"Modultheorie","title":"Endlich erzeugte Moduln","description":"Sei $M$ ein endlich erzeugter $\\\\mathbb{Z}$-Modul mit Erzeugern $\\\\{m_1, m_2, m_3\\\\}$ und Relationen $2m_1 + 3m_2 = 0$, $m_1 + m_3 = 0$, $4m_2 + 2m_3 = 0$.\\n\\na) Stellen Sie die Relationsmatrix auf\\nb) Bestimmen Sie die Smith-Normalform\\nc) Geben Sie die Struktur von $M$ als direkte Summe zyklischer Moduln an","difficulty":"hard","points":16,"solutionSteps":["Schritt 1: Relationsmatrix aufstellen\\nDie Relationsmatrix $R = \\\\begin{pmatrix} 2 & 3 & 0 \\\\\\\\ 1 & 0 & 1 \\\\\\\\ 0 & 4 & 2 \\\\end{pmatrix}$","Schritt 2: Smith-Normalform berechnen\\nDurch elementare Zeilen- und Spaltenoperationen erhalten wir die Smith-Normalform.","Schritt 3: Struktur bestimmen\\nNach dem Struktursatz für endlich erzeugte Moduln über Hauptidealringen folgt die Struktur aus den Invarianten."]},{"id":6,"topic":"Lie-Algebren","title":"Lie-Klammer und Jacobi-Identität","description":"Betrachten Sie die Lie-Algebra $\\\\mathfrak{sl}_2(\\\\mathbb{R})$ der spurlosen $2 \\\\times 2$-Matrizen mit der Lie-Klammer $[X,Y] = XY - YX$.\\n\\na) Zeigen Sie, dass die Matrizen $H$, $E$, $F$ eine Basis bilden\\nb) Berechnen Sie alle Lie-Klammern\\nc) Verifizieren Sie die Jacobi-Identität","difficulty":"hard","points":15,"solutionSteps":["Schritt 1: Basis verifizieren\\nDie drei Matrizen sind linear unabhängig und spannen den 3-dimensionalen Raum auf.","Schritt 2: Lie-Klammern berechnen\\n$[H,E] = 2E$, $[H,F] = -2F$, $[E,F] = H$","Schritt 3: Jacobi-Identität prüfen\\n$[X,[Y,Z]] + [Y,[Z,X]] + [Z,[X,Y]] = 0$ für alle Kombinationen"]},{"id":7,"topic":"Funktionalanalysis","title":"Operatornormen und Kompaktheit","description":"Sei $T: \\\\ell^2 \\\\to \\\\ell^2$ der lineare Operator definiert durch $(Tx)_n = \\\\frac{x_n}{n}$.\\n\\na) Zeigen Sie, dass $T$ beschränkt ist\\nb) Berechnen Sie die Operatornorm $\\\\|T\\\\|$\\nc) Untersuchen Sie, ob $T$ kompakt ist","difficulty":"hard","points":18,"solutionSteps":["Schritt 1: Beschränktheit zeigen\\n$\\\\|Tx\\\\|_2^2 = \\\\sum_{n=1}^\\\\infty \\\\frac{|x_n|^2}{n^2} \\\\leq \\\\sum_{n=1}^\\\\infty |x_n|^2 = \\\\|x\\\\|_2^2$","Schritt 2: Operatornorm berechnen\\n$\\\\|T\\\\| = \\\\sup_{\\\\|x\\\\|_2 \\\\leq 1} \\\\|Tx\\\\|_2 = 1$","Schritt 3: Kompaktheit untersuchen\\nDa $\\\\frac{1}{n} \\\\to 0$, ist $T$ kompakt nach dem Satz über kompakte Operatoren."]},{"id":8,"topic":"Homologische Algebra","title":"Exakte Sequenzen und Tor-Funktoren","description":"Betrachten Sie die kurze exakte Sequenz: $0 \\\\to \\\\mathbb{Z} \\\\xrightarrow{\\\\cdot 2} \\\\mathbb{Z} \\\\xrightarrow{\\\\pi} \\\\mathbb{Z}/2\\\\mathbb{Z} \\\\to 0$\\n\\na) Verifizieren Sie die Exaktheit\\nb) Berechnen Sie $\\\\text{Tor}_1^\\\\mathbb{Z}(\\\\mathbb{Z}/2\\\\mathbb{Z}, \\\\mathbb{Z}/3\\\\mathbb{Z})$\\nc) Interpretieren Sie das Ergebnis","difficulty":"hard","points":16,"solutionSteps":["Schritt 1: Exaktheit verifizieren\\n$\\\\ker(\\\\pi) = 2\\\\mathbb{Z} = \\\\text{im}(\\\\cdot 2)$","Schritt 2: Tor-Funktor berechnen\\nVerwende die projektive Auflösung und tensoriere mit $\\\\mathbb{Z}/3\\\\mathbb{Z}$.","Schritt 3: Interpretation\\nDas Verschwinden von $\\\\text{Tor}_1$ bedeutet, dass die Moduln 'teilerfremd' sind."]},{"id":9,"topic":"Darstellungstheorie","title":"Irreduzible Darstellungen","description":"Betrachten Sie die Gruppe $GL_2(\\\\mathbb{F}_2)$ der invertierbaren $2 \\\\times 2$-Matrizen über $\\\\mathbb{F}_2$.\\n\\na) Bestimmen Sie die Ordnung von $GL_2(\\\\mathbb{F}_2)$\\nb) Finden Sie alle Konjugationsklassen\\nc) Bestimmen Sie die Anzahl der irreduziblen Darstellungen","difficulty":"hard","points":14,"solutionSteps":["Schritt 1: Ordnung bestimmen\\n$|GL_2(\\\\mathbb{F}_2)| = (2^2 - 1)(2^2 - 2^1) = 3 \\\\cdot 2 = 6$","Schritt 2: Konjugationsklassen finden\\nEs gibt 3 Konjugationsklassen entsprechend der Matrixtypen.","Schritt 3: Irreduzible Darstellungen\\nAnzahl = Anzahl Konjugationsklassen = 3"]},{"id":10,"topic":"Algebraische Geometrie","title":"Lineare Varietäten und Grassmannsche","description":"Betrachten Sie die Grassmannsche $Gr(2,4)$ der 2-dimensionalen Unterräume von $\\\\mathbb{C}^4$.\\n\\na) Bestimmen Sie die Dimension von $Gr(2,4)$\\nb) Parametrisieren Sie einen offenen Teil\\nc) Zeigen Sie, dass $Gr(2,4)$ eine algebraische Varietät ist","difficulty":"hard","points":20,"solutionSteps":["Schritt 1: Dimension bestimmen\\n$\\\\dim(Gr(2,4)) = 2(4-2) = 4$","Schritt 2: Plücker-Einbettung\\nJeder 2-dimensionale Unterraum wird durch Plücker-Koordinaten parametrisiert.","Schritt 3: Algebraische Varietät\\n$Gr(2,4)$ ist als Nullstellenmenge der Plücker-Relation eine algebraische Varietät."]}]}
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
        
        private func embeddedLinearAlgebraBeginner(language: AppLanguage) -> Data? {
            let json: String
            if language == .english {
                json = """
                {"exam":{"title":"Linear Algebra I - Beginner Exam","subtitle":"Fundamentals of Linear Algebra","duration":120,"totalPoints":60,"difficulty":"beginner","language":"en","instructions":"Complete all tasks. Show complete solution approach for all calculations. Permitted aids: calculator without programming function. Good luck!"},"exercises":[{"id":1,"topic":"Vector Operations","title":"Basic Operations with Vectors","description":"Given are the vectors $\\\\vec{a} = \\\\begin{pmatrix} 2 \\\\\\\\ -1 \\\\\\\\ 3 \\\\end{pmatrix}$ and $\\\\vec{b} = \\\\begin{pmatrix} 1 \\\\\\\\ 4 \\\\\\\\ -2 \\\\end{pmatrix}$.\\n\\na) Calculate $\\\\vec{a} + \\\\vec{b}$\\nb) Calculate $3\\\\vec{a} - 2\\\\vec{b}$\\nc) Determine the length of $\\\\vec{a}$","difficulty":"easy","points":8,"solutionSteps":["Step 1: Vector addition","Step 2: Calculate linear combination","Step 3: Perform subtraction","Step 4: Calculate length of $\\\\vec{a}$","Step 5: Final results"]},{"id":2,"topic":"Dot Product","title":"Dot Product and Angle","description":"Given are the vectors $\\\\vec{u} = \\\\begin{pmatrix} 3 \\\\\\\\ 4 \\\\\\\\ 0 \\\\end{pmatrix}$ and $\\\\vec{v} = \\\\begin{pmatrix} 1 \\\\\\\\ 2 \\\\\\\\ 5 \\\\end{pmatrix}$.\\n\\na) Calculate the dot product $\\\\vec{u} \\\\cdot \\\\vec{v}$\\nb) Determine the angle between the vectors","difficulty":"easy","points":10,"solutionSteps":["Step 1: Calculate dot product","Step 2: Calculate vector lengths","Step 3: Apply angle formula","Step 4: Simplify fraction","Step 5: Determine angle","Step 6: Final results"]},{"id":3,"topic":"Linear Systems","title":"Simple Linear System","description":"Solve the following linear system using Gaussian elimination:\\n$\\\\begin{align}\\nx + 2y - z &= 3 \\\\\\\\\\n2x - y + z &= 1 \\\\\\\\\\n3x + y + 2z &= 11\\n\\\\end{align}$","difficulty":"medium","points":12,"solutionSteps":["Step 1: Set up augmented matrix","Step 2: Eliminate first column","Step 3: Eliminate second column","Step 4: Back substitution - determine z","Step 5: Determine y","Step 6: Determine x","Step 7: Solution"]},{"id":4,"topic":"Matrices","title":"Matrix Operations","description":"Given are the matrices $A = \\\\begin{pmatrix} 1 & 2 \\\\\\\\ 3 & 4 \\\\end{pmatrix}$ and $B = \\\\begin{pmatrix} 2 & 1 \\\\\\\\ 0 & 3 \\\\end{pmatrix}$.\\n\\na) Calculate $A + B$\\nb) Calculate $A \\\\cdot B$\\nc) Determine $\\\\det(A)$","difficulty":"easy","points":10,"solutionSteps":["Step 1: Matrix addition","Step 2: Matrix multiplication","Step 3: Result of multiplication","Step 4: Calculate determinant","Step 5: Final results"]},{"id":5,"topic":"Linear Independence","title":"Linear Independence of Vectors","description":"Check whether the vectors $\\\\vec{v_1} = \\\\begin{pmatrix} 1 \\\\\\\\ 2 \\\\\\\\ 1 \\\\end{pmatrix}$, $\\\\vec{v_2} = \\\\begin{pmatrix} 2 \\\\\\\\ 1 \\\\\\\\ 0 \\\\end{pmatrix}$ and $\\\\vec{v_3} = \\\\begin{pmatrix} 1 \\\\\\\\ -1 \\\\\\\\ -1 \\\\end{pmatrix}$ are linearly independent.","difficulty":"medium","points":10,"solutionSteps":["Step 1: Approach for linear independence","Step 2: Set up system of equations","Step 3: Matrix of the system","Step 4: Gaussian elimination","Step 5: Back substitution","Step 6: Conclusion"]},{"id":6,"topic":"Matrix Inverse","title":"Inverse of a 2×2 Matrix","description":"Determine the inverse of the matrix $C = \\\\begin{pmatrix} 3 & 1 \\\\\\\\ 2 & 1 \\\\end{pmatrix}$, if it exists.","difficulty":"medium","points":10,"solutionSteps":["Step 1: Calculate determinant","Step 2: Formula for 2×2 inverse","Step 3: Calculate inverse","Step 4: Perform verification","Step 5: Final result"]}]}
                """
            } else {
                json = """
                {"exam":{"title":"Lineare Algebra I - Anfängerklausur","subtitle":"Grundlagen der linearen Algebra","duration":120,"totalPoints":60,"difficulty":"beginner","language":"de","instructions":"Bearbeiten Sie alle Aufgaben. Geben Sie bei allen Berechnungen den vollständigen Lösungsweg an. Hilfsmittel: Taschenrechner ohne Programmierfunktion. Viel Erfolg!"},"exercises":[{"id":1,"topic":"Vektorrechnung","title":"Grundoperationen mit Vektoren","description":"Gegeben sind die Vektoren $\\\\vec{a} = \\\\begin{pmatrix} 2 \\\\\\\\ -1 \\\\\\\\ 3 \\\\end{pmatrix}$ und $\\\\vec{b} = \\\\begin{pmatrix} 1 \\\\\\\\ 4 \\\\\\\\ -2 \\\\end{pmatrix}$.\\n\\na) Berechnen Sie $\\\\vec{a} + \\\\vec{b}$\\nb) Berechnen Sie $3\\\\vec{a} - 2\\\\vec{b}$\\nc) Bestimmen Sie die Länge von $\\\\vec{a}$","difficulty":"easy","points":8,"solutionSteps":["Schritt 1: Vektoraddition","Schritt 2: Linearkombination berechnen","Schritt 3: Subtraktion durchführen","Schritt 4: Länge von $\\\\vec{a}$ berechnen","Schritt 5: Endergebnisse"]},{"id":2,"topic":"Skalarprodukt","title":"Skalarprodukt und Winkel","description":"Gegeben sind die Vektoren $\\\\vec{u} = \\\\begin{pmatrix} 3 \\\\\\\\ 4 \\\\\\\\ 0 \\\\end{pmatrix}$ und $\\\\vec{v} = \\\\begin{pmatrix} 1 \\\\\\\\ 2 \\\\\\\\ 5 \\\\end{pmatrix}$.\\n\\na) Berechnen Sie das Skalarprodukt $\\\\vec{u} \\\\cdot \\\\vec{v}$\\nb) Bestimmen Sie den Winkel zwischen den Vektoren","difficulty":"easy","points":10,"solutionSteps":["Schritt 1: Skalarprodukt berechnen","Schritt 2: Längen der Vektoren berechnen","Schritt 3: Winkelformel anwenden","Schritt 4: Bruch vereinfachen","Schritt 5: Winkel bestimmen","Schritt 6: Endergebnisse"]},{"id":3,"topic":"Lineare Gleichungssysteme","title":"Einfaches lineares Gleichungssystem","description":"Lösen Sie das folgende lineare Gleichungssystem mit dem Gauß-Verfahren:\\n$\\\\begin{align}\\nx + 2y - z &= 3 \\\\\\\\\\n2x - y + z &= 1 \\\\\\\\\\n3x + y + 2z &= 11\\n\\\\end{align}$","difficulty":"medium","points":12,"solutionSteps":["Schritt 1: Erweiterte Matrix aufstellen","Schritt 2: Erste Spalte eliminieren","Schritt 3: Zweite Spalte eliminieren","Schritt 4: Rücksubstitution - z bestimmen","Schritt 5: y bestimmen","Schritt 6: x bestimmen","Schritt 7: Lösung"]},{"id":4,"topic":"Matrizen","title":"Matrixoperationen","description":"Gegeben sind die Matrizen $A = \\\\begin{pmatrix} 1 & 2 \\\\\\\\ 3 & 4 \\\\end{pmatrix}$ und $B = \\\\begin{pmatrix} 2 & 1 \\\\\\\\ 0 & 3 \\\\end{pmatrix}$.\\n\\na) Berechnen Sie $A + B$\\nb) Berechnen Sie $A \\\\cdot B$\\nc) Bestimmen Sie $\\\\det(A)$","difficulty":"easy","points":10,"solutionSteps":["Schritt 1: Matrixaddition","Schritt 2: Matrixmultiplikation","Schritt 3: Ergebnis der Multiplikation","Schritt 4: Determinante berechnen","Schritt 5: Endergebnisse"]},{"id":5,"topic":"Lineare Unabhängigkeit","title":"Lineare Unabhängigkeit von Vektoren","description":"Prüfen Sie, ob die Vektoren $\\\\vec{v_1} = \\\\begin{pmatrix} 1 \\\\\\\\ 2 \\\\\\\\ 1 \\\\end{pmatrix}$, $\\\\vec{v_2} = \\\\begin{pmatrix} 2 \\\\\\\\ 1 \\\\\\\\ 0 \\\\end{pmatrix}$ und $\\\\vec{v_3} = \\\\begin{pmatrix} 1 \\\\\\\\ -1 \\\\\\\\ -1 \\\\end{pmatrix}$ linear unabhängig sind.","difficulty":"medium","points":10,"solutionSteps":["Schritt 1: Ansatz für lineare Unabhängigkeit","Schritt 2: Gleichungssystem aufstellen","Schritt 3: Matrix des Gleichungssystems","Schritt 4: Gauß-Elimination","Schritt 5: Rücksubstitution","Schritt 6: Fazit"]},{"id":6,"topic":"Inverse Matrix","title":"Inverse einer 2×2-Matrix","description":"Bestimmen Sie die Inverse der Matrix $C = \\\\begin{pmatrix} 3 & 1 \\\\\\\\ 2 & 1 \\\\end{pmatrix}$, falls sie existiert.","difficulty":"medium","points":10,"solutionSteps":["Schritt 1: Determinante berechnen","Schritt 2: Formel für 2×2-Inverse","Schritt 3: Inverse berechnen","Schritt 4: Probe durchführen","Schritt 5: Endergebnis"]}]}
                """
            }
            return json.data(using: .utf8)
        }
        
        private func embeddedLinearAlgebraExpert(language: AppLanguage) -> Data? {
            let json: String
            if language == .english {
                json = """
                {"exam":{"title":"Linear Algebra - Expert Exam","subtitle":"Advanced Theory and Applications","duration":180,"totalPoints":150,"difficulty":"advanced","language":"en","instructions":"Complete all tasks. Show complete solution approach for all calculations. Proofs must be complete and rigorous. Permitted aids: calculator without programming function. Good luck!"},"exercises":[{"id":1,"topic":"Jordan Normal Form","title":"Complex Jordan Blocks","description":"Given is the matrix $A = \\\\begin{pmatrix} 2 & 1 & 0 & 0 \\\\\\\\ 0 & 2 & 1 & 0 \\\\\\\\ 0 & 0 & 2 & 0 \\\\\\\\ 0 & 0 & 0 & 3 \\\\end{pmatrix}$.\\n\\na) Determine the Jordan normal form of $A$\\nb) Calculate the minimal polynomial of $A$\\nc) Determine a transformation matrix $P$ with $P^{-1}AP = J$","difficulty":"hard","points":18,"solutionSteps":["Step 1: Determine eigenvalues","Step 2: Determine geometric multiplicity","Step 3: Determine nilpotency index","Step 4: Jordan normal form","Step 5: Minimal polynomial","Step 6: Transformation matrix"]},{"id":2,"topic":"Spectral Theory","title":"Spectral Radius and Matrix Powers","description":"Let $B = \\\\begin{pmatrix} 0.5 & 0.3 \\\\\\\\ 0.2 & 0.4 \\\\end{pmatrix}$.\\n\\na) Calculate the spectral radius $\\\\rho(B)$\\nb) Show that $\\\\lim_{n \\\\to \\\\infty} B^n$ exists\\nc) Determine the limit $\\\\lim_{n \\\\to \\\\infty} B^n$","difficulty":"hard","points":15,"solutionSteps":["Step 1: Calculate eigenvalues of B","Step 2: Spectral radius","Step 3: Convergence of $B^n$","Step 4: Calculate limit"]},{"id":3,"topic":"Tensor Products","title":"Tensor Product of Vector Spaces","description":"Let $V = \\\\mathbb{R}^2$ and $W = \\\\mathbb{R}^3$ with bases $\\\\{e_1, e_2\\\\}$ and $\\\\{f_1, f_2, f_3\\\\}$ respectively.\\n\\na) Determine a basis for $V \\\\otimes W$\\nb) Express $v \\\\otimes w$ with $v = \\\\begin{pmatrix} 2 \\\\\\\\ 1 \\\\end{pmatrix}$ and $w = \\\\begin{pmatrix} 1 \\\\\\\\ 0 \\\\\\\\ -1 \\\\end{pmatrix}$ as a linear combination of the basis\\nc) Show that $\\\\dim(V \\\\otimes W) = \\\\dim(V) \\\\cdot \\\\dim(W)$","difficulty":"hard","points":12,"solutionSteps":["Step 1: Basis for $V \\\\otimes W$","Step 2: Representation of $v \\\\otimes w$","Step 3: Dimension of tensor product"]},{"id":4,"topic":"Multilinear Algebra","title":"Alternating Forms and Determinants","description":"Let $\\\\omega: \\\\mathbb{R}^3 \\\\times \\\\mathbb{R}^3 \\\\times \\\\mathbb{R}^3 \\\\to \\\\mathbb{R}$ be the alternating 3-form given by $\\\\omega(x, y, z) = \\\\det(x, y, z)$.\\n\\na) Show that $\\\\omega$ is alternating\\nb) Calculate $\\\\omega$ for three given vectors\\nc) Determine the dimension of the space of all alternating 3-forms on $\\\\mathbb{R}^3$","difficulty":"hard","points":14,"solutionSteps":["Step 1: Show alternating property","Step 2: Perform calculation","Step 3: Determine dimension"]},{"id":5,"topic":"Module Theory","title":"Finitely Generated Modules","description":"Let $M$ be a finitely generated $\\\\mathbb{Z}$-module with generators $\\\\{m_1, m_2, m_3\\\\}$ and relations $2m_1 + 3m_2 = 0$, $m_1 + m_3 = 0$, $4m_2 + 2m_3 = 0$.\\n\\na) Set up the relation matrix\\nb) Determine the Smith normal form\\nc) Give the structure of $M$ as a direct sum of cyclic modules","difficulty":"hard","points":16,"solutionSteps":["Step 1: Set up relation matrix","Step 2: Calculate Smith normal form","Step 3: Determine structure"]},{"id":6,"topic":"Lie Algebras","title":"Lie Bracket and Jacobi Identity","description":"Consider the Lie algebra $\\\\mathfrak{sl}_2(\\\\mathbb{R})$ of traceless $2 \\\\times 2$ matrices with the Lie bracket $[X,Y] = XY - YX$.\\n\\na) Show that the matrices $H$, $E$, $F$ form a basis\\nb) Calculate all Lie brackets\\nc) Verify the Jacobi identity","difficulty":"hard","points":15,"solutionSteps":["Step 1: Verify basis","Step 2: Calculate Lie brackets","Step 3: Check Jacobi identity"]},{"id":7,"topic":"Functional Analysis","title":"Operator Norms and Compactness","description":"Let $T: \\\\ell^2 \\\\to \\\\ell^2$ be the linear operator defined by $(Tx)_n = \\\\frac{x_n}{n}$.\\n\\na) Show that $T$ is bounded\\nb) Calculate the operator norm $\\\\|T\\\\|$\\nc) Investigate whether $T$ is compact","difficulty":"hard","points":18,"solutionSteps":["Step 1: Show boundedness","Step 2: Calculate operator norm","Step 3: Investigate compactness"]},{"id":8,"topic":"Homological Algebra","title":"Exact Sequences and Tor Functors","description":"Consider the short exact sequence: $0 \\\\to \\\\mathbb{Z} \\\\xrightarrow{\\\\cdot 2} \\\\mathbb{Z} \\\\xrightarrow{\\\\pi} \\\\mathbb{Z}/2\\\\mathbb{Z} \\\\to 0$\\n\\na) Verify exactness\\nb) Calculate $\\\\text{Tor}_1^\\\\mathbb{Z}(\\\\mathbb{Z}/2\\\\mathbb{Z}, \\\\mathbb{Z}/3\\\\mathbb{Z})$\\nc) Interpret the result","difficulty":"hard","points":16,"solutionSteps":["Step 1: Verify exactness","Step 2: Calculate Tor functor","Step 3: Interpretation"]},{"id":9,"topic":"Representation Theory","title":"Irreducible Representations","description":"Consider the group $GL_2(\\\\mathbb{F}_2)$ of invertible $2 \\\\times 2$ matrices over $\\\\mathbb{F}_2$.\\n\\na) Determine the order of $GL_2(\\\\mathbb{F}_2)$\\nb) Find all conjugacy classes\\nc) Determine the number of irreducible representations","difficulty":"hard","points":14,"solutionSteps":["Step 1: Determine order","Step 2: Find conjugacy classes","Step 3: Irreducible representations"]},{"id":10,"topic":"Algebraic Geometry","title":"Linear Varieties and Grassmannians","description":"Consider the Grassmannian $Gr(2,4)$ of 2-dimensional subspaces of $\\\\mathbb{C}^4$.\\n\\na) Determine the dimension of $Gr(2,4)$\\nb) Parametrize an open part\\nc) Show that $Gr(2,4)$ is an algebraic variety","difficulty":"hard","points":20,"solutionSteps":["Step 1: Determine dimension","Step 2: Plücker embedding","Step 3: Algebraic variety"]}]}
                """
            } else {
                json = """
                {"exam":{"title":"Lineare Algebra - Expertenklausur","subtitle":"Fortgeschrittene Theorie und Anwendungen","duration":180,"totalPoints":150,"difficulty":"advanced","language":"de","instructions":"Bearbeiten Sie alle Aufgaben. Geben Sie bei allen Berechnungen den vollständigen Lösungsweg an. Beweise müssen vollständig und rigoros geführt werden. Hilfsmittel: Taschenrechner ohne Programmierfunktion. Viel Erfolg!"},"exercises":[{"id":1,"topic":"Jordansche Normalform","title":"Komplexe Jordanblöcke","description":"Gegeben ist die Matrix $A = \\\\begin{pmatrix} 2 & 1 & 0 & 0 \\\\\\\\ 0 & 2 & 1 & 0 \\\\\\\\ 0 & 0 & 2 & 0 \\\\\\\\ 0 & 0 & 0 & 3 \\\\end{pmatrix}$.\\n\\na) Bestimmen Sie die Jordansche Normalform von $A$\\nb) Berechnen Sie das Minimalpolynom von $A$\\nc) Bestimmen Sie eine Transformationsmatrix $P$ mit $P^{-1}AP = J$","difficulty":"hard","points":18,"solutionSteps":["Schritt 1: Eigenwerte bestimmen","Schritt 2: Geometrische Vielfachheit bestimmen","Schritt 3: Nilpotenz-Index bestimmen","Schritt 4: Jordansche Normalform","Schritt 5: Minimalpolynom","Schritt 6: Transformationsmatrix"]},{"id":2,"topic":"Spektraltheorie","title":"Spektralradius und Matrixpotenzen","description":"Sei $B = \\\\begin{pmatrix} 0.5 & 0.3 \\\\\\\\ 0.2 & 0.4 \\\\end{pmatrix}$.\\n\\na) Berechnen Sie den Spektralradius $\\\\rho(B)$\\nb) Zeigen Sie, dass $\\\\lim_{n \\\\to \\\\infty} B^n$ existiert\\nc) Bestimmen Sie den Grenzwert $\\\\lim_{n \\\\to \\\\infty} B^n$","difficulty":"hard","points":15,"solutionSteps":["Schritt 1: Eigenwerte von B berechnen","Schritt 2: Spektralradius","Schritt 3: Konvergenz von $B^n$","Schritt 4: Grenzwert berechnen"]},{"id":3,"topic":"Tensorprodukte","title":"Tensorprodukt von Vektorräumen","description":"Seien $V = \\\\mathbb{R}^2$ und $W = \\\\mathbb{R}^3$ mit Basen $\\\\{e_1, e_2\\\\}$ bzw. $\\\\{f_1, f_2, f_3\\\\}$.\\n\\na) Bestimmen Sie eine Basis für $V \\\\otimes W$\\nb) Stellen Sie $v \\\\otimes w$ mit $v = \\\\begin{pmatrix} 2 \\\\\\\\ 1 \\\\end{pmatrix}$ und $w = \\\\begin{pmatrix} 1 \\\\\\\\ 0 \\\\\\\\ -1 \\\\end{pmatrix}$ als Linearkombination der Basis dar\\nc) Zeigen Sie, dass $\\\\dim(V \\\\otimes W) = \\\\dim(V) \\\\cdot \\\\dim(W)$","difficulty":"hard","points":12,"solutionSteps":["Schritt 1: Basis für $V \\\\otimes W$","Schritt 2: Darstellung von $v \\\\otimes w$","Schritt 3: Dimension des Tensorprodukts"]},{"id":4,"topic":"Multilineare Algebra","title":"Alternierende Formen und Determinanten","description":"Sei $\\\\omega: \\\\mathbb{R}^3 \\\\times \\\\mathbb{R}^3 \\\\times \\\\mathbb{R}^3 \\\\to \\\\mathbb{R}$ die alternierende 3-Form gegeben durch $\\\\omega(x, y, z) = \\\\det(x, y, z)$.\\n\\na) Zeigen Sie, dass $\\\\omega$ alternierend ist\\nb) Berechnen Sie $\\\\omega$ für drei gegebene Vektoren\\nc) Bestimmen Sie die Dimension des Raums aller alternierenden 3-Formen auf $\\\\mathbb{R}^3$","difficulty":"hard","points":14,"solutionSteps":["Schritt 1: Alternierende Eigenschaft zeigen","Schritt 2: Berechnung durchführen","Schritt 3: Dimension bestimmen"]},{"id":5,"topic":"Modultheorie","title":"Endlich erzeugte Moduln","description":"Sei $M$ ein endlich erzeugter $\\\\mathbb{Z}$-Modul mit Erzeugern $\\\\{m_1, m_2, m_3\\\\}$ und Relationen $2m_1 + 3m_2 = 0$, $m_1 + m_3 = 0$, $4m_2 + 2m_3 = 0$.\\n\\na) Stellen Sie die Relationsmatrix auf\\nb) Bestimmen Sie die Smith-Normalform\\nc) Geben Sie die Struktur von $M$ als direkte Summe zyklischer Moduln an","difficulty":"hard","points":16,"solutionSteps":["Schritt 1: Relationsmatrix aufstellen","Schritt 2: Smith-Normalform berechnen","Schritt 3: Struktur bestimmen"]},{"id":6,"topic":"Lie-Algebren","title":"Lie-Klammer und Jacobi-Identität","description":"Betrachten Sie die Lie-Algebra $\\\\mathfrak{sl}_2(\\\\mathbb{R})$ der spurlosen $2 \\\\times 2$-Matrizen mit der Lie-Klammer $[X,Y] = XY - YX$.\\n\\na) Zeigen Sie, dass die Matrizen $H$, $E$, $F$ eine Basis bilden\\nb) Berechnen Sie alle Lie-Klammern\\nc) Verifizieren Sie die Jacobi-Identität","difficulty":"hard","points":15,"solutionSteps":["Schritt 1: Basis verifizieren","Schritt 2: Lie-Klammern berechnen","Schritt 3: Jacobi-Identität prüfen"]},{"id":7,"topic":"Funktionalanalysis","title":"Operatornormen und Kompaktheit","description":"Sei $T: \\\\ell^2 \\\\to \\\\ell^2$ der lineare Operator definiert durch $(Tx)_n = \\\\frac{x_n}{n}$.\\n\\na) Zeigen Sie, dass $T$ beschränkt ist\\nb) Berechnen Sie die Operatornorm $\\\\|T\\\\|$\\nc) Untersuchen Sie, ob $T$ kompakt ist","difficulty":"hard","points":18,"solutionSteps":["Schritt 1: Beschränktheit zeigen","Schritt 2: Operatornorm berechnen","Schritt 3: Kompaktheit untersuchen"]},{"id":8,"topic":"Homologische Algebra","title":"Exakte Sequenzen und Tor-Funktoren","description":"Betrachten Sie die kurze exakte Sequenz: $0 \\\\to \\\\mathbb{Z} \\\\xrightarrow{\\\\cdot 2} \\\\mathbb{Z} \\\\xrightarrow{\\\\pi} \\\\mathbb{Z}/2\\\\mathbb{Z} \\\\to 0$\\n\\na) Verifizieren Sie die Exaktheit\\nb) Berechnen Sie $\\\\text{Tor}_1^\\\\mathbb{Z}(\\\\mathbb{Z}/2\\\\mathbb{Z}, \\\\mathbb{Z}/3\\\\mathbb{Z})$\\nc) Interpretieren Sie das Ergebnis","difficulty":"hard","points":16,"solutionSteps":["Schritt 1: Exaktheit verifizieren","Schritt 2: Tor-Funktor berechnen","Schritt 3: Interpretation"]},{"id":9,"topic":"Darstellungstheorie","title":"Irreduzible Darstellungen","description":"Betrachten Sie die Gruppe $GL_2(\\\\mathbb{F}_2)$ der invertierbaren $2 \\\\times 2$-Matrizen über $\\\\mathbb{F}_2$.\\n\\na) Bestimmen Sie die Ordnung von $GL_2(\\\\mathbb{F}_2)$\\nb) Finden Sie alle Konjugationsklassen\\nc) Bestimmen Sie die Anzahl der irreduziblen Darstellungen","difficulty":"hard","points":14,"solutionSteps":["Schritt 1: Ordnung bestimmen","Schritt 2: Konjugationsklassen finden","Schritt 3: Irreduzible Darstellungen"]},{"id":10,"topic":"Algebraische Geometrie","title":"Lineare Varietäten und Grassmannsche","description":"Betrachten Sie die Grassmannsche $Gr(2,4)$ der 2-dimensionalen Unterräume von $\\\\mathbb{C}^4$.\\n\\na) Bestimmen Sie die Dimension von $Gr(2,4)$\\nb) Parametrisieren Sie einen offenen Teil\\nc) Zeigen Sie, dass $Gr(2,4)$ eine algebraische Varietät ist","difficulty":"hard","points":20,"solutionSteps":["Schritt 1: Dimension bestimmen","Schritt 2: Plücker-Einbettung","Schritt 3: Algebraische Varietät"]}]}
                """
            }
            return json.data(using: .utf8)
        }
        
        private func embeddedStatisticsBeginner(language: AppLanguage) -> Data? {
            let json: String
            if language == .english {
                json = """
                {"exam":{"title":"Statistics - Beginner Exam","subtitle":"Fundamentals of Probability and Statistics","duration":120,"totalPoints":60,"difficulty":"beginner","language":"en","instructions":"Answer all questions. Show all work and calculations. Permitted aids: Non-programmable calculator, standard normal distribution table. Good luck!"},"exercises":[{"id":1,"topic":"Fundamentals of Probability","title":"Probability calculation with urn model","description":"An urn contains 5 red, 3 blue, and 2 green balls. One ball is drawn randomly. What is the probability of drawing a red ball?","difficulty":"easy","points":8,"solutionSteps":["Determine total number of balls","Calculate probability"]}]}
                """
            } else {
                json = """
                {"exam":{"title":"Statistik - Anfängerklausur","subtitle":"Grundlagen der Wahrscheinlichkeitsrechnung und Statistik","duration":120,"totalPoints":60,"difficulty":"beginner","language":"de","instructions":"Bearbeiten Sie alle Aufgaben. Geben Sie bei allen Berechnungen den vollständigen Lösungsweg an. Hilfsmittel: Taschenrechner ohne Programmierfunktion, Tabelle der Standardnormalverteilung. Viel Erfolg!"},"exercises":[{"id":1,"topic":"Grundlagen der Wahrscheinlichkeit","title":"Wahrscheinlichkeitsrechnung mit Urnenmodell","description":"In einer Urne befinden sich 5 rote, 3 blaue und 2 grüne Kugeln. Es wird eine Kugel zufällig gezogen. Wie groß ist die Wahrscheinlichkeit, eine rote Kugel zu ziehen?","difficulty":"easy","points":8,"solutionSteps":["Gesamtanzahl der Kugeln bestimmen","Wahrscheinlichkeit berechnen"]}]}
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
