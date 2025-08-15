# Tab Bar System - Komplett neu aufgebaut

## Übersicht

Das Tab Bar System wurde komplett neu aufgebaut und stark vereinfacht. Die Tab Bar wird nur in der Hauptansicht angezeigt und bei Klausur-Ansichten automatisch versteckt.

## Neue Architektur

### TabBarManager (Singleton)
Extrem einfacher Manager mit nur zwei Methoden:

```swift
class TabBarManager: ObservableObject {
    static let shared = TabBarManager()
    @Published var isVisible = true
    
    func hide() { ... }  // Tab Bar verstecken
    func show() { ... }  // Tab Bar anzeigen
}
```

### MainTabView
Die Hauptansicht zeigt die Tab Bar nur bedingt an:

```swift
struct MainTabView: View {
    @ObservedObject private var tabBarManager = TabBarManager.shared
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab Content
            
            // Tab Bar - nur anzeigen wenn sichtbar
            if tabBarManager.isVisible {
                CustomTabBar(selectedTab: $selectedTab)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}
```

## Verwendung

### Klausur-Ansichten (Tab Bar verstecken)
```swift
struct ExamDetailView: View {
    @ObservedObject private var tabBarManager = TabBarManager.shared
    
    var body: some View {
        // Klausur-Inhalt
        .onAppear {
            tabBarManager.hide()  // Tab Bar verstecken
        }
        .onDisappear {
            tabBarManager.show() // Tab Bar wieder anzeigen
        }
    }
}
```

### Hauptansichten (Tab Bar anzeigen)
```swift
struct ÜbungsklausurenView: View {
    @ObservedObject private var tabBarManager = TabBarManager.shared
    
    var body: some View {
        // Klausur-Übersicht
        .onAppear {
            tabBarManager.show() // Tab Bar anzeigen
        }
    }
}
```

## Implementierte Views

### Tab Bar wird VERSTECKT:
- `ExamDetailView` - **Klausur-Detailansicht (Hauptziel)**
- `InteractiveLearningView` - Interaktive Lernansicht
- `TopicDetailView` - Detailansicht eines Themas
- `ExerciseDetailView` - Einzelne Übung
- `SubTopicsView` - Unterthemen-Ansicht
- `ContentSelectionView` - Inhaltsauswahl

### Tab Bar wird ANGEZEIGT:
- `MainTabView` - Beim App-Start
- `ÜbungsklausurenView` - Klausur-Übersicht (Teil der Hauptansicht)

## Vorteile des neuen Systems

1. **Extrem einfach**: Nur 2 Methoden (`hide()` und `show()`)
2. **Zielgerichtet**: Erfüllt genau die Anforderung - Tab Bar nur in Hauptansicht
3. **Automatisch**: Tab Bar verschwindet bei Klausur-Ansichten
4. **Performant**: Minimaler Code-Overhead
5. **Wartbar**: Sehr wenig Code, einfach zu verstehen
6. **Zuverlässig**: Klare Regeln ohne Komplexität

## Migration vom alten System

Das komplexe alte System wurde durch das einfache neue System ersetzt:

### Vorher (komplex):
```swift
@EnvironmentObject private var tabBarViewModel: TabBarViewModel

.onAppear {
    tabBarViewModel.hideTabBar()
}
.onDisappear {
    tabBarViewModel.showTabBar()
}
```

### Nachher (einfach):
```swift
@ObservedObject private var tabBarManager = TabBarManager.shared

.onAppear {
    tabBarManager.hide()
}
.onDisappear {
    tabBarManager.show()
}
```

## Technische Details

- **Animation**: Einfache `easeInOut` Animation (0.3s)
- **State Management**: Ein einziger `@Published var isVisible: Bool`
- **Memory Management**: Singleton Pattern
- **UI Updates**: Automatisch durch SwiftUI's `@ObservedObject`

Das neue System ist viel einfacher und erfüllt perfekt die Anforderung: **Tab Bar nur in der Hauptansicht, versteckt bei Klausur-Ansichten**.