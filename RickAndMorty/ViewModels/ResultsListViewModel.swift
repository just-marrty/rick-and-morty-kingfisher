//
//  ResultsListViewModel.swift
//  RickAndMorty
//
//  Created by Martin Hrbáček on 15.01.2026.
//

import Foundation
import Observation

@Observable
@MainActor
class ResultsListViewModel {
    var results: [ResultsViewModel] = []
    var wrapperInfo: WrapperInfoViewModel?
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    private let fetchService: FetchService
    
    init(fetchService: FetchService) {
        self.fetchService = fetchService
    }
    
    func loadResults() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let wrapper = try await fetchService.fetchResults()
            self.results = wrapper.results.map(ResultsViewModel.init)
            self.wrapperInfo = WrapperInfoViewModel(wrapperInfo: wrapper.info)
        } catch {
            errorMessage = "There seems to be a problem on the provider's side..."
        }
        isLoading = false
    }
    
    func loadNextPage() async {
        guard let nextURL = wrapperInfo?.next else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let wrapper = try await fetchService.fetchPage(url: nextURL)
            self.results = wrapper.results.map(ResultsViewModel.init)
            self.wrapperInfo = WrapperInfoViewModel(wrapperInfo: wrapper.info)
        } catch {
            errorMessage = "Oups, looks there is some issue.."
        }
        isLoading = false
    }
    
    func loadPrevPage() async {
        guard let prevURL = wrapperInfo?.prev else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let wrapper = try await fetchService.fetchPage(url: prevURL)
            self.results = wrapper.results.map(ResultsViewModel.init)
            self.wrapperInfo = WrapperInfoViewModel(wrapperInfo: wrapper.info)
        } catch {
            errorMessage = "Oups, looks there is some issue.."
        }
        isLoading = false
    }
}

struct ResultsViewModel: Identifiable, Hashable {
    
    private var result: ResultWrapper.Results
    
    init(result: ResultWrapper.Results) {
        self.result = result
    }
    
    var id: Int {
        result.id
    }
    
    var name: String {
        result.name
    }
    
    var status: String {
        result.status
    }
    
    var species: String {
        result.species
    }
    
    var type: String? {
        result.type ?? "No type"
    }
    
    var gender: String {
        result.gender
    }
    
    var image: URL? {
        guard let urlString = result.image else { return nil }
        return URL(string: urlString)
    }
}

struct WrapperInfoViewModel {
    
    private var wrapperInfo: ResultWrapper.WrapperInfo
    
    init(wrapperInfo: ResultWrapper.WrapperInfo) {
        self.wrapperInfo = wrapperInfo
    }
    
    var next: URL? {
        guard let urlString = wrapperInfo.next else { return nil }
        return URL(string: urlString)
    }
    
    var prev: URL? {
        guard let urlString = wrapperInfo.prev else { return nil }
        return URL(string: urlString)
    }
}
