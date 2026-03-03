import ARKit
import Observation

@Observable
final class EyePhoneMeter: NSObject, ARSessionDelegate {
    var distance = 0
    var status: EyePhoneMeterStatus = .good
    
    // NOTE: 検証メモ
    // - 複数人映っても、anchors.count: 1
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        let faceAnchors = anchors.compactMap({ $0 as? ARFaceAnchor })
        if 2 <= faceAnchors.count {
            status = .multiplePeople
            distance = 0
            return
        }
        guard let faceAnchor = faceAnchors.first else { return }
        
        // カメラ外（anchors.countは0にならない）
        if !faceAnchor.isTracked {
            status = .notTracking
            distance = 0
            return
        }
        
        // カメラ → 顔の中心への行列（親）
        let cameraToFaceMatrix = faceAnchor.transform
        // 顔の中心 → 左目への行列（子）
        let faceToLeftEyeMatrix = faceAnchor.leftEyeTransform
        
        // カメラ → 左目への行列（親 * 子）
        let cameraToLeftEyeMatrix = cameraToFaceMatrix * faceToLeftEyeMatrix
        let _distance = abs(cameraToLeftEyeMatrix.columns.3.z)
        
        // UIを更新
        DispatchQueue.main.async {
            self.distance = Int(_distance * 100)
            let goalValue = UserDefaults.standard.object(forKey: UserDefaults.Keys.goalValue) as? Int ?? 30
            if goalValue <= self.distance {
                self.status = .good
            } else {
                self.status = .tooClose
            }
        }
    }
}
