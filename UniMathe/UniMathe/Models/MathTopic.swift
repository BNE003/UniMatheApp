import Foundation

struct MathTopic: Identifiable, Codable {
    let id: String
    let title: String
    let icon: String
    let description: String
    var subTopics: [MathTopic]?
    var markdownContent: String?
    
    // CodingKeys to match JSON structure
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case icon
        case description
        case subTopics
        case markdownContent
    }
    
    // Custom init from decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        icon = try container.decode(String.self, forKey: .icon)
        description = try container.decode(String.self, forKey: .description)
        subTopics = try container.decodeIfPresent([MathTopic].self, forKey: .subTopics)
        markdownContent = try container.decodeIfPresent(String.self, forKey: .markdownContent)
    }
    
    // Custom encode method
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(icon, forKey: .icon)
        try container.encode(description, forKey: .description)
        try container.encodeIfPresent(subTopics, forKey: .subTopics)
        try container.encodeIfPresent(markdownContent, forKey: .markdownContent)
    }
    
    // Custom initializer
    init(id: String, title: String, icon: String, description: String, subTopics: [MathTopic]? = nil, markdownContent: String? = nil) {
        self.id = id
        self.title = title
        self.icon = icon
        self.description = description
        self.subTopics = subTopics
        self.markdownContent = markdownContent
    }
}

struct MathTopicsResponse: Codable {
    let topics: [MathTopic]
    
    enum CodingKeys: String, CodingKey {
        case topics
    }
} 