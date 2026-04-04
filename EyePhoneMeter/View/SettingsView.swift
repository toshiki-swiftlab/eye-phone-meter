import SwiftUI

struct SettingsView: View {
    @Environment(\.scenePhase) private var scenePhase
    
    @AppStorage(UserDefaults.Keys.goalValue) private var goalValue = 30
    @State private var isTimerToggleOn: Bool?
    
    @State private var notificationError: NotificationError?
    @State private var notificationErrorAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("計測") {
                    Picker("目標値", selection: $goalValue, content: {
                        ForEach(20...100, id: \.self, content: { n in
                            Text("\(n)cm")
                                .tag(n)
                        })
                    })
                }
                Section("タイマー") {
                    HStack {
                        Text("20分の繰り返しタイマー")
                        Spacer()
                        if let isOn = Binding($isTimerToggleOn) {
                            Toggle("", isOn: isOn)
                                .onChange(of: isOn.wrappedValue) { _, newValue in
                                    onTimerToggleChange(newValue)
                                }
                        } else {
                            ProgressView()
                        }
                    }
                }
                Section {
                    Link("お問い合わせ", destination: URL(string: "https://forms.gle/2XKtw71deWyNV3oD9")!)
                }
                Section {
                    Link("利用規約", destination: URL(string: "https://www.notion.so/319ba9d52164803facf4dc0b40e8c1e2")!)
                    Link("プライバシーポリシー", destination: URL(string: "https://www.notion.so/319ba9d521648025846dc45c302ef691")!)
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
        .task {
            task()
        }
        .onChange(of: scenePhase) { _, newValue in
            onScenePhaseChange(newValue)
        }
        .alert(
            isPresented: $notificationErrorAlert,
            error: notificationError,
            actions: { error in
                switch error {
                case .authorization:
                    Link("通知を許可", destination: URL(string: UIApplication.openNotificationSettingsURLString)!)
                    Button("閉じる", role: .close, action: {})
                default:
                    Button("閉じる", role: .close, action: {})
                }
            }, message: { error in
                Text(error.message ?? "エラーが発生しました。")
            }
        )
    }
    
    // MARK: - Life Cycle
    
    private func task() {
        syncToggleWithNotification()
    }
    
    private func onScenePhaseChange(_ newValue: ScenePhase) {
        if newValue == .active {
            syncToggleWithNotification()
        }
    }
    
    private func syncToggleWithNotification() {
        Task {
            isTimerToggleOn = nil
            let isPending = await NotificationManager.shared.getIs20mRepeatPending()
            isTimerToggleOn = isPending
        }
    }
    
    // MARK: - Action
    
    private func onTimerToggleChange(_ newValue: Bool) {
        if newValue {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    private func startTimer() {
        Task {
            do {
                let isAuthorized = try await UserNotificationManager.shared.requestAuthorization()
                if !isAuthorized {
                    isTimerToggleOn = false
                    notificationError = .authorization
                    notificationErrorAlert = true
                    return
                }
                try await UserNotificationManager.shared.add20mRepeatNotification()
                isTimerToggleOn = true
            } catch {
                notificationError = .adding(message: error.localizedDescription)
                notificationErrorAlert = true
            }
        }
    }
    
    private func stopTimer() {
        UserNotificationManager.shared.remove20mRepeatNotification()
        isTimerToggleOn = false
    }
}

#Preview {
    SettingsView()
}

enum NotificationError: LocalizedError {
    case adding(message: String)
    case authorization
    
    // タイトル
    var errorDescription: String? {
        switch self {
        case .adding(_):
            return "通知作成エラー"
        case .authorization:
            return "通知の許可がOFFです"
        }
    }
    
    var message: String? {
        switch self {
        case .adding(let message):
            return message
        case .authorization:
            return "設定アプリを開いて、通知を許可してください"
        }
    }
}
