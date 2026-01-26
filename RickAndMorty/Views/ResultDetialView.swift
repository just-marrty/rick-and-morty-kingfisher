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
                        Text(Strings.status)
                            .font(.system(size: 18, design: .rounded))
                            .bold()
                        Text(result.status)
                    }
                    
                    HStack {
                        Text(Strings.species)
                            .font(.system(size: 18, design: .rounded))
                            .bold()
                        Text(result.species)
                    }
                    
                    HStack {
                        Text(Strings.type)
                            .font(.system(size: 18, design: .rounded))
                            .bold()
                        Text(result.type ?? Strings.notAvailable)
                    }
                    
                    HStack {
                        Text(Strings.gender)
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
