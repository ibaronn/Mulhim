import SwiftUI
import UIKit

// MARK: - Premium Card
struct PremiumCard<Content: View>: View {
    var cornerRadius: CGFloat = 20
    @Environment(\.colorScheme) var cs
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(cs == .dark ? Color.cardDark : Color.cardLight, in: RoundedRectangle(cornerRadius: cornerRadius))
            .background(.regularMaterial.opacity(0.65), in: RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(LinearGradient(colors: [Color.gold.opacity(0.2), Color.gold.opacity(0.06), .clear],
                        startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1))
            .shadow(color: Color.greenIslamic.opacity(0.04), radius: 12, x: 0, y: 4)
    }
}

// MARK: - Tasbih Counter
struct TasbihCounter: View {
    let preset: TasbihPreset
    @ObservedObject var tracker: DailyTracker

    @State private var count = 0
    @State private var pressed = false

    var isComplete: Bool { count >= preset.target }

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 2) {
                Text(preset.name).font(.system(size: 16, weight: .bold)).foregroundColor(.textDark)
                if isComplete {
                    Text("أكملت ✓").font(.caption).foregroundColor(.greenCompleted)
                }
            }

            Spacer()

            Text("\(count)").font(.system(size: 20, weight: .bold, design: .monospaced))
                .foregroundColor(isComplete ? .greenCompleted : .textDark)

            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                pressed = true
                if count < preset.target {
                    count += 1
                    var counts = tracker.today.tasbihCounts
                    counts[preset.name] = count
                    tracker.today.tasbihCounts = counts
                    tracker.save()
                    if count >= preset.target {
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                    }
                } else {
                    count = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { pressed = false }
            } label: {
                ZStack {
                    Circle().fill(Color.greenIslamic).frame(width: 44, height: 44)
                        .scaleEffect(pressed ? 0.85 : 1)
                    Text("ت").font(.system(size: 18, weight: .bold)).foregroundColor(.gold)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .background(Color.textDark.opacity(0.02), in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(isComplete ? Color.greenCompleted.opacity(0.3) : Color.gold.opacity(0.06), lineWidth: 1))
        .onAppear {
            count = tracker.today.tasbihCounts[preset.name] ?? 0
        }
    }
}

// MARK: - Zikr Card (with green completion)
struct ZikrCardView: View {
    let item: ZikrItem
    @ObservedObject var tracker: DailyTracker
    @State private var count = 0
    @State private var animate = false

    var isComplete: Bool { count >= item.count }

