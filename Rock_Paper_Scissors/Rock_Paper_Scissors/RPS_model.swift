//
//  RPS_model.swift
//  Rock_Paper_Scissors
//
//  Created by Ella Collins on 17/02/2022.
//

import Foundation

class RPS_model{
    var model = Model()
    var current_choice = ""
    var step_num = 0
    
    func loadModel() {
        model.loadModel(fileName: "rps")
    }
    
    func run_rps() -> String {
        if step_num == 0{
            print("Im not being dumb")
            loadModel()
        }
        model.run()
        current_choice = model.lastAction(slot: "choice")!
        step_num += 1
        return return_image(choice: current_choice)
    }
    
    func return_image(choice: String) -> String {
        if choice == "paper" {
            return "doc.fill"
        }
        else if choice == "scissors"{
            return "scissors"
        }
        else if choice == "rock"{
            return "oval.fill"
        }
        return ""
    }
    
    func consider_opponent_action(thing: String) {
        model.modifyLastAction(slot: "opponent", value: return_name(choice: thing))
    }
    
    func return_name(choice: String) -> String {
        if choice == "doc.fill" {
            return "paper"
        }
        else if choice == "scissors"{
            return "scissors"
        }
        else if choice == "oval.fill"{
            return "rock"
        }
        return ""
    }
}
