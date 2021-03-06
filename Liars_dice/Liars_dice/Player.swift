//
//  Player.swift
//  Liars_dice
//
//  Created by Ella Collins on 18/02/2022.
//

import Foundation

/**
 This class implements the player. It has the name of the player, the hand of the player and a boolean showing whether the player still has dice in tehir hand.
 */

class Player {
    var hand: Hand
    var name: String
    var still_in: Bool
    
    init(name: String, num_die: Int, still_in: Bool){
        self.hand = Hand(num_die: num_die)
        self.name = name
        self.still_in = still_in
    }
    
    func run_opponent() -> (String, String){
        return ("sup", "bro")
    }
    
    func send_info(last_bid: Bid, total_die: Int, first_bid: Bool){}
    
    func send_hand(total_die: Int){}
    
    func send_reasonable_bids(reasonable_bids: [Bid], total_die: Int){}
    
    func save_model(){}
}
