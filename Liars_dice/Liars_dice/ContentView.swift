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
    @ObservedObject var viewModel: LDViewModel
    @State var isActive : Bool = false

    var body: some View {
        NavigationView {
            VStack{
                Text("Liars Dice")
                    .font(.system(size:50, design:.serif))
                    .fontWeight(.black)
                    .foregroundColor(Color(red: 0.719, green: 0.002, blue: 0.312))
                Spacer()
                Image("liarsdice_image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Spacer()
                NavigationLink( destination: GameView(viewModel: viewModel) ) {
                        Text("Start game")
                            .font(.system(.headline, design: .serif))
                            .fontWeight(.black)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(lineWidth: 4))
                }
                    .foregroundColor(Color(red: 0.719, green: 0.002, blue: 0.312))
                Spacer()
                    .navigationBarHidden(true)
                    .navigationBarTitle("", displayMode: .inline)
            }
        }
        
    }
}

/*
 
 }
 */
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
        let contentViewModel = LDViewModel()
        ContentView(viewModel: contentViewModel)
    }
}
