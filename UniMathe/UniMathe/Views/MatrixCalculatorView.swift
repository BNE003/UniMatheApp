import SwiftUI

struct MatrixCalculatorView: View {
    @ObservedObject private var settings = SettingsModel.shared
    @ObservedObject private var storeManager = StoreKitManager.shared

    @AppStorage("matrixFreeOperationCount") private var matrixFreeOperationCount: Int = 0
    @State private var showPaywall = false

    @State private var tool: Tool = .gauss
    @State private var matrixSize: MatrixSize = .threeByThree
    @State private var algorithm: Algorithm = .gauss

    @State private var matrix: [[String]] = MatrixCalculatorView.makeMatrix(size: 3)
    @State private var rhs: [[String]] = MatrixCalculatorView.makeRhs(size: 3)
    @State private var result: [[Double]] = MatrixCalculatorView.makeAugmentedMatrix(size: 3)

    @State private var leftMatrix: [[String]] = MatrixCalculatorView.makeMatrix(size: 3)
    @State private var rightMatrix: [[String]] = MatrixCalculatorView.makeMatrix(size: 3)
    @State private var productMatrix: [[Double]] = MatrixCalculatorView.makeResultMatrix(size: 3)

    @State private var gaussSteps: [GaussStep] = []
    @State private var currentStepIndex: Int = 0
    @State private var showAllSteps = false

    @State private var determinantValue: Double?
    @State private var equationLines: [String] = []
    @State private var solutionSteps: [String] = []
    @State private var solutionResults: [String] = []
    @State private var solutionVectorLines: [String] = []
    @State private var solutionStatus: SolutionStatus = .none
    @State private var solutionLatexHeight: CGFloat = 0

    enum Tool: CaseIterable {
        case gauss
        case multiplication
        case determinant
    }

    enum MatrixSize: String, CaseIterable {
        case twoByTwo = "2x2"
        case threeByThree = "3x3"
        case fourByFour = "4x4"

        var size: Int {
            switch self {
            case .twoByTwo: return 2
            case .threeByThree: return 3
            case .fourByFour: return 4
            }
        }
    }

    enum Algorithm: String, CaseIterable {
        case gauss = "Gauss"
        case gaussJordan = "Gauss-Jordan"
    }

    struct GaussStep: Identifiable {
        let id = UUID()
        let description: String
        let matrix: [[Double]]
        let operation: RowOperation?
    }

    enum RowOperationType {
        case swap
        case scale
        case add
    }

    struct RowOperation {
        let type: RowOperationType
        let targetRow: Int
        let sourceRow: Int?
        let factor: Double?
    }

    enum SolutionStatus {
        case none
        case unique
        case infinite
        case inconsistent
    }

    struct SolutionOutput {
        let status: SolutionStatus
        let steps: [String]
        let results: [String]
        let vectorLines: [String]
    }

