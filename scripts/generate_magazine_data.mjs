import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const count = Number.parseInt(process.argv[2] ?? "3000", 10);
const scriptDir = path.dirname(fileURLToPath(import.meta.url));
const dataDir = path.resolve(scriptDir, "../Sources/MagRabbit/Data");

const categories = [
  ["Animals", "動物", "#D4A574", [["Ferret Fancy", "フェレット愛好家向け", "ferret"], ["Koi Pond Review", "錦鯉と池づくり", "koi"], ["Reptile Room", "爬虫類飼育", "reptile"], ["Falconry Notes", "鷹匠文化", "falconry"], ["Small Farm Stock", "小規模家畜", "livestock"]]],
  ["Food", "食文化", "#C35A2E", [["Fermentation Field", "発酵食文化", "fermentation"], ["Cheese Cellar", "チーズ熟成", "cheese"], ["Regional Pickle Review", "郷土漬物", "pickles"], ["Forager Kitchen", "採集と料理", "foraging"], ["Smokehouse Quarterly", "燻製文化", "smokehouse"]]],
  ["DIY", "手仕事", "#8A6F3E", [["Backyard Foundry", "小さな鋳造", "foundry"], ["Tool Shed Journal", "工具と修理", "tools"], ["Off Grid Workshop", "自給工作", "off-grid"], ["Cabin Maker", "小屋づくり", "cabin"], ["Repair Culture", "修理文化", "repair"]]],
  ["Tech", "技術", "#2F6F8F", [["Retro Computing", "旧型コンピュータ", "retro-computing"], ["Radio Packet", "アマチュア無線", "radio"], ["Small Robot Notes", "小型ロボット", "robotics"], ["Synth Circuit", "電子音響回路", "synth"], ["Open Hardware Desk", "オープンハードウェア", "hardware"]]],
  ["Nature", "自然", "#5A7B4B", [["Moss & Lichen", "苔と地衣類", "moss"], ["Wetland Watch", "湿地観察", "wetlands"], ["Desert Field Notes", "砂漠の自然", "desert"], ["Tidepool Journal", "潮だまり観察", "tidepool"], ["Mycology Walk", "きのこ観察", "mycology"]]],
  ["Culture", "文化", "#8B4F7D", [["Mask Ritual Review", "仮面と祭礼", "masks"], ["Street Shrine", "街角信仰", "folk-culture"], ["Carnival Archive", "祝祭文化", "carnival"], ["Nomad Textile", "遊牧民の布", "textile"], ["Local Lore", "地域伝承", "lore"]]],
  ["History", "歴史", "#7B5A3B", [["Microhistory Review", "小さな地域史", "microhistory"], ["Old Map Room", "古地図研究", "maps"], ["Industrial Past", "産業遺産", "industrial-history"], ["Postal History", "郵便史", "postal"], ["Maritime Archive", "海事史", "maritime"]]],
  ["Hobby", "趣味", "#B85C5C", [["Miniature Rail", "鉄道模型", "model-rail"], ["Pen Collector", "万年筆収集", "fountain-pens"], ["Clock Bench", "時計修理", "clocks"], ["Board Game Folio", "ボードゲーム文化", "board-games"], ["Puzzle Cabinet", "パズル蒐集", "puzzles"]]],
  ["Travel", "旅", "#3E7A78", [["Slow Ferry", "フェリー旅", "ferry"], ["Border Town Notes", "国境の街", "border-town"], ["Tiny Museum Guide", "小さな博物館", "small-museum"], ["Railway Stopover", "途中下車の旅", "railway"], ["Island Detour", "島の寄り道", "island"]]],
  ["Craft", "クラフト", "#B98B3D", [["Letterpress Ledger", "活版印刷", "letterpress"], ["Basketry Field", "かご編み", "basketry"], ["Bookbinding Desk", "製本", "bookbinding"], ["Natural Dye Review", "草木染め", "natural-dye"], ["Clay Kiln Notes", "陶芸窯", "ceramics"]]],
  ["Plants", "植物", "#4F7F42", [["Rare Seed Review", "珍しい種子", "seeds"], ["Orchid Bench", "蘭栽培", "orchids"], ["Alpine Garden", "高山植物", "alpine-plants"], ["Bonsai Room", "盆栽", "bonsai"], ["Herbarium Notes", "植物標本", "herbarium"]]],
  ["Literary", "文芸", "#5F5A8B", [["Small Press Review", "小出版社文芸", "small-press"], ["Flash Fiction Desk", "掌編小説", "flash-fiction"], ["Poetry Pamphlet", "詩の小冊子", "poetry"], ["Translation Margins", "翻訳文芸", "translation"], ["Zine Library", "ZINE文化", "zine"]]],
  ["Machines", "機械", "#56616B", [["Steam Model Engineer", "蒸気模型", "steam"], ["Old Tractor News", "古いトラクター", "tractor"], ["Workshop Lathe", "旋盤工作", "lathe"], ["Motorcycle Shed", "古いバイク", "motorcycle"], ["Mechanical Type", "タイプライター", "typewriter"]]],
  ["Weird", "不思議", "#6F4D8B", [["Fortean Field", "怪異研究", "fortean"], ["Cryptid Review", "未確認生物", "cryptid"], ["UFO Archive", "UFO文化", "ufo"], ["Odd Museum", "奇妙な博物館", "oddities"], ["Strange Weather", "奇妙な気象", "weather"]]],
  ["Sports", "スポーツ", "#4E7BAF", [["Fencing Room", "フェンシング", "fencing"], ["Curling Sheet", "カーリング", "curling"], ["Ultra Trail Notes", "山岳長距離", "trail"], ["Velodrome Weekly", "自転車競技場", "velodrome"], ["Table Tennis Lab", "卓球研究", "table-tennis"]]],
  ["Science", "科学", "#3F7898", [["Citizen Astronomy", "市民天文", "astronomy"], ["Microscopy Notes", "顕微鏡観察", "microscopy"], ["Cave Survey", "洞窟調査", "cave"], ["Meteorite Desk", "隕石研究", "meteorite"], ["Amateur Geology", "地質観察", "geology"]]],
  ["Music", "音楽", "#9A4D5E", [["Tape Culture", "カセット文化", "cassette"], ["Field Recording", "フィールド録音", "field-recording"], ["Drone Music Review", "ドローン音楽", "drone"], ["Local Scene Notes", "ローカル音楽シーン", "local-scene"], ["Vinyl Small Press", "自主盤レコード", "vinyl"]]],
  ["Architecture", "建築", "#6A6F58", [["Brutalist Walk", "ブルータリズム", "brutalism"], ["Vernacular House", "民家建築", "vernacular"], ["Ruins Survey", "廃墟観察", "ruins"], ["Tiny Apartment", "小さな住まい", "small-living"], ["Station Design", "駅舎建築", "station"]]],
  ["Urban", "都市観察", "#4A6A73", [["Alleyway Atlas", "路地観察", "alley"], ["Signage Review", "看板文化", "signage"], ["Public Bench", "公共空間", "public-space"], ["Night Market Notes", "夜市文化", "night-market"], ["Suburb Field", "郊外観察", "suburb"]]],
  ["Fashion", "装い", "#A05A72", [["Workwear Journal", "作業着文化", "workwear"], ["Indigo Cloth", "藍染と布", "indigo"], ["Hat Maker", "帽子づくり", "hats"], ["Archive Uniform", "制服アーカイブ", "uniform"], ["Street Tailor", "街の仕立て", "tailor"]]],
  ["Film", "映画", "#714F4F", [["Midnight Cinema", "深夜映画", "midnight-cinema"], ["Analog Film Desk", "フィルム上映", "analog-film"], ["Horror Fanzine", "ホラー映画", "horror"], ["Regional Screens", "地域映画館", "cinema"], ["Documentary Notes", "ドキュメンタリー", "documentary"]]],
  ["Games", "ゲーム", "#5C5F9B", [["Arcade Cabinet", "アーケード筐体", "arcade"], ["Solo RPG Notes", "ソロRPG", "solo-rpg"], ["Wargame Table", "ウォーゲーム", "wargame"], ["Indie Game Zine", "インディーゲーム", "indie-game"], ["Pinball Room", "ピンボール", "pinball"]]],
  ["Transport", "交通", "#4D6B8F", [["Tramway Review", "路面電車", "tram"], ["Ferry Timetable", "フェリー航路", "ferry"], ["Bus Depot", "バス車庫", "bus"], ["Canal Boat", "運河交通", "canal"], ["Funicular Notes", "ケーブルカー", "funicular"]]],
  ["Collecting", "収集", "#8D744A", [["Matchbox Archive", "マッチ箱収集", "matchbox"], ["Ticket Stub Review", "半券収集", "tickets"], ["Ephemera Cabinet", "紙もの蒐集", "ephemera"], ["Bottle Label", "ラベル収集", "labels"], ["Toy Catalog", "玩具カタログ", "toys"]]]
];

