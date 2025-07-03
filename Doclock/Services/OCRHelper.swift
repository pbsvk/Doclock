//
//  OCRHelper.swift
//  Doclock
//
//  Created by Bhaskara Padala on 6/30/25.
//

import Foundation
import Vision
import UIKit

class OCRHelper {
    static let shared = OCRHelper()

    private init() {}

    func detectExpiryDate(from image: UIImage, completion: @escaping (Date?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }

        let request = VNRecognizeTextRequest { req, _ in
            let text = req.results?.compactMap { ($0 as? VNRecognizedTextObservation)?.topCandidates(1).first?.string }
                .joined(separator: " ") ?? ""
            completion(self.parseDate(from: text))
        }
        request.recognitionLevel = .accurate

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }

    private func parseDate(from text: String) -> Date? {
        // Very simple example: looks for MM/YY or MM/YYYY
        let pattern = #"(\d{2})[\/\-](\d{2,4})"#
        if let match = text.range(of: pattern, options: .regularExpression) {
            let dateStr = String(text[match])
            let formatter = DateFormatter()
            formatter.dateFormat = dateStr.count == 5 ? "MM/yy" : "MM/yyyy"
            return formatter.date(from: dateStr)
        }
        return nil
    }
}

