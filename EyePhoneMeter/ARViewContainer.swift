import SwiftUI
import ARKit
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    let sessionManager: ARSessionManager
    
    func makeUIView(context: Context) -> some UIView {
        let arView = ARView(frame: .zero)
        arView.session.delegate = sessionManager
        let config = ARFaceTrackingConfiguration()
        arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
