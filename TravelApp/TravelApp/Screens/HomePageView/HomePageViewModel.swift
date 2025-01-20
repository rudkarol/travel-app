//
//  HomePageViewModel.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI
import Observation


@Observable final class HomePageViewModel {
    //    TODO: exploreItems: [Place] = []
    //    TODO: exploreItems: [Place]?
    var exploreItems: [LocationBasic] = MockDataPlace.samplePlaces
}

