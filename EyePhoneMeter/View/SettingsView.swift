import SwiftUI

struct SettingsView: View {
    @AppStorage(UserDefaults.Keys.goalValue) private var goalValue = 30
    @State private var isTimerToggleOn: Bool?
    
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
        .alert("エラー", isPresented: $notificationErrorAlert, actions: {}, message: {
            Text("通知の作成に失敗しました。")
        })
    }
    
    // MARK: - Life Cycle
    
    private func task() {
        Task {
            let isPending = await NotificationManager.shared.getIs20mRepeatPending()
            self.isTimerToggleOn = isPending
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
                try await NotificationManager.shared.requestAuthorization()
                try await NotificationManager.shared.add20mRepeatNotification()
                isTimerToggleOn = true
            } catch {
                notificationErrorAlert = true
            }
        }
    }
    
    private func stopTimer() {
        NotificationManager.shared.remove20mRepeatNotification()
        isTimerToggleOn = false
    }
}

#Preview {
    SettingsView()
}
