import SwiftUI

struct SettingsView: View {
    @ObservedObject private var settings = SettingsModel.shared
    @Environment(\.presentationMode) var presentationMode
    
    // Available accent colors
    private let accentColors: [Color] = [
        .blue, .purple, .pink, .orange, .green
    ]
    
    // Animation properties
    @State private var animationAmount: CGFloat = 1
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            // Abstract background
            GeometryReader { geometry in
                ZStack {
                    // Background gradient
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.95, green: 0.97, blue: 1.0),
                            Color(red: 0.92, green: 0.95, blue: 1.0)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    // Abstract shapes in background
                    Circle()
                        .fill(settings.accentColor.opacity(0.1))
                        .frame(width: geometry.size.width * 0.7)
                        .offset(x: -geometry.size.width * 0.2, y: -geometry.size.height * 0.3)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    RoundedRectangle(cornerRadius: 100)
                        .fill(settings.accentColor.opacity(0.08))
                        .frame(width: geometry.size.width * 0.6, height: geometry.size.width * 0.6)
                        .offset(x: geometry.size.width * 0.2, y: geometry.size.height * 0.1)
                        .rotationEffect(.degrees(-rotationAngle))
                    
                    Ellipse()
                        .fill(settings.accentColor.opacity(0.05))
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.4)
                        .offset(x: 0, y: geometry.size.height * 0.25)
                        .rotationEffect(.degrees(rotationAngle/2))
                }
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 20).repeatForever(autoreverses: true)) {
                        rotationAngle = 360
                    }
                }
            }
            
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    Text("Settings")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(settings.accentColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    // Settings groups
                    VStack(spacing: 25) {
                        // Appearance section
                        SettingsSection(title: "Appearance") {
                            // Dark mode toggle
                            Toggle(isOn: $settings.isDarkModeEnabled) {
                                SettingRow(icon: "moon.stars.fill", title: "Dark Mode", iconColor: .purple)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: settings.accentColor))
                            
                            // Large text toggle
                            Toggle(isOn: $settings.useLargeText) {
                                SettingRow(icon: "textformat.size", title: "Large Text", iconColor: .blue)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: settings.accentColor))
                            
                            // Accent color picker
                            HStack {
                                SettingRow(icon: "paintpalette.fill", title: "Accent Color", iconColor: .orange)
                                Spacer()
                                HStack(spacing: 10) {
                                    ForEach(accentColors, id: \.self) { color in
                                        Circle()
                                            .fill(color)
                                            .frame(width: 30, height: 30)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.white, lineWidth: 2)
                                                    .opacity(color == settings.accentColor ? 1 : 0)
                                            )
                                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                            .onTapGesture {
                                                settings.accentColor = color
                                                generateHapticFeedback()
                                            }
                                    }
                                }
                            }
                        }
                        
                        // Notifications section
                        SettingsSection(title: "Notifications") {
                            Toggle(isOn: $settings.notificationsEnabled) {
                                SettingRow(icon: "bell.fill", title: "Notifications", iconColor: .red)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: settings.accentColor))
                        }
                        
                        // About section
                        SettingsSection(title: "About") {
                            Button(action: {
                                // Open app review
                            }) {
                                SettingRow(icon: "star.fill", title: "Rate App", iconColor: .yellow)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.gray.opacity(0.6))
                            }
                            
                            Button(action: {
                                // Share app link
                            }) {
                                SettingRow(icon: "square.and.arrow.up", title: "Share App", iconColor: .green)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.gray.opacity(0.6))
                            }
                            
                            Button(action: {
                                // Open privacy policy
                            }) {
                                SettingRow(icon: "lock.shield", title: "Privacy Policy", iconColor: .blue)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.gray.opacity(0.6))
                            }
                        }
                    }
                    .padding(.horizontal)
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
    
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

// MARK: - Supporting Views
struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.horizontal, 5)
            
            VStack(spacing: 2) {
                content
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            )
        }
    }
}

struct SettingRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(iconColor)
                .frame(width: 32, height: 32)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.1))
                )
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    NavigationView {
        SettingsView()
    }
} 