import SwiftUI

struct MagazineDetailView: View {
    let magazine: Magazine

    @Environment(\.openURL) private var openURL
    @AppStorage("savedMagazineIDs") private var savedMagazineIDs = ""

    private var isSaved: Bool {
        savedIDs.contains(magazine.id)
    }

    private var savedIDs: Set<String> {
        Set(savedMagazineIDs.split(separator: ",").map(String.init))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                hero
                quickFacts
                noteSection
                originalSection
                tagSection
                websiteButton
            }
            .padding(18)
            .padding(.bottom, 22)
        }
        .background(AppTheme.paper.ignoresSafeArea())
        .navigationTitle(magazine.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: toggleSaved) {
                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                }
                .accessibilityLabel(isSaved ? "保存を解除" : "気になるに保存")
            }
        }
        .tint(AppTheme.coral)
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(magazine.localizedCategory)
                        .font(.caption.weight(.black))
                        .foregroundStyle(AppTheme.paperLight)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 5)
                        .background(AppTheme.ink.opacity(0.82), in: RoundedRectangle(cornerRadius: 5))

                    Text(magazine.name)
                        .font(.system(size: 38, weight: .black, design: .serif))
                        .foregroundStyle(.white)
                        .lineLimit(3)
                        .minimumScaleFactor(0.62)
                }

                Spacer()

                Image(systemName: magazine.categorySymbol)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.white.opacity(0.9))
            }

            Rectangle()
                .fill(.white.opacity(0.7))
                .frame(height: 2)

            Text(magazine.readableJapaneseName)
                .font(.title3.weight(.bold))
                .foregroundStyle(.white.opacity(0.92))
                .lineLimit(2)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(magazine.accentColor, in: RoundedRectangle(cornerRadius: 8))
        .overlay(alignment: .bottomTrailing) {
            Text(magazine.country.uppercased())
                .font(.system(size: 44, weight: .black, design: .serif))
                .foregroundStyle(.white.opacity(0.12))
                .padding(.trailing, 14)
                .padding(.bottom, 8)
        }
    }

    private var quickFacts: some View {
        HStack(spacing: 10) {
            FactBox(title: "国", value: magazine.country, icon: "globe.asia.australia.fill")
            FactBox(title: "刊行", value: magazine.frequencyLabel, icon: "calendar")
            FactBox(title: "価格", value: magazine.priceLabel, icon: magazine.price.lowercased() == "free" ? "gift.fill" : "tag.fill")
        }
    }

    private var noteSection: some View {
        DetailSection(title: "読む前のメモ", icon: "note.text") {
            VStack(alignment: .leading, spacing: 12) {
                Text(magazine.discoveryNote)
                    .font(.body)
                    .lineSpacing(5)
                    .foregroundStyle(AppTheme.ink)

                Text(magazine.readableJapaneseDescription)
                    .font(.callout)
                    .lineSpacing(5)
                    .foregroundStyle(AppTheme.mutedInk)
            }
        }
    }

    private var originalSection: some View {
        DetailSection(title: "原文の短い説明", icon: "text.quote") {
            Text(magazine.description)
                .font(.callout)
                .lineSpacing(5)
                .foregroundStyle(AppTheme.mutedInk)
        }
    }

    @ViewBuilder
    private var tagSection: some View {
        let tags = magazine.safeTags.isEmpty ? [magazine.localizedCategory, magazine.country, magazine.frequencyLabel] : magazine.safeTags

        DetailSection(title: "手がかり", icon: "number") {
            TagWrapLayout(spacing: 8) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.ink)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(AppTheme.rule.opacity(0.22), in: RoundedRectangle(cornerRadius: 5))
                }
            }
        }
    }

    private var websiteButton: some View {
        Button {
            guard let url = URL(string: magazine.websiteUrl) else { return }
            openURL(url)
        } label: {
            HStack {
                Image(systemName: "safari.fill")
                Text("公式サイトで確認")
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: "arrow.up.right")
            }
            .padding()
            .foregroundStyle(AppTheme.paperLight)
            .background(AppTheme.ink, in: RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }

    private func toggleSaved() {
        var ids = savedIDs

        if ids.contains(magazine.id) {
            ids.remove(magazine.id)
        } else {
            ids.insert(magazine.id)
        }

        savedMagazineIDs = ids.sorted().joined(separator: ",")
    }
}

private struct FactBox: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundStyle(AppTheme.coral)
            Text(title)
                .font(.caption2.weight(.bold))
                .foregroundStyle(AppTheme.mutedInk)
            Text(value)
                .font(.caption.weight(.black))
                .foregroundStyle(AppTheme.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.paperLight, in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(AppTheme.ink.opacity(0.1), lineWidth: 1)
        )
    }
}

private struct DetailSection<Content: View>: View {
    let title: String
    let icon: String
    let content: Content

    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundStyle(AppTheme.brass)
                Text(title)
                    .font(.headline.weight(.black))
                    .foregroundStyle(AppTheme.ink)
            }

            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.paperLight, in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(AppTheme.ink.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        MagazineDetailView(magazine: Magazine(
            id: "test",
            name: "Ferret Fancy",
            nameJa: "フェレット愛好家向け",
            description: "A niche magazine covering ferret care, breeding, and community culture.",
            descriptionJa: "フェレットの飼育や文化を扱う海外誌。",
            category: "Animals",
            country: "USA",
            emoji: "",
            color: "#D4A574",
            websiteUrl: "https://example.com",
            frequency: "monthly",
            price: "paid",
            tags: ["animals", "ferret"]
        ))
    }
}