const countries = ["USA", "UK", "Germany", "France", "Italy", "Netherlands", "Sweden", "Norway", "Finland", "Spain", "Portugal", "Canada", "Australia", "New Zealand", "Japan", "Taiwan", "Korea", "Mexico", "Brazil", "Argentina"];
const frequencies = ["weekly", "biweekly", "monthly", "bimonthly", "quarterly", "biannually"];
const suffixes = ["Review", "Journal", "Digest", "Quarterly", "Gazette", "Notebook", "Field Guide", "Ledger", "Archive", "Companion"];

const magazines = Array.from({ length: count }, (_, index) => {
  const category = categories[index % categories.length];
  const [key, categoryJa, color, topics] = category;
  const topic = topics[Math.floor(index / categories.length) % topics.length];
  const [baseName, jaName, tag] = topic;
  const serial = index + 1;
  const suffix = suffixes[index % suffixes.length];
  const issueName = index % 3 === 0 ? baseName : `${baseName} ${suffix}`;
  const country = countries[(index * 7) % countries.length];
  const frequency = frequencies[(index * 5) % frequencies.length];

  return {
    id: `${key.toLowerCase()}-${String(serial).padStart(4, "0")}`,
    name: `${issueName} ${serial}`,
    nameJa: `${jaName} #${serial}`,
    description: `${issueName} is an overseas niche magazine covering ${tag} culture, makers, collectors, and small communities.`,
    descriptionJa: `${jaName}を中心に、海外の小さなコミュニティや専門文化を紹介する雑誌。本文の翻訳ではなく、テーマを日本語でつかむためのメモです。`,
    category: key,
    country,
    emoji: "",
    color,
    websiteUrl: `https://example-mag-${index}.com`,
    frequency,
    price: index % 4 === 0 ? "free" : "paid",
    tags: [categoryJa, jaName, country, frequency]
  };
});

fs.mkdirSync(dataDir, { recursive: true });
const json = `${JSON.stringify(magazines, null, 2)}\n`;
fs.writeFileSync(path.join(dataDir, "magazines_3000.json"), json, "utf8");
fs.writeFileSync(path.join(dataDir, "magazines.json"), json, "utf8");
