//
//  NetworkError.swift
//  RickAndMorty
//
//  Created by Martin Hrbáček on 25.01.2026.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case badResponse
    case httpFail(Int)
    case decodingFail
}
