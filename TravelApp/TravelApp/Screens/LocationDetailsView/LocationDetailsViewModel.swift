//
//  LocationDetailsViewModel.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 26/01/2025.
//

import Foundation


@Observable final class LocationDetailsViewModel {
    
    var sheetVisible: Bool = false
    var isSheetLoading: Bool = false
    var isDescriptionExpanded: Bool = false
    var alertData: AlertData?
    
}
