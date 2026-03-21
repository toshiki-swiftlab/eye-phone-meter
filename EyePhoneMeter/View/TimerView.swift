import SwiftUI

struct TimerView: View {
    private let identifier = "20m-repeat"
    
    @State private var isOn: Bool?
    @State private var errorAlert = false
    
    var body: some View {
        Group {
            switch isOn {
            case .none:
                ProgressView()
                    .onAppear {
                        onAppear()
                    }
            case .some(false):
                Button(
                    action: onStartButton,
                    label: {
                        Label("20分の繰り返しタイマーを開始", systemImage: "play.fill")
                    }
                )
                .buttonStyle(.glassProminent)
                .buttonBorderShape(.capsule)
            case .some(true):
                Button(
                    action: onStopButton,
                    label: {
                        Label("20分の繰り返しタイマーを停止", systemImage: "stop.fill")
                    }
                )
                .buttonStyle(.glassProminent)
                .buttonBorderShape(.capsule)
            }
        }
        .alert("エラー", isPresented: $errorAlert, actions: {}, message: {
            Text("通知の作成に失敗しました。")
        })
    }
    
    private func onAppear() {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            let isPending = requests.contains(where: { $0.identifier == self.identifier })
            self.isOn = isPending
        })
    }
    
    private func onStartButton() {
        Task {
            do {
                try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .providesAppNotificationSettings])
                let content = UNMutableNotificationContent()
                content.title = "20分経過"
                content.body = "目を休憩させましょう！🌱"
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60 * 20, repeats: true)
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                try await UNUserNotificationCenter.current().add(request)
                isOn = true
            } catch {
                errorAlert = true
            }
        }
    }
    
    private func onStopButton() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        isOn = false
    }
}

#Preview {
    TimerView()
}
