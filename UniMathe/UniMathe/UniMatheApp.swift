//
//  UniMatheApp.swift
//  UniMathe
//
//  Created by Benedikt Held on 24.04.25.
//

import SwiftUI

@main
struct UniMatheApp: App {
    @ObservedObject private var settings = SettingsModel.shared
    @State private var needsRefresh = false
    @State private var showLanguageSelection = false
    
    init() {
        // Track app launch for rating prompt
        settings.trackAppLaunch()
        
        // Check if the language has been selected before
        let hasSelectedLanguage = UserDefaults.standard.bool(forKey: "hasSelectedLanguage")
        _showLanguageSelection = State(initialValue: !hasSelectedLanguage)
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
                
                ContentView()
                    .preferredColorScheme(settings.isDarkModeEnabled ? .dark : .light)
                    .id(settings.language) // Force view recreation when language changes
                
                // Show language selection on first launch
                if showLanguageSelection {
                    LanguageSelectionView(showLanguageSelection: $showLanguageSelection)
                        .transition(.opacity)
                        .zIndex(1) // Ensure it's on top
                }
            }
            .onChange(of: settings.language) { _ in
                // Force view refresh when language changes
                needsRefresh = true
            }
        }
    }
}
