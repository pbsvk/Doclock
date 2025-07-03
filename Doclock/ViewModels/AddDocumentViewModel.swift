//
//  AddDocumentViewModel.swift
//  Doclock
//
//  Created by Bhaskara Padala on 6/30/25.
//
import Foundation
import SwiftData
import UIKit

@MainActor
class AddDocumentViewModel: ObservableObject {
    @Published var title = ""
    @Published var docType: Document.DocType = .doc
    @Published var expiryDate: Date?
    @Published var reminderOffsetDays = 7
    @Published var selectedFileData: Data?
    @Published var fileName: String = ""

    func save(in context: ModelContext) {
        guard let fileData = selectedFileData else { return }

        let filePath = FileManagerService.shared.saveFile(data: fileData, fileName: fileName) ?? ""
        let newDoc = Document(
            title: title,
            fileURL: filePath,
            expiryDate: expiryDate,
            docType: docType,
            reminderOffsetDays: reminderOffsetDays
        )

        context.insert(newDoc)
        ReminderManager.shared.scheduleReminder(for: newDoc)
    }

    func processImageForExpiry(image: UIImage) {
        OCRHelper.shared.detectExpiryDate(from: image) { [weak self] detectedDate in
            self?.expiryDate = detectedDate
        }
    }
}
