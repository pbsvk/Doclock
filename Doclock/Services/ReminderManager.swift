//
//  ReminderManager.swift
//  Doclock
//
//  Created by Bhaskara Padala on 6/30/25.
//

import Foundation
import UserNotifications

class ReminderManager {
    static let shared = ReminderManager()

    private init() {}

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    func scheduleReminder(for document: Document) {
        guard let expiry = document.expiryDate else { return }

        let content = UNMutableNotificationContent()
        content.title = "Document Expiry Reminder"
        content.body = "\(document.title) expires soon!"

        let remindDate = Calendar.current.date(byAdding: .day, value: -document.reminderOffsetDays, to: expiry) ?? expiry
        let components = Calendar.current.dateComponents([.year, .month, .day], from: remindDate)

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: document.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func cancelReminder(for document: Document) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [document.id.uuidString])
    }
}

