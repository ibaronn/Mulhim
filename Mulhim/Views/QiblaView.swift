import SwiftUI
import CoreLocation

struct QiblaView: View {
    @EnvironmentObject private var loc: LocationViewModel
    @State private var rotation: Double = 0
    @State private var appear = false
    @State private var wasFacingQibla = false

    private let qiblaThreshold: Double = 4

    private var isFacingQibla: Bool {
        let diff = abs((loc.qiblaDirection + rotation).truncatingRemainder(dividingBy: 360))
        return diff < qiblaThreshold || diff > (360 - qiblaThreshold)
    }

    private var activeColor: Color { isFacingQibla ? .greenIslamic : .gold }
    private var activeColorOpacity: Double { isFacingQibla ? 0.35 : 0.15 }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                SectionHeader(title: "اتجاه القبلة", subtitle: "حدد اتجاهك نحو الكعبة المشرفة")
                    .padding(.top, 12)

                if loc.authStatus == .denied || loc.authStatus == .restricted {
                    locationNeeded
                } else if loc.location == nil {
                    loadingView
                } else {
                    compassCard
                    directionCard
                }
            }
            .padding(.bottom, 24)
        }
        .background(AppBackground())
        .onReceive(loc.$heading) { h in
            if let h = h {
                withAnimation(.linear(duration: 0.3)) {
                    rotation = -h.trueHeading
                }
                checkQiblaAlignment()
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) { appear = true }
        }
    }

    private func checkQiblaAlignment() {
        let facing = isFacingQibla
        if facing && !wasFacingQibla {
            let impact = UIImpactFeedbackGenerator(style: .rigid)
            impact.impactOccurred(intensity: 0.7)
        }
        wasFacingQibla = facing
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
            Text("جاري تحديد موقعك...")
                .font(.system(size: 15))
                .foregroundColor(.textMuted)
            Spacer().frame(height: 100)
        }
    }

    // MARK: - Compass Card
    private var compassCard: some View {
        PremiumCard {
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial.opacity(0.8))
                        .frame(width: 270, height: 270)
                        .overlay(
                            Circle()
                                .stroke(activeColor.opacity(activeColorOpacity), lineWidth: 1.5)
                        )

                    if isFacingQibla {
                        Circle()
                            .stroke(Color.greenIslamic.opacity(0.08), lineWidth: 12)
                            .frame(width: 310, height: 310)
                            .scaleEffect(appear ? 1 : 0.85)
                    }

                    TickMarks(activeColor: activeColor, isAligned: isFacingQibla)
                        .frame(width: 250, height: 250)

                    Group {
                        Text("N").font(.system(size: 13, weight: .bold)).foregroundColor(.textMuted).offset(y: -120)
                        Text("S").font(.system(size: 13, weight: .bold)).foregroundColor(.textMuted).offset(y: 120)
                        Text("W").font(.system(size: 13, weight: .bold)).foregroundColor(.textMuted).offset(x: -120)
                        Text("E").font(.system(size: 13, weight: .bold)).foregroundColor(.textMuted).offset(x: 120)
                    }

                    QiblaArrow(direction: loc.qiblaDirection, isAligned: isFacingQibla)
                        .rotationEffect(.degrees(loc.qiblaDirection))

                    Circle()
                        .fill(activeColor)
                        .frame(width: 10, height: 10)
                        .shadow(color: activeColor.opacity(0.4), radius: isFacingQibla ? 10 : 4)

                    if isFacingQibla {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.greenIslamic)
                            .offset(y: 110)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .rotationEffect(.degrees(rotation))
                .animation(.easeOut(duration: 0.3), value: rotation)
                .scaleEffect(appear ? 1 : 0.85)
                .opacity(appear ? 1 : 0)
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Direction Card
    private var directionCard: some View {
        PremiumCard {
            VStack(spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: isFacingQibla ? "checkmark.circle.fill" : "location.north.line")
                        .font(.system(size: 18))
                        .foregroundColor(activeColor)
                    Text(isFacingQibla ? "أنت تتجه إلى القبلة" : "اتجاه القبلة")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.textMuted)
                }

                HStack(spacing: 6) {
                    Image(systemName: "location.north.line")
                        .font(.system(size: 20))
                        .foregroundColor(activeColor)
                    Text("\(loc.qiblaDirection, specifier: "%.1f")°")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(isFacingQibla ? .greenIslamic : .greenIslamic)
                }

                Text("بالنسبة للشمال الحقيقي")
                    .font(.system(size: 13))
                    .foregroundColor(.textMuted)

                Text(directionName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(activeColor)
                    .padding(.top, 4)
            }
        }
        .padding(.horizontal, 40)
        .animation(.easeOut(duration: 0.3), value: isFacingQibla)
    }

    private var directionName: String {
        let d = loc.qiblaDirection
        switch d {
        case 0..<22.5, 337.5...360: return "شمال"
        case 22.5..<67.5: return "شمال شرقي"
        case 67.5..<112.5: return "شرق"
        case 112.5..<157.5: return "جنوب شرقي"
        case 157.5..<202.5: return "جنوب"
        case 202.5..<247.5: return "جنوب غربي"
        case 247.5..<292.5: return "غرب"
        case 292.5..<337.5: return "شمال غربي"
        default: return "-"
        }
    }
}

// MARK: - Tick Marks
struct TickMarks: View {
    var activeColor: Color = .gold
    var isAligned: Bool = false

    var body: some View {
        GeometryReader { geo in
            let r = geo.size.width / 2
            ForEach(0..<72) { i in
                let angle = Double(i) * 5
                let isMajor = i % 6 == 0
                Rectangle()
                    .fill(isMajor ? activeColor.opacity(isAligned ? 0.5 : 0.4) : Color.textMuted.opacity(0.2))
                    .frame(width: isMajor ? 2 : 1, height: isMajor ? 14 : 8)
                    .offset(y: r - 16 - (isMajor ? 14 : 8) / 2)
                    .rotationEffect(.degrees(angle))
            }
        }
    }
}

// MARK: - Qibla Arrow
struct QiblaArrow: View {
    let direction: Double
    var isAligned: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "location.north.fill")
                .font(.system(size: 32))
                .foregroundColor(isAligned ? .greenIslamic : .gold)
                .shadow(color: (isAligned ? Color.greenIslamic : Color.gold).opacity(0.4), radius: isAligned ? 12 : 8, x: 0, y: 2)
            Spacer()
        }
        .frame(height: 80)
    }
}


