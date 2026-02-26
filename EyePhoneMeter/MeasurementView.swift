import SwiftUI
import RealityKit

struct MeasurementView: View {
    @Environment(ARSessionManager.self) private var sessionManager
    
    var body: some View {
        VStack {
            if sessionManager.distance <= 0 {
                Text("測定不能")
            } else {
                Text(String(sessionManager.distance))
            }
            ARViewContainer(sessionManager: sessionManager)
                .aspectRatio(3 / 4, contentMode: .fit)
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    MeasurementView()
}
