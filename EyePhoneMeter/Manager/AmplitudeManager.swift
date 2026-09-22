import AmplitudeSwift

final class AmplitudeManager {
    
    // 外部からの意図しないインスタンス化を防止
    private init() {}
    
    // アプリ全体で1つのAmplitudeインスタンスを保持
    static var amplitude: Amplitude?
    
    static func initAmplitude() {
        let AMPLITUDE_API_KEY = Secrets.amplitudeAPIKey
        amplitude = Amplitude(configuration: Configuration(
            apiKey: AMPLITUDE_API_KEY,
            autocapture: [
                .sessions,
                .appLifecycles,
                .screenViews,
                .elementInteractions,
                .networkTracking,
                .frustrationInteractions
            ]
        ))
    }
    
    static func trackEvent(eventName: String) {
        let event = BaseEvent(eventType: eventName)
        amplitude?.track(event: event)
    }
}
