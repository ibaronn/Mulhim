import SwiftUI

extension View {
    func glass(cornerRadius: CGFloat = 16) -> some View {
        self
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(Color.gold.opacity(0.2), lineWidth: 1))
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}

extension Color {
    static let gold = Color(red: 0.82, green: 0.62, blue: 0.12)
    static let goldLight = Color(red: 0.92, green: 0.77, blue: 0.30)
    static let bg = Color(red: 0.96, green: 0.97, blue: 0.98)
    static let card = Color.white
    static let textP = Color(red: 0.10, green: 0.10, blue: 0.15)
    static let textS = Color(red: 0.45, green: 0.45, blue: 0.55)
    static let blueStart = Color(red: 0.85, green: 0.92, blue: 0.98)
    static let blueEnd = Color(red: 0.95, green: 0.97, blue: 1.0)

    static var bgGradient: LinearGradient {
        LinearGradient(colors: [.blueStart, .blueEnd], startPoint: .top, endPoint: .bottom)
    }
}
