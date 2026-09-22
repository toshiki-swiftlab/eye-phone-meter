import SwiftUI

@main
struct EyePhoneMeterApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        AmplitudeManager.initAmplitude()
        AmplitudeManager.trackEvent(eventName: "Log In")
    }
    
    var body: some Scene {
        WindowGroup {
            MeasurementView()
                .preferredColorScheme(.dark)
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
