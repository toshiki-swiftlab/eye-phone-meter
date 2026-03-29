import SwiftUI

@main
struct EyePhoneMeterApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        UNUserNotificationCenter.current().delegate = NotificationManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab(
                    content: {
                        MeasurementView()
                            .preferredColorScheme(.dark)
                            .task {
                                await CameraAccessManager.shared.requestAccessIfNeeded()
                            }
                    },
                    label: {
                        Label("計測", systemImage: "eyes")
                    }
                )
                Tab(
                    content: {
                        SettingsView()
                    },
                    label: {
                        Label("その他", systemImage: "gearshape")
                    }
                )
            }
        }
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active {
                CameraAccessManager.shared.updateStatus()
            }
        }
    }
}
