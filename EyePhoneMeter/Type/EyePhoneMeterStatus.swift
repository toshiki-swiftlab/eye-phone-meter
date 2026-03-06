import SwiftUI

enum EyePhoneMeterStatus {
    case good
    case tooClose
    case multiplePeople
    case notTracking
    
    var description: String {
        switch self {
        case .good: return "目標距離をクリア！"
        case .tooClose: return "近いです！"
        case .multiplePeople: return "正確な測定のため、1人で写って下さい。"
        case .notTracking: return "顔を正面に向けて下さい。"
        }
    }
    
    var color: Color {
        switch self {
        case .good:
            return .green
        case .tooClose:
            return .red
        case .multiplePeople:
            return .yellow
        case .notTracking:
            return .yellow
        }
    }
}
