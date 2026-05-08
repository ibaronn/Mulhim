import Foundation

// MARK: - Prayer Times
struct PrayerTimings: Codable { let data: PrayerData }
struct PrayerData: Codable { let timings: Timings; let date: PrayerDate; let meta: PrayerMeta }
struct Timings: Codable { let Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha: String }
struct PrayerDate: Codable { let readable: String; let hijri: Hijri }
struct Hijri: Codable { let date: String; let month: HijriMonth; let day: String; let year: String }
struct HijriMonth: Codable { let ar: String }
struct PrayerMeta: Codable { let timezone: String }

// MARK: - Quran
struct SurahResponse: Codable { let data: [Surah] }
struct SurahDetailResponse: Codable { let data: SurahDetail }
struct Surah: Codable, Identifiable {
    var id: Int { number }
    let number: Int; let name: String; let englishName: String
    let englishNameTranslation: String; let numberOfAyahs: Int; let revelationType: String
}
struct SurahDetail: Codable { let number: Int; let name: String; let englishName: String; let ayahs: [Ayah] }
struct Ayah: Codable, Identifiable { let number: Int; let text: String; var id: Int { number } }

// MARK: - Azkar & Duas
struct ZikrItem: Identifiable, Codable {
    let id: UUID
    let text: String
    let count: Int
    let description: String?
    let category: ZikrCategory
}

enum ZikrCategory: String, Codable, CaseIterable {
    case morning = "أذكار الصباح"
    case evening = "أذكار المساء"
    case general = "أذكار عامة"
    case sleep = "أدعية النوم"
    case wake = "أدعية الاستيقاظ"
    case comprehensive = "أدعية شاملة"

    var icon: String {
        switch self {
        case .morning: return "sunrise.fill"
        case .evening: return "moon.stars.fill"
        case .general: return "bookmark.fill"
        case .sleep: return "bed.double.fill"
        case .wake: return "sun.max.fill"
        case .comprehensive: return "sparkles"
        }
    }
}

// MARK: - Sunnah Prayers
struct SunnahItem: Identifiable, Codable {
    let id: String
    let name: String
    let description: String

    static let all: [SunnahItem] = [
        SunnahItem(id: "fajr_before", name: "سنة الفجر", description: "ركعتان قبل صلاة الفجر"),
        SunnahItem(id: "dhuhr_before", name: "سنة الظهر القبلية", description: "أربع ركعات قبل الظهر"),
        SunnahItem(id: "dhuhr_after", name: "سنة الظهر البعدية", description: "ركعتان بعد الظهر"),
        SunnahItem(id: "maghrib_after", name: "سنة المغرب", description: "ركعتان بعد المغرب"),
        SunnahItem(id: "isha_after", name: "سنة العشاء", description: "ركعتان بعد العشاء"),
        SunnahItem(id: "tahajjud", name: "صلاة التهجد", description: "قيام الليل"),
        SunnahItem(id: "duha", name: "صلاة الضحى", description: "ركعتان إلى ثمان ركعات"),
        SunnahItem(id: "witr", name: "الوتر", description: "ركعة أو ثلاث ركعات بعد العشاء"),
    ]
}

// MARK: - Tasbih Presets
struct TasbihPreset: Identifiable, Codable {
    let id: UUID
    let name: String
    let target: Int

    static let all: [TasbihPreset] = [
        TasbihPreset(id: UUID(), name: "سبحان الله", target: 33),
        TasbihPreset(id: UUID(), name: "الحمد لله", target: 33),
        TasbihPreset(id: UUID(), name: "الله أكبر", target: 33),
        TasbihPreset(id: UUID(), name: "لا إله إلا الله", target: 33),
        TasbihPreset(id: UUID(), name: "أستغفر الله", target: 33),
        TasbihPreset(id: UUID(), name: "اللهم صل على محمد", target: 33),
    ]
}

// MARK: - Holiday
struct IslamicHoliday: Identifiable {
    let id = UUID()
    let name: String
    let hijriDay: Int
    let hijriMonth: Int
    let icon: String
}

let islamicHolidays: [IslamicHoliday] = [
    IslamicHoliday(name: "عيد الفطر", hijriDay: 1, hijriMonth: 10, icon: "🎉"),
    IslamicHoliday(name: "عيد الأضحى", hijriDay: 10, hijriMonth: 12, icon: "🕋"),
    IslamicHoliday(name: "رمضان", hijriDay: 1, hijriMonth: 9, icon: "🌙"),
    IslamicHoliday(name: "المولد النبوي", hijriDay: 12, hijriMonth: 3, icon: "🕌"),
    IslamicHoliday(name: "رأس السنة الهجرية", hijriDay: 1, hijriMonth: 1, icon: "✨"),
    IslamicHoliday(name: "ليلة الإسراء والمعراج", hijriDay: 27, hijriMonth: 7, icon: "⭐"),
]

