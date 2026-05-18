import SwiftUI

struct MagazineDetailView: View {
    let magazine: Magazine
    @Environment(\.openURL) var openURL
    @State private var showEnglish = false
    @State private var showInterstitial = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                VStack(spacing: 12) {
                    Text(magazine.emoji)
                        .font(.system(size: 64))

                    VStack(spacing: 4) {
                        Text(magazine.name)
                            .font(.title2)
                            .fontWeight(.bold)

                        Text(magazine.nameJa)
                            .font(.headline)
                            .foregroundColor(.gray)
                    }

                    HStack(spacing: 8) {
                        Badge(text: magazine.category, color: .blue)
                        Badge(text: magazine.country, color: .green)
                        Badge(text: magazine.frequency.capitalized, color: .orange)
                        if magazine.price == "free" {
                            Badge(text: "Free", color: .purple)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(hex: magazine.color) ?? Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)

                // Japanese Description (Main)
                VStack(alignment: .leading, spacing: 8) {
                    Text("説明")
                        .font(.headline)
                        .fontWeight(.semibold)

                    Text(magazine.descriptionJa)
                        .font(.body)
                        .lineSpacing(6)
                        .foregroundColor(.black)
                }
                .padding()

                // English Description (Expandable)
                DisclosureGroup("English Description") {
                    Text(magazine.description)
                        .font(.body)
                        .lineSpacing(6)
                        .padding()
                }
                .padding(.horizontal)

                // Tags
                if !magazine.tags.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("タグ")
                            .font(.headline)
                            .fontWeight(.semibold)

                        FlowLayout(spacing: 8) {
                            ForEach(magazine.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(4)
                            }
                        }
                    }
                    .padding()
                }

                // Website Button
                Link(destination: URL(string: magazine.websiteUrl) ?? URL(fileURLWithPath: "")) {
                    HStack {
                        Image(systemName: "globe")
                        Text("公式サイトを見る")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()

                Spacer()
                    .frame(height: 20)
            }
        }
        .navigationTitle(magazine.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct Badge: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.3))
            .foregroundColor(color)
            .cornerRadius(4)
    }
}

struct FlowLayout<Content: View>: View {
    let content: () -> Content
    var spacing: CGFloat = 8

    @State private var totalHeight = CGFloat.zero

    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    init(spacing: CGFloat = 8, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }
}

#Preview {
    NavigationStack {
        MagazineDetailView(magazine: Magazine(
            id: "test",
            name: "Test Magazine",
            nameJa: "テスト雑誌",
            description: "This is a test magazine for testing purposes.",
            descriptionJa: "これはテスト目的のテスト雑誌です。",
            category: "Test",
            country: "USA",
            emoji: "📚",
            color: "#FF6B6B",
            websiteUrl: "https://example.com",
            frequency: "monthly",
            price: "paid",
            tags: ["test", "demo"]
        ))
    }
}
