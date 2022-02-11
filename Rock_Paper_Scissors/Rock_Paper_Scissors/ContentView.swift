//
//  ContentView.swift
//  Rock_Paper_Scissors
//
//  Created by Ella Collins on 11/02/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GameView()
    }
}

struct GameView: View {
    
    @State var display_text = "Choose one to start the game."
    
    var body: some View {
        VStack{
            Text("Opponent")
                .font(.title)
            
            Spacer()
            Text(display_text)
            Spacer()
            HStack{
                Button {
                    display_text = "You chose: rock"
                } label: {
                    VStack {
                        Image(systemName:"oval.fill")
                            .font(.largeTitle)
                        Text("Rock")
                            .font(.caption)
                    }
                }
                Spacer()
                Button {
                    display_text = "You chose: paper"
                } label: {
                    VStack {
                        Image(systemName:"doc.fill")
                            .font(.largeTitle)
                        Text("Paper")
                            .font(.caption)
                    }
                }
                Spacer()
                Button {
                    display_text = "You chose: scissors"
                } label: {
                    VStack {
                        Image(systemName:"scissors")
                            .font(.largeTitle)
                        Text("Scissors")
                            .font(.caption)
                    }
                }
            }
            
            Text("You")
                .font(.title)
        }
        
            
        .padding(.horizontal)
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
