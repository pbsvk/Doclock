//
//  AppLockManager.swift
//  Doclock
//
//  Created by Bhaskara Padala on 6/30/25.
//

import LocalAuthentication

class AppLockManager {
    static let shared = AppLockManager()

    private init() {}

    func authenticate(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock DocReminder") { success, _ in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(false)
            }
        }
    }
}

