import SwiftUI
import ARKit
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    let sessionManager: ARSessionManager
    
    func makeUIView(context: Context) -> some UIView {
        // 内部的にARSessionを生成
        let arView = ARView(frame: .zero)
        arView.session.delegate = sessionManager
        // Faceにすることで内カメラ推奨になる
        let config = ARFaceTrackingConfiguration()
        arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
