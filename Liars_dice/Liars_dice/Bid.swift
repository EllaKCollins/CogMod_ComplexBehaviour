//
//  Bid.swift
//  Liars_dice
//
//  Created by Ella Collins on 18/02/2022.
//

import Foundation

/**
 This class is for the bids made by the players.
 */

class Bid {
    var face: String
    var num: Int
    
    init(face: String, num: Int) {
        self.face = face
        self.num = num
    }
}
