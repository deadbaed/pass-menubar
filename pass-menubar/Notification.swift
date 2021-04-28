//
//  Notification.swift
//  pass-menubar
//
//  Created by phil on 28/04/2021.
//

import Foundation
import UserNotifications

func sendNotification(password: Password, timeInterval: Double) {
    let content = UNMutableNotificationContent()
    content.title = "Copied \(password.display) to clipboard"
    content.subtitle = "subtitle goes here"
    content.sound = UNNotificationSound.default

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request)
}
