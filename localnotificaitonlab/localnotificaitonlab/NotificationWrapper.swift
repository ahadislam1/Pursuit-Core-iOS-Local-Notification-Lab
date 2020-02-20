//
//  NotificationHelper.swift
//  localnotificaitonlab
//
//  Created by Ahad Islam on 2/20/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import UserNotifications

final class NotificationWrapper {
    static let helper = NotificationWrapper()
    private init() {}
    public func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> ()) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            completion(requests)
        }
    }
    
    public func createNotification(_ title: String, timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        
        let identifier = UUID().uuidString
        
        if let imageURL = Bundle.main.url(forResource: "pursuit-logo", withExtension: "png") {
            do {
            let attachment = try UNNotificationAttachment(identifier: identifier, url: imageURL, options: nil)
                content.attachments = [attachment]
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("IMAGE HAD A PROBLEM I REPEAT THE IMAGE HAD A PROBLEMMMMMMMM")
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding request: \(error)")
            } else {
                print("Request was successfully added.")
            }
        }
    }
    
    public func deleteNotification(_ identifier: String) {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    public func checkForNotificationsPermissions() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                print("App is authorized for notifications")
                
            } else {
                self.requestNotificationPermissions()
            }
        }
    }
    
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print("Error requesting authorization: \(error)")
                return
            }
            if granted {
                print("Access was granted.")
            } else {
                print("Access denied.")
            }
        }
    }
    
}
