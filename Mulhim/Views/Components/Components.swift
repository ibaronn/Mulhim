import SwiftUI

struct GlassCard<Content: View>: View {
    let content: Content
    var cornerRadius: CGFloat = 16
    init(cornerRadius: CGFloat = 16, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius; self.content = content()
    }
    var body: some View { content.glass(cornerRadius: cornerRadius) }
}

struct StatCard: View {
    let icon: String; let title: String; let value: String; let color: Color
    var body: some View {
        GlassCard {
            VStack(spacing: 8) {
                Image(systemName: icon).font(.title2).foregroundColor(color)
                Text(title).font(.caption).foregroundColor(.textS)
                Text(value).font(.title3).bold().foregroundColor(.textP)
            }.padding(12).frame(maxWidth: .infinity)
        }
    }
}

struct PrayerRow: View {
    let name: String; let time: String; let isNext: Bool
    var body: some View {
        HStack {
            Text(name).font(.headline).foregroundColor(.textP)
            Spacer()
            Text(time).font(.title3).fontWeight(.bold).foregroundColor(isNext ? .gold : .textP)
            if isNext {
                Text("التالي").font(.caption).bold().foregroundColor(.white).padding(.horizontal, 8).padding(.vertical, 3)
                    .background(Color.gold, in: RoundedRectangle(cornerRadius: 6))
            }
        }
        .padding(.horizontal, 16).padding(.vertical, 10)
        .background(isNext ? Color.gold.opacity(0.08) : .clear, in: RoundedRectangle(cornerRadius: 10))
    }
}

struct ZikrCard: View {
    let zikr: Zikr
    @State private var count = 0
    var body: some View {
        GlassCard {
            VStack(spacing: 12) {
                Text(zikr.text).font(.body).multilineTextAlignment(.center).foregroundColor(.textP).padding(.top, 4)
                if let d = zikr.description {
                    Text(d).font(.caption).foregroundColor(.textS)
                }
                HStack {
                    Text("\(count)/\(zikr.count)").font(.caption).foregroundColor(.textS)
                    Spacer()
                    Button {
                        withAnimation(.easeOut(duration: 0.15)) {
                            if count < zikr.count { count += 1 } else { count = 0 }
                        }
                    } label: {
                        Text("تسبيح").font(.caption).bold().foregroundColor(.white).padding(.horizontal, 16).padding(.vertical, 8)
                            .background(Color.gold, in: RoundedRectangle(cornerRadius: 10))
                    }.buttonStyle(.plain)
                }
            }.padding(16)
        }
    }
}