    var body: some View {
        NavigationView {
            ZStack {
                backgroundView

                ScrollView {
                    VStack(spacing: 20) {
                        headerCard
                        toolPickerCard
                        sizePickerCard

                        switch tool {
                        case .gauss:
                            gaussSection
                        case .multiplication:
                            multiplicationSection
                        case .determinant:
                            determinantSection
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle(localized("Matrix Rechner", "Matrix Tools"))
            .onChange(of: matrixSize) { newSize in
                updateMatrixSize(to: newSize.size)
            }
            .onChange(of: algorithm) { _ in
                resetGaussOutput()
            }
            .onChange(of: tool) { _ in
                resetToolOutputs()
            }
            .fullScreenCover(isPresented: $showPaywall) {
                PurchaseView(isPresented: $showPaywall)
            }
        }
    }

    private var headerCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                Text(localized(
                    "Gauss, Multiplikation und Determinanten - Schritt für Schritt.",
                    "Gauss, multiplication and determinants - step by step."
                ))
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var toolPickerCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                Text(localized("Werkzeug", "Tool"))
                    .font(.headline)

                Picker("Tool", selection: $tool) {
                    ForEach(Tool.allCases, id: \.self) { item in
                        Text(toolTitle(item)).tag(item)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
    }

    private var sizePickerCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                Text(localized("Matrixgröße", "Matrix Size"))
                    .font(.headline)

                Picker("Matrix Size", selection: $matrixSize) {
                    ForEach(MatrixSize.allCases, id: \.self) { size in
                        Text(size.rawValue).tag(size)
                    }
                }
                .pickerStyle(.segmented)

                Text(localized(
                    "Gilt für alle Werkzeuge.",
                    "Applies to all tools."
                ))
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
    }

    private var gaussSection: some View {
        VStack(spacing: 18) {
            GlassCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text(localized("Algorithmus", "Algorithm"))
                        .font(.headline)

                    Picker("Algorithm", selection: $algorithm) {
                        ForEach(Algorithm.allCases, id: \.self) { algo in
                            Text(algo.rawValue).tag(algo)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }

            GlassCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text(localized("Matrix", "Matrix"))
                        .font(.headline)

                    AugmentedMatrixInputView(
                        matrix: $matrix,
                        rhs: $rhs,
                        cellSize: cellSize,
                        accent: accentColor
                    )
                }
            }

            Button(action: calculateGauss) {
                Text(localized("Berechnen", "Calculate"))
            }
            .buttonStyle(PrimaryButtonStyle(accent: accentColor))

            if gaussSteps.isEmpty {
                GlassCard {
                    Text(localized(
                        "Noch keine Schritte. Tippe auf Berechnen.",
                        "No steps yet. Tap Calculate."
                    ))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else {
                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(localized("Schritte", "Steps"))
                                .font(.headline)
                            Spacer()
                            Text(stepIndicatorText)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Toggle(isOn: $showAllSteps) {
                            Text(localized("Alle Schritte anzeigen", "Show all steps"))
                                .font(.subheadline)
                        }
                        .tint(accentColor)

                        if !showAllSteps {
                            HStack {
                                Button(action: previousStep) {
                                    Image(systemName: "chevron.left")
                                    Text(localized("Zurück", "Back"))
                                }
                                .disabled(currentStepIndex == 0)

                                Spacer()

                                Button(action: nextStep) {
                                    Text(localized("Weiter", "Next"))
                                    Image(systemName: "chevron.right")
                                }
                                .disabled(currentStepIndex >= gaussSteps.count - 1)
                            }
                            .font(.subheadline)
                        }
                    }
                }

                if showAllSteps {
                    ForEach(gaussSteps.indices, id: \.self) { index in
                        stepCard(for: gaussSteps[index], index: index)
                    }
                } else {
                    stepCard(for: gaussSteps[currentStepIndex], index: currentStepIndex)
                }

                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(localized("Endmatrix", "Final Matrix"))
                            .font(.headline)
                        AugmentedMatrixResultView(
                            matrix: result,
                            cellSize: cellSize,
                            accent: accentColor,
                            highlightRows: []
                        )
                    }
                }

                if solutionStatus != .none {
                    solutionCard
                }
            }
        }
    }

    private var multiplicationSection: some View {
        VStack(spacing: 18) {
            GlassCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text(localized("Matrixmultiplikation", "Matrix Multiplication"))
                        .font(.headline)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            MatrixInputView(
                                matrix: $leftMatrix,
                                cellSize: cellSize,
                                accent: accentColor
                            )

                            Text("x")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(accentColor)

                            MatrixInputView(
                                matrix: $rightMatrix,
                                cellSize: cellSize,
                                accent: accentColor
                            )
                        }
                        .padding(.vertical, 4)
                    }
                }
            }

            Button(action: calculateMultiplication) {
                Text(localized("Berechnen", "Calculate"))
            }
            .buttonStyle(PrimaryButtonStyle(accent: accentColor))

            GlassCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text(localized("Ergebnis", "Result"))
                        .font(.headline)
                    MatrixResultView(
                        matrix: productMatrix,
                        cellSize: cellSize,
                        accent: accentColor,
                        highlightRows: []
                    )
                }
            }
        }
    }

    private var determinantSection: some View {
        VStack(spacing: 18) {
            GlassCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text(localized("Matrix", "Matrix"))
                        .font(.headline)

                    MatrixInputView(
                        matrix: $matrix,
                        cellSize: cellSize,
                        accent: accentColor
                    )
                }
            }

            Button(action: calculateDeterminant) {
                Text(localized("Determinante berechnen", "Calculate determinant"))
            }
            .buttonStyle(PrimaryButtonStyle(accent: accentColor))

            GlassCard {
                VStack(alignment: .leading, spacing: 8) {
                    Text(localized("Determinante", "Determinant"))
                        .font(.headline)

                    if let value = determinantValue {
                        Text("det(A) = \(formatNumber(value, maximumFractionDigits: 4))")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(accentColor)
                    } else {
                        Text(localized("Noch nicht berechnet.", "Not calculated yet."))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var backgroundView: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.94, green: 0.97, blue: 1.0),
                    Color(red: 0.98, green: 0.99, blue: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            GeometryReader { geometry in
                ZStack {
                    Circle()
                        .fill(accentColor.opacity(0.08))
                        .frame(width: geometry.size.width * 0.9)
                        .offset(x: -geometry.size.width * 0.3, y: -geometry.size.height * 0.2)

                    Circle()
                        .fill(Color.mint.opacity(0.08))
                        .frame(width: geometry.size.width * 0.7)
                        .offset(x: geometry.size.width * 0.35, y: geometry.size.height * 0.25)
                }
            }
        }
    }

    private var cellSize: CGFloat {
        switch matrixSize {
        case .twoByTwo: return 70
        case .threeByThree: return 58
        case .fourByFour: return 48
        }
    }

    private var accentColor: Color {
        settings.accentColor
    }

    private var hasProAccess: Bool {
        !storeManager.purchasedProductIDs.isEmpty
    }

    private var stepIndicatorText: String {
        let total = gaussSteps.count
        if total == 0 { return "" }
        return localized(
            "Schritt \(currentStepIndex + 1) von \(total)",
            "Step \(currentStepIndex + 1) of \(total)"
        )
    }

    private func stepCard(for step: GaussStep, index: Int) -> some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(localized("Schritt", "Step"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("\(index + 1)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                if let operation = step.operation {
                    operationView(operation)
                }

                Text(step.description)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))

                AugmentedMatrixResultView(
                    matrix: step.matrix,
                    cellSize: cellSize,
                    accent: accentColor,
                    highlightRows: highlightRows(for: step.operation)
                )
            }
        }
    }

    private var solutionCard: some View {
        GlassCard {
            LaTeXView(content: solutionLatexContent, height: $solutionLatexHeight)
                .frame(height: max(60, solutionLatexHeight))
        }
    }

    private var solutionLatexContent: String {
        var html = "<div class=\"content-container\">"
        html += "<h2>\(localized("Lösung des Gleichungssystems", "Solution of the system"))</h2>"

        if !equationLines.isEmpty {
            let aligned = equationLines.joined(separator: " \\\\ ")
            html += "<h3>\(localized("Gleichungssystem", "System"))</h3>"
            html += "<div class=\"math-block\">$$\\begin{aligned} \(aligned) \\end{aligned}$$</div>"
        }

        if solutionStatus == .inconsistent {
            let text = localized("Keine Lösung (inkonsistentes System).", "No solution (inconsistent system).")
            html += "<div class=\"math-block\">$$\\text{\(text)}$$</div>"
        } else {
            if !solutionSteps.isEmpty {
                html += "<h3>\(localized("Rechenweg", "Derivation"))</h3>"
                for step in solutionSteps {
                    html += "<div class=\"math-block\">$$\(step)$$</div>"
                }
            }

            if !solutionResults.isEmpty {
                html += "<h3>\(localized("Ergebnis", "Result"))</h3>"
                for line in solutionResults {
                    html += "<div class=\"math-block\">$$\(line)$$</div>"
                }
            }

            if !solutionVectorLines.isEmpty {
                html += "<h3>\(localized("Allgemeine Lösung", "General solution"))</h3>"
                for line in solutionVectorLines {
                    html += "<div class=\"math-block\">$$\(line)$$</div>"
                }
            }
        }

        html += "</div>"
        return html
    }

    private func toolTitle(_ tool: Tool) -> String {
        switch tool {
        case .gauss:
            return localized("Gauss", "Gauss")
        case .multiplication:
            return localized("Multiplikation", "Multiply")
        case .determinant:
            return localized("Determinante", "Determinant")
        }
    }

    private func localized(_ german: String, _ english: String) -> String {
        settings.language == .english ? english : german
    }

    private func updateMatrixSize(to size: Int) {
        matrix = MatrixCalculatorView.makeMatrix(size: size)
        rhs = MatrixCalculatorView.makeRhs(size: size)
        result = MatrixCalculatorView.makeAugmentedMatrix(size: size)
        leftMatrix = MatrixCalculatorView.makeMatrix(size: size)
        rightMatrix = MatrixCalculatorView.makeMatrix(size: size)
        productMatrix = MatrixCalculatorView.makeResultMatrix(size: size)
        gaussSteps = []
        determinantValue = nil
        currentStepIndex = 0
        equationLines = []
        solutionSteps = []
        solutionResults = []
        solutionVectorLines = []
        solutionStatus = .none
    }

    private func resetGaussOutput() {
        gaussSteps = []
        currentStepIndex = 0
        result = buildAugmentedMatrix(matrix: parseMatrix(matrix), rhs: parseRhs(rhs))
        equationLines = []
        solutionSteps = []
        solutionResults = []
        solutionVectorLines = []
        solutionStatus = .none
    }

    private func resetToolOutputs() {
        gaussSteps = []
        currentStepIndex = 0
        showAllSteps = false
        determinantValue = nil
        equationLines = []
        solutionSteps = []
        solutionResults = []
        solutionVectorLines = []
        solutionStatus = .none
    }

    private func calculateGauss() {
        performOperation {
            let numericMatrix = parseMatrix(matrix)
            let numericRhs = parseRhs(rhs)
            let output = gaussStepsFor(numericMatrix, rhs: numericRhs, algorithm: algorithm)
            gaussSteps = output.steps
            result = output.result
            currentStepIndex = 0
            showAllSteps = false
            equationLines = buildEquationLines(matrix: numericMatrix, rhs: numericRhs)
            let solution = solveLinearSystem(matrix: numericMatrix, rhs: numericRhs)
            solutionSteps = solution.steps
            solutionResults = solution.results
            solutionVectorLines = solution.vectorLines
            solutionStatus = solution.status
        }
    }

    private func calculateMultiplication() {
        performOperation {
            productMatrix = multiply(parseMatrix(leftMatrix), parseMatrix(rightMatrix))
        }
    }

    private func calculateDeterminant() {
        performOperation {
            determinantValue = determinant(of: parseMatrix(matrix))
        }
    }

    private func performOperation(_ action: () -> Void) {
        if hasProAccess {
            action()
            return
        }

        if matrixFreeOperationCount < 1 {
            matrixFreeOperationCount += 1
            action()
            return
        }

        showPaywall = true
    }

    private func nextStep() {
        guard currentStepIndex < gaussSteps.count - 1 else { return }
        currentStepIndex += 1
    }

    private func previousStep() {
        guard currentStepIndex > 0 else { return }
        currentStepIndex -= 1
    }

    private func gaussStepsFor(_ input: [[Double]], rhs: [Double], algorithm: Algorithm) -> (steps: [GaussStep], result: [[Double]]) {
        var matrix = buildAugmentedMatrix(matrix: input, rhs: rhs)
        let n = input.count
        let cols = n + 1
        let eps = 1e-9
        var steps: [GaussStep] = [
            GaussStep(description: localized("Startmatrix", "Start matrix"), matrix: matrix, operation: nil)
        ]

        for i in 0..<n {
            var pivotRow = i
            var pivotValue = abs(matrix[i][i])

            if i + 1 < n {
                for row in (i + 1)..<n {
                    if abs(matrix[row][i]) > pivotValue {
                        pivotValue = abs(matrix[row][i])
                        pivotRow = row
                    }
                }
            }

            if pivotValue < eps {
                steps.append(GaussStep(
                    description: localized(
                        "Pivot in Spalte \(i + 1) ist 0, Spalte übersprungen.",
                        "Pivot in column \(i + 1) is 0, column skipped."
                    ),
                    matrix: matrix,
                    operation: nil
                ))
                continue
            }

            if pivotRow != i {
                matrix.swapAt(i, pivotRow)
                steps.append(GaussStep(
                    description: localized(
                        "R\(i + 1) <-> R\(pivotRow + 1)",
                        "R\(i + 1) <-> R\(pivotRow + 1)"
                    ),
                    matrix: matrix,
                    operation: RowOperation(type: .swap, targetRow: i, sourceRow: pivotRow, factor: nil)
                ))
            }

            if algorithm == .gaussJordan {
                let pivot = matrix[i][i]
                if abs(pivot - 1) > eps {
                    for j in i..<cols {
                        matrix[i][j] /= pivot
                    }
                    steps.append(GaussStep(
                        description: localized(
                            "R\(i + 1) = R\(i + 1) / \(formatNumber(pivot))",
                            "R\(i + 1) = R\(i + 1) / \(formatNumber(pivot))"
                        ),
                        matrix: matrix,
                        operation: RowOperation(type: .scale, targetRow: i, sourceRow: nil, factor: pivot)
                    ))
                }
            }

            for row in 0..<n {
                if row == i { continue }
                if algorithm == .gauss && row < i { continue }

                let pivot = matrix[i][i]
                if abs(pivot) < eps { continue }

                let factor = algorithm == .gauss ? matrix[row][i] / pivot : matrix[row][i]
                if abs(factor) < eps { continue }

                for col in i..<cols {
                    matrix[row][col] -= factor * matrix[i][col]
                }

                let operation = localized(
                    "R\(row + 1) = R\(row + 1) - \(formatNumber(factor)) * R\(i + 1)",
                    "R\(row + 1) = R\(row + 1) - \(formatNumber(factor)) * R\(i + 1)"
                )
                steps.append(GaussStep(
                    description: operation,
                    matrix: matrix,
                    operation: RowOperation(type: .add, targetRow: row, sourceRow: i, factor: factor)
                ))
            }
        }

        return (steps, matrix)
    }

    private func multiply(_ left: [[Double]], _ right: [[Double]]) -> [[Double]] {
        let n = left.count
        var result = MatrixCalculatorView.makeResultMatrix(size: n)

        for i in 0..<n {
            for j in 0..<n {
                var sum = 0.0
                for k in 0..<n {
                    sum += left[i][k] * right[k][j]
                }
                result[i][j] = sum
            }
        }

        return result
    }

    private func determinant(of matrix: [[Double]]) -> Double {
        var matrix = matrix
        let n = matrix.count
        let eps = 1e-9
        var sign = 1.0

        for i in 0..<n {
            var pivotRow = i
            var pivotValue = abs(matrix[i][i])

            if i + 1 < n {
                for row in (i + 1)..<n {
                    if abs(matrix[row][i]) > pivotValue {
                        pivotValue = abs(matrix[row][i])
                        pivotRow = row
                    }
                }
            }

            if pivotValue < eps {
                return 0
            }

            if pivotRow != i {
                matrix.swapAt(i, pivotRow)
                sign *= -1
            }

            let pivot = matrix[i][i]
            for row in (i + 1)..<n {
                let factor = matrix[row][i] / pivot
                if abs(factor) < eps { continue }
                for col in i..<n {
                    matrix[row][col] -= factor * matrix[i][col]
                }
            }
        }

        var det = sign
        for i in 0..<n {
            det *= matrix[i][i]
        }

        return det
    }

    private func formatNumber(_ value: Double, maximumFractionDigits: Int = 3) -> String {
        let adjusted = abs(value) < 1e-9 ? 0 : value
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = maximumFractionDigits
        formatter.minimumFractionDigits = 0
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: adjusted)) ?? String(format: "%g", adjusted)
    }

    private static func makeMatrix(size: Int) -> [[String]] {
        Array(repeating: Array(repeating: "", count: size), count: size)
    }

    private static func makeRhs(size: Int) -> [[String]] {
        Array(repeating: ["0"], count: size)
    }

    private static func makeResultMatrix(size: Int) -> [[Double]] {
        Array(repeating: Array(repeating: 0, count: size), count: size)
    }

    private static func makeAugmentedMatrix(size: Int) -> [[Double]] {
        Array(repeating: Array(repeating: 0, count: size + 1), count: size)
    }

    private func parseMatrix(_ input: [[String]]) -> [[Double]] {
        input.map { row in
            row.map { parseNumber($0) }
        }
    }

    private func parseRhs(_ input: [[String]]) -> [Double] {
        input.map { row in
            parseNumber(row.first ?? "")
        }
    }

    private func buildAugmentedMatrix(matrix: [[Double]], rhs: [Double]) -> [[Double]] {
        let n = matrix.count
        var augmented: [[Double]] = []
        for i in 0..<n {
            var row = matrix[i]
            let value = i < rhs.count ? rhs[i] : 0
            row.append(value)
            augmented.append(row)
        }
        return augmented
    }

    private func parseNumber(_ value: String) -> Double {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return 0 }
        let normalized = trimmed.replacingOccurrences(of: ",", with: ".")
        return Double(normalized) ?? 0
    }

    private func buildEquationLines(matrix: [[Double]], rhs: [Double]) -> [String] {
        var lines: [String] = []
        let n = matrix.count
        for row in 0..<n {
            let rhsValue = row < rhs.count ? rhs[row] : 0
            lines.append(equationLatexString(coefficients: matrix[row], rhs: rhsValue))
        }
        return lines
    }

    private func equationLatexString(coefficients: [Double], rhs: Double) -> String {
        let eps = 1e-9
        var parts: [String] = []
        for (index, coeff) in coefficients.enumerated() {
            if abs(coeff) < eps { continue }
            let absCoeff = abs(coeff)
            let coeffText = abs(absCoeff - 1) < eps ? "" : "\(formatNumber(absCoeff)) "
            let term = "\(coeffText)x_{\(index + 1)}"
            if parts.isEmpty {
                parts.append(coeff < 0 ? "-\(term)" : term)
            } else {
                let sign = coeff < 0 ? "-" : "+"
                parts.append("\(sign) \(term)")
            }
        }
        if parts.isEmpty {
            parts.append("0")
        }
        return "\(parts.joined(separator: " ")) &= \(formatNumber(rhs, maximumFractionDigits: 4))"
    }

    private func solveLinearSystem(matrix: [[Double]], rhs: [Double]) -> SolutionOutput {
        let augmented = buildAugmentedMatrix(matrix: matrix, rhs: rhs)
        let rref = rrefAugmented(augmented)
        return solveFromRref(rref)
    }

    private func solveFromRref(_ rref: [[Double]]) -> SolutionOutput {
        let eps = 1e-9
        let rowCount = rref.count
        let colCount = rref.first?.count ?? 0
        let varCount = max(colCount - 1, 0)

        if rowCount == 0 || varCount == 0 {
            return SolutionOutput(status: .none, steps: [], results: [], vectorLines: [])
        }

        var pivotCols: [Int] = []
        var rowForPivot: [Int: Int] = [:]
        var inconsistent = false

        for row in 0..<rowCount {
            var firstNonZero: Int?
            for col in 0..<varCount {
                if abs(rref[row][col]) > eps {
                    firstNonZero = col
                    break
                }
            }
            if firstNonZero == nil {
                if abs(rref[row][varCount]) > eps {
                    inconsistent = true
                    break
                }
                continue
            }
            pivotCols.append(firstNonZero!)
            rowForPivot[firstNonZero!] = row
        }

        if inconsistent {
            return SolutionOutput(status: .inconsistent, steps: [], results: [], vectorLines: [])
        }

        let freeCols = (0..<varCount).filter { !pivotCols.contains($0) }
        var steps: [String] = []
        var resultsByVar: [Int: String] = [:]
        var vectorLines: [String] = []

        var parameterLatex: [Int: String] = [:]
        if freeCols.count == 1, let free = freeCols.first {
            parameterLatex[free] = "x_{\(free + 1)}"
        } else {
            for (index, col) in freeCols.enumerated() {
                parameterLatex[col] = "t_{\(index + 1)}"
            }
        }

        if !freeCols.isEmpty {
            for col in freeCols {
                let name = parameterLatex[col] ?? "t"
                let prefix = localized("Setze freie Variable", "Set free variable")
                steps.append("\\text{\(prefix) } x_{\(col + 1)} = \(name).")
                resultsByVar[col] = "x_{\(col + 1)} = \(name)"
            }
        }

        for col in 0..<varCount {
            guard let row = rowForPivot[col] else { continue }
            let rhsValue = rref[row][varCount]
            var terms: [(Double, String)] = []
            for freeCol in freeCols {
                let coeff = -rref[row][freeCol]
                if abs(coeff) < eps { continue }
                let name = parameterLatex[freeCol] ?? "t"
                terms.append((coeff, name))
            }
            let expression = buildExpressionLatex(constant: rhsValue, terms: terms)
            let prefix = localized("Aus Zeile \(row + 1) folgt", "From row \(row + 1):")
            steps.append("\\text{\(prefix) } x_{\(col + 1)} = \(expression).")
            resultsByVar[col] = "x_{\(col + 1)} = \(expression)"
        }

        let results = (0..<varCount).compactMap { resultsByVar[$0] }

        if freeCols.isEmpty {
            let values = (0..<varCount).map { col -> String in
                if let row = rowForPivot[col] {
                    return formatNumber(rref[row][varCount], maximumFractionDigits: 4)
                }
                return "0"
            }
            vectorLines.append("x = \(latexVector(values))")
            return SolutionOutput(status: .unique, steps: steps, results: results, vectorLines: vectorLines)
        }

        let particular = buildParticularVector(rref, varCount: varCount, rowForPivot: rowForPivot)
        let basis = buildBasisVectors(rref, varCount: varCount, freeCols: freeCols, rowForPivot: rowForPivot)
        let particularText = particular.map { formatNumber($0, maximumFractionDigits: 4) }
        var generalLine = "x = \(latexVector(particularText))"
        for (index, vector) in basis.enumerated() {
            let name = parameterLatex[freeCols[index]] ?? "t_{\(index + 1)}"
            let vectorText = vector.map { formatNumber($0, maximumFractionDigits: 4) }
            generalLine += " + \(name) \\cdot \(latexVector(vectorText))"
        }
        vectorLines.append(generalLine)

        return SolutionOutput(status: .infinite, steps: steps, results: results, vectorLines: vectorLines)
    }

    private func buildExpressionLatex(constant: Double, terms: [(Double, String)]) -> String {
        let eps = 1e-9
        var parts: [String] = []

        if abs(constant) > eps {
            parts.append(formatNumber(constant, maximumFractionDigits: 4))
        }

        for (coeff, name) in terms {
            if abs(coeff) < eps { continue }
            let absCoeff = abs(coeff)
            let coeffText = abs(absCoeff - 1) < eps ? "" : "\(formatNumber(absCoeff, maximumFractionDigits: 4)) "
            let term = "\(coeffText)\(name)"
            if parts.isEmpty {
                parts.append(coeff < 0 ? "-\(term)" : term)
            } else {
                let sign = coeff < 0 ? "-" : "+"
                parts.append("\(sign) \(term)")
            }
        }

        return parts.isEmpty ? "0" : parts.joined(separator: " ")
    }

    private func buildParticularVector(_ rref: [[Double]], varCount: Int, rowForPivot: [Int: Int]) -> [Double] {
        var vector = Array(repeating: 0.0, count: varCount)
        for col in 0..<varCount {
            if let row = rowForPivot[col] {
                vector[col] = rref[row][varCount]
            }
        }
        return vector
    }

    private func buildBasisVectors(_ rref: [[Double]], varCount: Int, freeCols: [Int], rowForPivot: [Int: Int]) -> [[Double]] {
        let eps = 1e-9
        var basis: [[Double]] = []
        for freeCol in freeCols {
            var vector = Array(repeating: 0.0, count: varCount)
            vector[freeCol] = 1
            for pivotCol in 0..<varCount {
                guard let row = rowForPivot[pivotCol] else { continue }
                let coeff = -rref[row][freeCol]
                vector[pivotCol] = abs(coeff) < eps ? 0 : coeff
            }
            basis.append(vector)
        }
        return basis
    }

    private func latexVector(_ values: [String]) -> String {
        let body = values.joined(separator: " \\\\ ")
        return "\\begin{pmatrix} \(body) \\end{pmatrix}"
    }

    private func latexVector(_ values: [Double]) -> String {
        let formatted = values.map { formatNumber($0, maximumFractionDigits: 4) }
        return latexVector(formatted)
    }

    private func rrefAugmented(_ matrix: [[Double]]) -> [[Double]] {
        var result = matrix
        let rowCount = result.count
        let colCount = result.first?.count ?? 0
        let varCount = max(colCount - 1, 0)
        let eps = 1e-9

        var lead = 0
        for r in 0..<rowCount {
            if lead >= varCount { break }
            var i = r
            while abs(result[i][lead]) < eps {
                i += 1
                if i == rowCount {
                    i = r
                    lead += 1
                    if lead >= varCount { return result }
                }
            }

            if i != r {
                result.swapAt(i, r)
            }

            let pivot = result[r][lead]
            if abs(pivot) > eps {
                for j in 0..<colCount {
                    result[r][j] /= pivot
                }
            }

            for row in 0..<rowCount {
                if row == r { continue }
                let factor = result[row][lead]
                if abs(factor) < eps { continue }
                for col in 0..<colCount {
                    result[row][col] -= factor * result[r][col]
                }
            }
            lead += 1
        }

        return result
    }

    private func highlightRows(for operation: RowOperation?) -> Set<Int> {
        guard let operation = operation else { return [] }
        switch operation.type {
        case .swap:
            return [operation.targetRow, operation.sourceRow ?? operation.targetRow]
        case .scale:
            return [operation.targetRow]
        case .add:
            return [operation.targetRow, operation.sourceRow ?? operation.targetRow]
        }
    }

    private func operationView(_ operation: RowOperation) -> some View {
        HStack(spacing: 10) {
            rowPill(index: operation.targetRow)

            switch operation.type {
            case .swap:
                Image(systemName: "arrow.left.and.right")
                    .foregroundColor(accentColor)
                if let source = operation.sourceRow {
                    rowPill(index: source)
                }
            case .scale:
                Image(systemName: "arrow.right")
                    .foregroundColor(accentColor)
                Text("R\(operation.targetRow + 1) / \(formatNumber(operation.factor ?? 1))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            case .add:
                Image(systemName: "arrow.right")
                    .foregroundColor(accentColor)
                if let source = operation.sourceRow {
                    Text("R\(operation.targetRow + 1) - \(formatNumber(operation.factor ?? 0)) * R\(source + 1)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(accentColor.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(accentColor.opacity(0.2), lineWidth: 1)
        )
    }

    private func rowPill(index: Int) -> some View {
        Text("R\(index + 1)")
            .font(.subheadline.weight(.semibold))
            .foregroundColor(accentColor)
            .padding(.vertical, 4)
            .padding(.horizontal, 10)
            .background(
                Capsule()
                    .fill(accentColor.opacity(0.15))
            )
    }
}

struct MatrixInputView: View {
    @Binding var matrix: [[String]]
    let cellSize: CGFloat
    let accent: Color
    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<matrix.count, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(0..<matrix[row].count, id: \.self) { col in
                        TextField("", text: $matrix[row][col])
                            .multilineTextAlignment(.center)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .frame(width: cellSize, height: cellSize * 0.7)
                            .background(Color.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(accent.opacity(0.25), lineWidth: 1)
                            )
                            .keyboardType(.decimalPad)
                    }
                }
            }
        }
    }
}

