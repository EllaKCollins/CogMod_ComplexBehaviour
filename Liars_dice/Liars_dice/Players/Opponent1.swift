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
    
    func load_model(){
        model.loadModel(fileName: "liarsDice")  //TODO: insert name of act-r model here
    }
    
    override func run_opponent() -> (String, String){
        
        model.run()
        let decision = model.lastAction(slot: "previous")!
        if decision != "challenge" {
            let face = model.lastAction(slot: "currentbidf")!
            let num = model.lastAction(slot: "currentbidn")!
            return (face, num)
        }
        return (decision, "")
      
    }
    
    override func send_info(last_bid: Bid){
        model.modifyLastAction(slot: "currentbidf", value: last_bid.face)
        model.modifyLastAction(slot: "currentbidn", value: String(last_bid.num))
    }
    
    override func send_hand(){
        let poss = ["one", "two", "three", "four", "five", "six"]
        for x in poss {
            let count = self.hand.faces.filter({$0 == x}).count
            model.modifyLastAction(slot: x, value: String(count))
        }
    }
    
}
