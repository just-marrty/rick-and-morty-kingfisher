//
//  ResultsViewModel+Extensions.swift
//  RickAndMorty
//
//  Created by Martin Hrbáček on 25.01.2026.
//

import Foundation

extension ResultsViewModel {
    static var sampleResultDetailView = ResultsViewModel(
        result: ResultWrapper.Results(
            id: 361,
            name: "Toxic Rick",
            status: "Dead",
            species: "Humanoid",
            type: "Rick's Toxic Side",
            gender: "Male",
            image: "https://rickandmortyapi.com/api/character/avatar/361.jpeg"
        )
    )
}
