import SwiftUI

struct ContentView: View {
    @State private var magazines: [Magazine] = []
    @State private var selectedCategory: String?
    @State private var searchText = ""
    @State private var showSavedOnly = false
    @AppStorage("savedMagazineIDs") private var savedMagazineIDs = ""

    private let columns = [
        GridItem(.adaptive(minimum: 158), spacing: 14)
    ]

    private var filteredMagazines: [Magazine] {
        magazines.filter { magazine in
            let matchesCategory = selectedCategory == nil || magazine.category == selectedCategory
            let matchesSaved = !showSavedOnly || savedIDs.contains(magazine.id)
            let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

            guard !query.isEmpty else { return matchesCategory && matchesSaved }

            let matchesSearch = [
                magazine.name,
                magazine.readableJapaneseName,
                magazine.localizedCategory,
                magazine.country
            ].contains { $0.localizedCaseInsensitiveContains(query) }

            return matchesCategory && matchesSaved && matchesSearch
        }
    }

    private var categories: [String] {
        Array(Set(magazines.map(\.category))).sorted()
    }

    private var savedIDs: Set<String> {
        Set(savedMagazineIDs.split(separator: ",").map(String.init))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.paper.ignoresSafeArea()

                VStack(spacing: 0) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 18) {
                            header
                            searchField
                            savedToggle
                            categoryFilter

                            if filteredMagazines.isEmpty {
                                emptyState
                            } else {
                                LazyVGrid(columns: columns, spacing: 14) {
                                    ForEach(filteredMagazines) { magazine in
                                        NavigationLink {
                                            MagazineDetailView(magazine: magazine)
                                        } label: {
                                            MagazineCard(magazine: magazine)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 18)
                        .padding(.top, 18)
                        .padding(.bottom, 28)
                    }

                    BannerAdView()
                        .frame(height: 50)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(AppTheme.paper, for: .navigationBar)
        }
        .tint(AppTheme.coral)
        .onAppear(perform: loadMagazines)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("海外のマニアックな雑誌紹介")
                        .font(.system(size: 28, weight: .black, design: .serif))
                        .foregroundStyle(AppTheme.ink)

                    Text("世界の変わった専門誌を、まずは日本語でざっくり発見。")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(AppTheme.mutedInk)
                }

                Spacer()

                Image(systemName: "books.vertical.fill")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(AppTheme.paperLight)
                    .frame(width: 56, height: 56)
                    .background(AppTheme.ink, in: RoundedRectangle(cornerRadius: 8))
            }

            HStack(spacing: 10) {
                StatPill(value: "\(magazines.count)", label: "冊")
                StatPill(value: "\(categories.count)", label: "ジャンル")
                StatPill(value: "検索", label: "導線")
            }
        }
        .padding(18)
        .background(AppTheme.paperLight, in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(AppTheme.ink.opacity(0.12), lineWidth: 1)
        )
    }

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppTheme.mutedInk)

            TextField("雑誌名、ジャンル、国で探す", text: $searchText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(AppTheme.mutedInk)
                }
                .buttonStyle(.plain)
            }
        }
        .font(.subheadline)
        .padding(.horizontal, 14)
        .frame(height: 46)
        .background(AppTheme.paperLight, in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(AppTheme.rule.opacity(0.7), lineWidth: 1)
        )
    }

    private var savedToggle: some View {
        Button {
            showSavedOnly.toggle()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: showSavedOnly ? "bookmark.fill" : "bookmark")
                Text("気になるだけ表示")
                    .font(.subheadline.weight(.bold))
                Spacer()
                Text("\(savedIDs.count)")
                    .font(.caption.weight(.black))
                    .foregroundStyle(showSavedOnly ? AppTheme.paperLight : AppTheme.ink)
                    .frame(minWidth: 28)
                    .padding(.vertical, 5)
                    .background(showSavedOnly ? AppTheme.coral : AppTheme.rule.opacity(0.22), in: Capsule())
            }
            .foregroundStyle(AppTheme.ink)
            .padding(.horizontal, 14)
            .frame(height: 44)
            .background(AppTheme.paperLight, in: RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(showSavedOnly ? AppTheme.coral : AppTheme.rule.opacity(0.7), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(
                    label: "すべて",
                    isSelected: selectedCategory == nil,
                    action: { selectedCategory = nil }
                )

                ForEach(categories, id: \.self) { category in
                    FilterChip(
                        label: Magazine.categoryLabel(for: category),
                        isSelected: selectedCategory == category,
                        action: { selectedCategory = category }
                    )
                }
            }
            .padding(.vertical, 2)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "text.magnifyingglass")
                .font(.system(size: 34))
                .foregroundStyle(AppTheme.mutedInk)
            Text("見つかりませんでした")
                .font(.headline)
                .foregroundStyle(AppTheme.ink)
            Text("検索語を短くするか、別のジャンルを選んでください。")
                .font(.subheadline)
                .foregroundStyle(AppTheme.mutedInk)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }

    private func loadMagazines() {
        let filenames = ["magazines_1000", "magazines"]

        for filename in filenames {
            guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
                continue
            }

            do {
                let data = try Data(contentsOf: url)
                magazines = try JSONDecoder().decode([Magazine].self, from: data)
                return
            } catch {
                print("Error loading \(filename): \(error)")
            }
        }

        print("Warning: Could not load magazine data")
    }
}

private struct StatPill: View {
    let value: String
    let label: String

    var body: some View {
        HStack(spacing: 4) {
            Text(value)
                .font(.caption.weight(.bold))
            Text(label)
                .font(.caption2.weight(.semibold))
        }
        .foregroundStyle(AppTheme.ink)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(AppTheme.rule.opacity(0.22), in: RoundedRectangle(cornerRadius: 6))
    }
}

struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption.weight(.bold))
                .foregroundStyle(isSelected ? AppTheme.paperLight : AppTheme.ink)
                .padding(.horizontal, 13)
                .frame(height: 34)
                .background(isSelected ? AppTheme.ink : AppTheme.paperLight, in: Capsule())
                .overlay(
                    Capsule()
                        .stroke(AppTheme.rule.opacity(isSelected ? 0 : 0.7), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
}
