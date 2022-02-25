//
//  Game.swift
//  Liars_dice
//
//  Created by Ella Collins on 18/02/2022.
//

import Foundation

struct Game{
    var num_players: Int
    var bids: [Bid] = []
    var total_die: Int
    var players: [Player] = []
    var hand_size: Int
    var possible_bid_num: Int = 1
    var disable_plus = false
    var disable_minus = true
    
    init(num_players: Int, hand_size: Int) {
        self.num_players = num_players
        players.append(Player(name: "You", num_die: hand_size))
        self.hand_size = hand_size
        self.total_die = self.num_players * self.hand_size
        for i in 0...(num_players-1) {
            players.append(Opponent1(name: "ACT-R model " + String(i) , num_die: hand_size))
        }
    }
    
    func start_round(){
        for player in players {
            player.hand.roll_die()
        }
    }
    
    mutating func check_button_disable() {
        if possible_bid_num == total_die {
            disable_plus = true
        }
        else {
            disable_plus = false
        }
        if possible_bid_num == 1 || (bids.count > 0 && possible_bid_num == bids.last?.num){
            disable_minus = true
        }
        else {
            disable_minus = false
        }
    }
    
    mutating func change_bid_num(action: String){
        switch action {
        case "+":
            if possible_bid_num < total_die {
                possible_bid_num += 1
            }
        case "-":
            if possible_bid_num > 0 {
                possible_bid_num -= 1
            }
        default:
            print("error in change bid num")
        }
        check_button_disable()
    }
    
    /* when this is called also show the die in the ui,
     make challege is correct remove die from bidder */
    /**
       Returns true if the challenge is successful, else fasle
     */
    func challenge_bid(last_bid: Bid) -> Bool{
        var total = 0
        for player in players {
            total += player.hand.count_face(face: last_bid.face)
        }
        if total >= last_bid.num {
            return false
        }
        return true
    }
    
}
