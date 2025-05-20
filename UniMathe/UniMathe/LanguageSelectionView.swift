import SwiftUI

struct LanguageSelectionView: View {
    @ObservedObject private var settings = SettingsModel.shared
    @Binding var showLanguageSelection: Bool
    @State private var selectedLanguage: AppLanguage = .german
    @State private var animateBackground = false
    
    private let blueGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.1, green: 0.3, blue: 0.9),
            Color(red: 0.2, green: 0.5, blue: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        ZStack {
            // Abstract background elements
            GeometryReader { geometry in
                ZStack {
                    // Background base color
                    Color(red: 0.96, green: 0.97, blue: 0.98)
                        .ignoresSafeArea()
                    
                    // Animated background shapes
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: geometry.size.width * 0.8)
                        .offset(x: animateBackground ? geometry.size.width * 0.3 : -geometry.size.width * 0.3, 
                                y: -geometry.size.height * 0.2)
                        .animation(Animation.easeInOut(duration: 20).repeatForever(autoreverses: true), value: animateBackground)
                    
                    Circle()
                        .fill(Color.purple.opacity(0.08))
                        .frame(width: geometry.size.width * 1.2)
                        .offset(x: animateBackground ? -geometry.size.width * 0.2 : geometry.size.width * 0.2, 
                                y: geometry.size.height * 0.3)
                        .animation(Animation.easeInOut(duration: 15).repeatForever(autoreverses: true).delay(5), value: animateBackground)
                }
            }
            
            VStack(spacing: 60) {
                // Title
                VStack(spacing: 10) {
                    Text("Willkommen | Welcome")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.black.opacity(0.8))
                        .multilineTextAlignment(.center)
                    
                    Text("Bitte wählen Sie Ihre Sprache aus")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                    
                    Text("Please select your language")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                }
                .padding(.top, 40)
                
                // Language options
                VStack(spacing: 25) {
                    // German option
                    languageButton(
                        language: .german,
                        title: "Deutsch",
                        description: "Fortfahren auf Deutsch",
                        flagEmoji: "🇩🇪"
                    )
                    
                    // English option
                    languageButton(
                        language: .english,
                        title: "English",
                        description: "Continue in English",
                        flagEmoji: "🇬🇧"
                    )
                }
                
                // Continue button
                Button(action: {
                    settings.setLanguage(selectedLanguage)
                    
                    // Dismiss the screen
                    showLanguageSelection = false
                }) {
                    Text(selectedLanguage == .german ? "Bestätigen" : "Confirm")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(blueGradient)
                        .cornerRadius(16)
                        .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            withAnimation {
                animateBackground = true
            }
        }
    }
    
    private func languageButton(language: AppLanguage, title: String, description: String, flagEmoji: String) -> some View {
        Button(action: {
            selectedLanguage = language
        }) {
            HStack(spacing: 20) {
                // Flag emoji
                Text(flagEmoji)
                    .font(.system(size: 40))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black.opacity(0.8))
                    
                    Text(description)
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Selection indicator
                if selectedLanguage == language {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        )
                } else {
                    Circle()
                        .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                        .frame(width: 24, height: 24)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(
                        color: selectedLanguage == language ? Color.blue.opacity(0.15) : Color.black.opacity(0.05),
                        radius: 10, x: 0, y: 5
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(selectedLanguage == language ? Color.blue.opacity(0.5) : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 30)
    }
} 