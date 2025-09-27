
import UIKit
import Social

open class BaseShareController: UIViewController {
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let attachment = extensionContext?.inputItems.flatMap { item in
            (item.self  as? NSExtensionItem)?.attachments ?? []
        }.first(where: { attachment in
            attachment.hasItemConformingToTypeIdentifier("sg.gov.mas.sgqr-data")
        })
        
        if let attachment = attachment {
            attachment.loadItem(forTypeIdentifier: "sg.gov.mas.sgqr-data") { (item, error) in
                let parsedItems = item.flatMap({ $0 as? URL})
                    .flatMap { try? Data(contentsOf: $0) }
                    .flatMap({ String(data: $0, encoding: .utf8) })
                    .flatMap {DataParser(str: $0)}
                
                if parsedItems == nil {
                    self.postFailureNotification(error: "Invalid payment data format (E2)")
                } else {
                    self.postNotificationFromExtension(paymentData: parsedItems!)
                }
                
                self.close()
                print("This should have ended here 1")
            }
        } else {
            self.postFailureNotification(error: "No valid payment data found (E1)")
            self.close()
            print("This should have ended here 2")
            return
        }
    }
    
    
    private func close() {
        DispatchQueue.main.async {
            print("Closing!!")
            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        }
    }
    
    func postFailureNotification(error: String) {
        let content = UNMutableNotificationContent()
        content.title = appName()
        content.body = "Unable to complete payment -- \(error)"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil // nil = deliver immediately
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error posting notification: \(error)")
            }
        }
    }
    
    func postNotificationFromExtension(paymentData: DataParser) {
        let recipient = paymentData.get("26", "02") ?? "(Unknown recipient)"
        
        let content = UNMutableNotificationContent()
        content.title = appName()
        content.body = "Tap here to complete payment to \(recipient)!"
        content.sound = .default
        content.userInfo = ["paymentData": paymentData.rawString]

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil // nil = deliver immediately
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error posting notification: \(error)")
            }
        }
    }
    
    open func appName() -> String {
        fatalError("Override appName() in subclasses")
    }

}
