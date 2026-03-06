import SwiftUI
import ARKit
import RealityKit

struct MeasurementView: View {
    
    @Environment(\.openURL) private var openURL
    
    @State private var cameraManager = CameraAccessManager.shared
    
    var body: some View {
        if ARFaceTrackingConfiguration.isSupported {
            switch cameraManager.status {
            case .authorized:
                ContentView()
            case .denied:
                VStack(spacing: 16) {
                    UnavailableView(
                        systemIconName: "camera",
                        message: "カメラのアクセスを許可して下さい。"
                    )
                    Button(
                        action: {
                            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                            if UIApplication.shared.canOpenURL(url) {
                                openURL(url)
                            }
                        }, label: {
                            Label("設定を開く", systemImage: "gearshape")
                                .bold()
                        }
                    )
                }
            case .restricted:
                UnavailableView(
                    systemIconName: "camera",
                    message: "端末の設定により、カメラを使用できませんでした。"
                )
            case .notDetermined:
                ProgressView()
            default:
                ContentView()
            }
        } else {
            UnavailableView(
                systemIconName: "person.and.background.dotted",
                message: "ご利用のiPhone/iPadにはTrueDepthカメラが搭載されていません。"
            )
        }
    }
}

struct ContentView: View {
    
    @State private var eyePhoneMeter = EyePhoneMeter()
    
    @State private var settingsView = false
    @State private var isImpactOccurred = false
    
    var body: some View {
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
        .sensoryFeedback(.success, trigger: isImpactOccurred)
        .onChange(of: eyePhoneMeter.status) { oldValue, newValue in
            if (oldValue == .tooClose && newValue == .good) {
                isImpactOccurred.toggle()
            } else if (oldValue == .good && newValue == .tooClose) {
                isImpactOccurred.toggle()
            }
        }
        .sheet(isPresented: $settingsView) {
            SettingsView()
                .presentationDetents([.medium, .large])
        }
    }
    
    private func onGearButton() {
        settingsView = true
    }
}

struct UnavailableView: View {
    let systemIconName: String
    let message: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemIconName)
                .font(.system(size: 60))
            Text(message)
                .font(.system(size: 18))
                .bold()
        }
        .foregroundStyle(.secondary)
        .padding(.horizontal)
    }
}

#Preview {
    MeasurementView()
}
