//
//  Game.swift
//  Liars_dice
//
//  Created by Ella Collins on 18/02/2022.
//

import Foundation

/**
 This struct includes all the important information about the game. All the logic of the game is dealt with and stored here.
 */

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
    
    /**
     this function is called when there is only one player left in the game. It returns this player.
     */
    mutating func end_game() -> String {
        disable_plus = true
        disable_minus = true
        disable_bid_chall = true
        still_bidding = false
        var winner = "no one"
        for player in players {
            player.save_model()
            if player.still_in {
                winner = player.name
                //break
            }
        }
        self.total_die = self.num_players * self.hand_size
        return winner
    }
    
    /**
     this function is called at the start of each round. It initialises each player's hand.
     */
    mutating func start_round(){
        current_player = starting_player
        challenged = false
        for player in players {
            if player.still_in {
                player.hand.roll_die()
                player.send_hand(total_die: self.total_die) // only has a functionality if the player is an opponent
            }
        }
    }
    
    /**
     this is the function called by the roll button in the view. It initializes all the necessary variables.
     */
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
    }
    
    /**
     this function changes the face of the dice for bidding in the view.
     */
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
    
    /**
     this function checks whether the current shown bid in the view is a valid bid or not. This makes the bid button avaliable or unavailable.
     */
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
    
    /**
     this function checks whether the plus or minus button should be available based on the previous bid made.
     */
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
    
    /**
     this function changes the bid number shown in the view for the human bid.
     */
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
    
    /**
       Returns true if the challenge is successful, else fasle
     */
    func determine_result() -> Bool{
        let last_bid = bids.last
        var total = 0
        for player in players {
            if player.still_in {
                total += player.hand.count_face(face: last_bid!.face)
            }
        }
        if total >= last_bid!.num {
            return false
        }
        return true
    }
    
    /**
     this function retrieves the previous player in the line of players.
     */
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
    
    /**
     this function retrives the next player in the line of players.
     */
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
    
    /**
     this function is called when the bidding in a round is stopped and helps make changes occur in the view.
     */
    mutating func stop_bidding(){
        still_bidding = false
    }
    
    /**
     this function is called when the user makes a bid. It adds the bid to the list of bids and passes the current player to the next player.
     */
    mutating func human_bid(){
        let cur_bid = Bid(face: current_bid_dice, num: possible_bid_num)
        bids.append(cur_bid)
        
        current_player = retrieve_next_player(current: current_player)
        check_button_disable()
        check_valid_bid()
    }
    
    /**
     this function is called to have either of the act-r  run and deals with the logic of their responses.
     */
    mutating func model_run(){
        print("running the model..")
        if !bids.isEmpty{
            let last_bid = bids.last!
            players[current_player].send_info(last_bid: last_bid, total_die: total_die, first_bid: false)
        }
        else {
            players[current_player].send_info(last_bid: Bid(face: "zero", num: 0), total_die: total_die, first_bid: true)
            print("sent")
        }
        var (face, num) = players[current_player].run_opponent()
        
        if face == "challenge" && bids.isEmpty {
            print("hi")
            (face, num) = players[current_player].run_opponent()
        }
        
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
    
    /**
     this function is called when a player challenges a bid. It allows changes in the variables to show up in the view before the result of the challenge is shown.
     */
    mutating func change_challenge() {
        still_bidding = false
        challenged = true
        challenge_over = false
    }
    
    /**
     this function goes through the bids made in a round and determines the bids that would have been correct.
     */
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
            if arr[face_dict[bid.face]!-1] >= bid.num {
                reasonable_bids.append(bid)
            }
        }
        return reasonable_bids
    }
    
    /**
     this function deals with the logic of challenging a bid. It calls the function that determines the winner, removes a dice from the looser's hand and changes the current player. Also, the reasonable bids are sent to the act-r models for the instance based learning.
     */
    mutating func challenge_bid() -> Int {
        
        let challenged_index = retrieve_previous_player(current: current_player)
        let challenger = players[current_player]
        let challenged_player = players[challenged_index]
        
        let challenge_result = determine_result()
        
        let reasonable_bids = determine_reasonable()
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
