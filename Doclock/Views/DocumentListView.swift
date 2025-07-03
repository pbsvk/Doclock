//
//  DocumentListView.swift
//  Doclock
//
//  Created by Bhaskara Padala on 6/30/25.
//

import SwiftUI
import SwiftData

struct DocumentListView: View {
    @Environment(\.modelContext) private var context
    @Query private var documents: [Document]
    @StateObject private var viewModel = DocumentListViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(documents) { doc in
                    NavigationLink {
                        DocumentDetailView(document: doc)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(doc.title)
                            if let expiry = doc.expiryDate {
                                Text("Expires: \(expiry.formatted(date: .numeric, time: .omitted))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete { offsets in
                    viewModel.deleteDocuments(at: offsets, from: documents, in: context)
                }
            }
            .navigationTitle("Documents")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        AddDocumentView()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
        }
    }
}


#Preview {
    DocumentListView()
}
