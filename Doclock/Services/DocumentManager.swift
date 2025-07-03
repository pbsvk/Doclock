//
//  DocumentManager.swift
//  Doclock
//
//  Created by Bhaskara Padala on 6/30/25.
//

import Foundation
import SwiftData

class DocumentManager {
    static let shared = DocumentManager()

    private init() {}

    func delete(document: Document, context: ModelContext) {
        FileManagerService.shared.deleteFile(atPath: document.fileURL)
        context.delete(document)
    }
}

