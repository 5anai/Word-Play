//
//  CheckerView.swift
//  WordPlay
//
//  Created by Sanay Fatullayeva on 07.12.21.
//

import SwiftUI

enum ViewChoice{
    case palindrome, anagram, pangram
}

enum ViewVisibility: CaseIterable {
    case visible,
         invisible,
         gone
}

extension View {
    @ViewBuilder func visibility(_ visibility: ViewVisibility) -> some View {
        if visibility != .gone {
            if visibility == .visible {
                self
            } else {
                hidden()
            }
        }
    }
}

struct CheckerView: View {
    @State private var toView: ViewChoice = .anagram
    @State var viewTitle = ""
    
    @State private var redVisibility: ViewVisibility = .visible
    
    @State var viewingGame: Bool = true
    
    var body: some View {
        
        ZStack(alignment: Alignment.bottom){
            
            switch(toView) {
            case .palindrome:
                PalindromeView()
            case .anagram:
                AnagramView(viewingGame: $viewingGame)
            case .pangram:
                PangramView()
            }
            
            if !viewingGame {
                
                Picker("Word Play Picker", selection: $toView){
                    Text("Palindrome").tag(ViewChoice.palindrome)
                    Text("Anagram").tag(ViewChoice.anagram)
                    Text("Pangram").tag(ViewChoice.pangram)
                }
                .pickerStyle(SegmentedPickerStyle())
                .visibility(.gone)
                
            } else if viewingGame{
                
                Picker("Word Play Picker", selection: $toView){
                    Text("Anagram").tag(ViewChoice.anagram)
                    Text("Palindrome").tag(ViewChoice.palindrome)
                    Text("Pangram").tag(ViewChoice.pangram)
                }
                //.frame(width: 350, height: 70)
                    .frame(width: UIScreen.main.bounds.width-10, height: 70)
                    .pickerStyle(SegmentedPickerStyle())
                    .visibility(.visible)
                    .accessibilityLabel("Picker")
            }
            
        }//.frame(width: UIScreen.main.bounds.width-10)
    }
    
}

struct CheckerView_Previews: PreviewProvider {
    static var previews: some View {
        CheckerView()
    }
}
