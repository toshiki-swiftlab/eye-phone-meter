import SwiftUI

struct SettingsView: View {
    
    @Environment(\.openURL) private var openURL
    
    @AppStorage(UserDefaults.Keys.goalValue) private var goalValue = 30
    
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
                Section {
                    Button("お問い合わせ") {
                        let urlString = "https://forms.gle/2XKtw71deWyNV3oD9"
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
    }
}

#Preview {
    SettingsView()
}
