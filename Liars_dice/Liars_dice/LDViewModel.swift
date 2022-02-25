//
//  LDviewModel.swift
//  Liars_dice
//
//  Created by Ella Collins on 24/02/2022.
//

import Foundation


class LDViewModel: ObservableObject {
    @Published private var model = Game(num_players: 3, hand_size: 5)
    
    var possible_bid_num: Int {
        model.possible_bid_num
    }
    
    var disable_minus: Bool {
        model.disable_minus
    }
    
    var disable_plus: Bool {
        model.disable_plus
    }
    
    func change_bid_num(action: String){
        model.change_bid_num(action: action)
    }
    
}
