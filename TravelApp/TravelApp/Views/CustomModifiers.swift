//
//  CustomModifiers.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 18/01/2025.
//

import SwiftUI

struct SmallButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.bordered)
            .tint(.accentColor)
            .controlSize(.small)
    }
}
