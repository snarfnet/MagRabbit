import SwiftUI

struct ContentView: View {
    @State private var magazines: [Magazine] = []
    @State private var selectedCategory: String? = nil
    @State private var showInterstitial = false
    @State private var detailInterstitialCounter = 0

    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var filteredMagazines: [Magazine] {
        if let category = selectedCategory {
            return magazines.filter { $0.category == category }
        }
        return magazines
    }

    var categories: [String] {
        let cats = Set(magazines.map { $0.category })
        return Array(cats).sorted()
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Mag Rabbit")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("世界のニッチ雑誌を発見")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text("🐰")
                            .font(.system(size: 40))
                    }
                    .padding()
                    .background(Color(.systemGray6))

                    // Category Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            FilterChip(
                                label: "All",
                                isSelected: selectedCategory == nil,
                                action: { selectedCategory = nil }
                            )

                            ForEach(categories, id: \.self) { category in
                                FilterChip(
                                    label: category,
                                    isSelected: selectedCategory == category,
                                    action: { selectedCategory = category }
                                )
                            }
                        }
                        .padding()
                    }

                    // Magazine Grid
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(filteredMagazines) { magazine in
                                NavigationLink(destination: MagazineDetailView(magazine: magazine)) {
                                    MagazineCard(magazine: magazine)
                                }
                            }
                        }
                        .padding()
                    }

                    // Banner Ad
                    BannerAdView()
                        .frame(height: 50)
                }
            }
            .navigationTitle("Magazines")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            loadMagazines()
        }
    }

    private func loadMagazines() {
        // Try loading 1000-magazine version first, fallback to 20-magazine version
        let filenames = ["magazines_1000", "magazines"]

        for filename in filenames {
            if let url = Bundle.main.url(forResource: filename, withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    magazines = try decoder.decode([Magazine].self, from: data)
                    print("Loaded \(magazines.count) magazines from \(filename).json")
                    return
                } catch {
                    print("Error loading \(filename): \(error)")
                }
            }
        }

        print("Warning: Could not load magazine data")
    }
}

struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(16)
        }
    }
}

#Preview {
    ContentView()
}
