import AppIntents

struct AppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        return [
            AppShortcut(
                intent: OpenAppIntent(),
                phrases: [
                    "\(.applicationName)で顔の距離を測定",
                ],
                shortTitle: "アプリを開く2",
                systemImageName: "eyes"
            )
        ]
    }
}
