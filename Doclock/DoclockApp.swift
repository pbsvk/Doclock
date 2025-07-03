//
//  DoclockApp.swift
//  Doclock
//
//  Created by Bhaskara Padala on 6/30/25.
//

import SwiftUI
import SwiftData

@main
struct DocReminderApp: App {
    var body: some Scene {
        WindowGroup {
            DocumentListView()
                .modelContainer(for: Document.self)
                .onAppear {
                    ReminderManager.shared.requestPermission()
                }
        }
    }
}
