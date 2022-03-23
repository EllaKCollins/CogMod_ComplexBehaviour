//
//  LDviewModel.swift
//  Liars_dice
//
//  Created by Ella Collins on 24/02/2022.
//

import Foundation


class LDViewModel: ObservableObject {
    @Published private var model = Game(num_players: 3, hand_size: 5)
    
    var possible_bid_num: Int {
        model.possible_bid_num
    }
    
    var bids: [Bid]{
        model.bids
    }
    
    var current_player: Int {
        model.current_player
    }
    
    var disable_minus: Bool {
        model.disable_minus
    }
    
    var disable_bid_chall: Bool {
        model.disable_bid_chall
    }
    
    var players: [Player] {
        model.players
    }
    
    var winner: String {
        model.winner
    }
    
    var disable_plus: Bool {
        model.disable_plus
    }
    
    var not_valid_bid: Bool {
        model.not_valid_bid
    }
    
    var current_bid_dice: String {
        model.current_bid_dice
    }
    
    var still_bidding: Bool {
        model.still_bidding
    }
    
    var game_over: Bool {
        model.game_over
    }
    
    func stop_bidding(){
        model.stop_bidding()
    }
    
    func roll(){
        model.roll()
    }
    
    func change_bid_dice(){
        model.change_current_bid_dice()
    }
    
    func change_bid_num(action: String){
        model.change_bid_num(action: action)
    }
    
    func challenge_bid(){
        model.challenge_bid()
    }
    
    func human_bid(){
        model.human_bid()
    }
    
    func end_game() -> String{
        model.end_game()
    }
    
    func model_run() {
        model.model_run()
    }
    
}
