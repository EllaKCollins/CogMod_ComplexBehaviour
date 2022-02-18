//
//  Hand.swift
//  Liars_dice
//
//  Created by Ella Collins on 18/02/2022.
//

import Foundation

class Hand {
    var num_die: Int
    var faces: [Int] = []
    
    init(num_die: Int) {
        self.num_die = num_die
    }
    
    func remove_dice(){
        num_die -= 1
    }
    
    func roll_die(){
        faces = []
        for _ in 0...num_die {
            faces.append(Int.random(in: 1..<7))
        }
    }
    
    func count_face(face: Int) -> Int{
        var count = 0
        for die in faces {
            if die == face {
                count += 1
            }
        }
        return count
    }
    
}
