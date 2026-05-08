import SwiftUI

struct PrayerTimesView: View {
    @EnvironmentObject private var loc: LocationViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                header
                if loc.authStatus == .denied || loc.authStatus == .restricted {
                    locationNeeded
                } else if loc.prayerTimes == nil {
                    loading
                } else {
                    dateCard
                    nextPrayerCard
                    timingsList
                    statsRow
                    hijriCard
                }
            }.padding(.bottom, 8)
        }
        .background(Color.bgGradient.overlay(Color.bg))
        .safeAreaInset(edge: .top) { Color.clear.frame(height: 0) }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("مواقيت الصلاة").font(.title).bold().foregroundColor(.textP)
                Text("استناداً إلى موقعك الحالي").font(.subheadline).foregroundColor(.textS)
            }
            Spacer()
            Image(systemName: "location.fill").font(.title3).foregroundColor(.gold).padding(10)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
        }.padding(.horizontal, 16).padding(.top, 8)
    }

    private var locationNeeded: some View {
        VStack(spacing: 12) {
            Spacer().frame(height: 60)
            Image(systemName: "location.slash").font(.system(size: 44)).foregroundColor(.gold)
            Text("الرجاء السماح بالوصول إلى الموقع").font(.headline).foregroundColor(.textP)
            Text("نحتاج موقعك لحساب أوقات الصلاة والقبلة بدقة").multilineTextAlignment(.center).foregroundColor(.textS).padding(.horizontal)
            Button { loc.requestPermission() } label: {
                Text("السماح بالموقع").font(.headline).foregroundColor(.white).padding(.horizontal, 24).padding(.vertical, 12)
                    .background(Color.gold, in: RoundedRectangle(cornerRadius: 12))
            }.buttonStyle(.plain)
            Spacer().frame(height: 100)
        }
    }

    private var loading: some View {
        VStack(spacing: 12) {
            Spacer().frame(height: 80)
            ProgressView().tint(.gold)
            Text("جاري تحميل أوقات الصلاة...").foregroundColor(.textS)
            Spacer().frame(height: 100)
        }
    }

    private var dateCard: some View {
        GlassCard {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(loc.prayerDate?.readable ?? "").font(.headline).foregroundColor(.textP)
                    Text("\(loc.prayerDate?.hijri.day ?? "") \(loc.prayerDate?.hijri.month.ar ?? "") \(loc.prayerDate?.hijri.year ?? "هـ")")
                        .font(.subheadline).foregroundColor(.gold)
                }
                Spacer()
                Image(systemName: "calendar").font(.title2).foregroundColor(.gold)
            }.padding(16)
        }.padding(.horizontal, 16)
    }

    private var nextPrayerCard: some View {
        GlassCard {
            VStack(spacing: 8) {
                if let next = loc.nextPrayer {
                    Text("الصلاة القادمة").font(.subheadline).foregroundColor(.textS)
                    Text(next.name).font(.system(size: 32, weight: .bold)).foregroundColor(.gold)
                    Text(next.time).font(.title).foregroundColor(.textP)
                }
            }.padding(20)
        }.padding(.horizontal, 16)
    }

    private var timingsList: some View {
        GlassCard {
            VStack(spacing: 0) {
                if let t = loc.prayerTimes {
                    PrayerRow(name: "الفجر", time: t.Fajr, isNext: loc.nextPrayer?.name == "الفجر")
                    Divider().padding(.horizontal, 16)
                    PrayerRow(name: "الشروق", time: t.Sunrise, isNext: loc.nextPrayer?.name == "الشروق")
                    Divider().padding(.horizontal, 16)
                    PrayerRow(name: "الظهر", time: t.Dhuhr, isNext: loc.nextPrayer?.name == "الظهر")
                    Divider().padding(.horizontal, 16)
                    PrayerRow(name: "العصر", time: t.Asr, isNext: loc.nextPrayer?.name == "العصر")
                    Divider().padding(.horizontal, 16)
                    PrayerRow(name: "المغرب", time: t.Maghrib, isNext: loc.nextPrayer?.name == "المغرب")
                    Divider().padding(.horizontal, 16)
                    PrayerRow(name: "العشاء", time: t.Isha, isNext: loc.nextPrayer?.name == "العشاء")
                }
            }.padding(.vertical, 8)
        }.padding(.horizontal, 16)
    }

    private var statsRow: some View {
        HStack(spacing: 12) {
            if let t = loc.prayerTimes {
                StatCard(icon: "sunrise", title: "بين الفجر والشروق", value: diff(t.Fajr, t.Sunrise), color: .gold)
                StatCard(icon: "sun.max", title: "بين الظهر والعصر", value: diff(t.Dhuhr, t.Asr), color: .gold)
            }
        }.padding(.horizontal, 16)
    }

    private var hijriCard: some View {
        GlassCard {
            HStack {
                Image(systemName: "moon.stars").font(.title2).foregroundColor(.gold)
                Text("التاريخ الهجري: \(loc.prayerDate?.hijri.date ?? "")").font(.headline).foregroundColor(.textP)
                Spacer()
            }.padding(16)
        }.padding(.horizontal, 16)
    }

    private func diff(_ t1: String, _ t2: String) -> String {
        let f = DateFormatter(); f.dateFormat = "HH:mm"
        guard let d1 = f.date(from: t1), let d2 = f.date(from: t2) else { return "-" }
        let sec = d2.timeIntervalSince(d1)
        let h = Int(sec) / 3600; let m = (Int(sec) % 3600) / 60
        return "\(h)س \(m)د"
    }
}
