import SwiftUI
import CoreLocation

struct QiblaView: View {
    @EnvironmentObject private var loc: LocationViewModel
    @State private var rotation: Double = 0

    var body: some View {
        VStack(spacing: 0) {
            header
            Spacer()
            if loc.authStatus == .denied || loc.authStatus == .restricted {
                locationNeeded
            } else if loc.location == nil {
                loading
            } else {
                compassView
                directionInfo
            }
            Spacer()
        }
        .background(Color.bgGradient.overlay(Color.bg))
        .onReceive(loc.$heading) { h in
            if let h = h {
                withAnimation(.linear(duration: 0.3)) {
                    rotation = -h.trueHeading
                }
            }
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("اتجاه القبلة").font(.title).bold().foregroundColor(.textP)
                Text("حدد اتجاهك نحو الكعبة").font(.subheadline).foregroundColor(.textS)
            }
            Spacer()
        }.padding(.horizontal, 16).padding(.top, 8)
    }

    private var locationNeeded: some View {
        VStack(spacing: 12) {
            Image(systemName: "location.slash").font(.system(size: 44)).foregroundColor(.gold)
            Text("الرجاء السماح بالوصول إلى الموقع").font(.headline).foregroundColor(.textP)
            Button { loc.requestPermission() } label: {
                Text("السماح بالموقع").font(.headline).foregroundColor(.white).padding(.horizontal, 24).padding(.vertical, 12)
                    .background(Color.gold, in: RoundedRectangle(cornerRadius: 12))
            }.buttonStyle(.plain)
        }
    }

    private var loading: some View {
        VStack(spacing: 12) {
            ProgressView().tint(.gold)
            Text("جاري تحديد موقعك...").foregroundColor(.textS)
        }
    }

    private var compassView: some View {
        ZStack {
            // Compass background
            Circle().fill(Color.white).frame(width: 280, height: 280)
                .shadow(color: .black.opacity(0.06), radius: 20)

            Circle().stroke(Color.gold.opacity(0.15), lineWidth: 2).frame(width: 260, height: 260)

            // Direction markers
            ForEach(0..<72) { i in
                Rectangle().fill(i % 6 == 0 ? Color.textP : Color.textS.opacity(0.3))
                    .frame(width: i % 6 == 0 ? 2 : 1, height: i % 6 == 0 ? 14 : 8)
                    .offset(y: -125)
                    .rotationEffect(.degrees(Double(i) * 5))
            }

            // N S E W labels
            Text("N").font(.caption).bold().foregroundColor(.textS).offset(y: -140)
            Text("S").font(.caption).bold().foregroundColor(.textS).offset(y: 140)
            Text("W").font(.caption).bold().foregroundColor(.textS).offset(x: -140)
            Text("E").font(.caption).bold().foregroundColor(.textS).offset(x: 140)

            // Qibla arrow (fixed, pointing to Qibla direction)
            Image(systemName: "location.north.fill")
                .font(.system(size: 36))
                .foregroundColor(.gold)
                .rotationEffect(.degrees(loc.qiblaDirection))
                .shadow(color: .gold.opacity(0.3), radius: 8)

            // Center dot
            Circle().fill(Color.gold).frame(width: 8, height: 8)
        }
        .rotationEffect(.degrees(rotation))
        .animation(.easeOut(duration: 0.3), value: rotation)
    }

    private var directionInfo: some View {
        VStack(spacing: 8) {
            Text("اتجاه القبلة").font(.headline).foregroundColor(.textP)
            Text("\(loc.qiblaDirection, specifier: "%.1f")°").font(.system(size: 42, weight: .bold)).foregroundColor(.gold)
            Text("بالنسبة للشمال الحقيقي").font(.caption).foregroundColor(.textS)
        }
        .padding(20).glass(cornerRadius: 20)
        .padding(.horizontal, 40)
    }
}
