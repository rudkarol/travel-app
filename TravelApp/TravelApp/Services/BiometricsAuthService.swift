//
//  BiometricsAuthService.swift
//  TravelApp
//
//  Created by osx on 07/02/2025.
//

import Foundation
import LocalAuthentication

func authenticateWithBiometrics(completion: @escaping (Bool) -> Void) {
    let context = LAContext()
    var error: NSError?

    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Confirm your identity") { success, error in
            DispatchQueue.main.async {
                if success {
                    print("Face ID success")
                    completion(true)
                } else {
                    print("Face ID error:", error?.localizedDescription ?? "unknown")
                    completion(false)
                }
            }
        }
    } else {
        print("faced not available")
        completion(false)
    }
}
