//
//  PlaceListCellViewModel.swift
//  TravelApp
//
//  Created by osx on 22/01/2025.
//

import Foundation

@Observable class PlaceListCellViewModel {
    
    let locationBasicData: LocationBasic?
    let locationDetailsData: LocationDetails?
    
    var locationId: String
    var name: String
    var addressObj: AddressObj
    var photos: [Photo]?
    
    init(locationBasicData: LocationBasic? = nil, locationDetailsData: LocationDetails? = nil) {
        
        self.locationBasicData = locationBasicData
        self.locationDetailsData = locationDetailsData
        
        if let details = locationDetailsData {
            self.locationId = details.locationId
            self.name = details.name
            self.addressObj = details.addressObj
            self.photos = details.photos
        } else if let basic = locationBasicData {
            self.locationId = basic.locationId
            self.name = basic.name
            self.addressObj = basic.addressObj
            self.photos = basic.photos
        } else {
            fatalError("PlaceListCallViewModel - two nil arguments")
        }
    }
}
