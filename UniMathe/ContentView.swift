import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Text("Lerninhalte")
                .tabItem {
                    Label("Lerninhalte", systemImage: "book.fill")
                }
            
            Text("Statistik")
                .tabItem {
                    Label("Statistik", systemImage: "chart.bar.fill")
                }
            
            Text("Einstellungen")
                .tabItem {
                    Label("Einstellungen", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
} 