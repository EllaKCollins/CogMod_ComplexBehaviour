//
//  GameView.swift
//  Liars_dice
//
//  Created by Ella Collins on 17/02/2022.
//

import Foundation
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

struct GameView: View {
    @ObservedObject var viewModel: LDViewModel
    @ScaledMetric var scale: CGFloat = 1
    @State var timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    @State var display_dice: String = "one"
    @State var display_bid: Int = 1
    
    var dice_size: CGFloat = 30
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                // Opponent stuff here
                if viewModel.current_player == 1 && viewModel.still_bidding { //  && viewModel.players[1]
                    Text("Opponent 1")
                        .padding(.all, 12.0)
                        .rotationEffect(Angle(degrees: -90))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.orange, lineWidth: 2)
                                .rotationEffect(Angle(degrees: -90)))
                        .onReceive(timer) { _ in
                            viewModel.model_run()
                        }
                }
                else {
                    Text("Opponent 1")
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
                        else {
                            Image(viewModel.players[1].hand.faces[dice])
                                .resizable()
                                .frame(width: dice_size * scale, height: dice_size * scale)
                        }
                    }
                }
                Spacer()
                VStack {
                    // Bids!
                    Spacer()
                    HStack{
                        if viewModel.bids.isEmpty == false && !viewModel.game_over {
                            
                            Text("\(viewModel.bids.last!.num)")
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
                    if viewModel.game_over {
                        Text("Game over \n \(viewModel.winner) won")
                    }
                    Spacer()
                    if !viewModel.still_bidding {
                        Button {
                            viewModel.roll()
                        } label: {
                            if viewModel.game_over {
                                Text("New game")
                            }
                            else {
                                Text("Roll")
                            }
                        }
                        .padding(.all, 12.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.orange, lineWidth: 4)
                            )
                        .cornerRadius(16)
                        .accentColor(.orange)
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
                        else {
                            Image(viewModel.players[2].hand.faces[dice])
                                .resizable()
                                .frame(width: dice_size * scale, height: dice_size * scale)
                        }
                    }
                }
                if viewModel.current_player == 2  && viewModel.still_bidding { //  && viewModel.players[1]
                    Text("Opponent 2")
                        .padding(.all, 12.0)
                        .rotationEffect(Angle(degrees: -90))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.orange, lineWidth: 2)
                                .rotationEffect(Angle(degrees: -90)))
                        .onReceive(timer) { _ in
                            viewModel.model_run()
                        }
                }
                else {
                    Text("Opponent 2")
                        .padding(.all, 12.0)
                        .rotationEffect(Angle(degrees: -90))
                }
            }
            Spacer()
            // Player hand
            HStack {
                ForEach(viewModel.players[0].hand.faces.indices, id: \.self){ dice in
                    Image(viewModel.players[0].hand.faces[dice])
                        .resizable()
                        .frame(width: dice_size * scale, height: dice_size * scale)
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
                        .foregroundColor(.orange)
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
                        .stroke(Color.orange, lineWidth: 2))
                .accentColor(.orange)
                Button {
                    // implement bidding here !
                    viewModel.human_bid()

                } label: {
                    Text("Bid")
                        .padding(.all, 12.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.orange, lineWidth: 4)
                            )
                }
                .disabled((viewModel.current_player != 0) || !viewModel.still_bidding || viewModel.not_valid_bid)
                .cornerRadius(16)
                .accentColor(.orange)
                Spacer()
                if viewModel.current_player == 0 && viewModel.still_bidding { //  && viewModel.players[1]
                    Text("You")
                        .padding(.all, 12.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.orange, lineWidth: 2))
                }
                else {
                    Text("You")
                        .padding(.all, 12.0)
                }
                Spacer()
                Button {
                    viewModel.stop_bidding()
                    viewModel.challenge_bid()
                } label: {
                    Text("Challenge")
                        .padding(.horizontal, 60)
                        .padding(.vertical, 12.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.orange, lineWidth: 4)
                            )
                }
                .disabled((viewModel.current_player != 0) || !viewModel.still_bidding || viewModel.bids.isEmpty)
                .cornerRadius(16)
                .accentColor(.orange)
                // Color(red: 0.719, green: 0.002, blue: 0.312)
            }
        }
        .padding()
    }    
}
