//
//  UniMatheApp.swift
//  UniMathe
//
//  Created by Benedikt Held on 24.04.25.
//

import SwiftUI

@main
struct UniMatheApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject private var settings = SettingsModel.shared
    @StateObject private var onboardingManager = OnboardingManager()
    @State private var needsRefresh = false
    
    init() {
        // Track app launch for rating prompt
        settings.trackAppLaunch()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // This is a hack to force view refresh when changing language
                if needsRefresh {
                    Color.clear.onAppear {
                        needsRefresh = false
                    }
                }
                
                if onboardingManager.showOnboarding {
                    // Show beautiful onboarding flow for new users
                    OnboardingCoordinator()
                        .environmentObject(onboardingManager)
                        .preferredColorScheme(settings.isDarkModeEnabled ? .dark : .light)
                        .transition(.opacity.combined(with: .scale(scale: 1.02)))
                        .animation(.easeInOut(duration: 0.5), value: onboardingManager.showOnboarding)
                } else {
                    // Show main app after onboarding is complete
                    MainTabView()
                        .preferredColorScheme(settings.isDarkModeEnabled ? .dark : .light)
                        .id(settings.language) // Force view recreation when language changes
                        .transition(.opacity.combined(with: .scale(scale: 0.98)))
                        .animation(.easeInOut(duration: 0.5), value: onboardingManager.showOnboarding)
                }
            }
            .onChange(of: settings.language) { _ in
                // Force view refresh when language changes
                needsRefresh = true
            }
        }
    }
}
