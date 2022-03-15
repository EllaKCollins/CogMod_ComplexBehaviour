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
    
    
    override func run_opponent() -> Bid{
//        if step_num == 0 {
//            loadModel()
//        }
        step_num += 1
        
        //model.run()
        
        if self.name == "ACT-R model 1" {
            return Bid(face: "four", num: 3)
        }
        
        return Bid(face: "three", num: 2)
    }
}
