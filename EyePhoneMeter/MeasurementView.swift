import SwiftUI
import RealityKit

struct MeasurementView: View {
    @Environment(ARSessionManager.self) private var sessionManager
    
    var body: some View {
        ARViewContainer(sessionManager: sessionManager)
            .aspectRatio(3 / 4, contentMode: .fit)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    MeasurementView()
}
