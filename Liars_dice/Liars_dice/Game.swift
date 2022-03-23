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
    var game_over = false
    var winner = "none"
    var not_valid_bid = false
    var face_dict: [String: Int] = ["one": 1, "two": 2, "three": 3, "four": 4, "five": 5, "six": 6]
    
    init(num_players: Int, hand_size: Int) {
        self.num_players = num_players
        self.hand_size = hand_size
        players.append(Player(name: "You", num_die: self.hand_size, still_in: true))
        self.total_die = self.num_players * self.hand_size
        for i in 1...(num_players-1) {
            let temp = Opponent1(name: "ACT-R model " + String(i) , num_die: self.hand_size, still_in: true)
            temp.load_model()
            players.append(temp)
        }
    }
    
    
    mutating func end_game() -> String {
        disable_plus = true
        disable_minus = true
        disable_bid_chall = true
        still_bidding = false
        var winner = "no one"
        for player in players {
            if player.still_in {
                winner = player.name
                break
            }
        }
        print("is this working")
        return winner
    }
    
    mutating func start_round(){
        print(total_die)
        for player in players {
            if player.still_in {
                player.hand.roll_die()
                player.send_hand() // only has a functionality if the player is an opponent
            }
        }
    }
    
    mutating func roll(){
        print("whatsup mate")
        if game_over {
            for player in players {
                player.hand.num_die = hand_size
                player.still_in = true
            }
            game_over = false
        }
        still_bidding = true
        self.start_round()
        self.bids.removeAll()
        possible_bid_num = 1
        current_bid_dice = "one"
        check_valid_bid()
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
        check_valid_bid()
    }
    
    mutating func check_valid_bid(){
        if bids.isEmpty == false {
            if current_bid_dice == bids.last!.face && possible_bid_num <= bids.last!.num {
                not_valid_bid = true
            }
            else if face_dict[current_bid_dice]! <= face_dict[bids.last!.face]! && possible_bid_num <= bids.last!.num {
                not_valid_bid = true
            }
            else {
                not_valid_bid = false
            }
        }
        else {
            not_valid_bid = false
        }
    }
    
    mutating func check_button_disable() {
        if possible_bid_num == total_die {
            disable_plus = true
        }
        else {
            disable_plus = false
        }
        if possible_bid_num == 1 || (bids.count > 0 && possible_bid_num <= bids.last!.num){
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
        check_valid_bid()
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
        var new_player = current
        if current == 0 {
            new_player = num_players - 1
            if players[new_player].still_in {
                return new_player
            }
            return retrieve_previous_player(current: new_player)
        }
        new_player = current - 1
        if players[new_player].still_in {
            return new_player
        }
        return retrieve_previous_player(current: new_player)
    }
    
    func retrieve_next_player(current: Int) -> Int {
        var new_player = current
        if current == (num_players - 1) {
            new_player = 0
            if players[new_player].still_in {
                return new_player
            }
            return retrieve_next_player(current: new_player)
        }
        new_player = current + 1
        if players[new_player].still_in {
            return new_player
        }
        return retrieve_next_player(current: new_player)
    }
    
    mutating func stop_bidding(){
        still_bidding = false
    }
    
    mutating func human_bid(){
        // human player
        let cur_bid = Bid(face: current_bid_dice, num: possible_bid_num)
        bids.append(cur_bid)
        
        current_player = retrieve_next_player(current: current_player)
        check_button_disable()
        check_valid_bid()
    }
    
    mutating func model_run(){
        // send last bid to model
        let last_bid = bids.last!
        players[current_player].send_info(last_bid: last_bid)
        
        let (face, num) = players[current_player].run_opponent()
        print(face, num)
        if face == "challenge" {
            self.challenge_bid()
        }
        else {
            let model_bid = Bid(face: face, num: Int(num)!)
            bids.append(model_bid)
            
            current_player = retrieve_next_player(current: current_player)
            check_button_disable()
        }
    }
    
    mutating func challenge_bid() {
        let challenged_index = retrieve_previous_player(current: current_player)
        let challenger = players[current_player]
        let challenged_player = players[challenged_index]
        
        let challenge_result = determine_result()
        
        if challenge_result{
            challenged_player.hand.remove_dice()
            current_player = challenged_index
            if challenged_player.hand.num_die == 0 {
                challenged_player.still_in = false
                current_player = retrieve_previous_player(current: current_player)
            }
        }else{
            challenger.hand.remove_dice()
            if challenger.hand.num_die == 0 {
                challenger.still_in = false
                current_player = retrieve_next_player(current: current_player)
            }
        }
        total_die -= 1
        var count = 0
        for player in players {
            if player.still_in {
                count += 1
            }
        }
        if count == 1 {
            game_over = true
            winner = end_game()
        }
    }
    
}
