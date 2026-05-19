import SwiftUI

struct MagazineCard: View {
    let magazine: Magazine

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            cover
            metadata
        }
        .background(AppTheme.paperLight)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(AppTheme.ink.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: AppTheme.ink.opacity(0.08), radius: 10, x: 0, y: 6)
    }

    private var cover: some View {
        ZStack(alignment: .topLeading) {
            magazine.accentColor

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(magazine.countryLabel.uppercased())
                        .font(.system(size: 10, weight: .black, design: .monospaced))
                    Spacer()
                    Text(magazine.frequencyLabel)
                        .font(.system(size: 10, weight: .black, design: .monospaced))
                }
                .foregroundStyle(.white.opacity(0.86))

                Rectangle()
                    .fill(.white.opacity(0.72))
                    .frame(height: 2)
                    .padding(.vertical, 12)

                Text(magazine.name)
                    .font(.system(size: 24, weight: .black, design: .serif))
                    .foregroundStyle(.white)
                    .lineLimit(3)
                    .minimumScaleFactor(0.72)

                Spacer()

                HStack(alignment: .bottom) {
                    Image(systemName: magazine.categorySymbol)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white.opacity(0.92))

                    Spacer()

                    Text(magazine.localizedCategory)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.ink)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(AppTheme.paperLight, in: RoundedRectangle(cornerRadius: 5))
                }
            }
            .padding(13)

            VStack(spacing: 5) {
                ForEach(0..<4, id: \.self) { _ in
                    Circle()
                        .fill(.white.opacity(0.22))
                        .frame(width: 4, height: 4)
                }
            }
            .padding(.leading, 7)
            .padding(.top, 58)
        }
        .aspectRatio(0.78, contentMode: .fit)
    }

    private var metadata: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(magazine.readableJapaneseName)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(AppTheme.ink)
                .lineLimit(2)

            HStack(spacing: 6) {
                Label(magazine.priceLabel, systemImage: magazine.price.lowercased() == "free" ? "gift.fill" : "magnifyingglass")
                Text("・")
                Text(magazine.frequencyLabel)
            }
            .font(.caption2.weight(.semibold))
            .foregroundStyle(AppTheme.mutedInk)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    MagazineCard(magazine: Magazine(
        id: "test",
        name: "Ferret Fancy",
        nameJa: "フェレット愛好家向け",
        description: "A niche magazine about ferret care.",
        descriptionJa: "フェレットの飼育や文化を扱う海外誌。",
        category: "Animals",
        country: "USA",
        emoji: "",
        color: "#D4A574",
        websiteUrl: "https://example.com",
        frequency: "monthly",
        price: "paid",
        publisher: "Small Press",
        tags: ["animals", "ferret"]
    ))
    .padding()
}
