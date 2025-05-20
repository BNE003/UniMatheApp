import SwiftUI
import MessageUI
import StoreKit

struct SettingsView: View {
    @ObservedObject private var settings = SettingsModel.shared
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
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
                VStack(spacing: horizontalSizeClass == .regular ? 30 : 20) {
                    // Header
                    Text(settings.language == .english ? "Settings" : "Einstellungen")
                        .font(.system(size: horizontalSizeClass == .regular ? 48 : 40, weight: .bold, design: .rounded))
                        .foregroundColor(settings.accentColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, horizontalSizeClass == .regular ? 40 : 20)
                        .padding(.top, horizontalSizeClass == .regular ? 30 : 20)
                    
                    // Language Section
                    SettingsSection {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Sprache / Language")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, horizontalSizeClass == .regular ? 24 : 16)
                                .padding(.top, 12)
                            
                            ForEach(AppLanguage.allCases, id: \.self) { language in
                                Button(action: {
                                    settings.language = language
                                }) {
                                    HStack {
                                        Image(systemName: language == .german ? "flag" : "globe")
                                            .font(.system(size: 18))
                                            .foregroundColor(settings.language == language ? settings.accentColor : .gray)
                                        
                                        Text(language.displayName)
                                            .font(.system(size: horizontalSizeClass == .regular ? 20 : 17))
                                        
                                        Spacer()
                                        
                                        if settings.language == language {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.system(size: 22))
                                                .foregroundColor(settings.accentColor)
                                        } else {
                                            Circle()
                                                .strokeBorder(Color.gray.opacity(0.5), lineWidth: 1.5)
                                                .frame(width: 22, height: 22)
                                        }
                                    }
                                    .padding(.horizontal, horizontalSizeClass == .regular ? 24 : 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(settings.language == language ? settings.accentColor.opacity(0.1) : Color.clear)
                                    )
                                }
                                .foregroundColor(.primary)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                    
                    // Action Buttons
                    SettingsSection {
                        // Get Pro Button - only show if not purchased
                        if StoreKitManager.shared.purchasedProductIDs.isEmpty {
                            NavigationLink(destination: ProFeaturesView()) {
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.white)
                                    Text(settings.language == .english ? "Get Pro" : "Pro Version")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(horizontalSizeClass == .regular ? 16 : 12)
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
                                .cornerRadius(14)
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
                            SettingsButton(icon: "envelope.fill", title: "Support", iconColor: .blue, isIpad: horizontalSizeClass == .regular)
                        }
                        .sheet(isPresented: $showMailView) {
                            MailView(isShowing: $showMailView, recipient: "bene-held@web.de", subject: settings.language == .english ? "UniMathe App Support" : "UniMathe App Support")
                        }
                        
                        // Rate
                        Button(action: {
                            // Use SKStoreReviewController for an in-app rating prompt
                            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                SKStoreReviewController.requestReview(in: scene)
                            }
                        }) {
                            SettingsButton(icon: "star.fill", title: settings.language == .english ? "Rate" : "Bewerten", iconColor: .yellow, isIpad: horizontalSizeClass == .regular)
                        }
                        
                        // Legal
                        Button(action: {
                            showLegalActionSheet = true
                        }) {
                            SettingsButton(icon: "doc.text.fill", title: settings.language == .english ? "Legal" : "Rechtliches", iconColor: .purple, isIpad: horizontalSizeClass == .regular)
                        }
                        .actionSheet(isPresented: $showLegalActionSheet) {
                            ActionSheet(
                                title: Text(settings.language == .english ? "Legal Information" : "Rechtliche Informationen"),
                                message: Text(settings.language == .english ? "Choose an option" : "Wähle eine Option aus"),
                                buttons: [
                                    .default(Text(settings.language == .english ? "Imprint" : "Impressum")) {
                                        showImpressumSheet = true
                                    },
                                    .default(Text(settings.language == .english ? "Privacy Policy" : "Datenschutz")) {
                                        if let url = URL(string: "https://sites.google.com/view/hoehere-mathematik/startseite") {
                                            UIApplication.shared.open(url)
                                        }
                                    },
                                    .default(Text(settings.language == .english ? "Terms of Service" : "AGB")) {
                                        if let url = URL(string: "https://sites.google.com/view/hoehere-mathematik-agb/startseite") {
                                            UIApplication.shared.open(url)
                                        }
                                    },
                                    .cancel(Text(settings.language == .english ? "Cancel" : "Abbrechen"))
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
                    .font(.system(size: horizontalSizeClass == .regular ? 28 : 22))
                    .foregroundColor(settings.accentColor)
            }
        )
        .preferredColorScheme(settings.isDarkModeEnabled ? .dark : .light)
    }
}

// MARK: - Support Views
struct SettingsSection<Content: View>: View {
    let content: Content
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: horizontalSizeClass == .regular ? 4 : 2) {
            content
        }
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.8))
                .shadow(color: Color.black.opacity(0.05), radius: 12)
        )
        .padding(.horizontal, horizontalSizeClass == .regular ? 32 : 20)
    }
}

struct SettingsButton: View {
    let icon: String
    let title: String
    let iconColor: Color
    var isIpad: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: isIpad ? 24 : 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: isIpad ? 48 : 36, height: isIpad ? 48 : 36)
                .background(
                    RoundedRectangle(cornerRadius: isIpad ? 12 : 10)
                        .fill(iconColor)
                )
                .padding(.vertical, isIpad ? 12 : 8)
                .padding(.leading, isIpad ? 24 : 16)
            
            Text(title)
                .font(.system(size: isIpad ? 20 : 17, weight: .medium))
                .foregroundColor(.primary)
                .padding(.leading, isIpad ? 12 : 8)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: isIpad ? 18 : 14, weight: .semibold))
                .foregroundColor(.gray)
                .padding(.trailing, isIpad ? 24 : 16)
        }
        .padding(.vertical, isIpad ? 14 : 10)
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
                    Text(SettingsModel.shared.language == .english ? "Imprint" : "Impressum")
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
            .navigationBarTitle(SettingsModel.shared.language == .english ? "Imprint" : "Impressum", displayMode: .inline)
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

#Preview {
    NavigationView {
        SettingsView()
    }
} 
