import SwiftUI
import ARKit
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    let eyePhoneMeter: EyePhoneMeter
    
    func makeUIView(context: Context) -> some UIView {
        // 内部的にARSessionを生成
        let arView = ARView(frame: .zero)
        arView.session.delegate = eyePhoneMeter
        // Faceにすることで内カメラ推奨になる
        let config = ARFaceTrackingConfiguration()
        config.worldAlignment = .camera
        config.maximumNumberOfTrackedFaces = ARFaceTrackingConfiguration.supportedNumberOfTrackedFaces
        arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