struct AugmentedMatrixInputView: View {
    @Binding var matrix: [[String]]
    @Binding var rhs: [[String]]
    let cellSize: CGFloat
    let accent: Color

    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<matrix.count, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(0..<matrix[row].count, id: \.self) { col in
                        TextField("", text: $matrix[row][col])
                            .multilineTextAlignment(.center)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .frame(width: cellSize, height: cellSize * 0.7)
                            .background(Color.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(accent.opacity(0.25), lineWidth: 1)
                            )
                            .keyboardType(.decimalPad)
                    }

                    Text("=")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(accent)
                        .frame(width: 20)

                    TextField("", text: $rhs[row][0])
                        .multilineTextAlignment(.center)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .frame(width: cellSize, height: cellSize * 0.7)
                        .background(Color.white.opacity(0.8), in: RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(accent.opacity(0.3), lineWidth: 1)
                        )
                        .keyboardType(.decimalPad)
                }
            }
        }
    }
}

struct MatrixResultView: View {
    let matrix: [[Double]]
    let cellSize: CGFloat
    let accent: Color
    let highlightRows: Set<Int>

    init(matrix: [[Double]], cellSize: CGFloat, accent: Color, highlightRows: Set<Int> = []) {
        self.matrix = matrix
        self.cellSize = cellSize
        self.accent = accent
        self.highlightRows = highlightRows
    }

    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<matrix.count, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(0..<matrix[row].count, id: \.self) { col in
                        Text(display(matrix[row][col]))
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .frame(width: cellSize, height: cellSize * 0.7)
                            .background(
                                (highlightRows.contains(row) ? accent.opacity(0.16) : Color.white.opacity(0.55)),
                                in: RoundedRectangle(cornerRadius: 10)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(accent.opacity(0.18), lineWidth: 1)
                            )
                    }
                }
            }
        }
    }

    private func display(_ value: Double) -> String {
        let adjusted = abs(value) < 1e-9 ? 0 : value
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3
        formatter.minimumFractionDigits = 0
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: adjusted)) ?? String(format: "%g", adjusted)
    }
}

