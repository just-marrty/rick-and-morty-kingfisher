//
//  ResultWrapper.swift
//  RickAndMorty
//
//  Created by Martin Hrbáček on 15.01.2026.
//

import Foundation

struct ResultWrapper: Decodable {
    let info: WrapperInfo
    let results: [Results]
    
    struct WrapperInfo: Decodable {
        let next: String?
        let prev: String?
    }
    
    struct Results: Identifiable, Decodable, Hashable {
        let id: Int
        let name: String
        let status: String
        let species: String
        let type: String?
        let gender: String
        let image: String?
    }
}
