import StoreKit
import SwiftUI

@MainActor
class StoreKitManager: ObservableObject {
    static let shared = StoreKitManager()
    static let yearlyProductID = "unimathe.pro.year"
    static let monthlyProductID = "unimathe.pro.month"
    static let lifetimeProductID = "unimathe.pro.lifetime"
    static let productIDs = [yearlyProductID, monthlyProductID, lifetimeProductID]
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs = Set<String>()
    
    private let productIDs = StoreKitManager.productIDs
    
    private init() {
        Task {
            await loadProducts()
            await updatePurchasedProducts()
            await listenForTransactions()
        }
    }
    
    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
            
            for product in products {
                print("Product loaded: \(product.id)")
                print("Display price: \(product.displayPrice)")
                print("Price: \(product.price)")
                print("Price format: \(product.priceFormatStyle)")
            }
        } catch {
            print("Failed to load products:", error)
        }
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            switch verification {
            case .verified(let transaction):
                // Mark entitlement immediately so UI can unlock without a second tap.
                purchasedProductIDs.insert(transaction.productID)
                await transaction.finish()
                await updatePurchasedProducts()
            case .unverified:
                throw StoreError.failedVerification
            }
        case .userCancelled:
            throw StoreError.userCancelled
        case .pending:
            throw StoreError.pending
        @unknown default:
            throw StoreError.unknown
        }
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
        } catch {
            print("Restore failed:", error)
        }
    }
    
    func updatePurchasedProducts() async {
        var updatedProductIDs = Set<String>()
        for await result in Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction):
                updatedProductIDs.insert(transaction.productID)
            case .unverified:
                continue
            }
        }
        purchasedProductIDs = updatedProductIDs
    }

    // Listen for transaction updates and keep purchase state in sync
    func listenForTransactions() async {
        for await _ in Transaction.updates {
            await updatePurchasedProducts()
        }
    }
}

enum StoreError: Error {
    case failedVerification
    case userCancelled
    case pending
    case unknown
} 
