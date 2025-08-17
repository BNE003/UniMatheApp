import SwiftUI

struct MainTabView: View {
    @ObservedObject private var settings = SettingsModel.shared
    @ObservedObject private var tabBarManager = TabBarManager.shared
    
    init() {
        setupTabBarAppearance()
    }
    
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Image(systemName: "house.circle.fill")
                    Text(settings.language == .english ? "Home" : "Start")
                }
                .tag(0)
            
            ÜbungsklausurenView()
                .tabItem {
                    Image(systemName: "doc.text.below.ecg")
                    Text(settings.language == .english ? "Exams" : "Klausuren")
                }
                .tag(1)
            
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gear.circle.fill")
                Text(settings.language == .english ? "Settings" : "Einstellungen")
            }
            .tag(2)
        }
        .toolbar(tabBarManager.isVisible ? .visible : .hidden, for: .tabBar)
        .onAppear {
            print("📱 MainTabView: Appeared with native TabView")
        }
    }
    
    private func setupTabBarAppearance() {
        // Modern glassmorphism TabBar styling
        let tabBarAppearance = UITabBarAppearance()
        
        // Configure translucent background for glassmorphism effect
        tabBarAppearance.configureWithTransparentBackground()
        
        // Modern glass background
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        tabBarAppearance.backgroundEffect = blurEffect
        
        // Subtle border on top
        tabBarAppearance.shadowColor = UIColor.systemGray5.withAlphaComponent(0.3)
        
        // Normal state styling with modern colors
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.systemGray2
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.systemGray2,
            .font: UIFont.systemFont(ofSize: 11, weight: .medium)
        ]
        
        // Selected state with vibrant gradient-like color
        let selectedColor = UIColor.systemBlue
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: selectedColor,
            .font: UIFont.systemFont(ofSize: 11, weight: .bold)
        ]
        
        // Apply to all tab bar states
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        // Modern accent colors
        UITabBar.appearance().tintColor = UIColor.systemBlue
        UITabBar.appearance().unselectedItemTintColor = UIColor.systemGray2
        
        // Add subtle background tint
        UITabBar.appearance().backgroundColor = UIColor.systemBackground.withAlphaComponent(0.1)
    }
}

#Preview {
    MainTabView()
} 