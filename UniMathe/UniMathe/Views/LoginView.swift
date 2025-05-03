import SwiftUI
import Supabase

// Import the Supabase configuration
@_exported import struct Foundation.URL

struct LoginView: View {
    @StateObject private var authManager = AuthManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var isRegistering = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    @State private var retryCount = 0
    private let maxRetries = 3
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                ContentView()
            } else {
                loginContent
            }
        }
        .task {
            await authManager.checkSession()
        }
    }
    
    private var loginContent: some View {
        NavigationView {
            ZStack {
                // Modern gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.95, green: 0.97, blue: 1.0),
                        Color(red: 0.98, green: 0.98, blue: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Abstract background elements
                GeometryReader { geometry in
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.05))
                            .frame(width: geometry.size.width * 1.2)
                            .offset(x: -geometry.size.width * 0.2, y: -geometry.size.height * 0.1)
                        
                        Circle()
                            .fill(Color.purple.opacity(0.03))
                            .frame(width: geometry.size.width * 0.8)
                            .offset(x: geometry.size.width * 0.3, y: geometry.size.height * 0.3)
                    }
                }
                
                VStack(spacing: 20) {
                    // App Logo/Title
                    Text("UniMathe")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.bottom, 40)
                    
                    // Email Field
                    TextField("E-Mail", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(.horizontal)
                        .disabled(isLoading)
                    
                    // Password Field
                    SecureField("Passwort", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(isRegistering ? .newPassword : .password)
                        .padding(.horizontal)
                        .disabled(isLoading)
                    
                    // Login/Register Button
                    Button(action: {
                        if isRegistering {
                            register()
                        } else {
                            login()
                        }
                    }) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .padding(.trailing, 5)
                            }
                            Text(isRegistering ? "Registrieren" : "Anmelden")
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .disabled(isLoading)
                    
                    // Toggle Register/Login
                    Button(action: {
                        isRegistering.toggle()
                    }) {
                        Text(isRegistering ? "Bereits registriert? Anmelden" : "Neu hier? Registrieren")
                            .foregroundColor(.blue)
                    }
                    .disabled(isLoading)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                )
                .padding()
            }
            .alert(isPresented: $showError) {
                Alert(
                    title: Text("Fehler"),
                    message: Text(errorMessage),
                    primaryButton: .default(Text("Wiederholen")) {
                        retryCount = 0
                        if isRegistering {
                            register()
                        } else {
                            login()
                        }
                    },
                    secondaryButton: .cancel(Text("Abbrechen"))
                )
            }
        }
    }
    
    private func login() {
        guard !email.isEmpty && !password.isEmpty else {
            errorMessage = "Bitte füllen Sie alle Felder aus."
            showError = true
            return
        }
        
        isLoading = true
        
        Task {
            do {
                try await authManager.signIn(email: email, password: password)
                await MainActor.run {
                    isLoading = false
                    retryCount = 0
                }
            } catch {
                await MainActor.run {
                    let errorString = String(describing: error).lowercased()
                    print("Login error: \(errorString)")
                    
                    if errorString.contains("invalid login credentials") || errorString.contains("invalid password") {
                        errorMessage = "Ungültige E-Mail oder Passwort. Bitte überprüfen Sie Ihre Eingaben."
                    } else if errorString.contains("user not found") {
                        errorMessage = "Benutzer nicht gefunden. Bitte registrieren Sie sich zuerst."
                    } else if errorString.contains("network") || errorString.contains("connection") {
                        if retryCount < maxRetries {
                            retryCount += 1
                            errorMessage = "Verbindungsfehler. Versuch \(retryCount) von \(maxRetries). Bitte versuchen Sie es erneut."
                        } else {
                            errorMessage = "Verbindungsfehler. Bitte überprüfen Sie Ihre Internetverbindung und versuchen Sie es später erneut."
                            retryCount = 0
                        }
                    } else {
                        errorMessage = "Ein Fehler ist aufgetreten: \(errorString)"
                    }
                    showError = true
                    isLoading = false
                }
            }
        }
    }
    
    private func register() {
        guard !email.isEmpty && !password.isEmpty else {
            errorMessage = "Bitte füllen Sie alle Felder aus."
            showError = true
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = "Das Passwort muss mindestens 6 Zeichen lang sein."
            showError = true
            return
        }
        
        isLoading = true
        
        Task {
            do {
                try await authManager.signUp(email: email, password: password)
                await MainActor.run {
                    isLoading = false
                    retryCount = 0
                }
            } catch {
                await MainActor.run {
                    let errorString = String(describing: error).lowercased()
                    print("Register error: \(errorString)")
                    
                    if errorString.contains("user already registered") {
                        errorMessage = "Diese E-Mail-Adresse ist bereits registriert."
                    } else if errorString.contains("network") || errorString.contains("connection") {
                        if retryCount < maxRetries {
                            retryCount += 1
                            errorMessage = "Verbindungsfehler. Versuch \(retryCount) von \(maxRetries). Bitte versuchen Sie es erneut."
                        } else {
                            errorMessage = "Verbindungsfehler. Bitte überprüfen Sie Ihre Internetverbindung und versuchen Sie es später erneut."
                            retryCount = 0
                        }
                    } else {
                        errorMessage = "Ein Fehler ist aufgetreten: \(errorString)"
                    }
                    showError = true
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    LoginView()
} 
