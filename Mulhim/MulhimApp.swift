import SwiftUI

@main
struct MulhimApp: App {
    @StateObject private var locationVM = LocationViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationVM)
                .environment(\.layoutDirection, .rightToLeft)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
