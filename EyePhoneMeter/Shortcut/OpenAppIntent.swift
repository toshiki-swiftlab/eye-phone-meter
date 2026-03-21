import AppIntents

struct OpenAppIntent: AppIntent {
    static var title: LocalizedStringResource = "アプリを開く"
    static var description = IntentDescription("「目とスマホ」アプリを起動します。")
    
    static var supportedModes: IntentModes {
        return .foreground
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
