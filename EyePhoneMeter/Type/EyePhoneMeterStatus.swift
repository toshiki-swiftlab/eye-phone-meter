enum EyePhoneMeterStatus {
    case normal
    case multiplePeople
    case notTracking
    
    // NOTE: アクションプランにする
    var description: String? {
        switch self {
        case .normal: return nil
        case .multiplePeople: return "正確な測定のため、1人で写って下さい！"
        case .notTracking: return "顔を正面に向けて下さい！"
        }
    }
}
