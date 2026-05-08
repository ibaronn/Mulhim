import SwiftUI

@main
struct MulhimApp: App {
    @StateObject private var locationVM = LocationViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationVM)
                .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
