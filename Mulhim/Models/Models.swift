import Foundation

// MARK: - Prayer Times
struct PrayerTimings: Codable {
    let data: PrayerData
}

struct PrayerData: Codable {
    let timings: Timings
    let date: PrayerDate
    let meta: PrayerMeta
}

struct Timings: Codable {
    let Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha: String
}

struct PrayerDate: Codable {
    let readable: String
    let hijri: Hijri
}

struct Hijri: Codable {
    let date: String
    let month: HijriMonth
    let day: String
    let year: String
}

struct HijriMonth: Codable {
    let ar: String
}

struct PrayerMeta: Codable {
    let timezone: String
}

// MARK: - Azkar
struct Zikr: Identifiable {
    let id = UUID()
    let text: String
    let count: Int
    let description: String?
}

struct ZikrCategory: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let items: [Zikr]
}
