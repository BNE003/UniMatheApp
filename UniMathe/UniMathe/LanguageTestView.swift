import SwiftUI

struct LanguageTestView: View {
    @ObservedObject private var settings = SettingsModel.shared
    @State private var debugOutput = ""
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Language Test")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Current Language: \(settings.language.displayName)")
                .font(.headline)
            
            HStack(spacing: 20) {
                Button(action: {
                    settings.language = .german
                    testFileLoading()
                }) {
                    Text("Switch to German")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(minWidth: 150)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    settings.language = .english
                    testFileLoading()
                }) {
                    Text("Switch to English")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(minWidth: 150)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
            }
            
            ScrollView {
                Text(debugOutput)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(8)
            }
            
            Button("Go Back") {
                // This is a placeholder for navigation back
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .padding(.top, 20)
        }
        .padding()
        .onAppear {
            testFileLoading()
        }
    }
    
    private func testFileLoading() {
        isLoading = true
        
        DispatchQueue.main.async {
            debugOutput = "Current language: \(settings.language.rawValue)\n\n"
            
            // Test a selection of files
            testLoadFile(basename: "matrizen", topicTitle: "Matrices")
            testLoadFile(basename: "vektorraeume", topicTitle: "Vector Spaces")
            testLoadFile(basename: "eigenwerte", topicTitle: "Eigenvalues")
            testLoadFile(basename: "determinanten", topicTitle: "Determinants")
            testLoadFile(basename: "lineare_abbildungen", topicTitle: "Linear Mappings")
            
            isLoading = false
        }
    }
    
    private func testLoadFile(basename: String, topicTitle: String) {
        let language = settings.language
        let langFolder = language == .english ? "en" : "de"
        let localizedFileName = language == .english ? basename + "_en" : basename
        
        debugOutput += "Testing \(topicTitle):\n"
        debugOutput += "Looking for file: \(localizedFileName).json in folder aufgaben/\(langFolder)\n"
        
        // Same loading logic as our updated ExercisesView
        var fileURL: URL?
        
        // Try with language-specific filename in language subfolder
        if let url = Bundle.main.url(forResource: localizedFileName, withExtension: "json", subdirectory: "aufgaben/\(langFolder)") {
            debugOutput += "✅ Found file with language suffix in language folder\n"
            fileURL = url
        }
        // Try with base filename in language subfolder
        else if let url = Bundle.main.url(forResource: basename, withExtension: "json", subdirectory: "aufgaben/\(langFolder)") {
            debugOutput += "⚠️ Found base filename in language folder\n"
            fileURL = url
        }
        // Try in the root aufgaben folder with language suffix
        else if let url = Bundle.main.url(forResource: localizedFileName, withExtension: "json", subdirectory: "aufgaben") {
            debugOutput += "⚠️ Found file with language suffix in root aufgaben folder\n"
            fileURL = url
        }
        // Try in the root aufgaben folder with base filename
        else if let url = Bundle.main.url(forResource: basename, withExtension: "json", subdirectory: "aufgaben") {
            debugOutput += "⚠️ Found base filename in root aufgaben folder\n"
            fileURL = url
        }
        // Try in the root bundle
        else {
            debugOutput += "❌ File not found in any location\n"
        }
        
        if let foundURL = fileURL {
            do {
                let data = try Data(contentsOf: foundURL)
                let response = try JSONDecoder().decode(ExercisesResponse.self, from: data)
                debugOutput += "✅ Successfully loaded \(response.exercises.count) exercises\n"
                if let firstExercise = response.exercises.first {
                    debugOutput += "First exercise: \(firstExercise.title)\n"
                }
            } catch {
                debugOutput += "❌ Error decoding file: \(error.localizedDescription)\n"
            }
        }
        
        debugOutput += "\n"
    }
} 