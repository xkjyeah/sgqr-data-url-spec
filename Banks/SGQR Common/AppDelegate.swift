class AppDelegate: NSObject, UIApplicationDelegate {
    @Published var incomingFileURL: URL?

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("App opened with file: \(url)")
        incomingFileURL = url
        return true
    }
}