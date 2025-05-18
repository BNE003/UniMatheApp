import SwiftUI
import MessageUI
import StoreKit

struct SettingsView: View {
    @ObservedObject private var settings = SettingsModel.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showContributeSheet = false
    @State private var showLegalActionSheet = false
    @State private var showMailView = false
    @State private var showImpressumSheet = false
    
    var body: some View {
        ZStack {
            // Modern gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.98, green: 0.98, blue: 1.0),
                    Color(red: 0.95, green: 0.97, blue: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Static decorative elements
            GeometryReader { geometry in
                ZStack {
                    // Top decorative shape
                    Circle()
                        .fill(settings.accentColor.opacity(0.1))
                        .frame(width: geometry.size.width * 0.5)
                        .offset(x: -geometry.size.width * 0.2, y: -geometry.size.height * 0.1)
                    
                    // Bottom decorative shape
                    Circle()
                        .fill(settings.accentColor.opacity(0.05))
                        .frame(width: geometry.size.width * 0.7)
                        .offset(x: geometry.size.width * 0.3, y: geometry.size.height * 0.5)
                    
                    // Subtle accent elements
                    RoundedRectangle(cornerRadius: 80)
                        .fill(settings.accentColor.opacity(0.07))
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.3)
                        .offset(x: 0, y: -geometry.size.height * 0.2)
                        .rotationEffect(.degrees(30))
                }
            }
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    Text("Settings")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(settings.accentColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    // Action Buttons
                    SettingsSection {
                        // Get Pro Button - only show if not purchased
                        if StoreKitManager.shared.purchasedProductIDs.isEmpty {
                            NavigationLink(destination: ProFeaturesView()) {
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.white)
                                    Text("Get Pro")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.2, green: 0.5, blue: 0.9),
                                            Color(red: 0.3, green: 0.3, blue: 0.8),
                                            Color(red: 0.4, green: 0.2, blue: 0.7)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(12)
                                .shadow(color: Color(red: 0.3, green: 0.3, blue: 0.8).opacity(0.4), radius: 6, x: 0, y: 3)
                            }
                            .padding(.bottom, 10)
                        }
                        
                        // Support
                        Button(action: {
                            if MFMailComposeViewController.canSendMail() {
                                showMailView = true
                            } else {
                                // Fallback for devices that can't send email
                                if let url = URL(string: "mailto:bene-held@web.de") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        }) {
                            SettingsButton(icon: "envelope.fill", title: "Support", iconColor: .blue)
                        }
                        .sheet(isPresented: $showMailView) {
                            MailView(isShowing: $showMailView, recipient: "bene-held@web.de", subject: "UniMathe App Support")
                        }
                        
                        // Contribute
                        Button(action: {
                            showContributeSheet = true
                        }) {
                            SettingsButton(icon: "hammer.fill", title: "Mitwirken", iconColor: .orange)
                        }
                        .sheet(isPresented: $showContributeSheet) {
                            ContributeView()
                        }
                        
                        // Rate
                        Button(action: {
                            // Use SKStoreReviewController for an in-app rating prompt
                            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                SKStoreReviewController.requestReview(in: scene)
                            }
                        }) {
                            SettingsButton(icon: "star.fill", title: "Bewerten", iconColor: .yellow)
                        }
                        
                        // Legal
                        Button(action: {
                            showLegalActionSheet = true
                        }) {
                            SettingsButton(icon: "doc.text.fill", title: "Rechtliches", iconColor: .purple)
                        }
                        .actionSheet(isPresented: $showLegalActionSheet) {
                            ActionSheet(
                                title: Text("Rechtliche Informationen"),
                                message: Text("Wähle eine Option aus"),
                                buttons: [
                                    .default(Text("Impressum")) {
                                        showImpressumSheet = true
                                    },
                                    .default(Text("Datenschutz")) {
                                        if let url = URL(string: "https://sites.google.com/view/hoehere-mathematik/startseite") {
                                            UIApplication.shared.open(url)
                                        }
                                    },
                                    .default(Text("AGB")) {
                                        if let url = URL(string: "https://sites.google.com/view/hoehere-mathematik-agb/startseite") {
                                            UIApplication.shared.open(url)
                                        }
                                    },
                                    .cancel(Text("Abbrechen"))
                                ]
                            )
                        }
                        .sheet(isPresented: $showImpressumSheet) {
                            ImpressumView()
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing: 
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(settings.accentColor)
            }
        )
        .preferredColorScheme(settings.isDarkModeEnabled ? .dark : .light)
    }
}

// MARK: - Support Views
struct SettingsSection<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 2) {
            content
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
                .shadow(color: Color.black.opacity(0.05), radius: 10)
        )
        .padding(.horizontal, 20)
    }
}

struct SettingsButton: View {
    let icon: String
    let title: String
    let iconColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(iconColor)
                )
                .padding(.vertical, 8)
                .padding(.leading, 16)
            
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.primary)
                .padding(.leading, 8)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)
                .padding(.trailing, 16)
        }
        .padding(.vertical, 10)
        .background(Color.clear)
    }
}

// MARK: - Impressum View
struct ImpressumView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.98, green: 0.98, blue: 1.0)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 24) {
                    Text("Impressum")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Benedikt Held")
                            .font(.headline)
                        
                        Text("Rotkehlchenweg 12")
                            .font(.body)
                        
                        Text("85591, Vaterstetten")
                            .font(.body)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 5)
                    )
                    
                    Spacer()
                }
                .padding(24)
            }
            .navigationBarTitle("Impressum", displayMode: .inline)
            .navigationBarItems(trailing: 
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.primary.opacity(0.7))
                }
            )
        }
    }
}

// MARK: - Email Support
struct MailView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    var recipient: String
    var subject: String
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = context.coordinator
        mailComposer.setToRecipients([recipient])
        mailComposer.setSubject(subject)
        return mailComposer
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView
        
        init(_ parent: MailView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.isShowing = false
        }
    }
}

// MARK: - Contribute View
struct ContributeView: View {
    @Environment(\.presentationMode) var presentationMode
    let repositoryURL = "https://github.com/BNE003/UniMatheApp"
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.98, green: 0.98, blue: 1.0)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("An der App mitwirken")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Du möchtest die App weiterentwickeln? Dann öffne das Repository und erstelle Pull Requests. Die App ist Open Source.")
                            .font(.body)
                            .lineSpacing(5)
                            .opacity(0.8)
                    }
                    .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Repository Link:")
                            .font(.headline)
                        
                        Text(repositoryURL)
                            .font(.system(.subheadline, design: .monospaced))
                            .padding(12)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Button(action: {
                        if let url = URL(string: repositoryURL) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "link")
                                .font(.headline)
                            Text("Repository öffnen")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .cornerRadius(12)
                        .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                }
                .padding(24)
            }
            .navigationBarTitle("Mitwirken", displayMode: .inline)
            .navigationBarItems(trailing: 
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.primary.opacity(0.7))
                }
            )
        }
    }
}

#Preview {
    NavigationView {
        SettingsView()
    }
} 
