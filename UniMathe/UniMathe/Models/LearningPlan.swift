import Foundation
import Combine

struct LearningPlanItem: Identifiable, Codable {
    let id: String
    let type: LearningPlanItemType
    let topicID: String?
    let topicTitle: String?
    var isCompleted: Bool
}

enum LearningPlanItemType: String, Codable {
    case content
    case exercises
    case steps
    case exams
}

struct LearningPlan: Codable {
    let id: String
    let createdAt: Date
    let selectedTopicIDs: [String]
    let includeExercises: Bool
    let includeExams: Bool
    let includeSteps: Bool
    var items: [LearningPlanItem]
}

final class LearningPlanManager: ObservableObject {
    static let shared = LearningPlanManager()

    @Published var plan: LearningPlan? {
        didSet { save() }
    }

    private let storageKey = "learningPlan.v1"

    private init() {
        load()
    }

    var progress: (completed: Int, total: Int) {
        guard let plan = plan else { return (0, 0) }
        let completed = plan.items.filter { $0.isCompleted }.count
        return (completed, plan.items.count)
    }

    func firstIncompleteIndex() -> Int? {
        guard let plan = plan else { return nil }
        return plan.items.firstIndex(where: { !$0.isCompleted })
    }

    func generatePlan(
        topics: [MathTopic],
        selectedTopicIDs: Set<String>,
        includeExercises: Bool,
        includeExams: Bool,
        includeSteps: Bool
    ) {
        let orderedTopics = expandSelectedTopics(topics: topics, selectedTopicIDs: selectedTopicIDs)
        let selectedIDs = orderedTopics.map { $0.id }
        let items = buildItems(
            orderedTopics: orderedTopics,
            includeExercises: includeExercises,
            includeExams: includeExams,
            includeSteps: includeSteps,
            existingItems: []
        )
        let newPlan = LearningPlan(
            id: UUID().uuidString,
            createdAt: Date(),
            selectedTopicIDs: selectedIDs,
            includeExercises: includeExercises,
            includeExams: includeExams,
            includeSteps: includeSteps,
            items: items
        )

        plan = newPlan
    }

    func rebuildPlanIfNeeded(topics: [MathTopic]) {
        guard let current = plan else { return }
        let orderedTopics = expandSelectedTopics(topics: topics, selectedTopicIDs: Set(current.selectedTopicIDs))
        let items = buildItems(
            orderedTopics: orderedTopics,
            includeExercises: current.includeExercises,
            includeExams: current.includeExams,
            includeSteps: current.includeSteps,
            existingItems: current.items
        )

        if items.count != current.items.count ||
            zip(items, current.items).contains(where: { $0.type != $1.type || $0.topicID != $1.topicID }) {
            let updated = LearningPlan(
                id: current.id,
                createdAt: current.createdAt,
                selectedTopicIDs: orderedTopics.map { $0.id },
                includeExercises: current.includeExercises,
                includeExams: current.includeExams,
                includeSteps: current.includeSteps,
                items: items
            )
            plan = updated
        }
    }

    private func buildItems(
        orderedTopics: [MathTopic],
        includeExercises: Bool,
        includeExams: Bool,
        includeSteps: Bool,
        existingItems: [LearningPlanItem]
    ) -> [LearningPlanItem] {
        var items: [LearningPlanItem] = []

        for topic in orderedTopics {
            if includeSteps {
                items.append(makeItem(
                    type: .steps,
                    topic: topic,
                    existingItems: existingItems
                ))
            }

            if includeExercises {
                items.append(makeItem(
                    type: .exercises,
                    topic: topic,
                    existingItems: existingItems
                ))
            }
        }

        if includeExams {
            let existingExam = existingItems.first(where: { $0.type == .exams })
            items.append(LearningPlanItem(
                id: existingExam?.id ?? UUID().uuidString,
                type: .exams,
                topicID: nil,
                topicTitle: nil,
                isCompleted: existingExam?.isCompleted ?? false
            ))
        }

        return items
    }

    private func makeItem(type: LearningPlanItemType, topic: MathTopic, existingItems: [LearningPlanItem]) -> LearningPlanItem {
        let existing = existingItems.first(where: { $0.type == type && $0.topicID == topic.id }) ??
            existingItems.first(where: { $0.type == type && $0.topicTitle == topic.title })

        return LearningPlanItem(
            id: existing?.id ?? UUID().uuidString,
            type: type,
            topicID: topic.id,
            topicTitle: topic.title,
            isCompleted: existing?.isCompleted ?? false
        )
    }

    private func expandSelectedTopics(topics: [MathTopic], selectedTopicIDs: Set<String>) -> [MathTopic] {
        var result: [MathTopic] = []

        for topic in topics {
            if selectedTopicIDs.contains(topic.id) {
                if let subTopics = topic.subTopics, !subTopics.isEmpty {
                    result.append(contentsOf: leafTopics(from: subTopics))
                } else {
                    result.append(topic)
                }
            } else if let subTopics = topic.subTopics, !subTopics.isEmpty {
                result.append(contentsOf: expandSelectedTopics(topics: subTopics, selectedTopicIDs: selectedTopicIDs))
            }
        }

        return result
    }

    private func leafTopics(from topics: [MathTopic]) -> [MathTopic] {
        var result: [MathTopic] = []
        for topic in topics {
            if let subTopics = topic.subTopics, !subTopics.isEmpty {
                result.append(contentsOf: leafTopics(from: subTopics))
            } else {
                result.append(topic)
            }
        }
        return result
    }

    func toggleCompletion(itemID: String) {
        guard var current = plan else { return }
        if let index = current.items.firstIndex(where: { $0.id == itemID }) {
            current.items[index].isCompleted.toggle()
            plan = current
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        if let decoded = try? JSONDecoder().decode(LearningPlan.self, from: data) {
            plan = decoded
        }
    }

    private func save() {
        guard let plan = plan else {
            UserDefaults.standard.removeObject(forKey: storageKey)
            return
        }
        if let data = try? JSONEncoder().encode(plan) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}
