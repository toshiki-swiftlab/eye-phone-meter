import UserNotifications

final class UserNotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    private override init() {}
    static let shared = UserNotificationManager()
    
    func requestAuthorization() async throws -> Bool {
        let isAuthorized = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .providesAppNotificationSettings])
        return isAuthorized
    }
    
    func add20mRepeatNotification() async throws {
        let content = UNMutableNotificationContent()
        content.title = "20分経過"
        content.body = "目を休憩させましょう！🌱"
        content.categoryIdentifier = NotificationCategoryID.timer
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60 * 20, repeats: true)
        let request = UNNotificationRequest(identifier: NotificationID.repeat20m, content: content, trigger: trigger)
        let category = UNNotificationCategory(
            identifier: NotificationCategoryID.timer,
            actions: [UNNotificationAction(identifier: NotificationActionID.stopTimer, title: "タイマーを停止")],
            intentIdentifiers: [NotificationIntentID.timer]
        )
        UNUserNotificationCenter.current().setNotificationCategories([category])
        try await UNUserNotificationCenter.current().add(request)
    }
    
    func remove20mRepeatNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [NotificationID.repeat20m])
    }
    
    func getIs20mRepeatPending(completion: @escaping (_ isPending: Bool) -> Void) {
        // async/awaitタイプでは、onChange(scenePhaseに限り、謎のクラッシュが発生した。
        UNUserNotificationCenter.current().getPendingNotificationRequests { notificationRequests in
            let isPending = notificationRequests.contains(where: { $0.identifier == NotificationID.repeat20m })
            completion(isPending)
        }
    }
    
    // MARK: UNUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        switch response.actionIdentifier {
        case NotificationActionID.stopTimer:
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [NotificationID.repeat20m])
        default:
            break
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.sound, .banner, .list]
    }
    
}