struct AugmentedMatrixResultView: View {
    let matrix: [[Double]]
    let cellSize: CGFloat
    let accent: Color
    let highlightRows: Set<Int>

    var body: some View {
        let lhsCount = max((matrix.first?.count ?? 1) - 1, 0)
        VStack(spacing: 8) {
            ForEach(0..<matrix.count, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(0..<lhsCount, id: \.self) { col in
                        cell(value: matrix[row][col], highlighted: highlightRows.contains(row))
                    }

                    Text("=")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(accent)
                        .frame(width: 18)

                    if lhsCount < matrix[row].count {
                        cell(value: matrix[row][lhsCount], highlighted: highlightRows.contains(row))
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func cell(value: Double, highlighted: Bool) -> some View {
        Text(display(value))
            .font(.system(size: 14, weight: .medium, design: .rounded))
            .frame(width: cellSize, height: cellSize * 0.7)
            .background(
                (highlighted ? accent.opacity(0.16) : Color.white.opacity(0.55)),
                in: RoundedRectangle(cornerRadius: 10)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(accent.opacity(0.18), lineWidth: 1)
            )
    }

    private func display(_ value: Double) -> String {
        let adjusted = abs(value) < 1e-9 ? 0 : value
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3
        formatter.minimumFractionDigits = 0
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: adjusted)) ?? String(format: "%g", adjusted)
    }
}

struct GlassCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 6)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    let accent: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [accent, accent.opacity(0.75)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(14)
            .shadow(color: accent.opacity(0.3), radius: 8, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

#Preview {
    MatrixCalculatorView()
}