// MARK: - Azkar Data
func allZikrItems() -> [ZikrItem] {
    return [
        // Morning
        ZikrItem(id: UUID(), text: "اللَّهُمَّ إِنِّي أَصْبَحْتُ مِنْكَ فِي نِعْمَةٍ وَعَافِيَةٍ وَسِتْرٍ، فَأَتِمَّ عَلَيَّ نِعْمَتَكَ وَعَافِيَتَكَ وَسِتْرَكَ فِي الدُّنْيَا وَالْآخِرَةِ", count: 1, description: "مرة واحدة", category: .morning),
        ZikrItem(id: UUID(), text: "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ", count: 1, description: "مرة واحدة", category: .morning),
        ZikrItem(id: UUID(), text: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ", count: 3, description: "3 مرات", category: .morning),
        ZikrItem(id: UUID(), text: "لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ", count: 1, description: "مرة واحدة", category: .morning),
        ZikrItem(id: UUID(), text: "اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ", count: 1, description: "مرة واحدة", category: .morning),
        ZikrItem(id: UUID(), text: "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، عَلَيْكَ تَوَكَّلْتُ، وَأَنْتَ رَبُّ الْعَرْشِ الْعَظِيمِ", count: 1, description: "مرة واحدة", category: .morning),
        // Evening
        ZikrItem(id: UUID(), text: "اللَّهُمَّ إِنِّي أَمْسَيْتُ مِنْكَ فِي نِعْمَةٍ وَعَافِيَةٍ وَسِتْرٍ، فَأَتِمَّ عَلَيَّ نِعْمَتَكَ وَعَافِيَتَكَ وَسِتْرَكَ فِي الدُّنْيَا وَالْآخِرَةِ", count: 1, description: "مرة واحدة", category: .evening),
        ZikrItem(id: UUID(), text: "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ", count: 1, description: "مرة واحدة", category: .evening),
        ZikrItem(id: UUID(), text: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ", count: 3, description: "3 مرات", category: .evening),
        ZikrItem(id: UUID(), text: "اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ الْمَصِيرُ", count: 1, description: "مرة واحدة", category: .evening),
        ZikrItem(id: UUID(), text: "أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ", count: 3, description: "3 مرات", category: .evening),
        // General
        ZikrItem(id: UUID(), text: "أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ", count: 3, description: "3 مرات", category: .general),
        ZikrItem(id: UUID(), text: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ", count: 3, description: "3 مرات", category: .general),
        ZikrItem(id: UUID(), text: "لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ", count: 1, description: "مرة واحدة", category: .general),
        ZikrItem(id: UUID(), text: "اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ", count: 10, description: "10 مرات", category: .general),
        // Sleep
        ZikrItem(id: UUID(), text: "بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا", count: 1, description: "عند النوم", category: .sleep),
        ZikrItem(id: UUID(), text: "اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ", count: 1, description: "عند النوم", category: .sleep),
        ZikrItem(id: UUID(), text: "سُبْحَانَ اللَّهِ (٣٣) وَالْحَمْدُ لِلَّهِ (٣٣) وَاللَّهُ أَكْبَرُ (٣٤)", count: 1, description: "قبل النوم", category: .sleep),
        ZikrItem(id: UUID(), text: "اللَّهُمَّ بِاسْمِكَ أَمُوتُ وَأَحْيَا", count: 3, description: "3 مرات", category: .sleep),
        ZikrItem(id: UUID(), text: "آيَةُ الْكُرْسِيِّ", count: 1, description: "عند النوم", category: .sleep),
        ZikrItem(id: UUID(), text: "اللَّهُمَّ أَسْلَمْتُ نَفْسِي إِلَيْكَ، وَوَجَّهْتُ وَجْهِي إِلَيْكَ، وَفَوَّضْتُ أَمْرِي إِلَيْكَ", count: 1, description: "عند النوم", category: .sleep),
        // Wake
        ZikrItem(id: UUID(), text: "الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ", count: 1, description: "عند الاستيقاظ", category: .wake),
        ZikrItem(id: UUID(), text: "اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْماً نَافِعاً، وَرِزْقاً طَيِّباً، وَعَمَلاً مُتَقَبَّلاً", count: 1, description: "عند الاستيقاظ", category: .wake),
        ZikrItem(id: UUID(), text: "الْحَمْدُ لِلَّهِ الَّذِي عَافَانِي فِي جَسَدِي، وَرَدَّ عَلَيَّ رُوحِي، وَأَذِنَ لِي بِذِكْرِهِ", count: 1, description: "عند الاستيقاظ", category: .wake),
        // Comprehensive
        ZikrItem(id: UUID(), text: "رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ", count: 1, description: "بعد كل صلاة", category: .comprehensive),
        ZikrItem(id: UUID(), text: "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْهُدَى وَالتُّقَى وَالْعَفَافَ وَالْغِنَى", count: 1, description: "دعاء", category: .comprehensive),
        ZikrItem(id: UUID(), text: "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ زَوَالِ نِعْمَتِكَ، وَتَحَوُّلِ عَافِيَتِكَ، وَفُجَاءَةِ نِقْمَتِكَ، وَجَمِيعِ سَخَطِكَ", count: 1, description: "دعاء", category: .comprehensive),
        ZikrItem(id: UUID(), text: "حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ", count: 1, description: "عند الخوف", category: .comprehensive),
        ZikrItem(id: UUID(), text: "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ الْعَلِيِّ الْعَظِيمِ", count: 1, description: "دعاء", category: .comprehensive),
        ZikrItem(id: UUID(), text: "رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ", count: 3, description: "3 مرات", category: .comprehensive),
        ZikrItem(id: UUID(), text: "اللَّهُمَّ لا تَجْعَلِ الدُّنْيَا أَكْبَرَ هَمِّنَا وَلا مَبْلَغَ عِلْمِنَا", count: 1, description: "دعاء", category: .comprehensive),
    ]
}

// MARK: - Daily Tracking
struct DailyRecord: Codable {
    let date: String
    var completedZikrIds: Set<String>
    var completedSunnahIds: Set<String>
    var tasbihCounts: [String: Int]
    var totalCompleted: Int { completedZikrIds.count + completedSunnahIds.count }
}

class DailyTracker: ObservableObject {
    @Published var today: DailyRecord
    @Published var history: [DailyRecord]

    private let key = "dailyRecords"

    init() {
        let todayStr = Self.dateKey()
        self.today = DailyRecord(date: todayStr, completedZikrIds: [], completedSunnahIds: [], tasbihCounts: [:])
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: key),
           let all = try? JSONDecoder().decode([DailyRecord].self, from: data) {
            self.history = all
        } else {
            self.history = []
        }
        if let existing = self.history.first(where: { $0.date == todayStr }) {
            self.today = existing
        } else {
            self.history.insert(self.today, at: 0)
        }
    }

    static func dateKey() -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: Date())
    }

    func save() {
        if let idx = history.firstIndex(where: { $0.date == today.date }) {
            history[idx] = today
        } else {
            history.insert(today, at: 0)
        }
        if let data = try? JSONEncoder().encode(Array(history.prefix(365))) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func toggleZikr(_ id: UUID) {
        let key = id.uuidString
        if today.completedZikrIds.contains(key) {
            today.completedZikrIds.remove(key)
        } else {
            today.completedZikrIds.insert(key)
        }
        save()
    }

    func toggleSunnah(_ id: String) {
        if today.completedSunnahIds.contains(id) {
            today.completedSunnahIds.remove(id)
        } else {
            today.completedSunnahIds.insert(id)
        }
        save()
    }

    func isZikrCompleted(_ id: UUID) -> Bool {
        today.completedZikrIds.contains(id.uuidString)
    }

    func isSunnahCompleted(_ id: String) -> Bool {
        today.completedSunnahIds.contains(id)
    }

    func historyForPastDays(_ days: Int) -> [DailyRecord] {
        let cal = Calendar.current
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return (0..<days).compactMap { d in
            let date = cal.date(byAdding: .day, value: -d, to: Date())!
            let key = f.string(from: date)
            return history.first(where: { $0.date == key })
        }
    }
}

// MARK: - Holiday Calculator
func daysUntilNextHoliday() -> [(IslamicHoliday, Int)] {
    let cal = Calendar(identifier: .islamicUmmAlQura)
    let today = cal.dateComponents([.year, .month, .day], from: Date())
    guard let currentYear = today.year else { return [] }
    var results: [(IslamicHoliday, Int)] = []
    for holiday in islamicHolidays {
        var comps = DateComponents()
        comps.year = currentYear
        comps.month = holiday.hijriMonth
        comps.day = holiday.hijriDay
        if let date = cal.date(from: comps) {
            let diff = cal.dateComponents([.day], from: Date(), to: date)
            if let days = diff.day, days >= 0 {
                results.append((holiday, days))
            } else {
                comps.year = currentYear + 1
                if let nextDate = cal.date(from: comps) {
                    let nextDiff = cal.dateComponents([.day], from: Date(), to: nextDate)
                    if let days = nextDiff.day {
                        results.append((holiday, days))
                    }
                }
            }
        }
    }
    return results.sorted { $0.1 < $1.1 }
}
