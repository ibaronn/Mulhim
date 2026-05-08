import SwiftUI

enum MulhimTab: String, CaseIterable {
    case prayer = "clock.arrow.2.circlepath"
    case qibla = "location.north.line"
    case azkar = "sparkles"

    var title: String {
        switch self {
        case .prayer: return "الصلاة"
        case .qibla: return "القبلة"
        case .azkar: return "الأذكار"
        }
    }

    var icon: String { rawValue }
}

struct ContentView: View {
    @State private var selected: MulhimTab = .prayer
    @State private var showSplash = true
    @State private var splashPhase = SplashPhase.first
    @AppStorage("isDarkMode") private var isDarkMode = false
    @EnvironmentObject private var locationVM: LocationViewModel

    enum SplashPhase { case first, second, done }

    var body: some View {
        ZStack {
            AppBackground()

            if showSplash {
                splashView
                    .transition(.opacity)
                    .zIndex(1)
            } else {
                mainView
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeOut(duration: 0.5)) { splashPhase = .second }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeOut(duration: 0.5)) {
                    showSplash = false
                }
            }
        }
    }

    // MARK: - Splash
    private var splashView: some View {
        VStack(spacing: 24) {
            Spacer()

            ZStack {
                IslamicPattern(opacity: 0.12, color: .gold)
                    .frame(width: 200, height: 200)

                Image(systemName: "mosque")
                    .font(.system(size: 72))
                    .foregroundColor(.gold)
                    .symbolRenderingMode(.hierarchical)
                    .opacity(splashPhase == .first ? 0 : 1)
                    .scaleEffect(splashPhase == .first ? 0.5 : 1)
                    .animation(.easeOut(duration: 0.6).delay(0.1), value: splashPhase)
            }

            VStack(spacing: 8) {
                Text("ملهم")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundColor(.greenIslamic)
                    .opacity(splashPhase == .second ? 1 : 0)
                    .offset(y: splashPhase == .second ? 0 : 20)
                    .animation(.easeOut(duration: 0.5).delay(0.2), value: splashPhase)

                Text("القبلة • الصلاة • الأذكار")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.textMuted)
                    .opacity(splashPhase == .second ? 1 : 0)
                    .offset(y: splashPhase == .second ? 0 : 15)
                    .animation(.easeOut(duration: 0.5).delay(0.35), value: splashPhase)
            }

            Spacer()
        }
    }

    // MARK: - Main View
    private var mainView: some View {
        VStack(spacing: 0) {
            tabContent
            premiumTabBar
        }
    }

    @ViewBuilder
    private var tabContent: some View {
        Group {
            switch selected {
            case .prayer:
                PrayerTimesView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .bottom).combined(with: .opacity)
                    ))
            case .qibla:
                QiblaView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .bottom).combined(with: .opacity)
                    ))
            case .azkar:
                AzkarView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .bottom).combined(with: .opacity)
                    ))
            }
        }
        .animation(.easeOut(duration: 0.35), value: selected)
    }

    // MARK: - Premium Tab Bar
    private var premiumTabBar: some View {
        HStack(spacing: 0) {
            ForEach(MulhimTab.allCases, id: \.self) { tab in
                tabBarButton(tab)
            }

            Button {
                isDarkMode.toggle()
            } label: {
                Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                    .font(.system(size: 14))
                    .foregroundColor(isDarkMode ? .gold : .textMuted)
                    .frame(width: 36, height: 36)
                    .background(isDarkMode ? Color.gold.opacity(0.1) : Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
            .padding(.leading, 4)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 6)
        .background(.regularMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.gold.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: Color.greenIslamic.opacity(0.08), radius: 12, y: -4)
        .padding(.horizontal, 12)
        .padding(.bottom, 8)
    }

    private func tabBarButton(_ tab: MulhimTab) -> some View {
        Button {
            withAnimation(.easeOut(duration: 0.25)) { selected = tab }
        } label: {
            VStack(spacing: 4) {
                ZStack {
                    if selected == tab {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.greenIslamic.opacity(0.1))
                            .frame(width: 44, height: 36)
                    }
                    Image(systemName: tab.icon)
                        .font(.system(size: 18, weight: selected == tab ? .semibold : .regular))
                        .foregroundColor(selected == tab ? Color.greenIslamic : Color.textMuted)
                        .frame(height: 22)
                }

                Text(tab.title)
                    .font(.system(size: 10, weight: selected == tab ? .bold : .medium))
                    .foregroundColor(selected == tab ? Color.greenIslamic : Color.textMuted)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
