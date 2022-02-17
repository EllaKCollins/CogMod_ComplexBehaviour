//
//  ContentView.swift
//  Rock_Paper_Scissors
//
//  Created by Ella Collins on 11/02/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GameView()
    }
}

struct GameView: View {
    
    @State var model = RPS_model()
    
    @State var display_text = "Choose one to start the game."
    
    @State var opponent_choice = ""
    
    @State var player_choice = ""
    
    @State var player_points = 0
    @State var opponent_points = 0
    
    @State var model_choice = ""
    
    var body: some View {
        
        VStack{
            Text("Opponent")
                .font(.title)
            HStack{
                VStack {
                    Image(systemName:"oval.fill")
                        .font(.largeTitle)
                    Text("Rock")
                        .font(.caption)
                }
                Spacer()
                VStack {
                    Image(systemName:"doc.fill")
                        .font(.largeTitle)
                    Text("Paper")
                        .font(.caption)
                }
                Spacer()
                VStack {
                    Image(systemName:"scissors")
                        .font(.largeTitle)
                    Text("Scissors")
                        .font(.caption)
                }
            }
                .foregroundColor(Color.red)
            
            if opponent_choice != "" {
                Spacer()
                Image(systemName:opponent_choice)
                    .font(.largeTitle)
            }
            
            
            Spacer()
            Text(display_text)

            if player_choice != "" {
                Spacer()
                Image(systemName:player_choice)
                    .font(.largeTitle)
            }
            
            Spacer()
            HStack{
                Button {
                    player_choice = "oval.fill"
                    determine_winner()
                } label: {
                    VStack {
                        Image(systemName:"oval.fill")
                            .font(.largeTitle)
                        Text("Rock")
                            .font(.caption)
                    }
                }
                Spacer()
                Button {
                    player_choice = "doc.fill"
                    determine_winner()
                    
                } label: {
                    VStack {
                        Image(systemName:"doc.fill")
                            .font(.largeTitle)
                        Text("Paper")
                            .font(.caption)
                    }
                }
                Spacer()
                Button {
                    player_choice = "scissors"
                    determine_winner()
                    
                } label: {
                    VStack {
                        Image(systemName:"scissors")
                            .font(.largeTitle)
                        Text("Scissors")
                            .font(.caption)
                    }
                }
            }
            
            Text("You")
                .font(.title)
        }
        
            
        .padding(.horizontal)
    }
    
    
    func determine_winner(){
        
        opponent_choice = model.run_rps()
        
        if opponent_choice == player_choice {
            display_text = "It is a draw."
        }
        else if (opponent_choice == "oval.fill" && player_choice == "doc.fill") || (player_choice == "oval.fill" && opponent_choice == "doc.fill")  {
            if opponent_choice == "oval.fill" {
                display_text = "You won!"
            }
            else {
                display_text = "Opponent won!"
            }
        }
        else if (opponent_choice == "oval.fill" && player_choice == "scissors") || (player_choice == "oval.fill" && opponent_choice == "scissors") {
            if opponent_choice == "scissors" {
                display_text = "You won!"
            }
            else {
                display_text = "Opponent won!"
            }
        }
        else if (opponent_choice == "doc.fill" && player_choice == "scissors") || (player_choice == "doc.fill" && opponent_choice == "scissors") {
            if opponent_choice == "doc.fill" {
                display_text = "You won!"
            }
            else {
                display_text = "Opponent won!"
            }
        }
        model.consider_opponent_action(thing: player_choice)
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
