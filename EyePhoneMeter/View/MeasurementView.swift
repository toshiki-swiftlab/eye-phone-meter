import SwiftUI
import ARKit
import RealityKit

struct MeasurementView: View {
    
    @State private var eyePhoneMeter = EyePhoneMeter()
    
    var body: some View {
        if ARFaceTrackingConfiguration.isSupported {
            VStack {
                Spacer()
                switch eyePhoneMeter.status {
                case .good, .tooClose:
                    Text(eyePhoneMeter.status.description)
                        .font(.title)
                        .bold()
                        .foregroundStyle(eyePhoneMeter.status.color)
                    
                    Text("判定：およそ\(eyePhoneMeter.distance)cm")
                        .opacity(0.7)
                case .multiplePeople, .notTracking:
                    Text(eyePhoneMeter.status.description)
                        .padding()
                        .background(Color.yellow.opacity(0.3))
                        .clipShape(.capsule)
                        .foregroundStyle(.yellow)
                }
                Spacer()
                ARViewContainer(eyePhoneMeter: eyePhoneMeter)
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
