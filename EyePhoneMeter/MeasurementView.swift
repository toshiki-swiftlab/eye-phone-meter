import SwiftUI
import RealityKit

struct MeasurementView: View {
    @Environment(ARSessionManager.self) private var sessionManager
    
    var body: some View {
        ARViewContainer(sessionManager: sessionManager)
    }
}

#Preview {
    MeasurementView()
}
