//
//  FavouritesViewModel.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import Observation

@Observable final class FavouritesViewModel {
//    TODO: var favouritePlaces: [Place] = []
    var favouritePlaces: [LocationBasic] = MockDataPlace.samplePlaces
}
