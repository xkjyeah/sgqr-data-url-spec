import SwiftUI
import SGQR_Common

@main
struct Birch_BankApp: App {
    @State private var document: SGQRDocument = SGQRDocument(text: "0005Birch")
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView(document: $document, bankName: "Birch Bank", fileURL: nil, color: Color(.sRGB, red: 1.0, green: 0.9, blue: 0.9))
                .onAppear {
                    self.appDelegate.setDocumentUpdater {
                        self.document = SGQRDocument(text: $0)
                    }
                }
                .onOpenURL { url in
                    handleURL(url)
                }
        }
    }
    
    func handleURL(_ url: URL) {
        let data = try! Data(contentsOf: url)
        document = SGQRDocument(text: String(data: data, encoding: .utf8) ?? "0007INVALID")
    }
}
