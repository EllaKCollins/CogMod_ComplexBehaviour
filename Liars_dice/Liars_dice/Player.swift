//
//  Player.swift
//  Liars_dice
//
//  Created by Ella Collins on 18/02/2022.
//

import Foundation

class Player {
    var hand: Hand
    var name: String
    var still_in: Bool
    //var still_in: Bool = true
    
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
}
