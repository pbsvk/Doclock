//
//  DocumentDetailView.swift
//  Doclock
//
//  Created by Bhaskara Padala on 6/30/25.
//

import SwiftUI
import QuickLook

struct DocumentDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @StateObject private var viewModel: DocumentDetailViewModel

    @State private var quickLookURL: URL?
    @State private var isSharePresented = false

    init(document: Document) {
        _viewModel = StateObject(wrappedValue: DocumentDetailViewModel(document: document))
    }

    var body: some View {
        Form {
            Section(header: Text("Info")) {
                Text(viewModel.document.title)
                Text("Type: \(viewModel.document.docType.rawValue.capitalized)")

                if let expiry = viewModel.document.expiryDate {
                    Text("Expires: \(expiry.formatted(date: .numeric, time: .omitted))")
                } else {
                    Text("No expiry date")
                }

                Stepper("Remind \(viewModel.document.reminderOffsetDays) days before", value: Binding(
                    get: { viewModel.document.reminderOffsetDays },
                    set: { viewModel.updateReminderOffset(days: $0) }
                ), in: 1...60)
            }

            Section {
                Button("View File") {
                    quickLookURL = URL(fileURLWithPath: viewModel.document.fileURL)
                }

                Button("Share File") {
                    isSharePresented = true
                }
            }

            Section {
                Button("Delete") {
                    viewModel.delete(in: context)
                    dismiss()
                }
                .foregroundColor(.red)
            }
        }
        .quickLookPreview($quickLookURL)
        .sheet(isPresented: $isSharePresented) {
            if let fileURL = URL(string: "file://\(viewModel.document.fileURL)") {
                ShareSheet(activityItems: [fileURL])
            }
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    let doc = Document(
        title: "Sample Document",
        fileURL: "/path/to/file.pdf",
        expiryDate: Date(),
        docType: .doc, reminderOffsetDays: 7
    )
     DocumentDetailView(document: doc)
        .modelContainer(for: Document.self, inMemory: true)
}
