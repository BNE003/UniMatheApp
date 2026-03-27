// PurchaseModel SwiftUI
// Created by Adam Lyttle on 7/18/2024

// Make cool stuff and share your build with me:

//  --> x.com/adamlyttleapps
//  --> github.com/adamlyttleapps

import Foundation
import StoreKit
import Combine

class PurchaseModel: ObservableObject {
    
    @Published var productIds: [String]
    @Published var productDetails: [PurchaseProductDetails] = []

    @Published var isSubscribed: Bool = false
    @Published var isPurchasing: Bool = false
    @Published var isFetchingProducts: Bool = false
    
    private let storeManager = StoreKitManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {

        //initialise your productids and product details
        self.productIds = ["unimathe.pro.year", "unimathe.pro.month"]
        
        // Create placeholder details - they will be updated with real prices from StoreKit
        self.productDetails = [
            PurchaseProductDetails(price: "$29.99", productId: "unimathe.pro.year", duration: "year", durationPlanName: "Yearly Plan", hasTrial: false),
            PurchaseProductDetails(price: "$4.99", productId: "unimathe.pro.month", duration: "month", durationPlanName: "3-Day Trial", hasTrial: true)
        ]
        
        // Update subscription status based on StoreKit
        Task { @MainActor in
            updateSubscriptionStatus()
        }
        
        // Load actual product information
        loadActualProductInfo()
        
        // Update localized plan names
        updateLocalizedPlanNames()
        
        // Listen for changes in StoreKitManager
        setupStoreKitObserver()
    }
    
    private func updateLocalizedPlanNames() {
        let settings = SettingsModel.shared
        let isEnglish = settings.language == .english
        
        for index in productDetails.indices {
            let product = productDetails[index]
            if product.productId == "unimathe.pro.year" {
                productDetails[index].durationPlanName = isEnglish ? "Yearly Plan" : "Jahresabo"
                productDetails[index].duration = isEnglish ? "year" : "Jahr"
            } else if product.productId == "unimathe.pro.month" {
                productDetails[index].durationPlanName = isEnglish ? "3-Day Trial" : "3-Tage-Test"
                productDetails[index].duration = isEnglish ? "month" : "Monat"
            }
        }
    }
    
    @MainActor
    private func updateSubscriptionStatus() {
        isSubscribed = !storeManager.purchasedProductIDs.isEmpty
    }
    
    private func loadActualProductInfo() {
        isFetchingProducts = true
        
        Task { @MainActor in
            // Update product details with actual StoreKit prices
            for product in storeManager.products {
                if let index = productDetails.firstIndex(where: { $0.productId == product.id }) {
                    productDetails[index].price = product.displayPrice
                }
            }
            isFetchingProducts = false
        }
    }
    
    func purchaseSubscription(productId: String) {
        isPurchasing = true
        
        Task { @MainActor in
            do {
                var product = storeManager.products.first(where: { $0.id == productId })
                
                if product == nil {
                    await storeManager.loadProducts()
                    product = storeManager.products.first(where: { $0.id == productId })
                }
                
                if let product {
                    try await storeManager.purchase(product)
                    updateSubscriptionStatus()
                }
            } catch {
                print("Purchase failed: \(error)")
            }
            isPurchasing = false
        }
    }
    
    func restorePurchases() {
        Task { @MainActor in
            do {
                try await AppStore.sync()
                await storeManager.updatePurchasedProducts()
                updateSubscriptionStatus()
            } catch {
                print("Restore failed: \(error)")
            }
        }
    }
    
    private func setupStoreKitObserver() {
        // Observe changes in StoreKitManager's purchasedProductIDs
        Task { @MainActor in
            storeManager.$purchasedProductIDs
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    Task { @MainActor in
                        self?.updateSubscriptionStatus()
                    }
                }
                .store(in: &cancellables)
        }
    }
    
}

class PurchaseProductDetails: ObservableObject, Identifiable {
    let id: UUID
    
    @Published var price: String
    @Published var productId: String
    @Published var duration: String
    @Published var durationPlanName: String
    @Published var hasTrial: Bool
    
    init(price: String = "", productId: String = "", duration: String = "", durationPlanName: String = "", hasTrial: Bool = false) {
        self.id = UUID()
        self.price = price
        self.productId = productId
        self.duration = duration
        self.durationPlanName = durationPlanName
        self.hasTrial = hasTrial
    }
    
}
