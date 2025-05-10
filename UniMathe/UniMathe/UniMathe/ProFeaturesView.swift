import SwiftUI
import StoreKit

struct ProFeaturesView: View {
    @StateObject private var storeManager = StoreKitManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 36) {
                // Moderner Header nur mit Blautönen
                VStack(alignment: .center, spacing: 22) {
                    // Icon mit sanftem Blau-Gradient
                    ZStack {
                        Circle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.0, green: 0.5, blue: 1.0),
                                    Color(red: 0.0, green: 0.3, blue: 0.8)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 100, height: 100)
                            .shadow(color: Color.blue.opacity(0.2), radius: 10, x: 0, y: 4)
                        
                        // Stern statt Funktions-Icon
                        Image(systemName: "star.circle.fill")
                            .font(.system(size: 50, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 6)
                    
                    // Titel mit modernem Blau
                    Text("Höhere Mathematik Pro")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.9))
                    
                    // Untertitel
                    Text("Erweitere deine Lernmöglichkeiten")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color.gray.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 16)
                .padding(.bottom, 10)

                // Feature-Liste - moderne, minimalistische Cards
                VStack(spacing: 16) {
                    FeatureRow(icon: "checkmark.circle.fill", text: "Alle interaktiven Lektionen freischalten")
                    FeatureRow(icon: "books.vertical.fill", text: "Vollen Zugriff auf über 300 Aufgaben ")
                    FeatureRow(icon: "list.bullet.rectangle.fill", text: "Detalierte Lösungschritte")
                    FeatureRow(icon: "star.fill", text: "Unterstütze die Weiterentwicklung")
                }
                .padding(.horizontal, 20)

                // Kaufoptionen
                if storeManager.purchasedProductIDs.contains("unimathe.pro.lifetime") {
                    VStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.3))
                        
                        Text("Du genießt bereits alle Pro-Features!")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.3))
                    }
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color(red: 0.9, green: 1.0, blue: 0.95))
                            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
                    )
                    .padding(.horizontal, 20)
                } else {
                    VStack(spacing: 16) {
                        ForEach(storeManager.products.filter { $0.id == "unimathe.pro.lifetime" }) { product in
                            PurchaseButton(product: product)
                        }
                    }
                    .padding(.horizontal, 20)
                }

                // Restore purchases - subtil aber klar erkennbar
                Button(action: {
                    Task {
                        await storeManager.updatePurchasedProducts()
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 14))
                        Text("Käufe wiederherstellen")
                            .fontWeight(.medium)
                    }
                    .font(.subheadline)
                    .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.9))
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(Color.blue.opacity(0.06))
                    .cornerRadius(14)
                }
                .padding(.top, 6)

                // Rechtliches - dezent und professionell
                VStack(spacing: 8) {
                    Text("Mit dem Kauf stimmst du den Nutzungsbedingungen und der Datenschutzerklärung zu.")
                        .font(.footnote)
                        .foregroundColor(Color.gray.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    HStack(spacing: 20) {
                        Link("AGB", destination: URL(string: "https://unimathe.app/agb")!)
                            .font(.footnote.weight(.medium))
                            .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.9))
                        
                        Link("Datenschutz", destination: URL(string: "https://unimathe.app/datenschutz")!)
                            .font(.footnote.weight(.medium))
                            .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.9))
                    }
                }
                .padding(.top, 16)
                .padding(.bottom, 24)
            }
        }
        .background(Color(UIColor.systemBackground))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: { dismiss() }) {
                    Text("Schließen")
                        .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.9))
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    var body: some View {
        HStack(spacing: 18) {
            // Modern blue icon
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.0, green: 0.4, blue: 0.9),
                            Color(red: 0.0, green: 0.5, blue: 1.0)
                        ]),
                        startPoint: .topLeading, 
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
            }
            
            // Feature text with subtle formatting
            Text(text)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color.primary.opacity(0.85))
                .lineLimit(2)
                .minimumScaleFactor(0.9)
            
            Spacer()
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 18)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
        )
    }
}

struct PurchaseButton: View {
    let product: Product
    @State private var isPurchasing = false
    @State private var error: String?
    @ObservedObject private var storeManager = StoreKitManager.shared
    @State private var animate = false
    
    var body: some View {
        Button(action: purchase) {
            HStack {
                if isPurchasing {
                    ProgressView()
                        .tint(.white)
                } else {
                    ZStack {
                        // Hintergrund für das Icon
                        Circle()
                            .fill(Color.white.opacity(0.15))
                            .frame(width: 32, height: 32)
                        
                        // Modernes Icon für Premium
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .scaleEffect(animate ? 1.08 : 1.0)
                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animate)
                    }
                    .padding(.trailing, 4)
                    
                    Text(product.displayName)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(product.displayPrice)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(12)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.0, green: 0.5, blue: 1.0),
                        Color(red: 0.0, green: 0.3, blue: 0.8)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(18)
            .shadow(color: Color.blue.opacity(0.25), radius: 8, x: 0, y: 4)
            .scaleEffect(isPurchasing ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPurchasing)
        }
        .buttonStyle(PlainButtonStyle()) // Um Hervorhebung zu vermeiden
        .onAppear { animate = true }
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
