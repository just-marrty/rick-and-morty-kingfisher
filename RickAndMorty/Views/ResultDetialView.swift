//
//  ResultDetialView.swift
//  RickAndMorty
//
//  Created by Martin Hrbáček on 15.01.2026.
//

import SwiftUI
import Kingfisher

struct ResultDetialView: View {
    
    let result: ResultsViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                KFImage(result.image)
                    .placeholder {
                        Image(.rm404)
                    }
                    .onFailureImage(UIImage(resource: .rm404))
                    .resizable()
                    .scaledToFit()
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(StringConstants.status)
                            .font(.system(size: 18, design: .rounded))
                            .bold()
                        Text(result.status)
                    }
                    
                    HStack {
                        Text(StringConstants.species)
                            .font(.system(size: 18, design: .rounded))
                            .bold()
                        Text(result.species)
                    }
                    
                    HStack {
                        Text(StringConstants.type)
                            .font(.system(size: 18, design: .rounded))
                            .bold()
                        Text(result.type ?? StringConstants.notAvailable)
                    }
                    
                    HStack {
                        Text(StringConstants.gender)
                            .font(.system(size: 18, design: .rounded))
                            .bold()
                        Text(result.gender)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
        .navigationTitle(result.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ResultDetialView(result: .sampleResultDetailView)
    }
}
