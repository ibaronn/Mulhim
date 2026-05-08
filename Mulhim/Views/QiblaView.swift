import SwiftUI
import CoreLocation

struct QiblaView: View {
    @EnvironmentObject private var loc: LocationViewModel
    @State private var rotation: Double = 0
    @State private var appear = false
    @State private var wasFacingQibla = false

    private let threshold: Double = 4

    private var facingQibla: Bool {
        let diff = abs((loc.qiblaDirection + rotation).truncatingRemainder(dividingBy: 360))
        return diff < threshold || diff > (360 - threshold)
    }

    private var activeColor: Color { facingQibla ? .greenIslamic : .gold }
    private var activeOpacity: Double { facingQibla ? 0.4 : 0.12 }

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
                withAnimation(.linear(duration: 0.3)) { rotation = -h.trueHeading }
                checkAlignment()
            }
        }
        .onAppear { withAnimation(.easeOut(duration: 0.6)) { appear = true } }
    }

    private func checkAlignment() {
        if facingQibla && !wasFacingQibla {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred(intensity: 0.7)
        }
        wasFacingQibla = facingQibla
    }

    // MARK: - Location Needed
    private var locationNeeded: some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 40)
            Image(systemName: "location.slash").font(.system(size: 48)).foregroundColor(.gold).symbolRenderingMode(.hierarchical)
            Text("الرجاء السماح بالوصول إلى الموقع").font(.system(size: 18, weight: .bold, design: .rounded)).foregroundColor(.textDark)
            Button { loc.requestPermission() } label: {
                HStack(spacing: 8) {
                    Image(systemName: "location.fill")
                    Text("السماح بالموقع").fontWeight(.semibold)
                }.foregroundColor(.white).padding(.horizontal, 28).padding(.vertical, 14)
                    .background(Color.greenIslamic, in: RoundedRectangle(cornerRadius: 14))
                    .shadow(color: Color.greenIslamic.opacity(0.2), radius: 8, y: 4)
            }.buttonStyle(.plain)
            Spacer().frame(height: 80)
        }
    }

    // MARK: - Loading
    private var loadingView: some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 60)
            ProgressView().scaleEffect(1.2).tint(.gold)
            Text("جاري تحديد موقعك...").font(.system(size: 15)).foregroundColor(.textMuted)
            Spacer().frame(height: 100)
        }
    }

    // MARK: - Compass Card
    private var compassCard: some View {
        PremiumCard {
            VStack(spacing: 0) {
                ZStack {
                    // Outer glow ring when aligned
                    if facingQibla {
                        Circle().stroke(Color.greenIslamic.opacity(0.1), lineWidth: 14)
                            .frame(width: 300, height: 300)
                            .scaleEffect(appear ? 1 : 0.85)
                    }

                    // Compass background - more transparent (ultraThin)
                    Circle().fill(.ultraThinMaterial).frame(width: 260, height: 260)
                        .overlay(Circle().stroke(activeColor.opacity(activeOpacity), lineWidth: 2))

                    // Tick marks
                    TickView()
                        .frame(width: 240, height: 240)

                    // N/S/E/W labels inside border
                    Text("N").font(.system(size: 12, weight: .bold)).foregroundColor(.textMuted).offset(y: -112)
                    Text("S").font(.system(size: 12, weight: .bold)).foregroundColor(.textMuted).offset(y: 112)
                    Text("W").font(.system(size: 12, weight: .bold)).foregroundColor(.textMuted).offset(x: -112)
                    Text("E").font(.system(size: 12, weight: .bold)).foregroundColor(.textMuted).offset(x: 112)

                    // Qibla arrow
                    VStack(spacing: 0) {
                        Image(systemName: "location.north.fill").font(.system(size: 28))
                            .foregroundColor(activeColor)
                            .shadow(color: activeColor.opacity(0.5), radius: facingQibla ? 12 : 6, x: 0, y: 2)
                            .rotationEffect(.degrees(loc.qiblaDirection))
                        Spacer()
                    }
                    .frame(height: 70)

                    // Center dot
                    Circle().fill(activeColor).frame(width: 8, height: 8)
                        .shadow(color: activeColor.opacity(0.5), radius: 6)

                    // ✅ when aligned
                    if facingQibla {
                        Text("✓").font(.system(size: 28, weight: .bold)).foregroundColor(.greenCompleted)
                            .offset(y: 100)
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
            VStack(spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: facingQibla ? "checkmark.circle.fill" : "location.north.line")
                        .font(.system(size: 16)).foregroundColor(activeColor)
                    Text(facingQibla ? "أنت تتجه إلى القبلة" : "اتجاه القبلة")
                        .font(.system(size: 14, weight: .medium)).foregroundColor(.textMuted)
                }
                HStack(spacing: 4) {
                    Text("\(loc.qiblaDirection, specifier: "%.1f")°").font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundColor(.greenIslamic)
                }
                Text("بالنسبة للشمال الحقيقي").font(.system(size: 12)).foregroundColor(.textMuted)
                Text(directionName).font(.system(size: 15, weight: .semibold)).foregroundColor(activeColor).padding(.top, 2)
            }
        }
        .padding(.horizontal, 40)
        .animation(.easeOut(duration: 0.3), value: facingQibla)
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

struct TickView: View {
    var body: some View {
        GeometryReader { geo in
            let r = geo.size.width / 2
            ForEach(0..<72) { i in
                let a = Double(i) * 5
                let big = i % 6 == 0
                Rectangle()
                    .fill(big ? Color.textDark.opacity(0.3) : Color.textMuted.opacity(0.15))
                    .frame(width: big ? 1.5 : 0.5, height: big ? 12 : 6)
                    .offset(y: r - 10 - (big ? 12 : 6) / 2)
                    .rotationEffect(.degrees(a))
            }
        }
    }
}
