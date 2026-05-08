import SwiftUI

enum MulhimTab: String, CaseIterable {
    case prayer = "clock.arrow.2.circlepath"
    case qibla = "location.north.line"
    case quran = "book"
    case azkar = "sparkles"

    var title: String {
        switch self {
        case .prayer: return "الصلاة"
        case .qibla: return "القبلة"
        case .quran: return "القرآن"
        case .azkar: return "الأذكار"
        }
    }
}

struct ContentView: View {
    @State private var selected: MulhimTab = .prayer
    @State private var showSplash = true
    @EnvironmentObject private var locationVM: LocationViewModel

    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()
            if showSplash { splash }
            else {
                VStack(spacing: 0) {
                    Group {
                        switch selected {
                        case .prayer: PrayerTimesView()
                        case .qibla: QiblaView()
                        case .quran: QuranView()
                        case .azkar: AzkarView()
                        }
                    }
                    tabBar
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                withAnimation(.easeOut(duration: 0.4)) { showSplash = false }
            }
        }
    }

    private var splash: some View {
        VStack(spacing: 16) {
            Image(systemName: "mosque").font(.system(size: 72)).foregroundColor(.gold)
            Text("ملهم").font(.system(size: 38, weight: .bold, design: .rounded)).foregroundColor(.textP)
            Text("القبلة • الصلاة • القرآن • الأذكار").font(.headline).foregroundColor(.textS)
        }
    }

    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(MulhimTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.easeOut(duration: 0.2)) { selected = tab }
                } label: {
                    VStack(spacing: 3) {
                        Image(systemName: tab.rawValue).font(.system(size: 18)).frame(height: 20)
                        Text(tab.title).font(.system(size: 10)).fontWeight(selected == tab ? .bold : .regular)
                    }
                    .frame(maxWidth: .infinity).padding(.vertical, 8)
                    .background(selected == tab ? Color.gold.opacity(0.12) : nil, in: RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)
                .foregroundColor(selected == tab ? .gold : .textS)
            }
        }
        .padding(.horizontal, 8).padding(.vertical, 5)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(.gold.opacity(0.15), lineWidth: 1))
        .shadow(color: .black.opacity(0.05), radius: 8)
        .padding(.horizontal, 12).padding(.bottom, 8)
    }
}
