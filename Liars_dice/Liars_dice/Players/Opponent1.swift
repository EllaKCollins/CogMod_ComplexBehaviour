//
//  Opponent1.swift
//  Liars_dice
//
//  Created by Ella Collins on 17/02/2022.
//

import Foundation

class Opponent1: Player {
    var model = Model()
    var step_num = 0
    
    func loadModel(){
        model.loadModel(fileName: "")  //TODO: insert name of act-r model here
    }
    
    func run_opponent(){
        if step_num == 0 {
            loadModel()
        }
        step_num += 1
        
        model.run()
    }
}
