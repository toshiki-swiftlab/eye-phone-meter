import Observation
import AVFoundation

@Observable
final class CameraAccessManager {
    
    private init() {}
    static let shared = CameraAccessManager()
    
    var status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
    
    @MainActor
    func updateStatus() {
        status = AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    func requestAccessIfNeeded() async {
        if AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined {
            await AVCaptureDevice.requestAccess(for: .video)
            updateStatus()
        }
    }
}
