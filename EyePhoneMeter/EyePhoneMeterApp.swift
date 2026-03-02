import SwiftUI

@main
struct EyePhoneMeterApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            MeasurementView()
                .task {
                    await CameraAccessManager.shared.requestAccessIfNeeded()
                }
        }
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active {
                CameraAccessManager.shared.updateStatus()
            }
        }
    }
}
