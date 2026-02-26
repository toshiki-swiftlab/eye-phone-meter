import ARKit
import Observation

@Observable
final class ARSessionManager: NSObject, ARSessionDelegate {
    var distance = 0
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard let faceAnchor = anchors.first(where: { $0 is ARFaceAnchor }) as? ARFaceAnchor else { return }
        
        let position = faceAnchor.transform.columns.3
        let currentDistance = sqrt(pow(position.x, 2) + pow(position.y, 2) + pow(position.z, 2))
        
        self.distance = Int(currentDistance * 100)
    }
}
