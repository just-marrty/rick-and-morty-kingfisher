//
//  FetchService.swift
//  RickAndMorty
//
//  Created by Martin Hrbáček on 15.01.2026.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case badResponse
    case httpFail(Int)
    case decodingFail
}

class FetchService {
    
    private let endpoint = "/character"
    
    private let baseURL = "https://rickandmortyapi.com/api"
    
    func fetchResults() async throws -> ResultWrapper {
        guard let url = URL(string: (baseURL+endpoint)) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
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
    
    func fetchPage(url: URL?) async throws -> ResultWrapper {
        guard let url = url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
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
