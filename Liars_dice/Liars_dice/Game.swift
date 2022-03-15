//
//  Game.swift
//  Liars_dice
//
//  Created by Ella Collins on 18/02/2022.
//

import Foundation

struct Game{
    var num_players: Int
    var bids: [Bid] = []
    var current_bid_dice = "one" // dice face that is being bid
    var total_die: Int
    var players: [Player] = []
    var hand_size: Int
    var possible_bid_num: Int = 1
    var disable_plus = false
    var disable_minus = true
    var still_bidding = false
    var current_player = 0
    var disable_bid_chall = false
    
    init(num_players: Int, hand_size: Int) {
        self.num_players = num_players
        players.append(Player(name: "You", num_die: 5, still_in: true))
        self.hand_size = hand_size
        self.total_die = self.num_players * self.hand_size
        for i in 1...(num_players-1) {
            players.append(Opponent1(name: "ACT-R model " + String(i) , num_die: 5, still_in: true))
        }
        print(num_players)
        print(still_bidding)
        print(current_player)
    }
    
    func start_round(){
        for player in players {
            if player.still_in {
                player.hand.roll_die()
                print(player.hand.faces)
            }
        }
    }
    
    mutating func roll(){
        still_bidding = true
        self.start_round()
        self.bids.removeAll()
    }
    
    mutating func change_current_bid_dice(){
        switch self.current_bid_dice {
        case "one": current_bid_dice = "two"
        case "two": current_bid_dice = "three"
        case "three": current_bid_dice = "four"
        case "four": current_bid_dice = "five"
        case "five": current_bid_dice = "six"
        case "six": current_bid_dice = "one"
        default: current_bid_dice = "one"
        }
    }
    
    mutating func check_button_disable() {
        if possible_bid_num == total_die {
            disable_plus = true
        }
        else {
            disable_plus = false
        }
        if possible_bid_num == 1 || (bids.count > 0 && possible_bid_num == bids.last?.num){
            disable_minus = true
        }
        else {
            disable_minus = false
        }
    }
    
    mutating func change_bid_num(action: String){
        switch action {
        case "+":
            if possible_bid_num < total_die {
                possible_bid_num += 1
            }
        case "-":
            if possible_bid_num > 0 {
                possible_bid_num -= 1
            }
        default:
            print("error in change bid num")
        }
        check_button_disable()
    }
    
    /* when this is called also show the die in the ui,
     make challege is correct remove die from bidder */
    /**
       Returns true if the challenge is successful, else fasle
     */
    func determine_result() -> Bool{
        let last_bid = bids.last
        var total = 0
        for player in players {
            total += player.hand.count_face(face: last_bid!.face)
        }
        if total >= last_bid!.num {
            return false
        }
        return true
    }
    
    func retrieve_previous_player(current: Int) -> Int {
        if current == 0 {
            return num_players - 1
        }
        else {
            return current - 1
        }
    }
    
    func retrieve_next_player(current: Int) -> Int {
        if current == (num_players - 1) {
            return 0
        }
        else {
            return current + 1
        }
    }
    
    mutating func stop_bidding(){
        still_bidding = false
    }
    
    mutating func human_bid(){
        if current_player == 0 {
            // human player
            let cur_bid = Bid(face: current_bid_dice, num: possible_bid_num)
            bids.append(cur_bid)
            
        }
        else {
            // one of the actr models do a thing :)
            let cur_bid = players[current_player].run_opponent()
            bids.append(cur_bid)
        }
        
        // move turn
        current_player = retrieve_next_player(current: current_player)
        print(bids)
        //sleep(5)
    }
    
    mutating func challenge_bid() {
        let challenged_index = retrieve_previous_player(current: current_player)
        let challenger = players[current_player]
        let challenged_player = players[challenged_index]
        
        let challenge_result = determine_result()
        
        if challenge_result{
            challenged_player.hand.remove_dice()
            if challenged_player.hand.num_die == 0 {
                challenged_player.still_in = false
            }
            current_player = challenged_index
        }else{
            challenger.hand.remove_dice()
            if challenger.hand.num_die == 0 {
                challenger.still_in = false
            }
        }
    }
    
}
