//
//  GameView.swift
//  Liars_dice
//
//  Created by Ella Collins on 17/02/2022.
//

import Foundation
import SwiftUI

/**
  This struct is for the View of the Game and displays all the dice and bids made by the players.
*/

struct GameView: View {
    @ObservedObject var viewModel: LDViewModel
    @ScaledMetric var scale: CGFloat = 1
    @State var timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    @State var display_dice: String = "one"
    @State var display_bid: Int = 1
    
    @State var current_loser = ""
    
    var dice_size: CGFloat = 30
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                // Opponent stuff here
                if viewModel.current_player == 1 && viewModel.still_bidding {
                    Text("Opponent 1")
                        .font(.headline)
                        .padding(.all, 12.0)
                        .rotationEffect(Angle(degrees: -90))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color("second_colour"), lineWidth: 2)
                                .rotationEffect(Angle(degrees: -90)))
                        .onReceive(timer) { _ in
                            viewModel.model_run()
                        }
                }
                else {
                    Text("Opponent 1")
                        .font(.headline)
                        .padding(.all, 12.0)
                        .rotationEffect(Angle(degrees: -90))
                }
                // opponent 1's hand
                VStack {
                    ForEach(viewModel.players[1].hand.faces.indices, id: \.self) { dice in
                        if viewModel.still_bidding {
                            Image("face_down")
                                .resizable()
                                .frame(width: dice_size * scale, height: dice_size * scale)
                        }
                        else if !viewModel.still_bidding && viewModel.challenged && !viewModel.bids.isEmpty{
                            if viewModel.bids.last!.face == viewModel.players[1].hand.faces[dice] {
                                Image(viewModel.players[1].hand.faces[dice])
                                    .resizable()
                                    .frame(width: dice_size * scale, height: dice_size * scale)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(.red, lineWidth: 3)
                                        )
                            }
                            else {
                                Image(viewModel.players[1].hand.faces[dice])
                                    .resizable()
                                    .frame(width: dice_size * scale, height: dice_size * scale)
                            }
                        }
                    }
                }
                Spacer()
                VStack {
                    // Bids!
                    Spacer()
                    HStack{
                        if viewModel.bids.isEmpty == false && !viewModel.game_over {
                            VStack{
                                Text("\(viewModel.players[viewModel.retrieve_previous_player(curr: viewModel.current_player)].name) bid")
                                    .font(.headline)
                                HStack{
                                    Text("\(viewModel.bids.last!.num)")
                                        .font(.headline)
                                        .onReceive(timer) { _ in
                                            display_bid = viewModel.bids.last!.num
                                        }
                                    Image(viewModel.bids.last!.face)
                                        .resizable()
                                        .frame(width: dice_size * scale, height: dice_size * scale)
                                        .onReceive(timer) { _ in
                                            display_dice = viewModel.bids.last!.face
                                        }
                                }
                            }
                        }
                        
                    }
                    if viewModel.challenged && !viewModel.challenge_over && !viewModel.game_over {
                        Text("\(current_loser)")
                            .font(.headline)
                            .onReceive(timer) { _ in
                                current_loser = viewModel.players[viewModel.challenge_bid()].name + " lost"
                            }
                        
                    } else if viewModel.challenged && viewModel.challenge_over && !viewModel.game_over {
                        Text("\(current_loser)")
                            .font(.headline)
                    }
                    
                    if viewModel.game_over {
                        Text("Game over \n \(viewModel.winner) won")
                            .font(.headline)
                    }
                    Spacer()
                    if !viewModel.still_bidding && viewModel.challenge_over {
                        Button {
                            viewModel.roll()
                            current_loser = ""
                        } label: {
                            if viewModel.game_over {
                                Text("New game")
                                    .font(.headline)
                            }
                            else {
                                Text("Roll")
                                    .font(.headline)
                            }
                        }
                        .padding(.all, 12.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color("second_colour"), lineWidth: 4)
                            )
                        .cornerRadius(16)
                        .accentColor(Color("second_colour"))
                    }

                }
                Spacer()
                // opponent 2's hand
                VStack {
                    ForEach(viewModel.players[2].hand.faces.indices, id: \.self) { dice in
                        if viewModel.still_bidding {
                            Image("face_down")
                                .resizable()
                                .frame(width: dice_size * scale, height: dice_size * scale)
                        }
                        else if !viewModel.still_bidding && viewModel.challenged && !viewModel.bids.isEmpty{
                            if viewModel.bids.last!.face == viewModel.players[2].hand.faces[dice] {
                                Image(viewModel.players[2].hand.faces[dice])
                                    .resizable()
                                    .frame(width: dice_size * scale, height: dice_size * scale)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(.red, lineWidth: 3)
                                        )
                            }
                            else {
                                Image(viewModel.players[2].hand.faces[dice])
                                    .resizable()
                                    .frame(width: dice_size * scale, height: dice_size * scale)
                            }
                        }
                        
                    }
                }
                if viewModel.current_player == 2  && viewModel.still_bidding { //  && viewModel.players[1]
                    Text("Opponent 2")
                        .font(.headline)
                        .padding(.all, 12.0)
                        .rotationEffect(Angle(degrees: -90))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color("second_colour"), lineWidth: 2)
                                .rotationEffect(Angle(degrees: -90)))
                        .onReceive(timer) { _ in
                            viewModel.model_run()
                        }
                }
                else {
                    Text("Opponent 2")
                        .font(.headline)
                        .padding(.all, 12.0)
                        .rotationEffect(Angle(degrees: -90))
                }
            }
            Spacer()
            // Player hand
            HStack {
                ForEach(viewModel.players[0].hand.faces.indices, id: \.self){ dice in
                    
                    if viewModel.challenged && !viewModel.bids.isEmpty{
                        if viewModel.bids.last!.face == viewModel.players[0].hand.faces[dice] {
                            Image(viewModel.players[0].hand.faces[dice])
                                .resizable()
                                .frame(width: dice_size * scale, height: dice_size * scale)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.red, lineWidth: 3)
                                    )
                        }
                        else {
                            Image(viewModel.players[0].hand.faces[dice])
                                .resizable()
                                .frame(width: dice_size * scale, height: dice_size * scale)
                        }
                    }
                    else {
                        Image(viewModel.players[0].hand.faces[dice])
                            .resizable()
                            .frame(width: dice_size * scale, height: dice_size * scale)
                    }
                }
            }
            // Player stuff here
            HStack {
                HStack {
                    Button {
                        viewModel.change_bid_num(action: "-")
                    } label: {
                        Image(systemName: "minus")
                        
                    }
                    .padding(.horizontal, 5.0)
                    .disabled(viewModel.disable_minus)
                    Text("\(viewModel.possible_bid_num)")
                        .font(.headline)
                        .foregroundColor(Color("base_colour"))
                    Button {
                        viewModel.change_bid_num(action: "+")
                    } label: {
                        Image(systemName: "plus")
                    }
                    .padding(.horizontal, 5.0)
                    .disabled(viewModel.disable_plus)
                    Image(viewModel.current_bid_dice)
                        .resizable()
                        .frame(width: 25 * scale, height: 25 * scale)
                        .onTapGesture {
                            viewModel.change_bid_dice()
                        }
                        .padding(.horizontal, 5.0)
                }
                .padding(.all, 8.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color("base_colour"), lineWidth: 2))
                .accentColor(Color("base_colour"))
                Button {
                    viewModel.human_bid()

                } label: {
                    Text("Bid")
                        .font(.headline)
                        .padding(.all, 12.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color("base_colour"), lineWidth: 4)
                            )
                }
                .disabled((viewModel.current_player != 0) || !viewModel.still_bidding || viewModel.not_valid_bid)
                .cornerRadius(16)
                .accentColor(Color("base_colour"))
                Spacer()
                if viewModel.current_player == 0 && viewModel.still_bidding { //  && viewModel.players[1]
                    Text("You")
                        .font(.headline)
                        .padding(.all, 12.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color("second_colour"), lineWidth: 2))
                }
                else {
                    Text("You")
                        .font(.headline)
                        .padding(.all, 12.0)
                }
                Spacer()
                Button {
                    viewModel.change_challenge()
                } label: {
                    Text("Challenge")
                        .font(.headline)
                        .padding(.horizontal, 60)
                        .padding(.vertical, 12.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color("base_colour"), lineWidth: 4)
                            )
                }
                .disabled((viewModel.current_player != 0) || !viewModel.still_bidding || viewModel.bids.isEmpty)
                .cornerRadius(16)
                .accentColor(Color("base_colour"))
            }
        }
        .padding()
        .background(
            Image("back")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                )
    }
    
}
