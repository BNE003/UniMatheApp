import SwiftUI

struct LearningPlanView: View {
    @ObservedObject private var settings = SettingsModel.shared
    @ObservedObject private var planManager = LearningPlanManager.shared

    @State private var topics: [MathTopic] = []
    @State private var isLoading = true
    @State private var error: Error?

    @State private var selectedTopicIDs: Set<String> = []
    @State private var includeExercises = true
    @State private var includeExams = true
    @State private var includeSteps = true
    @State private var searchText = ""
    @State private var isEditingPlan = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.96, green: 0.98, blue: 1.0),
                        Color(red: 0.94, green: 0.97, blue: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                if isLoading {
                    VStack {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text(settings.language == .english ? "Loading..." : "Wird geladen...")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                    }
                } else if let error = error {
                    VStack {
                        Text(settings.language == .english ? "Error loading data" : "Fehler beim Laden der Daten")
                            .font(.headline)
                            .foregroundColor(.red)
                        Text(error.localizedDescription)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            headerCard
                            planOverviewCard
                            if isEditingPlan || planManager.plan == nil {
                                optionsCard
                                topicsCard
                                createPlanButton
                                    .opacity(0)
                                    .frame(height: 0)
                            } else {
                                planItemsCard
                            }
                        }
                        .padding(16)
                        .padding(.bottom, isEditingPlan || planManager.plan == nil ? 80 : 0)
                    }
                    if isEditingPlan || planManager.plan == nil {
                        VStack {
                            Spacer()
                            createPlanButton
                                .padding(.horizontal, 16)
                                .padding(.bottom, 12)
                        }
                    }
                }
            }
            .navigationTitle(settings.language == .english ? "Learning Plan" : "Lernplan")
            .toolbar {
                if planManager.plan != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { isEditingPlan.toggle() }) {
                            Text(settings.language == .english ? (isEditingPlan ? "Done" : "Edit") : (isEditingPlan ? "Fertig" : "Bearbeiten"))
                                .font(.subheadline.weight(.semibold))
                        }
                    }
                }
            }
            .onAppear {
                loadTopics()
                hydrateFromPlan()
                isEditingPlan = planManager.plan == nil
            }
            .onChange(of: isEditingPlan) { editing in
                if editing {
                    hydrateFromPlan()
                }
            }
            .onChange(of: settings.language) { _ in
                loadTopics()
                hydrateFromPlan()
            }
        }
    }

    private var headerCard: some View {
        PlanCard {
            VStack(alignment: .leading, spacing: 8) {
                Text(settings.language == .english ? "Create your personal learning plan" : "Erstelle deinen individuellen Lernplan")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                Text(settings.language == .english ? "Choose topics and include exercises, exams, and step-by-step explanations." : "Wähle Themen und ergänze Übungen, Klausuren und Schritt-für-Schritt-Erklärungen.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var optionsCard: some View {
        PlanCard {
            VStack(alignment: .leading, spacing: 12) {
                Text(settings.language == .english ? "Options" : "Optionen")
                    .font(.headline)

                Toggle(isOn: $includeExercises) {
                    Text(settings.language == .english ? "Include exercises" : "Übungen einschließen")
                }

                Toggle(isOn: $includeSteps) {
                    Text(settings.language == .english ? "Include step-by-step explanations" : "Schritt-für-Schritt-Erklärungen einschließen")
                }

                Toggle(isOn: $includeExams) {
                    Text(settings.language == .english ? "Include exams" : "Klausuren einschließen")
                }
            }
            .tint(.blue)
        }
    }

    private var topicsCard: some View {
        PlanCard {
            VStack(alignment: .leading, spacing: 12) {
                Text(settings.language == .english ? "Topics" : "Themen")
                    .font(.headline)

                TextField(settings.language == .english ? "Search topics" : "Themen suchen", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                ForEach(filteredTopics) { topic in
                    TopicSelectionRow(
                        title: topic.title,
                        subtitle: topic.description,
                        isSelected: selectedTopicIDs.contains(topic.id)
                    )
                    .onTapGesture {
                        toggleTopic(topic.id)
                    }
                }
            }
        }
    }

    private var createPlanButton: some View {
        Button(action: createPlan) {
            Text(settings.language == .english ? "Create / Update Plan" : "Plan erstellen / aktualisieren")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(14)
                .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
        }
    }

    private var planOverviewCard: some View {
        PlanCard {
            VStack(alignment: .leading, spacing: 8) {
                Text(settings.language == .english ? "Progress" : "Fortschritt")
                    .font(.headline)

                let progress = planManager.progress
                let total = max(progress.total, 1)
                let ratio = CGFloat(progress.completed) / CGFloat(total)

                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 10)

                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                        .frame(width: ratio * UIScreen.main.bounds.width * 0.7, height: 10)
                }

                Text(settings.language == .english ?
                     "\(progress.completed) of \(progress.total) completed" :
                     "\(progress.completed) von \(progress.total) abgeschlossen")
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
        }
    }

    private var planItemsCard: some View {
        PlanCard {
            VStack(alignment: .leading, spacing: 12) {
                Text(settings.language == .english ? "Your Plan" : "Dein Plan")
                    .font(.headline)

                if let plan = planManager.plan, !plan.items.isEmpty {
                    let currentIndex = planManager.firstIncompleteIndex()
                    ForEach(Array(plan.items.enumerated()), id: \.element.id) { index, item in
                        let isLocked = currentIndex != nil && index > (currentIndex ?? 0)
                        let isCurrent = currentIndex == index
                        PlanItemRow(item: item, settings: settings, isLocked: isLocked, isCurrent: isCurrent) {
                            if !isLocked {
                                planManager.toggleCompletion(itemID: item.id)
                            }
                        }
                    }
                } else {
                    Text(settings.language == .english ? "No plan created yet." : "Noch kein Plan erstellt.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    private var filteredTopics: [MathTopic] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return selectableTopics
        }
        let term = searchText.lowercased()
        return selectableTopics.filter { $0.title.lowercased().contains(term) || $0.description.lowercased().contains(term) }
    }

    private var selectableTopics: [MathTopic] {
        leafTopics(from: topics)
    }

    private func leafTopics(from topics: [MathTopic]) -> [MathTopic] {
        var result: [MathTopic] = []
        for topic in topics {
            if let sub = topic.subTopics, !sub.isEmpty {
                result.append(contentsOf: leafTopics(from: sub))
            } else {
                result.append(topic)
            }
        }
        return result
    }

    private func toggleTopic(_ id: String) {
        if selectedTopicIDs.contains(id) {
            selectedTopicIDs.remove(id)
        } else {
            selectedTopicIDs.insert(id)
        }
    }

    private func createPlan() {
        planManager.generatePlan(
            topics: topics,
            selectedTopicIDs: selectedTopicIDs,
            includeExercises: includeExercises,
            includeExams: includeExams,
            includeSteps: includeSteps
        )
        isEditingPlan = false
    }

    private func hydrateFromPlan() {
        guard let plan = planManager.plan else { return }
        selectedTopicIDs = Set(plan.selectedTopicIDs)
        includeExercises = plan.includeExercises
        includeExams = plan.includeExams
        includeSteps = plan.includeSteps
    }

    private func loadTopics() {
        let language = settings.language
        let languageSuffix = language == .english ? "_en" : ""
        let indexName = "index" + languageSuffix
        var indexUrl: URL?

        if let url = Bundle.main.url(forResource: indexName, withExtension: "json") {
            indexUrl = url
        } else if let url = Bundle.main.url(forResource: "index", withExtension: "json") {
            indexUrl = url
        } else if let url = Bundle.main.url(forResource: indexName, withExtension: "json", subdirectory: "lerninhalt") {
            indexUrl = url
        } else if let url = Bundle.main.url(forResource: "index", withExtension: "json", subdirectory: "lerninhalt") {
            indexUrl = url
        } else if let url = Bundle.main.url(forResource: indexName, withExtension: "json", subdirectory: "lerninhalt/\(language.rawValue)") {
            indexUrl = url
        } else if let url = Bundle.main.url(forResource: "index", withExtension: "json", subdirectory: "lerninhalt/\(language.rawValue)") {
            indexUrl = url
        } else {
            let errorMessage = language == .english ?
                "Index file not found in bundle" :
                "Index-Datei nicht im Bundle gefunden"
            error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            isLoading = false
            return
        }

        do {
            let indexData = try Data(contentsOf: indexUrl!)
            let indexResponse = try JSONDecoder().decode(IndexResponse.self, from: indexData)
            var loadedTopics: [MathTopic] = []

            for topicIndex in indexResponse.topics {
                let filenameWithoutExtension = topicIndex.filename.replacingOccurrences(of: ".json", with: "")
                let localizedFilename = filenameWithoutExtension + languageSuffix
                let topicUrl: URL?

                if let url = Bundle.main.url(forResource: localizedFilename, withExtension: "json") {
                    topicUrl = url
                } else if let url = Bundle.main.url(forResource: filenameWithoutExtension, withExtension: "json") {
                    topicUrl = url
                } else if let url = Bundle.main.url(forResource: localizedFilename, withExtension: "json", subdirectory: "lerninhalt") {
                    topicUrl = url
                } else if let url = Bundle.main.url(forResource: filenameWithoutExtension, withExtension: "json", subdirectory: "lerninhalt") {
                    topicUrl = url
                } else if let url = Bundle.main.url(forResource: localizedFilename, withExtension: "json", subdirectory: "lerninhalt/\(language.rawValue)") {
                    topicUrl = url
                } else if let url = Bundle.main.url(forResource: filenameWithoutExtension, withExtension: "json", subdirectory: "lerninhalt/\(language.rawValue)") {
                    topicUrl = url
                } else {
                    continue
                }

                do {
                    let topicData = try Data(contentsOf: topicUrl!)
                    let topic = try JSONDecoder().decode(MathTopic.self, from: topicData)
                    loadedTopics.append(topic)
                } catch {
                    continue
                }
            }

            topics = loadedTopics
            LearningPlanTopicCache.shared.update(with: selectableTopics)
            planManager.rebuildPlanIfNeeded(topics: topics)
            hydrateFromPlan()
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
}

private struct PlanCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white.opacity(0.85))
                    .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.blue.opacity(0.08), lineWidth: 1)
            )
    }
}

private struct TopicSelectionRow: View {
    let title: String
    let subtitle: String
    let isSelected: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? .blue : .gray)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 6)
    }
}

