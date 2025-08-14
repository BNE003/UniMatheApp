import SwiftUI
import PostHog

// ObservableObject to manage tab bar visibility
class TabBarViewModel: ObservableObject {
    @Binding var isHidden: Bool
    
    init(isHidden: Binding<Bool>) {
        self._isHidden = isHidden
    }
    
    func hideTabBar() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isHidden = true
        }
    }
    
    func showTabBar() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isHidden = false
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var isTabBarHidden = false
    @ObservedObject private var settings = SettingsModel.shared
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab Content
            Group {
                switch selectedTab {
                case 0:
                    ContentView()
                        .environmentObject(TabBarViewModel(isHidden: $isTabBarHidden))
                case 1:
                    ÜbungsklausurenView()
                        .environmentObject(TabBarViewModel(isHidden: $isTabBarHidden))
                case 2:
                    NavigationView {
                        SettingsView()
                    }
                default:
                    ContentView()
                        .environmentObject(TabBarViewModel(isHidden: $isTabBarHidden))
                }
            }
            .animation(.easeInOut(duration: 0.4), value: selectedTab)
            
            // Custom Tab Bar with animation
            CustomTabBar(selectedTab: $selectedTab)
                .offset(y: isTabBarHidden ? 200 : 0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isTabBarHidden)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            PostHogSDK.shared.capture("app_opened", properties: [
                "language": settings.language.rawValue
            ])
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @ObservedObject private var settings = SettingsModel.shared
    @Namespace private var tabSelection
    
    private func getTabName(_ index: Int) -> String {
        switch index {
        case 0: return "home"
        case 1: return "exams"
        case 2: return "settings"
        default: return "unknown"
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let tabWidth = geometry.size.width / 3
            
            ZStack {
                // Modern glass background
                RoundedRectangle(cornerRadius: 28)
                    .fill(.ultraThinMaterial)
                    .background(
                        RoundedRectangle(cornerRadius: 28)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.1),
                                        Color.gray.opacity(0.05)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.2),
                                        Color.clear
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // Selection indicator with glass effect
                RoundedRectangle(cornerRadius: 22)
                    .fill(.regularMaterial)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.blue.opacity(0.4),
                                        Color(red: 0.1, green: 0.3, blue: 0.7).opacity(0.3)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .frame(width: tabWidth - 16, height: 48)
                    .offset(x: CGFloat(selectedTab) * tabWidth - geometry.size.width / 2 + tabWidth / 2)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.1), value: selectedTab)
                
                HStack(spacing: 0) {
                    // Home Tab
                    TabBarItem(
                        icon: "house.fill",
                        title: settings.language == .english ? "Home" : "Start",
                        isSelected: selectedTab == 0,
                        action: { 
                            PostHogSDK.shared.capture("tab_switched", properties: [
                                "from_tab": getTabName(selectedTab),
                                "to_tab": "home",
                                "language": settings.language.rawValue
                            ])
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { 
                                selectedTab = 0 
                            } 
                        }
                    )
                    .frame(width: tabWidth)
                    
                    // Practice Exams Tab
                    TabBarItem(
                        icon: "doc.text.magnifyingglass",
                        title: settings.language == .english ? "Exams" : "Klausuren",
                        isSelected: selectedTab == 1,
                        action: { 
                            PostHogSDK.shared.capture("tab_switched", properties: [
                                "from_tab": getTabName(selectedTab),
                                "to_tab": "exams",
                                "language": settings.language.rawValue
                            ])
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { 
                                selectedTab = 1 
                            } 
                        }
                    )
                    .frame(width: tabWidth)
                    
                    // Settings Tab
                    TabBarItem(
                        icon: "gearshape.fill",
                        title: settings.language == .english ? "Settings" : "Einstellungen",
                        isSelected: selectedTab == 2,
                        action: { 
                            PostHogSDK.shared.capture("tab_switched", properties: [
                                "from_tab": getTabName(selectedTab),
                                "to_tab": "settings",
                                "language": settings.language.rawValue
                            ])
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { 
                                selectedTab = 2 
                            } 
                        }
                    )
                    .frame(width: tabWidth)
                }
            }
        }
        .frame(height: 76)
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
    }
}

struct TabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: isSelected ? 22 : 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(
                        isSelected ? 
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.blue,
                                Color(red: 0.1, green: 0.3, blue: 0.7)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            gradient: Gradient(colors: [
                                colorScheme == .dark ? Color.white.opacity(0.7) : Color.black.opacity(0.7),
                                colorScheme == .dark ? Color.white.opacity(0.7) : Color.black.opacity(0.7)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
                
                Text(title)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(
                        isSelected ? 
                        (colorScheme == .dark ? .white : .black) :
                        (colorScheme == .dark ? Color.white.opacity(0.7) : Color.black.opacity(0.6))
                    )
                    .scaleEffect(isSelected ? 1.0 : 0.95)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
        .contentShape(Rectangle())
    }
}

#Preview {
    MainTabView()
} 