import SwiftUI
import UIKit

// MARK: - Premium Glass Card
struct PremiumCard<Content: View>: View {
    var cornerRadius: CGFloat = 20
    @Environment(\.colorScheme) var colorScheme
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(colorScheme == .dark ? Color.cardDark : Color.cardLight, in: RoundedRectangle(cornerRadius: cornerRadius))
            .background(.regularMaterial.opacity(0.7), in: RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(colors: [
                            Color.gold.opacity(0.25),
                            Color.gold.opacity(0.08),
                            Color.gold.opacity(0.03),
                        ], startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.greenIslamic.opacity(0.06), radius: 12, x: 0, y: 4)
    }
}

// MARK: - Tasbih Counter Button
struct TasbihButton: View {
    let count: Int
    let total: Int
    let action: () -> Void

    @State private var pressed = false
    @State private var showPulse = false

    var body: some View {
        Button(action: {
            pressed = true
            showPulse = true
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            action()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                pressed = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showPulse = false
            }
        }) {
            ZStack {
                if showPulse {
                    Circle()
                        .stroke(Color.gold.opacity(0.3), lineWidth: 2)
                        .frame(width: 56, height: 56)
                        .scaleEffect(1.4)
                        .opacity(showPulse ? 0 : 1)
                        .animation(.easeOut(duration: 0.3), value: showPulse)
                }
                Circle()
                    .fill(Color.greenIslamic)
                    .frame(width: 48, height: 48)
                    .overlay(
                        Image(systemName: "hand.point.up.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.gold)
                    )
                    .scaleEffect(pressed ? 0.88 : 1)
                    .animation(.easeOut(duration: 0.15), value: pressed)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Circular Progress
struct CircularProgress: View {
    let progress: CGFloat
    var color: Color = .gold
    var lineWidth: CGFloat = 4

    var body: some View {
        Circle()
            .stroke(color.opacity(0.15), lineWidth: lineWidth)
            .overlay(
                Circle()
                    .trim(from: 0, to: min(progress, 1))
                    .stroke(
                        AngularGradient(
                            colors: [color.opacity(0.6), color, color.opacity(0.6)],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 0.3), value: progress)
            )
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

// MARK: - Category Card
struct CategoryCard: View {
    let category: ZikrCategory

    @State private var animateIn = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: category.icon)
                    .font(.system(size: 18))
                    .foregroundColor(.gold)
                    .frame(width: 38, height: 38)
                    .background(Color.gold.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                Text(category.name)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.greenIslamic)
            }

            ForEach(category.items) { zikr in
                ZikrCardPremium(zikr: zikr)
            }
        }
        .opacity(animateIn ? 1 : 0)
        .offset(y: animateIn ? 0 : 20)
        .animation(.easeOut(duration: 0.4).delay(animationDelay), value: animateIn)
        .onAppear { animateIn = true }
    }

    private var animationDelay: Double {
        let cats = azkarData
        if let idx = cats.firstIndex(where: { $0.id == category.id }) {
            return Double(idx) * 0.1
        }
        return 0
    }
}

// MARK: - Zikr Card Premium
struct ZikrCardPremium: View {
    let zikr: Zikr
    @State private var count = 0
    @State private var animateTap = false
    @State private var completed = false

    var body: some View {
        VStack(spacing: 14) {
            Text(zikr.text)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.textDark)
                .lineSpacing(6)
                .padding(.top, 4)
                .scaleEffect(animateTap ? 0.97 : 1)
                .animation(.easeOut(duration: 0.15), value: animateTap)

            if let desc = zikr.description {
                Text(desc)
                    .font(.system(size: 13))
                    .foregroundColor(.textMuted)
            }

            HStack(spacing: 16) {
                HStack(spacing: 6) {
                    CircularProgress(
                        progress: CGFloat(count) / CGFloat(zikr.count),
                        color: completed ? .greenIslamic : .gold
                    )
                    .frame(width: 28, height: 28)

                    Text("\(count)/\(zikr.count)")
                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                        .foregroundColor(completed ? .greenIslamic : .textMuted)
                }

                Spacer()

                TasbihButton(
                    count: count,
                    total: zikr.count,
                    action: {
                        animateTap = true
                        if count < zikr.count {
                            count += 1
                            if count >= zikr.count {
                                completed = true
                                UINotificationFeedbackGenerator().notificationOccurred(.success)
                            }
                        } else {
                            count = 0
                            completed = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            animateTap = false
                        }
                    }
                )
            }
        }
        .padding(16)
        .background(Color.textDark.opacity(0.02))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(completed ? Color.greenIslamic.opacity(0.2) : Color.gold.opacity(0.08), lineWidth: 1)
        )
    }
}
