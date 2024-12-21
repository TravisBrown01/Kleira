import SwiftUI

struct AppItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let iconName: String
    let url: URL
}

struct MoreAppsView: View {
    let apps = [
        AppItem(
            name: NSLocalizedString("App Name 1", bundle: .main, comment: ""),
            description: NSLocalizedString("Description of the first app", bundle: .main, comment: ""),
            iconName: "app1Icon",
            url: URL(string: "https://apps.apple.com/app/id1234567890")!
        ),
        AppItem(
            name: NSLocalizedString("App Name 2", bundle: .main, comment: ""),
            description: NSLocalizedString("Description of the second app", bundle: .main, comment: ""),
            iconName: "app2Icon",
            url: URL(string: "https://apps.apple.com/app/id0987654321")!
        )
    ]
    
    var body: some View {
        List(apps) { app in
            Link(destination: app.url) {
                HStack {
                    Image(app.iconName)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .cornerRadius(12)
                    
                    VStack(alignment: .leading) {
                        Text(app.name)
                            .font(.headline)
                        Text(app.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle(Text("More Apps", bundle: .main))
        .navigationBarTitleDisplayMode(.inline)
    }
} 