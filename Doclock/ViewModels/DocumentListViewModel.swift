//
//  DocumentListViewModel.swift
//  Doclock
//
//  Created by Bhaskara Padala on 6/30/25.
//

import Foundation
import SwiftData

@MainActor
class DocumentListViewModel: ObservableObject {
    func deleteDocuments(at offsets: IndexSet, from documents: [Document], in context: ModelContext) {
        for index in offsets {
            let doc = documents[index]
            ReminderManager.shared.cancelReminder(for: doc)
            DocumentManager.shared.delete(document: doc, context: context)
        }
    }
}

