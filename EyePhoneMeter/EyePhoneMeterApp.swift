import SwiftUI

@main
struct EyePhoneMeterApp: App {
    @State private var arSessionMnager = ARSessionManager()
    
    var body: some Scene {
        WindowGroup {
            MeasurementView()
                .environment(arSessionMnager)
        }
    }
}
