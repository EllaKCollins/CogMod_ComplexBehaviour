//
//  ContentView.swift
//  Memorize
//
//  Created by Ella Collins on 10/02/2022.
//

import SwiftUI

struct ContentView: View {
    
    let labels = ["Vehicles", "Second option", "Third option"]
    let card_arrays = [["🚗", "🚌", "🚙", "🚎", "🛵", "🚛", "🚜", "✈️", "🚝", "🚕", "🚑", "🚂", "🛺", "🚔", "🏎", "🚒"], ["🚗", "🚌", "🚙", "🚎", "🛵"], ["🛺", "🚔", "🏎", "🚒"]]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(labels.indices) { idx in
                    VStack(alignment: .leading, spacing: 3){
                        NavigationLink {
                            LinkView(cards: card_arrays[idx])
                        } label: {
                            LabelView(label: labels[idx], options: card_arrays[idx])
                        }
                        .navigationTitle("Memorize")
                    }
                }
            }
        }
    }
}

struct LinkView: View {
    var cards: [String]
    @ State var cardCount = 4
    var body: some View {
        ScrollView{
            LazyVGrid(columns:[GridItem(.adaptive(minimum: 65))]){
                ForEach(cards[0..<cardCount], id: \.self){card in
                    CardView(card: card)
                        .aspectRatio(2/3, contentMode: .fit)
                }
            }
        }
        .foregroundColor(.red)
        Spacer()
        HStack{
            remove
            Spacer()
            add
        }
        .font(.largeTitle)
        .padding(.horizontal)
    }
    var remove: some View {
        Button {
            if cardCount > 1 {
                cardCount -= 1
            }
        } label: {
            Image(systemName: "minus.circle")
        }
    }
    var add: some View {
        Button {
            if cardCount < cards.capacity {
                cardCount += 1
            }
        } label: {
            Image(systemName: "plus.circle")
        }
    }
}

struct CardView: View{
    var card: String
    @State var isFaceUp: Bool = false
    var body: some View{
        ZStack{
            let shape = RoundedRectangle(cornerRadius: 20)
            if isFaceUp{
                shape.stroke(lineWidth: 3)
                shape.fill().foregroundColor(.white)
                Text(card).font(.largeTitle)
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .fill()
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}

struct LabelView: View {
    var label: String
    var options: [String]
    var body: some View {
        VStack(alignment: .leading, spacing: 3){
            Text(label)
                .foregroundColor(.primary)
                .font(.headline)
            HStack{
                Text(options.joined(separator: ", "))
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewInterfaceOrientation(.portraitUpsideDown)
        }
    }
}
