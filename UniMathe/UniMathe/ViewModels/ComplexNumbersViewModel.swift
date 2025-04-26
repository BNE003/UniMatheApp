import Foundation
import SwiftUI

@MainActor
class ComplexNumbersViewModel: ObservableObject {
    @Published private(set) var content: ComplexNumbersContent?
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    enum LoadingError: Error {
        case failedToLoadContent
    }
    
    init() {
        Task {
            await loadContent()
        }
    }
    
    func loadContent() async {
        isLoading = true
        error = nil
        
        do {
            content = try ComplexNumbersLoader.loadComplexNumbers()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
} 