    var body: some View {
        VStack(spacing: 12) {
            Text(item.text).font(.system(size: 16)).multilineTextAlignment(.center)
                .foregroundColor(isComplete ? .greenCompleted : .textDark).lineSpacing(6)

            if let d = item.description {
                Text(d).font(.system(size: 13)).foregroundColor(.textMuted)
            }

            HStack(spacing: 14) {
                // Progress
                HStack(spacing: 6) {
                    ZStack {
                        Circle().stroke(Color.gold.opacity(0.15), lineWidth: 3).frame(width: 24, height: 24)
                        Circle().trim(from: 0, to: min(CGFloat(count) / CGFloat(item.count), 1))
                            .stroke(isComplete ? Color.greenCompleted : Color.gold,
                                    style: StrokeStyle(lineWidth: 3, lineCap: .round))
                            .frame(width: 24, height: 24).rotationEffect(.degrees(-90))
                            .animation(.easeOut(duration: 0.2), value: count)
                    }
                    Text("\(count)/\(item.count)").font(.system(size: 13, weight: .medium, design: .monospaced))
                        .foregroundColor(isComplete ? .greenCompleted : .textMuted)
                }

                Spacer()

                Button {
                    animate = true
                    if count < item.count {
                        count += 1
                        if count >= item.count {
                            tracker.toggleZikr(item.id)
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                        }
                    } else {
                        count = 0
                        tracker.toggleZikr(item.id)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { animate = false }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: isComplete ? "checkmark.circle.fill" : "hand.point.up.fill")
                            .font(.system(size: 14))
                        Text(isComplete ? "أكملت" : "تسبيح").font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(.white).padding(.horizontal, 16).padding(.vertical, 9)
                    .background(isComplete ? Color.greenCompleted : Color.greenIslamic, in: RoundedRectangle(cornerRadius: 10))
                    .scaleEffect(animate ? 0.92 : 1)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .background(Color.textDark.opacity(0.02), in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(isComplete ? Color.greenCompleted.opacity(0.25) : Color.gold.opacity(0.06), lineWidth: 1))
        .onAppear { count = tracker.isZikrCompleted(item.id) ? item.count : 0 }
    }
}

// MARK: - Sunnah Row
struct SunnahRow: View {
    let item: SunnahItem
    @ObservedObject var tracker: DailyTracker
    var isOn: Bool { tracker.isSunnahCompleted(item.id) }

    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            tracker.toggleSunnah(item.id)
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isOn ? Color.greenCompleted : Color.textMuted.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    if isOn {
                        Image(systemName: "checkmark").font(.system(size: 12, weight: .bold)).foregroundColor(.greenCompleted)
                    }
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.name).font(.system(size: 16, weight: .medium)).foregroundColor(.textDark)
                    Text(item.description).font(.caption).foregroundColor(.textMuted)
                }

                Spacer()

                Text(isOn ? "أكملت" : "").font(.caption).foregroundColor(.greenCompleted)
            }
            .padding(14)
            .background(isOn ? Color.greenCompleted.opacity(0.05) : Color.clear, in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Holiday Banner
struct HolidayBanner: View {
    var body: some View {
        let holidays = daysUntilNextHoliday()
        if let first = holidays.first {
            PremiumCard {
                HStack(spacing: 14) {
                    Text(first.0.icon).font(.system(size: 32))
                    VStack(alignment: .leading, spacing: 4) {
                        Text(first.0.name).font(.system(size: 18, weight: .bold)).foregroundColor(.greenIslamic)
                        HStack(spacing: 4) {
                            Text("متبقي").font(.subheadline).foregroundColor(.textMuted)
                            Text("\(first.1)").font(.system(size: 20, weight: .bold)).foregroundColor(.gold)
                            Text("يوم").font(.subheadline).foregroundColor(.textMuted)
                        }
                    }
                    Spacer()
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - Daily Progress
struct DailyProgressCard: View {
    @ObservedObject var tracker: DailyTracker
    let totalItems: Int

    var progress: CGFloat {
        guard totalItems > 0 else { return 0 }
        return CGFloat(tracker.today.totalCompleted) / CGFloat(totalItems)
    }

    var body: some View {
        PremiumCard {
            VStack(spacing: 10) {
                HStack {
                    Text("تقدم اليوم").font(.system(size: 16, weight: .bold)).foregroundColor(.textDark)
                    Spacer()
                    Text("\(tracker.today.totalCompleted)/\(totalItems)").font(.system(size: 14, weight: .medium)).foregroundColor(.textMuted)
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6).fill(Color.gold.opacity(0.12)).frame(height: 10)
                        RoundedRectangle(cornerRadius: 6)
                            .fill(LinearGradient(colors: [Color.greenIslamic, Color.greenCompleted], startPoint: .leading, endPoint: .trailing))
                            .frame(width: geo.size.width * min(progress, 1), height: 10)
                            .animation(.easeOut(duration: 0.4), value: progress)
                    }
                }.frame(height: 10)
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Aya Card (for Quran)
struct AyaCard: View {
    let ayah: Ayah
    var body: some View {
        VStack(spacing: 8) {
            Text(ayah.text).font(.system(size: 22)).multilineTextAlignment(.center)
                .foregroundColor(.textDark).lineSpacing(8)
            Text("\(ayah.number)").font(.caption).foregroundColor(.textMuted)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.gold.opacity(0.04), in: RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Prayer Row Premium
struct PrayerRowPremium: View {
    let name: String
    let time: String
    let isNext: Bool
    var icon: String

    @State private var animateIn = false

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(isNext ? .gold : .textMuted)
                .frame(width: 36, height: 36)
                .background(isNext ? Color.gold.opacity(0.12) : Color.textMuted.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(name)
                .font(.system(size: 16, weight: isNext ? .bold : .regular))
                .foregroundColor(isNext ? .greenIslamic : .textDark)

            Spacer()

            Text(time)
                .font(.system(size: 17, weight: .semibold, design: .monospaced))
                .foregroundColor(.textDark)

            if isNext {
                Text("التالي")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.greenIslamic, in: RoundedRectangle(cornerRadius: 6))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            isNext
                ? Color.greenIslamic.opacity(0.04)
                : Color.clear,
            in: RoundedRectangle(cornerRadius: 12)
        )
        .opacity(animateIn ? 1 : 0)
        .offset(x: animateIn ? 0 : -20)
        .animation(.easeOut(duration: 0.3).delay(animationDelay), value: animateIn)
        .onAppear { animateIn = true }
    }

    private var animationDelay: Double {
        let order = ["الفجر", "الشروق", "الظهر", "العصر", "المغرب", "العشاء"]
        if let idx = order.firstIndex(of: name) {
            return Double(idx) * 0.05
        }
        return 0
    }
}

// MARK: - Category Picker
struct CategoryPicker: View {
    let categories: [ZikrCategory]
    @Binding var selected: ZikrCategory

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories, id: \.rawValue) { cat in
                    Button {
                        withAnimation(.easeOut(duration: 0.25)) { selected = cat }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: cat.icon).font(.system(size: 12))
                            Text(cat.rawValue).font(.system(size: 13, weight: selected == cat ? .bold : .regular))
                        }
                        .foregroundColor(selected == cat ? .white : .textDark)
                        .padding(.horizontal, 14).padding(.vertical, 8)
                        .background(selected == cat ? Color.greenIslamic : Color.gold.opacity(0.08), in: RoundedRectangle(cornerRadius: 20))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}
