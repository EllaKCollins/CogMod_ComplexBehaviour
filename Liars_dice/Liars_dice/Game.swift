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
    var challenged = false
    var challenge_over = true
    var game_over = false
    var winner = "none"
    var starting_player = 0
    var not_valid_bid = false
    var face_dict: [String: Int] = ["one": 1, "two": 2, "three": 3, "four": 4, "five": 5, "six": 6]
    
    init(num_players: Int, hand_size: Int) {
        self.num_players = num_players
        self.hand_size = hand_size
        players.append(Player(name: "You", num_die: self.hand_size, still_in: true))
        self.total_die = self.num_players * self.hand_size
        for i in 1...(num_players-1) {
            let temp = Opponent(name: "Opponent " + String(i) , num_die: self.hand_size, still_in: true)
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
        self.total_die = self.num_players * self.hand_size
        return winner
    }
    
    mutating func start_round(){
        current_player = starting_player
        print("current player2: ", current_player)
        print("starting player2: ", starting_player)
        challenged = false
        for player in players {
            if player.still_in {
                player.hand.roll_die()
                player.send_hand(total_die: self.total_die) // only has a functionality if the player is an opponent
            }
        }
    }
    
    mutating func roll(){
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
        check_button_disable()
        print("roll: ", still_bidding, challenged)
        print(current_player)
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
        let test = false // TODO: remove when actr works :)
        if test {
            print("Im trying")
            let challenge = Int.random(in: 0..<4)
            if challenge == 0 && !bids.isEmpty{
                change_challenge()
                check_button_disable()
                check_valid_bid()
            }
            else {
            let poss = ["one", "two", "three", "four", "five", "six"]
            var temp_bid = Bid(face: poss[Int.random(in: 0..<6)], num: Int.random(in: 1..<(total_die/2)))
                if !bids.isEmpty{
                    let last_bid = bids.last!
                    var count = 0
                    while (temp_bid.num <= last_bid.num || (face_dict[temp_bid.face]! <= face_dict[last_bid.face]! && temp_bid.num == last_bid.num)) {
                        temp_bid = Bid(face: poss[Int.random(in: 0..<6)], num: Int.random(in: 1..<(total_die/2)))
                        count += 1
                        if count > 20 {
                            change_challenge()
                            check_button_disable()
                            check_valid_bid()
                            break
                        }
                    }
                    print("I did it!")
                    if count < 20 {
                        bids.append(temp_bid)
                        current_player = retrieve_next_player(current: current_player)
                        check_button_disable()
                        check_valid_bid()
                    }
                        
                }
                else{
                    bids.append(temp_bid)
                    current_player = retrieve_next_player(current: current_player)
                    check_button_disable()
                    check_valid_bid()
                }
            }
        }
        // not testing
        else {
            if !bids.isEmpty{
                let last_bid = bids.last!
                players[current_player].send_info(last_bid: last_bid, total_die: total_die, first_bid: false)
            }
            else {
                print("I have sent it nothing ")
                players[current_player].send_info(last_bid: Bid(face: "zero", num: 0), total_die: total_die, first_bid: true)
            }
            let (face, num) = players[current_player].run_opponent()
            
            if face == "challenge" {
                change_challenge()
                check_button_disable()
                check_valid_bid()
            }
            else {
                let model_bid = Bid(face: face, num: Int(Double(num)!))
                bids.append(model_bid)
                
                current_player = retrieve_next_player(current: current_player)
                check_button_disable()
                check_valid_bid()
            }
        }
    }
    
    mutating func change_challenge() {
        still_bidding = false
        challenged = true
        challenge_over = false
    }
    
    func determine_reasonable() -> [Bid]{
        let faces = ["one", "two", "three", "four", "five", "six"]
        var arr = [0, 0, 0, 0, 0, 0]
        
        for player in players {
            for (i, face) in faces.enumerated() {
                arr[i] += player.hand.count_face(face: face)
            }
        }
        var reasonable_bids: [Bid] = []
        for bid in bids {
            if arr[face_dict[bid.face]!] >= bid.num {
                reasonable_bids.append(bid)
            }
        }
        return reasonable_bids
    }
    
    mutating func challenge_bid() -> Int {
        
        let challenged_index = retrieve_previous_player(current: current_player)
        let challenger = players[current_player]
        let challenged_player = players[challenged_index]
        
        let challenge_result = determine_result()
        
        let reasonable_bids = determine_reasonable()
        print("giving the models more info...")
        players[1].send_reasonable_bids(reasonable_bids: reasonable_bids, total_die: total_die)
        players[2].send_reasonable_bids(reasonable_bids: reasonable_bids, total_die: total_die)
        
        if challenge_result{
            challenged_player.hand.remove_dice()
            starting_player = challenged_index
            if challenged_player.hand.num_die == 0 {
                challenged_player.still_in = false
                starting_player = retrieve_previous_player(current: current_player)
            }
        }else{
            challenger.hand.remove_dice()
            starting_player = current_player
            if challenger.hand.num_die == 0 {
                challenger.still_in = false
                starting_player = retrieve_next_player(current: current_player)
            }
            print("current player: ", current_player)
            print("starting player: ", starting_player)
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
        challenge_over = true
        
        return challenge_result ? challenged_index : current_player
    }
    
}
