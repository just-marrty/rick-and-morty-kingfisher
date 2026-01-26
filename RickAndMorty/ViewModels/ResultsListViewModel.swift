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
    var showContent: Bool = false
    
    private let fetchService: FetchServiceProtocol
    private let fetchPage: PageServiceProtocol
    
    init(fetchService: FetchServiceProtocol, fetchPage: PageServiceProtocol) {
        self.fetchService = fetchService
        self.fetchPage = fetchPage
    }
    
    func loadResults() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let wrapper = try await fetchService.fetchResults()
            self.results = wrapper.results.map(ResultsViewModel.init)
            self.wrapperInfo = WrapperInfoViewModel(wrapperInfo: wrapper.info)
        } catch {
            errorMessage = Strings.errorMessageLoadResults
        }
        isLoading = false
    }
    
    func loadNextPage() async {
        guard let nextURL = wrapperInfo?.next, !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let wrapper = try await fetchPage.fetchPage(url: nextURL)
            self.results = wrapper.results.map(ResultsViewModel.init)
            self.wrapperInfo = WrapperInfoViewModel(wrapperInfo: wrapper.info)
        } catch {
            errorMessage = Strings.errorMessageNextPage
        }
        isLoading = false
    }
    
    func loadPrevPage() async {
        guard let prevURL = wrapperInfo?.prev, !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let wrapper = try await fetchPage.fetchPage(url: prevURL)
            self.results = wrapper.results.map(ResultsViewModel.init)
            self.wrapperInfo = WrapperInfoViewModel(wrapperInfo: wrapper.info)
        } catch {
            errorMessage = Strings.errorMessagePrevPage
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
        result.type ?? Strings.noType
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