private struct PlanItemRow: View {
    let item: LearningPlanItem
    let settings: SettingsModel
    let isLocked: Bool
    let isCurrent: Bool
    let toggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: toggle) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.isCompleted ? .green : (isLocked ? .gray.opacity(0.4) : .gray))
                    .font(.system(size: 20))
            }
            .disabled(isLocked)

            VStack(alignment: .leading, spacing: 4) {
                Text(itemTitle)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                if let subtitle = itemSubtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                if isCurrent {
                    Text(settings.language == .english ? "Current step" : "Aktueller Schritt")
                        .font(.caption2)
                        .foregroundColor(.blue)
                }
            }

            Spacer()

            if isLocked {
                Image(systemName: "lock.fill")
                    .foregroundColor(.gray.opacity(0.6))
            } else {
                NavigationLink(destination: destinationView) {
                    Image(systemName: "arrow.up.right.square")
                        .foregroundColor(.blue)
                }
            }
        }
        .opacity(isLocked ? 0.6 : 1.0)
    }

    private var itemTitle: String {
        if item.type == .exercises {
            return settings.language == .english ? "Exercise" : "Übung"
        }
        if let topicTitle = item.topicTitle, !topicTitle.isEmpty {
            return topicTitle
        }
        return settings.language == .english ? "Practice exams" : "Klausuren"
    }

    private var itemSubtitle: String? {
        switch item.type {
        case .content:
            return settings.language == .english ? "Learning content" : "Lerninhalte"
        case .exercises:
            return item.topicTitle
        case .steps:
            return settings.language == .english ? "Step-by-step explanation" : "Schritt-für-Schritt-Erklärung"
        case .exams:
            return settings.language == .english ? "Practice exams" : "Klausuren"
        }
    }

    @ViewBuilder
    private var destinationView: some View {
        switch item.type {
        case .content:
            if let topic = resolveTopic() {
                TopicDetailView(topic: topic)
            } else {
                MissingTopicView()
            }
        case .steps:
            if let topic = resolveTopic() {
                InteractiveLearningView(topic: topic)
            } else {
                MissingTopicView()
            }
        case .exercises:
            if let topic = resolveTopic() {
                ExercisesView(topic: topic)
            } else {
                MissingTopicView()
            }
        case .exams:
            ÜbungsklausurenView()
        }
    }

    private func resolveTopic() -> MathTopic? {
        guard let topicID = item.topicID else { return nil }
        if let cached = LearningPlanTopicCache.shared.topic(for: topicID) {
            return cached
        }
        if let title = item.topicTitle {
            return MathTopic(
                id: topicID,
                title: title,
                icon: "book.fill",
                description: ""
            )
        }
        return nil
    }
}

private struct MissingTopicView: View {
    @ObservedObject private var settings = SettingsModel.shared

    var body: some View {
        VStack(spacing: 12) {
            Text(settings.language == .english ? "Topic not found" : "Thema nicht gefunden")
                .font(.headline)
                .foregroundColor(.red)
            Text(settings.language == .english ? "Please reopen the learning plan." : "Bitte den Lernplan neu öffnen.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

private final class LearningPlanTopicCache {
    static let shared = LearningPlanTopicCache()
    private var topics: [String: MathTopic] = [:]

    func update(with topics: [MathTopic]) {
        for topic in topics {
            self.topics[topic.id] = topic
        }
    }

    func topic(for id: String) -> MathTopic? {
        topics[id]
    }
}

#Preview {
    LearningPlanView()
}
