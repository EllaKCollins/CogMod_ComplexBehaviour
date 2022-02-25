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

    var body: some View {
        VStack {
            HStack {
                // Opponent stuff here
                Text("Opponent 1")
                Spacer()
                Text("Opponent 2")
            }
            Spacer()
            // Player stuff here
            HStack {
                HStack {
                    Button {
                        viewModel.change_bid_num(action: "-")
                    } label: {
                        Image(systemName: "minus")
                    }
                    .disabled(viewModel.disable_minus)
                    Text("\(viewModel.possible_bid_num)")
                        .foregroundColor(.orange)
                    Button {
                        viewModel.change_bid_num(action: "+")
                    } label: {
                        Image(systemName: "plus")
                    }
                    .disabled(viewModel.disable_plus)
                    Text("dice") // make this a image button
                }
                .padding(.all, 6.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.orange, lineWidth: 2))
                .accentColor(.orange)

                Button {
                    
                } label: {
                    Text("Bid")
                        .foregroundColor(.orange)
                        .padding(.all, 6.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.orange, lineWidth: 2)
                            )
                }
                .background(Color.yellow)
                .cornerRadius(16)
                Spacer()
                Text("Player Hand")
                Spacer()
                Button {
            
                } label: {
                    Text("Challenge")
                        .foregroundColor(.orange)
                        .padding(.all, 6.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.orange, lineWidth: 2)
                            )
                }
                .background(Color.yellow)
                .cornerRadius(16)
            }
        }
        .padding()
    }
}
