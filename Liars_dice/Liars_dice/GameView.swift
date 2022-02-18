//
//  GameView.swift
//  Liars_dice
//
//  Created by Ella Collins on 17/02/2022.
//

import Foundation
import SwiftUI


struct GameView: View {
    @Binding var rootIsActive : Bool

    var body: some View {
        NavigationLink(destination: ContentView3(shouldPopToRootView: self.$rootIsActive)) {
            Text("Hello, World #2!")
        }
        .isDetailLink(false)
        .navigationBarTitle("Two")
    }
}


/*struct GameView: View {
    
    var body: some View {
        Text("whats up liars game")
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
    }
}*/

/*struct ContentView: View {
    
    @State var model = Opponent1()
    
    var body: some View {
        VStack {
            Text("Liars Dice")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(Color.pink)
            Image("dice")
                .resizable()
                .aspectRatio(contentMode: .fit)
            NavigationView {
                NavigationLink {
                    GameView()
                } label: {
                    Text("Start game")
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        /*.font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.pink)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.pink, lineWidth: 4)
                        )*/
                }
            }
        }
    }
}
*/
