import Foundation

struct IndexResponse: Codable {
    let topics: [TopicIndex]
}

struct TopicIndex: Codable, Identifiable {
    let id: String
    let title: String
    let filename: String
    let subTopics: [SubTopicIndex]?
}

struct SubTopicIndex: Codable, Identifiable {
    let id: String
    let title: String
    let filename: String
}
