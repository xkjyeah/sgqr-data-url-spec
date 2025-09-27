//
//  NotificationDelegate.swift
//  SGQR Common
//
//  Created by Daniel Sim on 26/9/25.
//

import Foundation
import SwiftUI

public class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var documentUpdater: ((String) -> Void)?
    var queuedUpdates: [String] = []
    
    public func setDocumentUpdater(updater: @escaping ((String) -> Void)) {
        documentUpdater = updater
        queuedUpdates.forEach(updater)
        queuedUpdates.removeAll()
    }

    public func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Set the UNUserNotificationCenter delegate
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                print("Granted")
        }
        return true
    }
    
    // Handle notifications when app is in foreground
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    // Handle notification tap
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let paymentData = response.notification.request.content.userInfo["paymentData"]
        print("Got payment data \(paymentData)")
        if let documentUpdater = documentUpdater {
            documentUpdater(paymentData as! String)
        } else {
            queuedUpdates.append(paymentData as! String)
        }
        completionHandler()
    }
}
