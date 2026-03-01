import SwiftUI
import ARKit
import RealityKit

struct MeasurementView: View {
    
    @State private var eyePhoneMeter = EyePhoneMeter()
    
    @State private var settingsView = false
    
    var body: some View {
        if ARFaceTrackingConfiguration.isSupported {
            VStack {
                Spacer()
                switch eyePhoneMeter.status {
                case .good, .tooClose:
                    Text(eyePhoneMeter.status.description)
                        .padding()
                        .background(eyePhoneMeter.status.color.opacity(0.3))
                        .clipShape(.capsule)
                        .foregroundStyle(eyePhoneMeter.status.color)
                        .bold()
                    Text("判定：およそ\(eyePhoneMeter.distance)cm")
                        .foregroundStyle(.secondary)
                case .multiplePeople, .notTracking:
                    Text(eyePhoneMeter.status.description)
                        .font(.headline)
                }
                Spacer()
                ARViewContainer(eyePhoneMeter: eyePhoneMeter)
                    .aspectRatio(3 / 4, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                HStack {
                    Spacer()
                    Button(
                        action: onGearButton,
                        label: {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 24))
                                .padding(8)
                        }
                    )
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    Spacer()
                }
                .padding(.vertical)
            }
            .sheet(isPresented: $settingsView) {
                SettingsView()
                    .presentationDetents([.medium, .large])
            }
        } else {
            Text("ご利用の端末ではTrueDepthカメラが搭載されていません。")
        }
    }
    
    private func onGearButton() {
        settingsView = true
    }
}

#Preview {
    MeasurementView()
}
