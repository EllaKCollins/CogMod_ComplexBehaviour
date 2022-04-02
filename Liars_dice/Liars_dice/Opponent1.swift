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
        model.loadModel(fileName: "liarsDice")
        model.run()
    }
    
    override func run_opponent() -> (String, String){
        print("model is trying to run ...")
        print(model.buffers)
        model.run()
        print("model has run ...")
        print(model.trace)
        print(model.buffers)
        let decision = model.lastAction(slot: "challenge")!
        if (String(decision) != "challenge") {
            let face = model.lastAction(slot: "bidface")!
            let num = model.lastAction(slot: "bidnumber")!
            print("model is bidding: " , face, num)
            return (face, num)
        }
        print("model is ", decision)
        return (decision, "")
      
    }
    
    override func send_info(last_bid: Bid, total_die: Int, first_bid: Bool){
        send_hand(total_die: total_die)
        model.modifyLastAction(slot: "first", value: String(first_bid))
        model.modifyLastAction(slot: "bidface", value: last_bid.face)
        model.modifyLastAction(slot: "bidnumber", value: String(last_bid.num))
    }

    override func send_hand(total_die: Int){
        let poss = ["one", "two", "three", "four", "five", "six"]
        for x in poss {
            let count = self.hand.faces.filter({$0 == x}).count
            model.modifyLastAction(slot: "hand" + x, value: String(count))
        }
        model.modifyLastAction(slot: "totaldie", value: String(total_die))
        print("we've sent this")
    }
    
}
