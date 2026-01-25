//
//  PageService.swift
//  RickAndMorty
//
//  Created by Martin Hrbáček on 25.01.2026.
//

import Foundation

struct PageService: PageServiceProtocol {
    
    func fetchPage(url: URL?) async throws -> ResultWrapper {
        guard let url = url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.badResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpFail(httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(ResultWrapper.self, from: data)
        } catch {
            throw NetworkError.decodingFail
        }
    }
}
