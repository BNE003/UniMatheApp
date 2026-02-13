// PurchaseView SwiftUI
// Created by Adam Lyttle on 7/18/2024

// Make cool stuff and share your build with me:

//  --> x.com/adamlyttleapps
//  --> github.com/adamlyttleapps

// Special thanks:

//  --> Mario (https://x.com/marioapps_com) for recommending changes to fix
//      an issue Apple had rejecting the paywall due to excessive use of
//      the word "FREE"

import SwiftUI

struct PurchaseView: View {
    
    @StateObject var purchaseModel: PurchaseModel = PurchaseModel()
    @ObservedObject private var settings = SettingsModel.shared
    
    @State private var shakeDegrees = 0.0
    @State private var shakeZoom = 0.9
    @State private var showCloseButton = false
    @State private var progress: CGFloat = 0.0

    @Binding var isPresented: Bool
    
    @State var showNoneRestoredAlert: Bool = false
    @State private var showTermsActionSheet: Bool = false

    @State private var freeTrial: Bool = true
    @State private var selectedProductId: String = ""
    @State private var showConfetti = false
    
    let color: Color = Color.blue
    
    private let allowCloseAfter: CGFloat = 5.0 //time in seconds until close is allows
    
    var hasCooldown: Bool = true
    
    let placeholderProductDetails: [PurchaseProductDetails] = [
        PurchaseProductDetails(price: "-", productId: "demo", duration: "week", durationPlanName: "week", hasTrial: false),
        PurchaseProductDetails(price: "-", productId: "demo", duration: "week", durationPlanName: "week", hasTrial: false)
    ]
    
    var callToActionText: String {
        if let selectedProductTrial = purchaseModel.productDetails.first(where: {$0.productId == selectedProductId})?.hasTrial {
            if selectedProductTrial {
                return settings.language == .english ? "Start Free Trial" : "Kostenlos testen"
            }
            else {
                return settings.language == .english ? "Unlock Now" : "Jetzt freischalten"
            }
        }
        else {
            return settings.language == .english ? "Unlock Now" : "Jetzt freischalten"
        }
    }
    
    var calculateFullPrice: Double? {
        if let weeklyPriceString = purchaseModel.productDetails.first(where: {$0.duration == "week"})?.price {
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency

            if let number = formatter.number(from: weeklyPriceString) {
                let weeklyPriceDouble = number.doubleValue
                return weeklyPriceDouble * 52
            }
            
            
        }
        
        return nil
    }
    
    var calculatePercentageSaved: Int {
        if let calculateFullPrice = calculateFullPrice, let yearlyPriceString = purchaseModel.productDetails.first(where: {$0.duration == "year"})?.price {
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency

            if let number = formatter.number(from: yearlyPriceString) {
                let yearlyPriceDouble = number.doubleValue
                
                let saved = Int(100 - ((yearlyPriceDouble / calculateFullPrice) * 100))
                
                if saved > 0 {
                    return saved
                }
                
            }
            
        }
        return 65
    }
    
    var body: some View {
        ZStack (alignment: .top) {
            
            // Confetti animation overlay
            if showConfetti {
                ConfettiView()
                    .allowsHitTesting(false)
                    .zIndex(1000)
                
                // Success message overlay
                VStack(spacing: 20) {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.green)
                            .scaleEffect(showConfetti ? 1.0 : 0.5)
                            .animation(.spring(response: 0.6, dampingFraction: 0.6), value: showConfetti)
                        
                        Text(settings.language == .english ? "Welcome to Premium!" : "Willkommen bei Premium!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                        
                        Text(settings.language == .english ? 
                             "You now have access to all features" : 
                             "Du hast jetzt Zugriff auf alle Funktionen")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(32)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                    )
                    .scaleEffect(showConfetti ? 1.0 : 0.8)
                    .opacity(showConfetti ? 1.0 : 0.0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.3), value: showConfetti)
                    
                    Spacer()
                }
                .padding(.horizontal, 40)
                .zIndex(1001)
            }
            
