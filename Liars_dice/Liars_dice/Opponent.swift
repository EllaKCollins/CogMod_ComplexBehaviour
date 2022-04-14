//
//  Opponent1.swift
//  Liars_dice
//
//  Created by Ella Collins on 17/02/2022.
//

import Foundation

/**
 This class is a sub-class of Player and is for the opponent. It loads the act-r model and has functions to send information to and from the act-r model.
 */

class Opponent: Player {
    var model = Model()
    var step_num = 0
    
    func load_model(){
        model.loadModel(fileName: "liarsDice")
        model.run(maxTime: 99999999999999999999)
    }
    
    override func run_opponent() -> (String, String){
        model.run(maxTime: 99999999999999999999)
        let decision = model.lastAction(slot: "challenge")!
        if (String(decision) != "challenge") {
            let face = model.lastAction(slot: "bidface")!
            let num = model.lastAction(slot: "bidnumber")!
            return (face, num)
        }
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
    }
    
    override func send_reasonable_bids(reasonable_bids: [Bid], total_die: Int){
        for bid in reasonable_bids {
            let name = "bid" + bid.face + String(bid.num) + String(total_die)
            let chunk = Chunk(s: name, m: model)
            chunk.setSlot(slot: "isa", value: "current-state")
            chunk.setSlot(slot: "bidface", value: bid.face)
            chunk.setSlot(slot: "bidnumber", value: Double(bid.num))
            chunk.setSlot(slot: "reasonable", value: Double(1))
            chunk.setSlot(slot: "totaldie", value: Double(total_die))
            model.dm.addToDM(chunk)
        }
    }
    
    override func save_model() {
        writeModel(filename: self.name, model: model)
    }
    
}
