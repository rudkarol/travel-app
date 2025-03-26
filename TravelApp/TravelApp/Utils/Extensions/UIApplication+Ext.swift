//
//  UIApplication+Ext.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 07/02/2025.
//

import UIKit

extension UIApplication {
    func openEmailApp() {
        if let emailURL = URL(string: "UL0265682@edu.uni.lodz.pl") {
            if UIApplication.shared.canOpenURL(emailURL) {
                UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
            } else {
                print("cannot open email app")
            }
        }
    }
}
