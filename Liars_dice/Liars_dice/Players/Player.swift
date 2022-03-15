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
    
    func run_opponent() -> Bid{
        return Bid(face: "one", num: 1)
    }
}
