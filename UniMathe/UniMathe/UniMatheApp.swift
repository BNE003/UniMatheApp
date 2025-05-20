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
                
                ContentView()
                    .preferredColorScheme(settings.isDarkModeEnabled ? .dark : .light)
                    .id(settings.language) // Force view recreation when language changes
            }
            .onChange(of: settings.language) { _ in
                // Force view refresh when language changes
                needsRefresh = true
            }
        }
    }
}
