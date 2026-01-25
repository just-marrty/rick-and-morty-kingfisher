//
//  MainResultView.swift
//  RickAndMorty
//
//  Created by Martin Hrbáček on 15.01.2026.
//

import SwiftUI
import Kingfisher

struct MainResultView: View {
    
    @State private var resultsVM = ResultsListViewModel(fetchService: FetchService())
    
    private let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    private let animationDuration: Double = 0.3
    private let sleepSeconds: Double = 0.05
    
    var body: some View {
        VStack {
            if let errorMessage = resultsVM.errorMessage {
                VStack {
                    Image(systemName: StringConstants.exclamationMarkTriangle)
                        .foregroundStyle(.orange)
                        .bold()
                        .font(.system(size: 28, design: .rounded))
                    Text(StringConstants.oups)
                        .font(.system(size: 26, design: .rounded))
                        .bold()
                        .padding()
                    Text(errorMessage)
                        .font(.system(size: 22, design: .rounded))
                        .bold()
                        .padding()
                    Button {
                        Task {
                            await resultsVM.loadResults()
                        }
                    } label: {
                        Image(systemName: StringConstants.arrowClockwise)
                            .font(.system(size: 20, design: .rounded))
                            .bold()
                            .padding()
                    }
                }
                .multilineTextAlignment(.center)
                .padding()
            } else {
                NavigationStack {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(resultsVM.results) { result in
                                NavigationLink(value: result) {
                                    VStack(spacing: 5) {
                                        Text(result.name)
                                            .lineLimit(1)
                                            .font(.system(size: 16, design: .rounded))
                                            .bold()
                                        
                                        KFImage(result.image)
                                            .placeholder {
                                                Image(.rm404)
                                                    .resizable()
                                                    .scaledToFit()
                                            }
                                            .onFailureImage(UIImage(resource: .rm404))
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 190, height: 190)
                                            .clipShape(.rect(cornerRadius: 15))
                                    }
                                }
                            }
                        }
                    }
                    .safeAreaPadding(.vertical, 20)
                    .scrollIndicators(.hidden)
                    .id(resultsVM.results.first?.id)
                    .navigationDestination(for: ResultsViewModel.self) { result in
                        ResultDetialView(result: result)
                    }
                    .navigationTitle(StringConstants.navigationTitle)
                    .navigationSubtitle(StringConstants.navigationSubtitle)
                    .toolbar {
                        ToolbarItemGroup(placement: .topBarTrailing) {
                            Button {
                                Task {
                                    resultsVM.showContent = false
                                    try? await Task.sleep(for: .seconds(sleepSeconds))
                                    await resultsVM.loadPrevPage()
                                    withAnimation(.easeInOut(duration: animationDuration)) {
                                        resultsVM.showContent = true
                                    }
                                }
                            } label: {
                                Image(systemName: StringConstants.chevronLeft)
                            }
                            .disabled(resultsVM.wrapperInfo?.prev == nil)
                            
                            Button {
                                Task {
                                    resultsVM.showContent = false
                                    try? await Task.sleep(for: .seconds(sleepSeconds))
                                    await resultsVM.loadNextPage()
                                    withAnimation(.easeInOut(duration: animationDuration)) {
                                        resultsVM.showContent = true
                                    }
                                }
                            } label: {
                                Image(systemName: StringConstants.chevronRight)
                            }
                            .disabled(resultsVM.wrapperInfo?.next == nil)
                        }
                        
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                Task {
                                    resultsVM.showContent = false
                                    try? await Task.sleep(for: .seconds(sleepSeconds))
                                    await resultsVM.loadResults()
                                    withAnimation(.easeInOut(duration: animationDuration)) {
                                        resultsVM.showContent = true
                                    }
                                }
                            } label: {
                                Image(systemName: StringConstants.arrowClockwise)
                            }
                        }
                    }
                    .opacity(resultsVM.showContent ? 1 : 0)
                }
            }
        }
        .task {
            await resultsVM.loadResults()
            withAnimation(.easeInOut(duration: animationDuration)) {
                resultsVM.showContent = true
            }
        }
    }
}

#Preview {
    MainResultView()
        .preferredColorScheme(.dark)
}
