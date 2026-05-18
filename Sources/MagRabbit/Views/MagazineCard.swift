import SwiftUI

struct MagazineCard: View {
    let magazine: Magazine

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background Color
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: magazine.color) ?? Color.blue)
                .opacity(0.9)

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(magazine.emoji)
                            .font(.system(size: 32))

                        Text(magazine.name)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .lineLimit(2)

                        Text(magazine.nameJa)
                            .font(.caption2)
                            .foregroundColor(.white)
                            .opacity(0.8)
                            .lineLimit(1)
                    }
                    Spacer()
                }

                Spacer()

                HStack(spacing: 4) {
                    Text(magazine.category)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.white.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(4)

                    Text(magazine.country)
                        .font(.caption2)
                        .foregroundColor(.white)
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .aspectRatio(1, contentMode: .fill)
    }
}

#Preview {
    MagazineCard(magazine: Magazine(
        id: "test",
        name: "Test Magazine",
        nameJa: "テスト雑誌",
        description: "Test description",
        descriptionJa: "テスト説明",
        category: "Test",
        country: "USA",
        emoji: "📚",
        color: "#FF6B6B",
        websiteUrl: "https://example.com",
        frequency: "monthly",
        price: "paid",
        tags: ["test"]
    ))
    .padding()
}
