
import SwiftUI
import Foundation

struct RulesView: View {
    
    var body: some View {
        VStack{
            ScrollView{
                VStack (alignment: .leading){
                    Group {
                        Text("Nature of the Game:")
                            .bold()
                        Text("Liar's Dice is a bluffing game where you want to deceive, but also detect deceptions of the other players.")
                    }
                    Spacer()
                    Group {
                        Text("How it is played:")
                            .bold()
                        Text("• Each player starts with 5 die, that are rolled at the start of the game. Every player's dice are hidden from every other player")
                        Text("• The starting player makes a bid, which is a guess of at least how many of a certain die face there are present in all the combined die")
                        Text("• The next player can then choose to bid, in which case their bid must conform to one of three rules: Given the bid 2 fours")
                        Text("  • Increase the number and keep the face the same: 3 or more fours")
                        Text("  • Increase the face and keep the  number the same: 2 fives")
                        Text("  • Decrease the face and Increase the number: 3 or more threes")
                    }
                    Group {
                        Text("• The next player can also choose to challenge:")
                        Text("  • All the die will be revealed and the number that are in line with the last bid will be counted")
                        Text("  • If there are at least the number that the bidder claimed, the challenger loses a die, otherwise the bidder loses a die")
                        Text("  • Players roll their dice")
                        Text("  • The one that loses a die starts the next round")
                        Text("• Once a player has lost all their die they are out")
                        Text("• These steps are repeated until only one player is left, and they are the winner")
                        Text("Good luck!")
                            .bold()
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    //.frame(width: 200, height: 200)
                    //.stroke(Color.white, lineWidth: 4)
                )
        }
        .background(
            Image("back")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                )
    }
    
        
}

