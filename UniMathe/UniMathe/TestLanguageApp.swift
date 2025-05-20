import SwiftUI

struct TestLanguageApp: View {
    @ObservedObject private var settings = SettingsModel.shared
    @State private var debugOutput = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Current Language: \(settings.language.rawValue)")
                .font(.headline)
            
            HStack(spacing: 20) {
                Button("Set to German") {
                    settings.language = .german
                    testFileLoading()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Set to English") {
                    settings.language = .english
                    testFileLoading()
                }
                .buttonStyle(.borderedProminent)
            }
            
            Button("Test File Loading") {
                testFileLoading()
            }
            .buttonStyle(.bordered)
            
            ScrollView {
                Text(debugOutput)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(8)
            }
            .frame(height: 400)
            
            Spacer()
        }
        .padding()
        .onAppear {
            testFileLoading()
        }
    }
    
    private func testFileLoading() {
        debugOutput = "Current language: \(settings.language.rawValue)\n\n"
        
        // Test matrix file
        testLoadFile(basename: "matrizen", topicTitle: "Matrices")
        
        // Test vector spaces file
        testLoadFile(basename: "vektorraeume", topicTitle: "Vector Spaces")
        
        // Test eigenvalues file
        testLoadFile(basename: "eigenwerte", topicTitle: "Eigenvalues")
        
        // Test determinants file
        testLoadFile(basename: "determinanten", topicTitle: "Determinants")
        
        // Test linear mappings file
        testLoadFile(basename: "lineare_abbildungen", topicTitle: "Linear Mappings")
    }
    
    private func testLoadFile(basename: String, topicTitle: String) {
        let language = settings.language
        let langFolder = language == .english ? "en" : "de"
        let localizedFileName = language == .english ? basename + "_en" : basename
        
        debugOutput += "Testing \(topicTitle):\n"
        debugOutput += "Looking for file: \(localizedFileName).json in folder aufgaben/\(langFolder)\n"
        
        if let fileURL = Bundle.main.url(forResource: localizedFileName, withExtension: "json", subdirectory: "aufgaben/\(langFolder)") {
            debugOutput += "✅ Found file at \(fileURL.path)\n"
            
            do {
                let data = try Data(contentsOf: fileURL)
                let response = try JSONDecoder().decode(ExercisesResponse.self, from: data)
                debugOutput += "✅ Successfully loaded \(response.exercises.count) exercises\n"
                debugOutput += "First exercise title: \(response.exercises.first?.title ?? "None")\n"
            } catch {
                debugOutput += "❌ Error loading file: \(error)\n"
            }
        } else {
            debugOutput += "❌ File not found\n"
            
            // Try fallback
            if let fallbackURL = Bundle.main.url(forResource: basename, withExtension: "json", subdirectory: "aufgaben") {
                debugOutput += "⚠️ Found fallback file at \(fallbackURL.path)\n"
            } else {
                debugOutput += "❌ No fallback file found\n"
            }
        }
        
        debugOutput += "\n"
    }
}

struct TestLanguageApp_Previews: PreviewProvider {
    static var previews: some View {
        TestLanguageApp()
    }
} 