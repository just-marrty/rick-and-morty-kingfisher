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
                        Text("Status:")
                            .font(.system(size: 18, design: .rounded))
                            .bold()
                        Text(result.status)
                    }
                    
                    HStack {
                        Text("Species:")
                            .font(.system(size: 18, design: .rounded))
                            .bold()
                        Text(result.species)
                    }
                    
                    HStack {
                        Text("Type:")
                            .font(.system(size: 18, design: .rounded))
                            .bold()
                        Text(result.type ?? "N/A")
                    }
                    
                    HStack {
                        Text("Gender:")
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
        ResultDetialView(result: ResultsViewModel(result: ResultWrapper.Results(id: 361, name: "Toxic Rick", status: "Dead", species: "Humanoid", type: "Rick's Toxic Side", gender: "Male", image: "https://rickandmortyapi.com/api/character/avatar/361.jpeg")))
    }
}
