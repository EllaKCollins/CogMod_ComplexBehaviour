//
//  Liars_diceApp.swift
//  Liars_dice
//
//  Created by Ella Collins on 17/02/2022.
//

import SwiftUI

@main
struct Liars_diceApp: App {
    var body: some Scene {
        WindowGroup {
            let contentViewModel = LDViewModel()
            ContentView(viewModel: contentViewModel)
        }
    }
}
