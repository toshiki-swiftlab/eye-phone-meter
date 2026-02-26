import SwiftUI
import ARKit
import RealityKit

struct MeasurementView: View {
    @Environment(ARSessionManager.self) private var sessionManager
    
    var body: some View {
        // サポートしてないなら、終了
        if ARFaceTrackingConfiguration.isSupported {
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
        } else {
            Text("ご利用の端末ではTrueDepthカメラが搭載されていません。")
        }
    }
}

#Preview {
    MeasurementView()
}
