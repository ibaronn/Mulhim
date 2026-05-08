import SwiftUI

// MARK: - Color Palette
extension Color {
    static let greenIslamic = Color(red: 0.11, green: 0.26, blue: 0.15)
    static let greenDark = Color(red: 0.07, green: 0.18, blue: 0.10)
    static let gold = Color(red: 0.83, green: 0.69, blue: 0.22)
    static let goldLight = Color(red: 0.93, green: 0.82, blue: 0.40)
    static let goldPale = Color(red: 0.95, green: 0.90, blue: 0.70)

    static let creamBg = Color(red: 0.98, green: 0.96, blue: 0.93)
    static let warmWhite = Color(red: 0.99, green: 0.98, blue: 0.96)

    static let textDark = Color(uiColor: UIColor {
        $0.userInterfaceStyle == .dark ? UIColor(red: 0.92, green: 0.92, blue: 0.90, alpha: 1) : UIColor(red: 0.12, green: 0.14, blue: 0.13, alpha: 1)
    })
    static let textMuted = Color(uiColor: UIColor {
        $0.userInterfaceStyle == .dark ? UIColor(red: 0.65, green: 0.65, blue: 0.62, alpha: 1) : UIColor(red: 0.50, green: 0.52, blue: 0.50, alpha: 1)
    })
    static let textLight = Color(red: 0.85, green: 0.87, blue: 0.85)

    static let cardLight = Color.white.opacity(0.7)
    static let cardDark = Color(red: 0.15, green: 0.18, blue: 0.16).opacity(0.7)
}

// MARK: - Background Patterns
struct IslamicPattern: View {
    var opacity: Double = 0.06
    var color: Color = .gold

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            ZStack {
                ForEach(0..<3) { i in
                    Circle()
                        .stroke(color.opacity(opacity), lineWidth: 1)
                        .frame(width: size * 0.7 - CGFloat(i) * 80, height: size * 0.7 - CGFloat(i) * 80)
                        .rotationEffect(.degrees(Double(i) * 15))
                }
                ForEach(0..<6) { i in
                    let angle = Double(i) * 60
                    DiamondShape()
                        .stroke(color.opacity(opacity), lineWidth: 1)
                        .frame(width: size * 0.15, height: size * 0.15)
                        .rotationEffect(.degrees(angle))
                        .offset(x: size * 0.28 * cos(angle.radians),
                                y: size * 0.28 * sin(angle.radians))
                }
                ForEach(0..<8) { i in
                    let angle = Double(i) * 45
                    Capsule()
                        .stroke(color.opacity(opacity * 0.5), lineWidth: 0.5)
                        .frame(width: size * 0.35, height: 1)
                        .rotationEffect(.degrees(angle))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        p.closeSubpath()
        return p
    }
}

// MARK: - Glass Modifier
extension View {
    func glass(cornerRadius: CGFloat = 20, inDarkMode: Bool = false) -> some View {
        self.background(
            inDarkMode
                ? Color.cardDark
                : Color.cardLight,
            in: RoundedRectangle(cornerRadius: cornerRadius)
        )
        .background(
            inDarkMode
                ? .ultraThinMaterial.opacity(0.6)
                : .regularMaterial.opacity(0.7),
            in: RoundedRectangle(cornerRadius: cornerRadius)
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    LinearGradient(colors: [
                        Color.gold.opacity(0.3),
                        Color.gold.opacity(0.1),
                        Color.gold.opacity(0.05),
                    ], startPoint: .topLeading, endPoint: .bottomTrailing),
                    lineWidth: 1
                )
        )
        .shadow(
            color: Color.greenIslamic.opacity(0.06),
            radius: 12, x: 0, y: 4
        )
    }

    func glassButton() -> some View {
        self
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.gold.opacity(0.2), lineWidth: 1)
            )
    }

    func safeHover() -> some View {
        self
    }
}

// MARK: - View Transitions
extension AnyTransition {
    static var slideUp: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .bottom).combined(with: .opacity)
        )
    }

    static var fadeScale: AnyTransition {
        .asymmetric(
            insertion: .scale(scale: 0.92).combined(with: .opacity),
            removal: .scale(scale: 0.92).combined(with: .opacity)
        )
    }
}

// MARK: - Dynamic Background View
struct AppBackground: View {
    @Environment(\.colorScheme) var colorScheme
    var showPattern: Bool = true

    var body: some View {
        ZStack {
            (colorScheme == .dark ? Color.greenDark : Color.creamBg)
                .ignoresSafeArea()

            if showPattern {
                IslamicPattern(
                    opacity: colorScheme == .dark ? 0.08 : 0.05,
                    color: colorScheme == .dark ? .gold : .greenIslamic
                )
                .ignoresSafeArea()
            }

            LinearGradient(
                colors: [
                    Color.gold.opacity(colorScheme == .dark ? 0.03 : 0.02),
                    Color.clear,
                    Color.greenIslamic.opacity(colorScheme == .dark ? 0.05 : 0.01),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        }
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.textDark)
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
}

// MARK: - Animations
struct PulseEffect: AnimatableModifier {
    var scale: CGFloat

    var animatableData: CGFloat {
        get { scale }
        set { scale = newValue }
    }

    func body(content: Content) -> some View {
        content.scaleEffect(scale)
    }
}

// MARK: - Double Extension for radians
extension Double {
    var radians: Double { self * .pi / 180 }
    var degrees: Double { self * 180 / .pi }
}
