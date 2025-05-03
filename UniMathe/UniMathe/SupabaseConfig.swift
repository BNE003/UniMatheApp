import Foundation
import Supabase
import SwiftUI

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    private let client: SupabaseClient
    
    private init() {
        self.client = SupabaseClient(
            supabaseURL: URL(string: "https://bciqydqismrwrjnigzaa.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJjaXF5ZHFpc21yd3JqbmlnemFhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDYxMzI3ODMsImV4cCI6MjA2MTcwODc4M30.im_SfKuqhIEyzycRGQ7_EqFIwuvESkRQsmGHu0lonvs"
        )
        
        // Check for existing session on init
        Task {
            await checkSession()
        }
    }
    
    func checkSession() async {
        do {
            let session = try await client.auth.session
            await MainActor.run {
                self.isAuthenticated = true
                self.currentUser = session.user
            }
        } catch {
            print("Session check error: \(error)")
            await MainActor.run {
                self.isAuthenticated = false
                self.currentUser = nil
            }
        }
    }
    
    func signIn(email: String, password: String) async throws {
        do {
            print("Attempting to sign in with email: \(email)")
            let response = try await client.auth.signIn(
                email: email,
                password: password
            )
            print("Sign in response: \(response)")
            
            await MainActor.run {
                self.isAuthenticated = true
                self.currentUser = response.user
            }
        } catch {
            print("Sign in error details: \(error)")
            throw error
        }
    }
    
    func signUp(email: String, password: String) async throws {
        do {
            print("Attempting to sign up with email: \(email)")
            let response = try await client.auth.signUp(
                email: email,
                password: password
            )
            print("Sign up response: \(response)")
            
            await MainActor.run {
                self.isAuthenticated = true
                self.currentUser = response.user
            }
        } catch {
            print("Sign up error: \(error)")
            throw error
        }
    }
    
    func signOut() async throws {
        do {
            try await client.auth.signOut()
            await MainActor.run {
                self.isAuthenticated = false
                self.currentUser = nil
            }
        } catch {
            print("Sign out error: \(error)")
            throw error
        }
    }
} 