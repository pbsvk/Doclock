//
//  FileManagerService.swift
//  Doclock
//
//  Created by Bhaskara Padala on 6/30/25.
//

import Foundation

class FileManagerService {
    static let shared = FileManagerService()

    private init() {
        createDocsFolderIfNeeded()
    }

    private var docsFolderURL: URL {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docDir.appendingPathComponent("DocReminderDocs")
    }

    private func createDocsFolderIfNeeded() {
        if !FileManager.default.fileExists(atPath: docsFolderURL.path) {
            try? FileManager.default.createDirectory(at: docsFolderURL, withIntermediateDirectories: true)
        }
    }

    func saveFile(data: Data, fileName: String) -> String? {
        let fileURL = docsFolderURL.appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
            return fileURL.path
        } catch {
            print("Error saving file: \(error)")
            return nil
        }
    }

    func deleteFile(atPath path: String) {
        let url = URL(fileURLWithPath: path)
        try? FileManager.default.removeItem(at: url)
    }

    func loadFile(atPath path: String) -> Data? {
        let url = URL(fileURLWithPath: path)
        return try? Data(contentsOf: url)
    }
}
