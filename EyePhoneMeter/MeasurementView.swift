import SwiftUI
import ARKit
import RealityKit

struct MeasurementView: View {
    
    @State private var eyePhoneMeter = EyePhoneMeter()
    
    var body: some View {
        if ARFaceTrackingConfiguration.isSupported {
            VStack {
                if eyePhoneMeter.distance <= 0 {
                    Text("測定不能")
                } else {
                    Text(String(eyePhoneMeter.distance))
                }
                ARViewContainer(sessionManager: eyePhoneMeter)
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
