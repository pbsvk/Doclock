//
//  DocumentDetailViewModel.swift
//  Doclock
//
//  Created by Bhaskara Padala on 6/30/25.
//

import Foundation
import SwiftData

@MainActor
class DocumentDetailViewModel: ObservableObject {
    @Published var document: Document

    init(document: Document) {
        self.document = document
    }

    func updateReminderOffset(days: Int) {
        document.reminderOffsetDays = days
        ReminderManager.shared.cancelReminder(for: document)
        ReminderManager.shared.scheduleReminder(for: document)
    }

    func delete(in context: ModelContext) {
        ReminderManager.shared.cancelReminder(for: document)
        DocumentManager.shared.delete(document: document, context: context)
    }
}
