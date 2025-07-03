//
//  AppLockView.swift
//  Doclock
//
//  Created by Bhaskara Padala on 6/30/25.
//

import SwiftUI

struct AppLockView: View {
    @StateObject private var viewModel = AppLockViewModel()

    var body: some View {
        VStack {
            if viewModel.isUnlocked {
                DocumentListView()
            } else {
                Text("Unlocking...")
                    .onAppear {
                        viewModel.unlock()
                    }
            }
        }
    }
}


#Preview {
    AppLockView()
}
