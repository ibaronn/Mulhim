import Foundation
import CoreLocation

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

// MARK: - Surah
struct SurahResponse: Codable {
    let data: [Surah]
}

struct SurahDetailResponse: Codable {
    let data: SurahDetail
}

struct Surah: Codable, Identifiable {
    var id: Int { number }
    let number: Int
    let name: String
    let englishName: String
    let englishNameTranslation: String
    let numberOfAyahs: Int
    let revelationType: String
}

struct SurahDetail: Codable {
    let number: Int
    let name: String
    let englishName: String
    let ayahs: [Ayah]
}

struct Ayah: Codable, Identifiable {
    let number: Int
    let text: String
    var id: Int { number }
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
    let items: [Zikr]
}
