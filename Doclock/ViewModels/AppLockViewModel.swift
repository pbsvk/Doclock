//
//  AppLockViewModel.swift
//  Doclock
//
//  Created by Bhaskara Padala on 6/30/25.
//

import Foundation

@MainActor
class AppLockViewModel: ObservableObject {
    @Published var isUnlocked = false

    func unlock() {
        AppLockManager.shared.authenticate { [weak self] success in
            self?.isUnlocked = success
        }
    }
}