            HStack {
                Spacer()
                
                if hasCooldown && !showCloseButton {
                    Circle()
                        .trim(from: 0.0, to: progress)
                        .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                        .opacity(0.1 + 0.1 * self.progress)
                        .rotationEffect(Angle(degrees: -90))
                        .frame(width: 20, height: 20)
                        .frame(width: 44, height: 44)
                }
                else {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "multiply")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, alignment: .center)
                            .clipped()
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .opacity(0.2)
                }
            }
            .padding(.top, 10)
            .padding(.trailing, 6)

            VStack (spacing: 20) {
                
                ZStack {
                    // Use app logo instead of missing hero image
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 100, alignment: .center)
                        .scaleEffect(shakeZoom)
                        .rotationEffect(.degrees(shakeDegrees))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                startShaking()
                            }
                        }
                }
                
                VStack (spacing: 20) {
                    Text(settings.language == .english ? "Unlock Premium Access" : "Premium freischalten")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color.primary, location: 0.0),
                                    .init(color: Color.primary.opacity(0.8), location: 0.5),
                                    .init(color: Color(red: 0.4, green: 0.6, blue: 1.0).opacity(0.7), location: 1.0)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                    VStack (alignment: .leading) {
                        PurchaseFeatureView(title: settings.language == .english ? "Unlock all interactive lessons" : "Alle interaktiven Lektionen freischalten", icon: "checkmark.circle.fill", color: color)
                        PurchaseFeatureView(title: settings.language == .english ? "Full access to over 300 exercises" : "Vollen Zugriff auf über 300 Aufgaben", icon: "books.vertical.fill", color: color)
                        PurchaseFeatureView(title: settings.language == .english ? "Detailed solution steps" : "Detaillierte Lösungsschritte", icon: "list.bullet.rectangle.fill", color: color)
                        PurchaseFeatureView(title: settings.language == .english ? "Access to all exams" : "Zugang zu allen Klausuren", icon: "doc.text.fill", color: color)
                        PurchaseFeatureView(title: settings.language == .english ? "Monthly new exams" : "Monatlich neue Klausuren", icon: "calendar.circle.fill", color: color)
                    }
                    .font(.system(size: 19))
                    .padding(.top)
                }
                
                Spacer()
                
                VStack (spacing: 24) {
                    VStack (spacing: 16) {
                        
                        let productDetails = purchaseModel.isFetchingProducts ? placeholderProductDetails : purchaseModel.productDetails
                        
                        ForEach(productDetails) { productDetails in
                            
                            Button(action: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    selectedProductId = productDetails.productId
                                }
                                self.freeTrial = productDetails.hasTrial
                            }) {
                                VStack(spacing: 0) {
                                    HStack(spacing: 16) {
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(productDetails.durationPlanName)
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(.primary)
                                            
                                            if productDetails.hasTrial {
                                                let germanDuration: String = {
                                                    switch productDetails.duration {
                                                    case "month": return "Monat"
                                                    case "year": return "Jahr"
                                                    case "week": return "Woche"
                                                    default: return productDetails.duration
                                                    }
                                                }()
                                                
                                                let trialText = settings.language == .english ? 
                                                    "then \(productDetails.price) per \(productDetails.duration)" :
                                                    "dann \(productDetails.price) pro \(germanDuration)"
                                                
                                                Text(trialText)
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(.secondary)
                                            }
                                            else {
                                                HStack(spacing: 4) {
                                                    if let calculateFullPrice = calculateFullPrice,
                                                       let calculateFullPriceLocalCurrency = toLocalCurrencyString(calculateFullPrice),
                                                       calculateFullPrice > 0
                                                    {
                                                        Text("\(calculateFullPriceLocalCurrency)")
                                                            .font(.system(size: 14, weight: .medium))
                                                            .strikethrough()
                                                            .foregroundColor(.secondary.opacity(0.6))
                                                    }
                                                    
                                                    let germanDuration: String = {
                                                        switch productDetails.duration {
                                                        case "month": return "Monat"
                                                        case "year": return "Jahr"
                                                        case "week": return "Woche"
                                                        default: return productDetails.duration
                                                        }
                                                    }()
                                                    
                                                    let priceText = settings.language == .english ? 
                                                        "\(productDetails.price) per \(productDetails.duration)" :
                                                        "\(productDetails.price) pro \(germanDuration)"
                                                    
                                                    Text(priceText)
                                                        .font(.system(size: 15, weight: .medium))
                                                        .foregroundColor(.secondary)
                                                }
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        if !productDetails.hasTrial {
                                            Text("SAVE \(calculatePercentageSaved)%")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color.orange, Color.red]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                                .cornerRadius(12)
                                        }
                                        
                                        ZStack {
                                            Circle()
                                                .fill(
                                                    selectedProductId == productDetails.productId ?
                                                    LinearGradient(
                                                        gradient: Gradient(stops: [
                                                            .init(color: Color(red: 0.4, green: 0.6, blue: 1.0), location: 0.0),
                                                            .init(color: Color(red: 0.7, green: 0.3, blue: 0.9), location: 1.0)
                                                        ]),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ) :
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color.clear]),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )
                                                .frame(width: 24, height: 24)
                                            
                                            Circle()
                                                .stroke(
                                                    selectedProductId == productDetails.productId ?
                                                    Color.clear :
                                                    Color.primary.opacity(0.3),
                                                    lineWidth: 2
                                                )
                                                .frame(width: 24, height: 24)
                                            
                                            if selectedProductId == productDetails.productId {
                                                Image(systemName: "checkmark")
                                                    .font(.system(size: 12, weight: .bold))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 18)
                                }
                                .background(
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(.ultraThinMaterial)
                                        
                                        if selectedProductId == productDetails.productId {
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(
                                                    LinearGradient(
                                                        gradient: Gradient(stops: [
                                                            .init(color: Color(red: 0.4, green: 0.6, blue: 1.0).opacity(0.6), location: 0.0),
                                                            .init(color: Color(red: 0.7, green: 0.3, blue: 0.9).opacity(0.5), location: 1.0)
                                                        ]),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 2
                                                )
                                            
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(stops: [
                                                            .init(color: Color(red: 0.4, green: 0.6, blue: 1.0).opacity(0.05), location: 0.0),
                                                            .init(color: Color(red: 0.7, green: 0.3, blue: 0.9).opacity(0.03), location: 1.0)
                                                        ]),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )
                                        } else {
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                                        }
                                    }
                                )
                                .shadow(
                                    color: selectedProductId == productDetails.productId ? 
                                    Color.blue.opacity(0.2) : Color.black.opacity(0.05),
                                    radius: selectedProductId == productDetails.productId ? 10 : 5,
                                    x: 0,
                                    y: selectedProductId == productDetails.productId ? 5 : 3
                                )
                                .scaleEffect(selectedProductId == productDetails.productId ? 1.02 : 1.0)
                                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedProductId)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                        }
                        
                        HStack {
                            Toggle(isOn: $freeTrial) {
                                Text(settings.language == .english ? "Free Trial Enabled" : "Kostenlosen Test aktivieren")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .onChange(of: freeTrial) { freeTrial in
                                if !freeTrial, let firstProductId = self.purchaseModel.productIds.first {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        self.selectedProductId = String(firstProductId)
                                    }
                                }
                                else if freeTrial, let lastProductId = self.purchaseModel.productIds.last {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        self.selectedProductId = lastProductId
                                    }
                                }
                            }
                        }
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.ultraThinMaterial)
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                            }
                        )
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        
                    }
                    .opacity(purchaseModel.isFetchingProducts ? 0 : 1)
                    
                    VStack (spacing: 25) {
                        
                        ZStack (alignment: .center) {
                            
                            //if purchasedModel.isPurchasing {
                            ProgressView()
                                .opacity(purchaseModel.isPurchasing ? 1 : 0)
                            
                            Button(action: {
                                //productManager.purchaseProduct()
                                if !purchaseModel.isPurchasing {
                                    purchaseModel.purchaseSubscription(productId: self.selectedProductId)
                                }
                            }) {
                                HStack {
                                    Spacer()
                                    HStack {
                                        Text(callToActionText)
                                        Image(systemName: "chevron.right")
                                    }
                                    Spacer()
                                }
                                .padding()
                                .foregroundColor(.white)
                                .font(.title3.bold())
                            }
                            .background(color)
                            .cornerRadius(6)
                            .opacity(purchaseModel.isPurchasing ? 0 : 1)
                            .padding(.top)
                            .padding(.bottom, 4)
                            
                            
                        }
                        
                    }
                    .opacity(purchaseModel.isFetchingProducts ? 0 : 1)
                }
                .id("view-\(purchaseModel.isFetchingProducts)")
                .background {
                    if purchaseModel.isFetchingProducts {
                        ProgressView()
                    }
                }
                
                VStack (spacing: 5) {
                    
                    /*HStack (spacing: 4) {
                        Image(systemName: "figure.2.and.child.holdinghands")
                            .foregroundColor(Color.red)
                        Text("Family Sharing enabled")
                            .foregroundColor(.white)
                    }
                    .font(.footnote)*/
                    
                    HStack (spacing: 10) {
                        
                        Button(settings.language == .english ? "Restore" : "Wiederherstellen") {
                            purchaseModel.restorePurchases()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                                if !purchaseModel.isSubscribed {
                                    showNoneRestoredAlert = true
                                }
                            }
                        }
                        .alert(isPresented: $showNoneRestoredAlert) {
                            Alert(
                                title: Text(settings.language == .english ? "Restore Purchases" : "Käufe wiederherstellen"), 
                                message: Text(settings.language == .english ? "No purchases restored" : "Keine Käufe wiederhergestellt"), 
                                dismissButton: .default(Text("OK"))
                            )
                        }
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray), alignment: .bottom
                        )
                        .font(.footnote)
                        
                        
                        Button(settings.language == .english ? "Terms of Use & Privacy Policy" : "Nutzungsbedingungen & Datenschutz") {
                            showTermsActionSheet = true
                        }
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray), alignment: .bottom
                        )
                        .actionSheet(isPresented: $showTermsActionSheet) {
                            ActionSheet(
                                title: Text(settings.language == .english ? "View Terms & Conditions" : "Bedingungen anzeigen"), 
                                message: nil,
                                buttons: [
                                    .default(Text(settings.language == .english ? "Terms of Use" : "Nutzungsbedingungen"), action: {
                                        if let url = URL(string: "https://sites.google.com/view/hoehere-mathematik-agb/startseite") {
                                            UIApplication.shared.open(url)
                                        }
                                    }),
                                    .default(Text(settings.language == .english ? "Privacy Policy" : "Datenschutzerklärung"), action: {
                                        if let url = URL(string: "https://sites.google.com/view/hoehere-mathematik/startseite") {
                                            UIApplication.shared.open(url)
                                        }
                                    }),
                                    .cancel(Text(settings.language == .english ? "Cancel" : "Abbrechen"))
                                ]
                            )
                        }
                        .font(.footnote)
                        
                        
                    }
                    //.font(.headline)
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
                    
                    
                    
                    
                }

                
            }
        }
        .padding(.horizontal)
        .onAppear {
            selectedProductId = purchaseModel.productIds.last ?? ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.easeIn(duration: allowCloseAfter)) {
                    self.progress = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + allowCloseAfter) {
                    withAnimation {
                        showCloseButton = true
                    }
                }
            }
        }
        .onChange(of: purchaseModel.isSubscribed) { isSubscribed in
            if(isSubscribed) {
                // Show confetti animation first
                showConfetti = true
                
                // Dismiss after confetti animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    isPresented = false
                }
            }
        }
        .onAppear {
            if(purchaseModel.isSubscribed) {
                isPresented = false
            }
        }
        
        
    }
    
    private func startShaking() {
            let totalDuration = 0.7 // Total duration of the shake animation
            let numberOfShakes = 3 // Total number of shakes
            let initialAngle: Double = 10 // Initial rotation angle
            
            withAnimation(.easeInOut(duration: totalDuration / 2)) {
                self.shakeZoom = 0.95
                DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration / 2) {
                    withAnimation(.easeInOut(duration: totalDuration / 2)) {
                        self.shakeZoom = 0.9
                    }
                }
            }

            for i in 0..<numberOfShakes {
                let delay = (totalDuration / Double(numberOfShakes)) * Double(i)
                let angle = initialAngle - (initialAngle / Double(numberOfShakes)) * Double(i)
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(Animation.easeInOut(duration: totalDuration / Double(numberOfShakes * 2))) {
                        self.shakeDegrees = angle
                    }
                    withAnimation(Animation.easeInOut(duration: totalDuration / Double(numberOfShakes * 2)).delay(totalDuration / Double(numberOfShakes * 2))) {
                        self.shakeDegrees = -angle
                    }
                }
            }

            // Stop the shaking and reset to 0
            DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
                withAnimation {
                    self.shakeDegrees = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                    startShaking()
                }
            }
        }
    
    
    struct PurchaseFeatureView: View {
        
        let title: String
        let icon: String
        let color: Color
        
        var body: some View {
            HStack {
                Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 27, height: 27, alignment: .center)
                .clipped()
                .foregroundColor(color)
                Text(title)
            }
        }
    }

    func toLocalCurrencyString(_ value: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        //formatter.locale = locale
        return formatter.string(from: NSNumber(value: value))
    }

}

#Preview {
    PurchaseView(isPresented: .constant(true))
}
