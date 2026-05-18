#!/usr/bin/env python3
"""
Mag Rabbit - 1000 Niche Magazines Generator
ニッチ雑誌 1000 誌の JSON データを自動生成
"""

import json
import hashlib
from typing import List, Dict

# ニッチ雑誌のカテゴリと例
MAGAZINE_DATA = {
    "Animals": [
        ("Ferret Fancy", "フェレット愛好家向け", "🦡", "#D4A574"),
        ("Pigeon Racing Digest", "ハト飼育・レース専門", "🕊️", "#A9A9A9"),
        ("Koi Fish World", "錦鯉養殖ガイド", "🐠", "#FF8C00"),
        ("Exotic Pet Journal", "珍しいペット飼育", "🦎", "#6B8E23"),
        ("Rabbit Care Monthly", "ウサギ飼育専門", "🐰", "#D2B48C"),
        ("Aquatic Life Quarterly", "水生生物研究", "🐙", "#4682B4"),
        ("Avian Wonders", "野鳥観察ガイド", "🦅", "#8B4513"),
        ("Reptile Keeper's Guide", "爬虫類飼育", "🐍", "#556B2F"),
        ("Insect Collector", "昆虫採集・飼育", "🦗", "#DAA520"),
        ("Amphibian Species", "両生類研究誌", "🐸", "#228B22"),
    ],
    "Food": [
        ("Fermentation Today", "発酵食品・醸造", "🍶", "#8B4513"),
        ("Cheese Artisan", "チーズ製造ガイド", "🧀", "#FFD700"),
        ("Sourdough Bakers", "サワー種パン焼き", "🍞", "#CD853F"),
        ("Molecular Gastronomy", "分子料理実験", "⚗️", "#4B0082"),
        ("Coffee Roasting Handbook", "コーヒー焙煎専門", "☕", "#6F4E37"),
        ("Mushroom Cultivation", "キノコ栽培ガイド", "🍄", "#808080"),
        ("Vinegar Making", "酢製造・醸造", "🍯", "#A0522D"),
        ("Tea Tasting Guide", "茶葉品評ガイド", "🫖", "#90EE90"),
        ("Spice Harvesting", "スパイス栽培・製造", "🌶️", "#FF4500"),
        ("Honey Production", "蜂蜜製造専門", "🍯", "#FFD700"),
    ],
    "DIY": [
        ("Primitive Archer", "弓矢製作・狩猟", "🏹", "#8B6F47"),
        ("Woodworking Craft", "木工細工ガイド", "🪵", "#654321"),
        ("Blacksmith's Forge", "鍛冶・金属加工", "🔨", "#696969"),
        ("Leathercraft Today", "レザークラフト", "🧥", "#8B4513"),
        ("Pottery Wheel", "陶芸・磁器製作", "🏺", "#CD5C5C"),
        ("Glass Blowing Art", "ガラス吹きガラス芸術", "🔥", "#FF6347"),
        ("Jewelry Making", "ジュエリー制作", "💎", "#FFD700"),
        ("Bookbinding Guide", "本の製本・修復", "📚", "#8B7355"),
        ("Candle Making", "ろうそく製造ガイド", "🕯️", "#FFFACD"),
        ("Soap Crafting", "石けん製造ガイド", "🧼", "#E6E6FA"),
    ],
    "Tech": [
        ("Hackaday", "オープンハードウェア", "🔧", "#FF6B35"),
        ("Arduino Projects", "Arduino プロジェクト", "⚙️", "#2E8B57"),
        ("Raspberry Pi Maker", "ラズパイ DIY", "🫐", "#C41E3A"),
        ("3D Printing Guide", "3D プリント技術", "🖨️", "#4169E1"),
        ("Retro Computing", "レトロコンピュータ", "💻", "#2F4F4F"),
        ("Electronics Workshop", "電子工作ガイド", "🔌", "#FF8C00"),
        ("CNC Machining", "CNC 機械加工", "🔩", "#708090"),
        ("Robotics Builder", "ロボット製作", "🤖", "#FFB6C1"),
        ("Drone Technology", "ドローン技術・操縦", "🛸", "#87CEEB"),
        ("Open Source Software", "オープンソース", "🖥️", "#191970"),
    ],
    "Nature": [
        ("Beekeeping Today", "養蜂専門", "🐝", "#FFD700"),
        ("Rock & Gem", "鉱物・宝石収集", "💎", "#8B008B"),
        ("Plant Science", "植物学・ボタニカル", "🌿", "#228B22"),
        ("Herbarium", "薬草・民間療法", "🌱", "#556B2F"),
        ("Mushroom Guide", "きのこ図鑑・採取", "🍄", "#696969"),
        ("Forest Ecology", "森林生態系研究", "🌲", "#228B22"),
        ("Lichen Study", "地衣類・コケ研究", "🌾", "#808000"),
        ("Wildflower Identification", "野生花同定ガイド", "🌻", "#FFD700"),
        ("Soil Science", "土壌学・地質学", "🪨", "#8B4513"),
        ("Butterfly Watching", "蝶の観察・採集", "🦋", "#FF69B4"),
    ],
    "Culture": [
        ("Delayed Gratification", "スロージャーナリズム", "📖", "#2C3E50"),
        ("The Gentlewoman", "女性文化・ファッション", "👗", "#B8A8D8"),
        ("Kinfolk", "スローライフ・北欧", "🏡", "#E8D4C0"),
        ("Literary Quarterly", "文学・エッセイ", "✒️", "#2F4F4F"),
        ("Art & Design", "アート・デザイン誌", "🎨", "#FF1493"),
        ("Architecture Today", "建築・都市計画", "🏛️", "#DAA520"),
        ("Photography Journal", "写真芸術専門", "📷", "#696969"),
        ("Theatre Arts", "舞台芸術・演劇", "🎭", "#8B008B"),
        ("Dance Culture", "ダンス・身体表現", "💃", "#FF1493"),
        ("Music Theory", "音楽理論・作曲", "🎵", "#4169E1"),
    ],
    "History": [
        ("Weapons & Warfare", "軍事史・兵器", "⚔️", "#5A4A42"),
        ("Ancient Civilizations", "古代文明研究", "🏺", "#CD853F"),
        ("Medieval Studies", "中世歴史研究", "🛡️", "#696969"),
        ("Industrial History", "産業史・遺産", "🏭", "#708090"),
        ("Maritime History", "海事史・船舶", "⛵", "#4682B4"),
        ("Railway Heritage", "鉄道史・遺産", "🚂", "#8B4513"),
        ("Archaeology Digest", "考古学・発掘", "🔨", "#A0522D"),
        ("Numismatic Journal", "貨幣・紙幣収集", "🪙", "#FFD700"),
        ("Philatelic Review", "切手収集ガイド", "🪧", "#DC143C"),
        ("Genealogy Today", "系図・家系図研究", "👨‍👩‍👧‍👦", "#8B4513"),
    ],
    "Hobby": [
        ("Model Railroader", "鉄道模型・レイアウト", "🚂", "#556B2F"),
        ("Scale Model Builder", "スケールモデル製作", "✈️", "#4682B4"),
        ("Miniature Painter", "ミニチュア塗装ガイド", "🎨", "#FF69B4"),
        ("Diorama Crafting", "ジオラマ製作", "🏞️", "#8FBC8F"),
        ("Board Game Design", "ボードゲーム設計", "🎲", "#FF4500"),
        ("Collectible Cards", "トレーディングカード", "🃏", "#FFD700"),
        ("Action Figure Customs", "アクションフィギュア", "🤖", "#DC143C"),
        ("Toy Restoration", "おもちゃ修復ガイド", "🧸", "#FF1493"),
        ("Model Aircraft", "模型飛行機・ドローン", "✈️", "#87CEEB"),
        ("Slot Car Racing", "スロットカーレース", "🏎️", "#FF0000"),
    ],
    "Travel": [
        ("Cereal Magazine", "ノスタルジック旅行", "✈️", "#F4A460"),
        ("Backpacker's Handbook", "バックパック旅行", "🎒", "#8B4513"),
        ("Train Journey Guide", "鉄道旅行ガイド", "🚂", "#DC143C"),
        ("Motorcycle Routes", "バイク旅行・ツーリング", "🏍️", "#FF4500"),
        ("Camping & Hiking", "キャンプ・登山", "⛺", "#556B2F"),
        ("Cruise Travel", "クルーズ・船旅", "🛢️", "#4682B4"),
        ("Caravan Living", "キャラバン・モーターホーム", "🚐", "#DAA520"),
        ("Urban Exploration", "廃墟探険・都市探検", "🏚️", "#696969"),
        ("Photography Travels", "写真旅行ガイド", "📷", "#696969"),
        ("Road Trip Planning", "ロードトリップ計画", "🗺️", "#FF6347"),
    ],
    "Craft": [
        ("Crochet Today", "かぎ針編み専門", "🧶", "#FF1493"),
        ("Knitting Patterns", "編み物パターン集", "🧵", "#9932CC"),
        ("Quilting Arts", "キルト製作ガイド", "🧵", "#FF69B4"),
        ("Sewing Techniques", "縫製・洋裁ガイド", "👔", "#DC143C"),
        ("Embroidery Design", "刺繍デザイン集", "🪡", "#FF1493"),
        ("Macrame Workshop", "マクラメ編み", "🧣", "#DAA520"),
        ("Lace Making", "レース製作・編み", "👰", "#FFFACD"),
        ("Weaving Guide", "機織り・布織り", "🪡", "#8B4513"),
        ("Tatting Lace", "タッティングレース", "💍", "#FFD700"),
        ("Fiber Arts", "繊維芸術・布アート", "🎨", "#FF1493"),
    ],
    "Plants": [
        ("Herbarium", "薬草・植物学", "🌿", "#228B22"),
        ("Bonsai Master", "盆栽栽培・手入れ", "🌳", "#556B2F"),
        ("Orchid Cultivation", "蘭栽培・交配", "🌺", "#FF1493"),
        ("Succulent Plants", "多肉植物・サボテン", "🌵", "#FF8C00"),
        ("Vegetable Gardening", "野菜・家庭菜園", "🥕", "#228B22"),
        ("Carnivorous Plants", "食虫植物栽培", "🪴", "#2F4F4F"),
        ("Hydroponic Farming", "水耕栽培ガイド", "💧", "#4169E1"),
        ("Rose Gardening", "バラ栽培・育成", "🌹", "#FF1493"),
        ("Herb Growing", "ハーブ栽培・利用", "🌿", "#228B22"),
        ("Fern Cultivation", "シダ植物栽培", "🌿", "#556B2F"),
    ],
    "Literary": [
        ("The Moth", "ストーリーテリング", "🦋", "#654321"),
        ("Poetry Quarterly", "詩集・詩作ガイド", "✒️", "#2F4F4F"),
        ("Short Story Review", "短編小説評論", "📖", "#8B4513"),
        ("Sci-Fi Classics", "SF・ファンタジー", "🚀", "#191970"),
        ("Mystery Writers", "ミステリー・推理", "🔍", "#2F4F4F"),
        ("Fantasy Worlds", "ファンタジー世界観", "🐉", "#4169E1"),
        ("Horror Anthology", "ホラー・恐怖小説", "👻", "#2F4F4F"),
        ("Manga Review", "漫画評論・紹介", "📚", "#FF1493"),
        ("Comic Art Journal", "コミックアート", "🎨", "#FFD700"),
        ("Storytelling Guild", "物語創作ワークショップ", "📝", "#8B4513"),
    ],
    "Machines": [
        ("Classic Tractor", "ビンテージトラクター", "🚜", "#DC143C"),
        ("Vintage Car Review", "クラシックカー", "🚗", "#FF4500"),
        ("Motorcycle Heritage", "バイク史・ビンテージ", "🏍️", "#2F4F4F"),
        ("Aviation History", "航空機・飛行機史", "✈️", "#4682B4"),
        ("Train Mechanics", "機関車・列車機械", "🚂", "#8B4513"),
        ("Ship Engineering", "造船・海船工学", "⛵", "#4682B4"),
        ("Heavy Equipment", "重機・建設機械", "🏗️", "#708090"),
        ("Vintage Engines", "エンジン史・機械", "⚙️", "#696969"),
        ("Auto Restoration", "自動車修復ガイド", "🔧", "#FF8C00"),
        ("Mechanical Watch", "機械時計・時計学", "⌚", "#FFD700"),
    ],
    "Weird": [
        ("Fortean Times", "UFO・超常現象", "👽", "#6B4C9A"),
        ("Cryptozoology Journal", "UMA・未確認生物", "🦣", "#2F4F4F"),
        ("Paranormal Investigation", "心霊現象・怪奇", "👻", "#191970"),
        ("Conspiracy Theory", "陰謀論・都市伝説", "📡", "#8B008B"),
        ("Strange Phenomena", "奇妙な事象・謎", "❓", "#FF1493"),
        ("Bigfoot Research", "ビッグフット研究", "🦶", "#696969"),
        ("UFO Sightings", "UFO目撃情報・宇宙", "🛸", "#191970"),
        ("Haunted Places", "幽霊屋敷・心霊スポット", "🏚️", "#2F4F4F"),
        ("Ancient Mysteries", "古代の謎・失われた文明", "🏺", "#CD853F"),
        ("Metaphysical Science", "形而上学・神秘主義", "✨", "#FFD700"),
    ],
    "Sports": [
        ("Competitive Curling", "カーリング競技", "🥌", "#87CEEB"),
        ("Table Tennis Masters", "卓球・ピンポン", "🏓", "#FF6347"),
        ("Badminton Weekly", "バドミントン", "🏸", "#FFD700"),
        ("Rock Climbing Guide", "ロッククライミング", "🧗", "#8B4513"),
        ("Parkour Training", "パルクール・フリーラン", "🏃", "#FF4500"),
        ("Archery Champion", "アーチェリー・弓術", "🏹", "#8B6F47"),
        ("Frisbee Golf", "フリスビーゴルフ", "🥏", "#228B22"),
        ("Skateboarding Tricks", "スケートボード", "🛹", "#696969"),
        ("Bowling Masters", "ボーリング・ボウル", "🎳", "#DC143C"),
        ("Darts Professional", "ダーツ・ダーツ競技", "🎯", "#FF4500"),
    ],
    "Science": [
        ("Molecular Biology", "分子生物学", "🧬", "#4169E1"),
        ("Quantum Physics", "量子物理学", "⚛️", "#191970"),
        ("Astrophysics Today", "天体物理学・宇宙", "🌌", "#000080"),
        ("Marine Biology", "海洋生物学", "🐠", "#4682B4"),
        ("Geology Journal", "地質学・鉱物学", "🪨", "#8B4513"),
        ("Palaeontology Review", "古生物学・恐竜", "🦴", "#A0522D"),
        ("Neuroscience Research", "神経科学・脳", "🧠", "#FF1493"),
        ("Biotech Innovation", "バイオテクノロジー", "🧫", "#228B22"),
        ("Meteorology Guide", "気象学・天気", "⛈️", "#4682B4"),
        ("Oceanography Today", "海洋学・深海", "🌊", "#1E90FF"),
    ],
}

