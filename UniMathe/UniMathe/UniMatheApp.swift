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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(settings.isDarkModeEnabled ? .dark : .light)
        }
    }
}
