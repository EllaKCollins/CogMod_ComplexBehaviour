//
//  ContentView.swift
//  Liars_dice
//
//  Created by Ella Collins on 17/02/2022.
//

import SwiftUI

/**
 This is the starting view and shows the logo of the game, the start game button and the rules on the left.
 */

struct ContentView: View {
    @ObservedObject var viewModel: LDViewModel
// Lie-R's Dice
    var body: some View {
        NavigationView {
            VStack{
                Text("Liar's Dice")
                    .font(.system(size:50, design:.serif))
                    .fontWeight(.black)
                    .foregroundColor(Color("base_colour"))
                Spacer()
                Image("liarsdice_image")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    //.aspectRatio(contentMode: .fit)
                Spacer()
                HStack{
                    NavigationLink(destination: RulesView() ) {
                            Image(systemName: "questionmark.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                
                    }
                        .foregroundColor(Color("base_colour"))  // 3, 4, 94
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
                    // for the rules
                }
                
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
