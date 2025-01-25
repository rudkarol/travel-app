//
//  PlansViewModel.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import Foundation
import SwiftUI


@Observable final class PlansViewModel {
    
    var addPlanSheetVisible: Bool = false
    var path = NavigationPath()
    
    var isLoading: Bool = false
    var alertData: AlertData?

}
