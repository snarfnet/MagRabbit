import Foundation

struct Magazine: Identifiable, Codable {
    let id: String
    let name: String
    let nameJa: String
    let description: String
    let descriptionJa: String
    let category: String
    let country: String
    let emoji: String
    let color: String
    let websiteUrl: String
    let frequency: String
    let price: String
    let tags: [String]
}
