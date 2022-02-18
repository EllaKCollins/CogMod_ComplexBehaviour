//
//  ContentView.swift
//  Liars_dice
//
//  Created by Ella Collins on 17/02/2022.
//

import SwiftUI

/* TODO: ideas
    horizontal layout
    show opponent die as blank cubes/squares
    bid on one side and challenge on the other
    bidding:
        - last bid number +  with die face click to change
        - and + can be not allowed buttons
        "bid" button below : unavailable for not allowed bid
    dice is removed physically
    
 */



struct ContentView: View {
    @State var isActive : Bool = false

    var body: some View {
        VStack {
            Text("Liars Dice")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(Color.pink)
            NavigationView {
                NavigationLink(
                    destination: GameView(rootIsActive: self.$isActive),
                    isActive: self.$isActive
                ) {
                    VStack{
                        Image("dice")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Spacer()
                        Text("Start game")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundColor(Color.pink)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.pink, lineWidth: 4)
                            )
                        Spacer()
                    }
                }
            }
        }
    }
}


struct ContentView3: View {
    @Binding var shouldPopToRootView : Bool

    var body: some View {
        VStack {
            Text("Hello, World #3!")
            Button (action: { self.shouldPopToRootView = false } ){
                Text("Pop to root")
            }
        }.navigationBarTitle("Three")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
