import SwiftUI

struct CartesianProductView: View {
    @State private var setA: [Int] = [1, 2]
    @State private var setB: [String] = ["a", "b"]
    @State private var showingExplanation = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                Text("Kartesisches Produkt")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom)
                
                // Definition
                VStack(alignment: .leading, spacing: 10) {
                    Text("Definition:")
                        .font(.headline)
                    Text("A × B = {(x,y) | x ∈ A und y ∈ B}")
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                
                // Interactive Sets
                HStack(spacing: 30) {
                    VStack {
                        Text("Menge A")
                            .font(.headline)
                        ForEach(setA, id: \.self) { element in
                            Text("\(element)")
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                    
                    VStack {
                        Text("Menge B")
                            .font(.headline)
                        ForEach(setB, id: \.self) { element in
                            Text(element)
                                .padding()
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // Result
                VStack(alignment: .leading, spacing: 10) {
                    Text("Kartesisches Produkt A × B:")
                        .font(.headline)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                        ForEach(setA, id: \.self) { a in
                            ForEach(setB, id: \.self) { b in
                                Text("(\(a),\(b))")
                                    .padding()
                                    .background(Color.orange.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // Properties
                VStack(alignment: .leading, spacing: 10) {
                    Text("Eigenschaften:")
                        .font(.headline)
                    
                    PropertyRow(icon: "number", text: "|A × B| = |A| · |B| = \(setA.count) · \(setB.count) = \(setA.count * setB.count)")
                    PropertyRow(icon: "arrow.right", text: "Die Elemente sind geordnete Paare")
                    PropertyRow(icon: "equal.square", text: "A × B ≠ B × A (außer wenn A = B)")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // Applications
                VStack(alignment: .leading, spacing: 10) {
                    Text("Anwendungen:")
                        .font(.headline)
                    
                    ApplicationRow(icon: "grid", text: "Definition von Koordinatensystemen")
                    ApplicationRow(icon: "arrow.triangle.branch", text: "Darstellung von Relationen zwischen Mengen")
                    ApplicationRow(icon: "cube", text: "Konstruktion von Produkträumen in der Topologie")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // Explanation Button
                Button(action: {
                    showingExplanation.toggle()
                }) {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("Detaillierte Erklärung")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .sheet(isPresented: $showingExplanation) {
                    ExplanationView()
                }
            }
            .padding()
        }
    }
}

struct PropertyRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(text)
        }
    }
}

struct ApplicationRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.green)
            Text(text)
        }
    }
}

struct ExplanationView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Detaillierte Erklärung")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Das kartesische Produkt ist eine grundlegende Operation in der Mengenlehre, die es ermöglicht, aus zwei Mengen eine neue Menge zu bilden, deren Elemente geordnete Paare sind.")
                
                Text("Schrittweise Berechnung:")
                    .font(.headline)
                
                Text("1. Für jedes Element x aus Menge A:")
                Text("   - Kombiniere x mit jedem Element y aus Menge B")
                Text("   - Bilde das geordnete Paar (x,y)")
                
                Text("2. Die Gesamtheit aller so gebildeten Paare ergibt das kartesische Produkt A × B")
                
                Text("Wichtige Eigenschaften:")
                    .font(.headline)
                
                Text("• Die Mächtigkeit des kartesischen Produkts ist das Produkt der Mächtigkeiten der Ausgangsmengen")
                Text("• Die Reihenfolge der Elemente in den Paaren ist wichtig")
                Text("• Das kartesische Produkt ist nicht kommutativ (außer wenn A = B)")
                
                Text("Anwendungsbeispiele:")
                    .font(.headline)
                
                Text("• In der Geometrie: Definition von Koordinatensystemen")
                Text("• In der Datenbanktheorie: Darstellung von Relationen")
                Text("• In der Topologie: Konstruktion von Produkträumen")
            }
            .padding()
        }
    }
}

#Preview {
    CartesianProductView()
} 