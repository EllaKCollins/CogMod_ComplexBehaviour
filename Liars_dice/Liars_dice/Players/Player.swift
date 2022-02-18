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
    
    
    init(name: String, num_die: Int){
        self.hand = Hand(num_die: num_die)
        self.name = name
    }
}
