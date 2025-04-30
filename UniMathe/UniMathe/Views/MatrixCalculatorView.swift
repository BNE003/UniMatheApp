import SwiftUI

struct MatrixCalculatorView: View {
    @State private var matrixSize: MatrixSize = .threeByThree
    @State private var algorithm: Algorithm = .gauss
    @State private var matrix: [[Double]] = Array(repeating: Array(repeating: 0, count: 3), count: 3)
    @State private var result: [[Double]] = Array(repeating: Array(repeating: 0, count: 3), count: 3)
    
    enum MatrixSize: String, CaseIterable {
        case threeByThree = "3x3"
        case fourByFour = "4x4"
        
        var size: Int {
            switch self {
            case .threeByThree: return 3
            case .fourByFour: return 4
            }
        }
    }
    
    enum Algorithm: String, CaseIterable {
        case gauss = "Gauss"
        case gaussJordan = "Gauss-Jordan"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Matrix Size Picker
                    VStack(alignment: .leading) {
                        Text("Matrix Größe")
                            .font(.headline)
                        Picker("Matrix Size", selection: $matrixSize) {
                            ForEach(MatrixSize.allCases, id: \.self) { size in
                                Text(size.rawValue).tag(size)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: matrixSize) { newSize in
                            updateMatrixSize(to: newSize.size)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    
                    // Algorithm Picker
                    VStack(alignment: .leading) {
                        Text("Algorithmus")
                            .font(.headline)
                        Picker("Algorithm", selection: $algorithm) {
                            ForEach(Algorithm.allCases, id: \.self) { algo in
                                Text(algo.rawValue).tag(algo)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    
                    // Matrix Input
                    VStack(alignment: .leading) {
                        Text("Matrix")
                            .font(.headline)
                        MatrixInputView(matrix: $matrix)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    
                    // Calculate Button
                    Button(action: calculateResult) {
                        Text("Berechnen")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    // Result Matrix
                    VStack(alignment: .leading) {
                        Text("Ergebnis")
                            .font(.headline)
                        MatrixResultView(matrix: result)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Matrix Rechner")
        }
    }
    
    private func updateMatrixSize(to size: Int) {
        matrix = Array(repeating: Array(repeating: 0, count: size), count: size)
        result = Array(repeating: Array(repeating: 0, count: size), count: size)
    }
    
    private func calculateResult() {
        switch algorithm {
        case .gauss:
            result = gaussElimination(matrix)
        case .gaussJordan:
            result = gaussJordanElimination(matrix)
        }
    }
    
    private func gaussElimination(_ matrix: [[Double]]) -> [[Double]] {
        var result = matrix
        let n = matrix.count
        
        // Forward elimination
        for i in 0..<n {
            // Find pivot
            var maxRow = i
            for k in (i + 1)..<n {
                if abs(result[k][i]) > abs(result[maxRow][i]) {
                    maxRow = k
                }
            }
            
            // Swap rows if necessary
            if maxRow != i {
                result.swapAt(i, maxRow)
            }
            
            // Eliminate column i
            for k in (i + 1)..<n {
                let factor = result[k][i] / result[i][i]
                for j in i..<n {
                    result[k][j] -= factor * result[i][j]
                }
            }
        }
        
        return result
    }
    
    private func gaussJordanElimination(_ matrix: [[Double]]) -> [[Double]] {
        var result = matrix
        let n = matrix.count
        
        // Forward elimination
        for i in 0..<n {
            // Find pivot
            var maxRow = i
            for k in (i + 1)..<n {
                if abs(result[k][i]) > abs(result[maxRow][i]) {
                    maxRow = k
                }
            }
            
            // Swap rows if necessary
            if maxRow != i {
                result.swapAt(i, maxRow)
            }
            
            // Normalize pivot row
            let pivot = result[i][i]
            for j in i..<n {
                result[i][j] /= pivot
            }
            
            // Eliminate column i
            for k in 0..<n {
                if k != i {
                    let factor = result[k][i]
                    for j in i..<n {
                        result[k][j] -= factor * result[i][j]
                    }
                }
            }
        }
        
        return result
    }
}

struct MatrixInputView: View {
    @Binding var matrix: [[Double]]
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<matrix.count, id: \.self) { i in
                HStack(spacing: 8) {
                    ForEach(0..<matrix[i].count, id: \.self) { j in
                        TextField("0", value: $matrix[i][j], format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 60)
                            .keyboardType(.decimalPad)
                    }
                }
            }
        }
    }
}

struct MatrixResultView: View {
    let matrix: [[Double]]
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<matrix.count, id: \.self) { i in
                HStack(spacing: 8) {
                    ForEach(0..<matrix[i].count, id: \.self) { j in
                        Text(String(format: "%.2f", matrix[i][j]))
                            .frame(width: 60)
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(5)
                    }
                }
            }
        }
    }
}

#Preview {
    MatrixCalculatorView()
} 