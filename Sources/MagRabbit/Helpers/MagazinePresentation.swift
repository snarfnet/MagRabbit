import SwiftUI

enum AppTheme {
    static let paper = Color(red: 0.97, green: 0.94, blue: 0.88)
    static let paperLight = Color(red: 1.00, green: 0.98, blue: 0.93)
    static let ink = Color(red: 0.11, green: 0.10, blue: 0.09)
    static let mutedInk = Color(red: 0.38, green: 0.35, blue: 0.31)
    static let rule = Color(red: 0.79, green: 0.72, blue: 0.62)
    static let coral = Color(red: 0.82, green: 0.27, blue: 0.20)
    static let moss = Color(red: 0.32, green: 0.42, blue: 0.31)
    static let brass = Color(red: 0.70, green: 0.50, blue: 0.24)
    static let cyan = Color(red: 0.16, green: 0.56, blue: 0.65)
}

extension Magazine {
    var accentColor: Color {
        Color(hex: color) ?? AppTheme.coral
    }

    var readableJapaneseName: String {
        nameJa.isReadableJapanese ? nameJa : localizedTitle
    }

    var readableJapaneseDescription: String {
        descriptionJa.isReadableJapanese ? descriptionJa : generatedJapaneseNote
    }

    var localizedCategory: String {
        Self.categoryNames[category] ?? category
    }

    static func categoryLabel(for category: String) -> String {
        categoryNames[category] ?? category
    }

    var categorySymbol: String {
        Self.categorySymbols[category] ?? "magazine"
    }

    var frequencyLabel: String {
        Self.frequencyNames[frequency.lowercased()] ?? frequency.capitalized
    }

    var priceLabel: String {
        price.lowercased() == "free" ? "無料" : "有料"
    }

    var safeTags: [String] {
        tags
            .filter { $0.isReadableJapanese || $0.range(of: "^[A-Za-z0-9 &+-]+$", options: .regularExpression) != nil }
            .prefix(5)
            .map { String($0) }
    }

    private var localizedTitle: String {
        "\(name) 日本語ガイド"
    }

    var discoveryNote: String {
        "\(country) 発の \(localizedCategory) 系インディペンデント誌。公式サイトや最新号を探す前に、雰囲気と基本情報をざっと掴めます。"
    }

    private var generatedJapaneseNote: String {
        "\(name) は、\(localizedCategory)を深く追う海外のニッチな雑誌です。ここでは本文の日本語化ではなく、雑誌のテーマ、刊行頻度、入手のしやすさを日本語メモとして整理しています。"
    }

    private static let categoryNames: [String: String] = [
        "Animals": "動物",
        "Food": "食",
        "DIY": "手仕事",
        "Tech": "技術",
        "Nature": "自然",
        "Culture": "文化",
        "History": "歴史",
        "Hobby": "趣味",
        "Travel": "旅",
        "Craft": "クラフト",
        "Plants": "植物",
        "Literary": "文芸",
        "Machines": "機械",
        "Weird": "不思議",
        "Sports": "スポーツ",
        "Science": "科学"
    ]

    private static let categorySymbols: [String: String] = [
        "Animals": "pawprint.fill",
        "Food": "fork.knife",
        "DIY": "hammer.fill",
        "Tech": "cpu.fill",
        "Nature": "leaf.fill",
        "Culture": "theatermasks.fill",
        "History": "building.columns.fill",
        "Hobby": "sparkles",
        "Travel": "map.fill",
        "Craft": "paintpalette.fill",
        "Plants": "camera.macro",
        "Literary": "text.book.closed.fill",
        "Machines": "gearshape.2.fill",
        "Weird": "questionmark.diamond.fill",
        "Sports": "figure.run",
        "Science": "atom"
    ]

    private static let frequencyNames: [String: String] = [
        "weekly": "週刊",
        "biweekly": "隔週",
        "monthly": "月刊",
        "bimonthly": "隔月",
        "quarterly": "季刊",
        "biannually": "年2回"
    ]
}

extension String {
    var isReadableJapanese: Bool {
        let hasJapanese = range(of: #"[\p{Hiragana}\p{Katakana}\p{Han}]"#, options: .regularExpression) != nil
        let mojibakeSignals = ["繝", "縺", "荳", "譁", "隱", "螟", "蜷", "髯", "", "笞"]
        let looksBroken = mojibakeSignals.contains { contains($0) }
        return hasJapanese && !looksBroken
    }
}

struct TagWrapLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 320
        var rows: [CGFloat] = [0]
        var currentX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > width, currentX > 0 {
                rows.append(size.height)
                currentX = size.width + spacing
            } else {
                rows[rows.count - 1] = max(rows.last ?? 0, size.height)
                currentX += size.width + spacing
            }
        }

        let height = rows.reduce(0, +) + CGFloat(max(rows.count - 1, 0)) * spacing
        return CGSize(width: width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }

            subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
