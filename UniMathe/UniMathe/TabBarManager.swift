import SwiftUI
import Combine

/// Einfacher Tab Bar Manager für die Sichtbarkeit der Tab Bar
class TabBarManager: ObservableObject {
    static let shared = TabBarManager()
    
    @Published var isVisible = true
    
    private init() {}
    
    /// Tab Bar verstecken mit Animation
    func hide() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isVisible = false
        }
    }
    
    /// Tab Bar anzeigen mit Animation
    func show() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isVisible = true
        }
    }
}