import UserNotifications

final class UserNotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    private override init() {}
    static let shared = UserNotificationManager()
    
    func requestAuthorization() async throws -> Bool {
        let isAuthorized = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .providesAppNotificationSettings])
        return isAuthorized
    }
    
    func add20mRepeatNotification() async throws {
        // category
        let category = UNNotificationCategory(
            identifier: UserNotificationCategoryID.timer,
            actions: [UNNotificationAction(identifier: UserNotificationActionID.stopTimer, title: "タイマー停止", icon: UNNotificationActionIcon(systemImageName: "stop.circle"))],
            intentIdentifiers: []
        )
        UNUserNotificationCenter.current().setNotificationCategories([category])
        // request
        let content = UNMutableNotificationContent()
        content.title = "20分経過"
        content.body = "目を休める時間です！🌱"
        content.categoryIdentifier = UserNotificationCategoryID.timer
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60 * 20, repeats: true)
        let request = UNNotificationRequest(identifier: UserNotificationID.repeat20m, content: content, trigger: trigger)
        try await UNUserNotificationCenter.current().add(request)
    }
    
    func remove20mRepeatNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [UserNotificationID.repeat20m])
    }
    
    func getIs20mRepeatPending(completion: @escaping (_ isPending: Bool) -> Void) {
        // async/awaitタイプでは、onChange(scenePhaseに限り、謎のクラッシュが発生した。
        UNUserNotificationCenter.current().getPendingNotificationRequests { notificationRequests in
            let isPending = notificationRequests.contains(where: { $0.identifier == UserNotificationID.repeat20m })
            completion(isPending)
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.sound, .banner, .list]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        switch response.actionIdentifier {
        case UserNotificationActionID.stopTimer:
            remove20mRepeatNotification()
        default:
            break
        }
    }
    
}
