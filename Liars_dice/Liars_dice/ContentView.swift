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

    var body: some View {
        NavigationView {
            VStack{
                Text("Liars Dice")
                    .font(.system(size:50, design:.serif))
                    .fontWeight(.black)
                    .foregroundColor(Color("base_colour"))
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
                    .foregroundColor(Color("base_colour"))  // 3, 4, 94
                Spacer()
                    .navigationBarHidden(true)
                    .navigationBarTitle("", displayMode: .inline)
            }
            .background(
                Image("back")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let contentViewModel = LDViewModel()
        ContentView(viewModel: contentViewModel)
    }
}
