import SwiftUI

struct PrayerTimesView: View {
    @EnvironmentObject private var loc: LocationViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                SectionHeader(title: "مواقيت الصلاة", subtitle: "استناداً إلى موقعك الحالي")
                    .padding(.top, 12)

                if loc.authStatus == .denied || loc.authStatus == .restricted {
                    locationNeeded
                } else if loc.prayerTimes == nil {
                    loadingView
                } else {
                    dateCard
                    nextPrayerCard
                    timingsCard
                    statsSection
                    hijriCard
                }
            }
            .padding(.bottom, 24)
        }
        .background(AppBackground())
    }

    // MARK: - Location Needed
    private var locationNeeded: some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 40)
            Image(systemName: "location.slash")
                .font(.system(size: 48))
                .foregroundColor(.gold)
                .symbolRenderingMode(.hierarchical)

            Text("الرجاء السماح بالوصول إلى الموقع")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.textDark)

            Text("نحتاج موقعك لحساب أوقات الصلاة واتجاه القبلة بدقة")
                .font(.system(size: 15))
                .foregroundColor(.textMuted)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button { loc.requestPermission() } label: {
                HStack(spacing: 8) {
                    Image(systemName: "location.fill")
                    Text("السماح بالموقع")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 28)
                .padding(.vertical, 14)
                .background(Color.greenIslamic, in: RoundedRectangle(cornerRadius: 14))
                .shadow(color: Color.greenIslamic.opacity(0.2), radius: 8, y: 4)
            }
            .buttonStyle(.plain)
            Spacer().frame(height: 80)
        }
    }

    // MARK: - Loading
    private var loadingView: some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 60)
            ProgressView()
                .scaleEffect(1.2)
                .tint(.gold)
            Text("جاري تحميل أوقات الصلاة...")
                .font(.system(size: 15))
                .foregroundColor(.textMuted)
            Spacer().frame(height: 100)
        }
    }

    // MARK: - Date Card
    private var dateCard: some View {
        PremiumCard {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(loc.prayerDate?.readable ?? "")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.textDark)
                    HStack(spacing: 4) {
                        Text(loc.prayerDate?.hijri.day ?? "")
                            .fontWeight(.medium)
                        Text(loc.prayerDate?.hijri.month.ar ?? "")
                            .fontWeight(.medium)
                        Text(loc.prayerDate?.hijri.year ?? "هـ")
                            .fontWeight(.medium)
                    }
                    .font(.system(size: 16))
                    .foregroundColor(.gold)
                }
                Spacer()
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 28))
                    .foregroundColor(.gold)
                    .symbolRenderingMode(.hierarchical)
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Next Prayer Card
    private var nextPrayerCard: some View {
        PremiumCard {
            VStack(spacing: 10) {
                if let next = loc.nextPrayer {
                    Text("الصلاة القادمة")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.textMuted)

                    Text(next.name)
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.greenIslamic)

                    Label(next.time, systemImage: "clock.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.textDark)
                }
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Timings Card
    private var timingsCard: some View {
        PremiumCard {
            VStack(spacing: 0) {
                if let t = loc.prayerTimes {
                    PrayerRowPremium(name: "الفجر", time: t.Fajr, isNext: loc.nextPrayer?.name == "الفجر", icon: "moon.stars.fill")
                    Divider().padding(.horizontal, 16)
                    PrayerRowPremium(name: "الشروق", time: t.Sunrise, isNext: loc.nextPrayer?.name == "الشروق", icon: "sunrise.fill")
                    Divider().padding(.horizontal, 16)
                    PrayerRowPremium(name: "الظهر", time: t.Dhuhr, isNext: loc.nextPrayer?.name == "الظهر", icon: "sun.max.fill")
                    Divider().padding(.horizontal, 16)
                    PrayerRowPremium(name: "العصر", time: t.Asr, isNext: loc.nextPrayer?.name == "العصر", icon: "cloud.sun.fill")
                    Divider().padding(.horizontal, 16)
                    PrayerRowPremium(name: "المغرب", time: t.Maghrib, isNext: loc.nextPrayer?.name == "المغرب", icon: "sunset.fill")
                    Divider().padding(.horizontal, 16)
                    PrayerRowPremium(name: "العشاء", time: t.Isha, isNext: loc.nextPrayer?.name == "العشاء", icon: "moon.fill")
                }
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Stats Section
    private var statsSection: some View {
        HStack(spacing: 12) {
            if let t = loc.prayerTimes {
                StatCardPremium(
                    icon: "sunrise.fill",
                    title: "بين الفجر والشروق",
                    value: diff(t.Fajr, t.Sunrise)
                )
                StatCardPremium(
                    icon: "sun.max.fill",
                    title: "بين الظهر والعصر",
                    value: diff(t.Dhuhr, t.Asr)
                )
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Hijri Card
    private var hijriCard: some View {
        PremiumCard {
            HStack(spacing: 14) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.gold)
                    .symbolRenderingMode(.multicolor)

                VStack(alignment: .leading, spacing: 4) {
                    Text("التاريخ الهجري")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.textMuted)
                    Text(loc.prayerDate?.hijri.date ?? "")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.greenIslamic)
                }
                Spacer()
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Helper
    private func diff(_ t1: String, _ t2: String) -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        guard let d1 = f.date(from: t1), let d2 = f.date(from: t2) else { return "-" }
        let sec = d2.timeIntervalSince(d1)
        let h = Int(sec) / 3600
        let m = (Int(sec) % 3600) / 60
        return "\(h)س \(m)د"
    }
}

// MARK: - Stat Card Premium
struct StatCardPremium: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        PremiumCard {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(.gold)
                    .symbolRenderingMode(.multicolor)
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.textMuted)
                    .multilineTextAlignment(.center)
                Text(value)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.greenIslamic)
            }
        }
    }
}
