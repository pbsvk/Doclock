//
//  Document.swift
//  Doclock
//
//  Created by Bhaskara Padala on 6/30/25.
//

import Foundation
import SwiftData

@Model
class Document {
    enum DocType: String, Codable, CaseIterable {
        case doc, id, cc
    }

    var id: UUID
    var title: String
    var fileURL: String
    var expiryDate: Date?
    var docType: DocType
    var reminderOffsetDays: Int

    init(
        id: UUID = UUID(),
        title: String,
        fileURL: String,
        expiryDate: Date?,
        docType: DocType,
        reminderOffsetDays: Int
    ) {
        self.id = id
        self.title = title
        self.fileURL = fileURL
        self.expiryDate = expiryDate
        self.docType = docType
        self.reminderOffsetDays = reminderOffsetDays
    }
}

