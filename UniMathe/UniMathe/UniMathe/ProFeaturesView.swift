import SwiftUI
import StoreKit

struct ProFeaturesView: View {
    @StateObject private var storeManager = StoreKitManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "star.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("UniMathe Pro")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Erweitere deine Lernmöglichkeiten")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                // Feature-Liste
                VStack(alignment: .leading, spacing: 12) {
                    FeatureRow(icon: "checkmark.seal.fill", text: "Alle interaktiven Beispiele freischalten")
                    FeatureRow(icon: "checkmark.seal.fill", text: "Zukünftige Pro-Features inklusive")
                    FeatureRow(icon: "checkmark.seal.fill", text: "Unterstütze die Weiterentwicklung")
                }
                .padding(.horizontal)
                
                // Kaufoptionen
                if storeManager.purchasedProductIDs.contains("unimathe.pro.lifetime") {
                    Text("Du genießt bereits alle Pro-Features!")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding()
                } else {
                    VStack(spacing: 16) {
                        ForEach(storeManager.products.filter { $0.id == "unimathe.pro.lifetime" }) { product in
                            PurchaseButton(product: product)
                        }
                    }
                }
                
                // Restore purchases
                Button(action: {
                    Task {
                        await storeManager.updatePurchasedProducts()
                    }
                }) {
                    Text("Käufe wiederherstellen")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .padding(.top, 8)
                
                // Rechtliches
                VStack(spacing: 4) {
                    Text("Mit dem Kauf stimmst du den Nutzungsbedingungen und der Datenschutzerklärung zu.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    HStack(spacing: 16) {
                        Link("AGB", destination: URL(string: "https://unimathe.app/agb")!)
                        Link("Datenschutz", destination: URL(string: "https://unimathe.app/datenschutz")!)
                    }
                    .font(.footnote)
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .navigationTitle("Pro freischalten")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Schließen") { dismiss() }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(text)
        }
    }
}

struct PurchaseButton: View {
    let product: Product
    @State private var isPurchasing = false
    @State private var error: String?
    @ObservedObject private var storeManager = StoreKitManager.shared
    
    var body: some View {
        Button(action: purchase) {
            HStack {
                if isPurchasing {
                    ProgressView()
                } else {
                    Text(product.displayName)
                        .fontWeight(.bold)
                    Spacer()
                    Text(product.displayPrice)
                        .fontWeight(.bold)
                }
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
        }
        .disabled(isPurchasing)
        .alert(isPresented: Binding<Bool>(
            get: { error != nil },
            set: { _ in error = nil }
        )) {
            Alert(title: Text("Fehler"), message: Text(error ?? "Unbekannter Fehler"), dismissButton: .default(Text("OK")))
        }
    }
    
    private func purchase() {
        Task {
            isPurchasing = true
            do {
                try await storeManager.purchase(product)
            } catch StoreError.userCancelled {
                // Nichts tun
            } catch {
                self.error = error.localizedDescription
            }
            isPurchasing = false
        }
    }
}

struct ProFeaturesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProFeaturesView()
        }
    }
} 