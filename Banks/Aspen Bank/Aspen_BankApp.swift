//
//  Aspen_BankApp.swift
//  Aspen Bank
//
//  Created by Daniel Sim on 21/7/25.
//

import SwiftUI
import SGQR_Common

@main
struct Aspen_BankApp: App {
    @State private var document: SGQRDocument = SGQRDocument(text: "0005Empty")
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView(document: $document, bankName: "Aspen Bank", fileURL: nil, color: Color(.sRGB, red: 0.9, green: 0.9, blue: 1.0))
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
