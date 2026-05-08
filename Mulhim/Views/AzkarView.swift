import SwiftUI

enum WorshipsTab: String, CaseIterable {
    case azkar = "الأذكار"
    case duas = "الأدعية"
    case tasbih = "التسبيح"
    case sunnah = "السنن"
    case quran = "القرآن"
    case calendar = "التقويم"

    var icon: String {
        switch self {
        case .azkar: return "bookmark.fill"
        case .duas: return "hands.sparkles.fill"
        case .tasbih: return "circle.hexagongrid.fill"
        case .sunnah: return "mosque.fill"
        case .quran: return "book.fill"
        case .calendar: return "calendar"
        }
    }
}

struct AzkarView: View {
    @StateObject private var tracker = DailyTracker()
    @State private var selectedCategory: ZikrCategory = .morning
    @State private var selectedTab: WorshipsTab = .azkar
    @State private var showHistory = false

    private let allZikr = allZikrItems()

    private var filteredZikr: [ZikrItem] {
        allZikr.filter { $0.category == selectedCategory }
    }

    private var totalDailyItems: Int {
        allZikr.count + SunnahItem.all.count
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                SectionHeader(title: "العبادات", subtitle: "حصن نفسك بالذكر والعبادة")
                    .padding(.top, 12)

                // Top tabs
                topTabs

                // Content based on selected tab
                switch selectedTab {
                case .azkar:
                    azkarContent
                case .duas:
                    duasContent
                case .tasbih:
                    tasbihContent
                case .sunnah:
                    sunnahContent
                case .quran:
                    quranContent
                case .calendar:
                    calendarContent
                }

                // Daily progress (always visible)
                if selectedTab != .calendar {
                    DailyProgressCard(tracker: tracker, totalItems: totalDailyItems)
                }
            }
            .padding(.bottom, 24)
        }
        .background(AppBackground())
        .onChange(of: selectedTab) { _ in
            switch selectedTab {
            case .azkar: selectedCategory = .morning
            case .duas: selectedCategory = .sleep
            default: break
            }
        }
        .sheet(isPresented: $showHistory) { historySheet }
    }

    // MARK: - Top Tabs
    private var topTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(WorshipsTab.allCases, id: \.rawValue) { tab in
                    Button {
                        withAnimation(.easeOut(duration: 0.2)) { selectedTab = tab }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: tab.icon).font(.system(size: 16))
                            Text(tab.rawValue).font(.system(size: 11, weight: selectedTab == tab ? .bold : .regular))
                        }
                        .foregroundColor(selectedTab == tab ? .white : .textDark)
                        .padding(.horizontal, 14).padding(.vertical, 8)
                        .background(selectedTab == tab ? Color.greenIslamic : Color.gold.opacity(0.08), in: RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Azkar
    private var azkarContent: some View {
        VStack(spacing: 12) {
            CategoryPicker(categories: [.morning, .evening, .general], selected: $selectedCategory)

            PremiumCard {
                LazyVStack(spacing: 12) {
                    ForEach(filteredZikr) { item in
                        ZikrCardView(item: item, tracker: tracker)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Duas
    private var duasContent: some View {
        VStack(spacing: 12) {
            CategoryPicker(categories: [.sleep, .wake, .comprehensive], selected: $selectedCategory)

            PremiumCard {
                LazyVStack(spacing: 12) {
                    ForEach(filteredZikr) { item in
                        ZikrCardView(item: item, tracker: tracker)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Tasbih
    private var tasbihContent: some View {
        PremiumCard {
            VStack(spacing: 12) {
                ForEach(TasbihPreset.all) { preset in
                    TasbihCounter(preset: preset, tracker: tracker)
                }
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Sunnah
    private var sunnahContent: some View {
        PremiumCard {
            VStack(spacing: 0) {
                ForEach(SunnahItem.all) { item in
                    SunnahRow(item: item, tracker: tracker)
                }
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Quran (inline)
    private var quranContent: some View {
        QuranView()
            .frame(height: 400)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 16)
    }

    // MARK: - Calendar
    private var calendarContent: some View {
        VStack(spacing: 16) {
            HolidayBanner()

            PremiumCard {
                VStack(spacing: 12) {
                    HStack {
                        Text("الأعياد القادمة").font(.system(size: 16, weight: .bold)).foregroundColor(.textDark)
                        Spacer()
                    }
                    let holidays = daysUntilNextHoliday()
                    ForEach(holidays.prefix(5), id: \.0.id) { h, days in
                        HStack(spacing: 12) {
                            Text(h.icon).font(.system(size: 24))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(h.name).font(.system(size: 15, weight: .medium)).foregroundColor(.textDark)
                            }
                            Spacer()
                            if days == 0 {
                                Text("اليوم!").font(.system(size: 13, weight: .bold)).foregroundColor(.greenCompleted)
                            } else {
                                Text("\(days) يوم").font(.system(size: 13)).foregroundColor(.textMuted)
                            }
                        }
                        if h.id != holidays.prefix(5).last?.0.id {
                            Divider()
                        }
                    }
                }
            }
            .padding(.horizontal, 16)

            Button {
                showHistory = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("عرض الأيام السابقة")
                }
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.gold)
                .padding(12)
                .glassButtonStyle()
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - History Sheet
    private var historySheet: some View {
        NavigationStack {
            List {
                let past = tracker.historyForPastDays(30)
                ForEach(past, id: \.date) { record in
                    HStack {
                        Text(record.date).font(.system(size: 15, weight: .medium))
                        Spacer()
                        Text("\(record.totalCompleted)").font(.system(size: 15, weight: .bold)).foregroundColor(.greenCompleted)
                        Text("م complete").font(.caption).foregroundColor(.textMuted)
                    }
                }
            }
            .navigationTitle("الأيام السابقة")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Glass Button Style
extension View {
    func glassButtonStyle() -> some View {
        self.background(.regularMaterial.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gold.opacity(0.15), lineWidth: 1))
    }
}
