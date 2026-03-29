import SwiftUI

struct SettingsView: View {
    
    @Environment(\.openURL) private var openURL
    
    @AppStorage(UserDefaults.Keys.goalValue) private var goalValue = 30
    
    @State private var isTimerToggleOn = false
    
    @State private var errorAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("目標値") {
                    Picker(
                        "",
                        selection: $goalValue,
                        content: {
                            ForEach(20...100, id: \.self, content: { n in
                                Text("\(n)cm")
                                    .tag(n)
                            })
                        }
                    )
                }
                Section("タイマー") {
                    Toggle("20分の繰り返しタイマー", isOn: $isTimerToggleOn)
                        .onChange(of: isTimerToggleOn) { _, newValue in
                            if newValue {
                                // 通知をオン
                                onStopButton()
                            } else {
                                // 通知をオフ
                                onStopButton()
                            }
                        }
                }
                Section {
                    Button("お問い合わせ") {
                        let urlString = "https://forms.gle/2XKtw71deWyNV3oD9"
                        guard let url = URL(string: urlString) else { return }
                        if UIApplication.shared.canOpenURL(url) {
                            openURL(url)
                        }
                    }
                }
                Section {
                    Button("利用規約") {
                        let urlString = "https://www.notion.so/319ba9d52164803facf4dc0b40e8c1e2"
                        guard let url = URL(string: urlString) else { return }
                        if UIApplication.shared.canOpenURL(url) {
                            openURL(url)
                        }
                    }
                    Button("プライバシーポリシー") {
                        let urlString = "https://www.notion.so/319ba9d521648025846dc45c302ef691"
                        guard let url = URL(string: urlString) else { return }
                        if UIApplication.shared.canOpenURL(url) {
                            openURL(url)
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("免責事項")
                        .font(.headline)
                    Text("本アプリは医療機器ではありません。\n計測される距離は目安であり、正確性を保証するものではありません。\n目の不調を感じた場合は専門医にご相談ください。")
                        .font(.caption2)
                }
                .listRowBackground(Color.clear)
                .foregroundStyle(.gray)
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDragIndicator(.visible)
        .alert("エラー", isPresented: $errorAlert, actions: {}, message: {
            Text("通知の作成に失敗しました。")
        })
        .onAppear {
            onAppear()
        }
    }
    
    private func onAppear() {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            let isPending = requests.contains(where: { $0.identifier == NotificationID.repeat20m })
            self.isTimerToggleOn = isPending
        })
    }
    
    private func onStartButton() {
        Task {
            do {
                // 通知許可
                try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .providesAppNotificationSettings])
                // 通知作成
                let content = UNMutableNotificationContent()
                content.title = "20分経過"
                content.body = "目を休憩させましょう！🌱"
                content.categoryIdentifier = "20m-repeat-category"
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
                let request = UNNotificationRequest(identifier: NotificationID.repeat20m, content: content, trigger: trigger)
                let category = UNNotificationCategory(
                    identifier: "20m-repeat-category",
                    actions: [UNNotificationAction(identifier: NotificationActionID.stopTimer, title: "タイマーを停止")],
                    intentIdentifiers: ["timer"]
                )
                UNUserNotificationCenter.current().setNotificationCategories([category])
                try await UNUserNotificationCenter.current().add(request)
                isTimerToggleOn = true
            } catch {
                errorAlert = true
            }
        }
    }
    
    private func onStopButton() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [NotificationID.repeat20m])
        isTimerToggleOn = false
    }
}

#Preview {
    SettingsView()
}
