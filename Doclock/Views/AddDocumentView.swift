//
//  AddDocumentView.swift
//  Doclock
//
//  Created by Bhaskara Padala on 6/30/25.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct AddDocumentView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel: AddDocumentViewModel

    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var isFileImporterPresented = false

    init() {
        _viewModel = StateObject(wrappedValue: AddDocumentViewModel())
    }

    var body: some View {
        Form {
            Section(header: Text("Info")) {
                TextField("Title", text: $viewModel.title)
                Picker("Type", selection: $viewModel.docType) {
                    Text("Document").tag(Document.DocType.doc)
                    Text("ID").tag(Document.DocType.id)
                    Text("Credit Card").tag(Document.DocType.cc)
                }
                if let expiry = viewModel.expiryDate {
                    DatePicker("Expiry", selection: Binding(get: { expiry }, set: { viewModel.expiryDate = $0 }), displayedComponents: .date)
                }
                Stepper("Remind \(viewModel.reminderOffsetDays) days before", value: $viewModel.reminderOffsetDays, in: 1...60)
            }

            Section(header: Text("File")) {
                PhotosPicker("Pick from Photos", selection: $selectedPhotoItem, matching: .images)
                Button("Pick from Files") {
                    isFileImporterPresented = true
                }
            }

            Button("Save") {
                viewModel.save(in: context)
                dismiss()
            }
            .disabled(viewModel.selectedFileData == nil || viewModel.title.isEmpty)
        }
        .fileImporter(isPresented: $isFileImporterPresented, allowedContentTypes: [.pdf, .image]) { result in
            if case .success(let url) = result,
               let data = try? Data(contentsOf: url) {
                viewModel.selectedFileData = data
                viewModel.fileName = url.lastPathComponent
            }
        }
        .onChange(of: selectedPhotoItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    viewModel.selectedFileData = data
                    viewModel.fileName = "photo_\(UUID().uuidString).jpg"
                    if let image = UIImage(data: data) {
                        viewModel.processImageForExpiry(image: image)
                    }
                }
            }
        }
    }
}



#Preview {
    AddDocumentView()
}
