//
//  Hand.swift
//  Liars_dice
//
//  Created by Ella Collins on 18/02/2022.
//

import Foundation

class Hand {
    var num_die: Int
    var faces: [String] = []
    
    init(num_die: Int) {
        self.num_die = num_die
    }
    
    func remove_dice(){
        num_die -= 1
        faces.removeLast()
    }
    
    func roll_die(){
        let options = ["one", "two", "three", "four", "five", "six"]
        faces = []
        for _ in 0...(num_die-1) {
            faces.append(options[Int.random(in: 0..<6)])
        }
    }
    
    func count_face(face: String) -> Int{
        var count = 0
        for die in faces {
            if die == face {
                count += 1
            }
        }
        return count
    }
    
}