def generate_magazines(count: int = 1000) -> List[Dict]:
    """1000 誌のニッチ雑誌データを生成"""
    magazines = []
    magazine_id = 0

    countries = ["USA", "UK", "Japan", "Germany", "France", "Canada", "Australia", "Netherlands", "Sweden", "Spain"]
    frequencies = ["weekly", "biweekly", "monthly", "bimonthly", "quarterly", "biannually"]
    prices = ["paid", "free"]

    for category, magazines_list in MAGAZINE_DATA.items():
        # カテゴリごとに複数の雑誌を生成
        items_per_category = count // len(MAGAZINE_DATA)

        for i in range(items_per_category):
            base_mag = magazines_list[i % len(magazines_list)]

            # 雑誌名にバリエーションを加える
            name = f"{base_mag[0]} {i+1}" if i > 0 else base_mag[0]
            name_ja = f"{base_mag[1]} #{i+1}" if i > 0 else base_mag[1]

            magazine = {
                "id": f"{category.lower()}-{i+1:04d}",
                "name": name,
                "nameJa": name_ja,
                "description": f"{base_mag[0]} magazine covering {category.lower()} topics from around the world.",
                "descriptionJa": f"世界中の{base_mag[1]}に関する最新情報と専門知識を提供する雑誌。",
                "category": category,
                "country": countries[i % len(countries)],
                "emoji": base_mag[2],
                "color": base_mag[3],
                "websiteUrl": f"https://example-mag-{magazine_id}.com",
                "frequency": frequencies[i % len(frequencies)],
                "price": prices[i % 2],
                "tags": [category.lower(), base_mag[1].split("・")[0].lower()],
            }
            magazines.append(magazine)
            magazine_id += 1

            if magazine_id >= count:
                break

        if magazine_id >= count:
            break

    return magazines[:count]

def save_to_json(magazines: List[Dict], filename: str):
    """JSON ファイルに保存"""
    with open(filename, 'w', encoding='utf-8') as f:
        json.dump(magazines, f, ensure_ascii=False, indent=2)

    file_size = __import__('os').path.getsize(filename) / (1024 * 1024)
    print(f"Generated {len(magazines)} magazines")
    print(f"File: {filename}")
    print(f"File size: {file_size:.2f}MB")

if __name__ == "__main__":
    magazines = generate_magazines(1000)
    output_file = "MagRabbit/Data/magazines_1000.json"
    save_to_json(magazines, output_file)
