//
//  PageServiceProtocol.swift
//  RickAndMorty
//
//  Created by Martin Hrbáček on 25.01.2026.
//

import Foundation

protocol PageServiceProtocol: Sendable {
    func fetchPage(url: URL?) async throws -> ResultWrapper
}
