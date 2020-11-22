import SwiftUI

public struct AboutRow: View {
    var title: String
    var accessibilityTitle: String

    /// A view for about description.
    /// - Parameters:
    ///   - title: The title of the row. For example, the title can be "Made with ❤️ by Rudrank Riyam".
    ///   - accessibilityTitle: The accessibility label for the row.
    ///   For example, the label can be "Made with love by Rudrank Riyam".
    public init(title: String, accessibilityTitle: String) {
        self.title = title
        self.accessibilityTitle = accessibilityTitle
    }

    public var body: some View {
        Text(title.uppercased())
            .font(.caption)
            .kerning(1)
            .frame(minWidth: 100, maxWidth: .infinity, alignment: .center)
            .accessibility(label: Text(accessibilityTitle))
            .padding(.top)
    }
}

public struct TwitterRow: View {
    var imageName: String
    var title: String
    var twitterAppURL: String
    var twitterWebURL: String

    /// A view for making the user write a review of the app on the store.
    /// - Parameters:
    ///   - imageName: The icon for the settings row.
    ///   - title: The title of the settings row.
    ///   - twitterAppURL: The deeplink to directly open in the Twitter app.
    ///   - twitterWebURL: The link to open in the browser if the app is not available.
    public init(imageName: String, title: String, twitterAppURL: String, twitterWebURL: String) {
        self.title = title
        self.imageName = imageName
        self.twitterAppURL = twitterAppURL
        self.twitterWebURL = twitterWebURL
    }

    public var body: some View {
        SettingsRow(imageName: imageName, title: title, action: {
            openTwitter(appURL: twitterAppURL, webURL: twitterWebURL)
        })
    }

    private func openTwitter(appURL: String, webURL: String) {
        if let appURL = URL(string: appURL), UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            guard let webURL = URL(string: webURL) else { return }
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        }
    }
}

public struct WriteReviewRow: View {
    var imageName: String
    var title: String
    var appURL: String

    /// A view for making the user write a review of the app on the store.
    /// - Parameters:
    ///   - imageName: The icon for the settings row.
    ///   - title: The title of the settings row.
    ///   - appURL: The URL of the app.
    public init(imageName: String = "pencil.and.outline", title: String = "Write a review", appURL: String) {
        self.title = title
        self.imageName = imageName
        self.appURL = appURL
    }

    public var body: some View {
        SettingsRow(imageName: imageName, title: title, action: {
            writeReview(appURL: appURL)
        })
    }

    private func writeReview(appURL: String) {
        guard let url = URL(string: appURL) else { return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "action", value: "write-review")]
        guard let writeReviewURL = components?.url else { return }
        UIApplication.shared.open(writeReviewURL)
    }
}

public struct AppVersionRow: View {
    var imageName: String = "info.circle"
    var title: String = "App version"
    var version: String

    /// The row which tells the user the app version of your application
    /// - Parameters:
    ///   - imageName: The icon for the app version row. The default is `info.circle`.
    ///   - title: The tile for the app version row. The default is `App version`.
    ///   - version: The version of your app.
    public init(imageName: String = "info.circle", title: String = "App version", version: String) {
        self.imageName = imageName
        self.title = title
        self.version = version
    }

    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: imageName).customIconImage()
            Text(title)
            Spacer()
            Text(version).bold()
        }
        .accessibilityElement(children: .combine)
        .padding(.vertical, 10)
        .settingsBackground()
    }
}

public struct SettingsRow: View {
    var imageName: String
    var title: String
    var action: () -> ()

    /// A generic settings row which can be customised according to your needs.
    /// - Parameters:
    ///   - imageName: The icon for the settings row.
    ///   - title: The title of the settings row.
    ///   - action: The custom action that you want to perform on tapping the row.
    public init(imageName: String, title: String, action: @escaping () -> ()) {
        self.imageName = imageName
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: imageName).customIconImage()
                Text(title).kerning(1)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding(.vertical, 10)
            .settingsBackground()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

extension View {
    func customIconImage() -> ModifiedContent<Self, CustomImageModifier> {
        return modifier(CustomImageModifier())
    }

    func settingsBackground(cornerRadius: CGFloat = 16, innerPadding: CGFloat = 8, outerBottomPadding: CGFloat = 6) -> some View {
        self
            .padding(.horizontal)
            .padding(.vertical, innerPadding)
            .background(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(Color(.secondarySystemBackground)))
            .padding(.bottom, outerBottomPadding)
            .padding(.horizontal)
    }
}

struct CustomImageModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .font(.headline)
            .frame(minWidth: 25, alignment: .leading)
            .accessibility(hidden: true)
    }
}