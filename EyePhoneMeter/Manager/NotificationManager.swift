import UserNotifications

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    private override init() {}
    static let shared = NotificationManager()
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        switch response.actionIdentifier {
        case NotificationActionID.stopTimer:
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [NotificationID.repeat20m])
        default:
            break
        }
    }
    
    // TODO: フォアグラウンド対応
    
}
