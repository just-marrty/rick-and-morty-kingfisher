//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Martin Hrbáček on 15.01.2026.
//

import SwiftUI

@main
struct RickAndMortyApp: App {
    var body: some Scene {
        WindowGroup {
            MainResultView()
                .preferredColorScheme(.dark)
        }
    }
}
