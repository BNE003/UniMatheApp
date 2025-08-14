# PostHog Analytics Events - UniMathe App

Diese Dokumentation bietet eine umfassende Übersicht über alle PostHog Analytics Events, die in der UniMathe App implementiert wurden.

## App Lifecycle Events

### `app_launched`
**Beschreibung:** Wird ausgelöst, wenn die App gestartet wird
**Eigenschaften:**
- `platform`: "iOS"
- `app_version`: App-Version aus Bundle

### `app_opened`
**Beschreibung:** Wird ausgelöst, wenn die Haupt-App-Oberfläche erscheint
**Eigenschaften:**
- `language`: Aktuelle Sprache der App

## Navigation Events

### `tab_switched`
**Beschreibung:** Wird ausgelöst, wenn zwischen Tabs gewechselt wird
**Eigenschaften:**
- `from_tab`: Vorheriger Tab ("home", "exams", "settings")
- `to_tab`: Neuer Tab ("home", "exams", "settings")
- `language`: Aktuelle Sprache der App

### `home_view_appeared`
**Beschreibung:** Wird ausgelöst, wenn die Home-View erscheint
**Eigenschaften:**
- `language`: Aktuelle Sprache der App

### `subtopics_view_appeared`
**Beschreibung:** Wird ausgelöst, wenn die Unterthemen-View erscheint
**Eigenschaften:**
- `parent_topic_title`: Titel des übergeordneten Themas
- `parent_topic_id`: ID des übergeordneten Themas
- `language`: Aktuelle Sprache der App

### `settings_view_appeared`
**Beschreibung:** Wird ausgelöst, wenn die Einstellungen-View erscheint
**Eigenschaften:**
- `language`: Aktuelle Sprache der App

### `exams_view_appeared`
**Beschreibung:** Wird ausgelöst, wenn die Klausuren-View erscheint
**Eigenschaften:**
- `language`: Aktuelle Sprache der App

## Content Interaction Events

### `topic_selected`
**Beschreibung:** Wird ausgelöst, wenn ein Hauptthema ausgewählt wird
**Eigenschaften:**
- `topic_title`: Titel des ausgewählten Themas
- `topic_id`: ID des ausgewählten Themas
- `has_subtopics`: Boolean, ob das Thema Unterthemen hat
- `language`: Aktuelle Sprache der App

### `subtopic_selected`
**Beschreibung:** Wird ausgelöst, wenn ein Unterthema ausgewählt wird
**Eigenschaften:**
- `parent_topic_title`: Titel des übergeordneten Themas
- `subtopic_title`: Titel des ausgewählten Unterthemas
- `subtopic_id`: ID des ausgewählten Unterthemas
- `language`: Aktuelle Sprache der App

## Exercise & Exam Events

### `exercise_difficulty_selected`
**Beschreibung:** Wird ausgelöst, wenn ein Schwierigkeitsgrad für Übungen ausgewählt wird
**Eigenschaften:**
- `topic_title`: Titel des Themas
- `topic_id`: ID des Themas
- `difficulty`: Ausgewählter Schwierigkeitsgrad ("easy", "medium", "hard")
- `language`: Aktuelle Sprache der App

### `exam_difficulty_selected`
**Beschreibung:** Wird ausgelöst, wenn ein Schwierigkeitsgrad für Klausuren ausgewählt wird
**Eigenschaften:**
- `difficulty`: Ausgewählter Schwierigkeitsgrad
- `language`: Aktuelle Sprache der App

### `exam_started`
**Beschreibung:** Wird ausgelöst, wenn eine Klausur gestartet wird
**Eigenschaften:**
- `exam_title`: Titel der Klausur
- `exam_difficulty`: Schwierigkeitsgrad der Klausur
- `exam_duration`: Dauer der Klausur in Minuten
- `exam_questions`: Anzahl der Fragen
- `language`: Aktuelle Sprache der App

## Settings & Configuration Events

### `language_changed`
**Beschreibung:** Wird ausgelöst, wenn die Sprache geändert wird
**Eigenschaften:**
- `from_language`: Vorherige Sprache
- `to_language`: Neue Sprache

### `pro_purchase_initiated`
**Beschreibung:** Wird ausgelöst, wenn der Pro-Kauf gestartet wird
**Eigenschaften:**
- `source`: Quelle des Kaufs ("settings")
- `language`: Aktuelle Sprache der App

### `support_contacted`
**Beschreibung:** Wird ausgelöst, wenn der Support kontaktiert wird
**Eigenschaften:**
- `method`: Kontaktmethode ("in_app_mail", "external_mail")
- `language`: Aktuelle Sprache der App

### `feedback_opened`
**Beschreibung:** Wird ausgelöst, wenn das Feedback-Portal geöffnet wird
**Eigenschaften:**
- `language`: Aktuelle Sprache der App

### `app_rating_requested`
**Beschreibung:** Wird ausgelöst, wenn eine App-Bewertung angefordert wird
**Eigenschaften:**
- `language`: Aktuelle Sprache der App

## Onboarding Events

### `onboarding_screen_advanced`
**Beschreibung:** Wird ausgelöst, wenn zum nächsten Onboarding-Screen gewechselt wird
**Eigenschaften:**
- `from_screen`: Vorheriger Screen-Titel
- `to_screen`: Neuer Screen-Titel
- `language`: Aktuelle Sprache der App

### `onboarding_completed`
**Beschreibung:** Wird ausgelöst, wenn das Onboarding abgeschlossen wird
**Eigenschaften:**
- `language`: Aktuelle Sprache der App

## Implementierungshinweise

1. **PostHog Import**: Alle relevanten Dateien importieren jetzt `PostHog`
2. **Event-Benennung**: Events verwenden snake_case Namenskonvention
3. **Eigenschafts-Konsistenz**: Gemeinsame Eigenschaften sind konsistent benannt
4. **Sprach-Tracking**: Die meisten Events tracken die aktuelle App-Sprache
5. **Automatische Events**: PostHog ist konfiguriert, um automatisch App-Lifecycle und Screen-View Events zu erfassen

## Konfiguration

PostHog ist in `AppDelegate.swift` konfiguriert mit:
- `captureApplicationLifecycleEvents = true`
- `captureScreenViews = true`
- API Key und Host für EU-Region

## Beispiel-Verwendung

### Tracking von Benutzer-Lernfortschritt
```swift
PostHogSDK.shared.capture("exercise_started", properties: [
    "topic_title": exercise.title,
    "exercise_difficulty": exercise.difficulty,
    "language": settings.language.rawValue
])
```

### Tracking von Navigation
```swift
PostHogSDK.shared.capture("tab_switched", properties: [
    "from_tab": "home",
    "to_tab": "exams",
    "language": settings.language.rawValue
])
```

### Tracking von Fehlern
```swift
PostHogSDK.shared.capture("content_loading_error", properties: [
    "error_type": "index_file_not_found",
    "language": language.rawValue,
    "topic_id": topic.id
])
```