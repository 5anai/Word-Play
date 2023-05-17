//
//  AnagramView.swift
//  WordPlay
//
//  Created by Sanay Fatullayeva on 06.12.21.
//

import SwiftUI
import Combine
import FloatingLabelTextFieldSwiftUI
import NaturalLanguage

struct AnagramView: View {
    @State var anagram1 = ""
    @State var anagram2 = ""
    
    @State var popPresented = false
    
    @State private var gameWord = ""
    
    @Binding var viewingGame: Bool
    
    @State var screenSize: CGRect = UIScreen.main.bounds
    
    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    
                    Text("Anagram Check")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .navigationBarTitleDisplayMode(.inline)
                        .padding()
                        .accessibilityAddTraits(.isHeader)
                    
                    
                    Button(action: {
                        self.popPresented = true
                    }){
                        Image(systemName: "info.circle")
                    }.accessibilityLabel("Anagram Definition")
                    .popover(isPresented: $popPresented) {
                        VStack{
                            HStack{
                                
                            Button(action: {
                                popPresented = false
                            }){
                                Spacer()
                                Image(systemName: "xmark")
                                    .padding()
                            }.accessibilityLabel("Close Anagram Definition Popover")
                            }
                            Spacer()
                            Spacer()
                            Text("Anagram")
                                .font(.largeTitle)
                                .accessibilityAddTraits(.isStaticText)
                            
                            HStack{
                                Text("Noun")
                                    .italic()
                                Text("/ˈanəɡram/")
                                    .font(.caption)
                            }
                            Spacer()
                                .frame(width: 30, height: 90)
                            Text("A word, phrase, or name formed by rearranging the letters of another")
                                .accessibilityAddTraits(.isStaticText)
                            Spacer()
                            Spacer()
                        }.accessibilityAddTraits(.isModal)
                    }
                }.accessibilityElement(children: .combine)
                
                Spacer()
                
                let anagramCase = (anagram1 != "") && (anagram2 != "")
                
                if anagramCheck(a: anagram1.lowercased(), b: anagram2.lowercased()) && anagramCase{
                    Text("'\(anagram1)' is an anagram of '\(anagram2)' ✅")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .accessibilityAddTraits(.isStaticText)
                    
                }else if anagramCase{
                    Text("'\(anagram1)' isn't an anagram '\(anagram2)'❌ ")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .accessibilityAddTraits(.isStaticText)
                }
                
                
                
                Spacer()
                Spacer()
                
                HStack{
                    Spacer()
                    ZStack(alignment: .leading) {
                        if !anagram1.isEmpty{
                            Text("First Word")
                                .padding(5)
                                .foregroundColor($anagram1.wrappedValue.isEmpty ? Color(.placeholderText) : .accentColor)
                                .offset(y: $anagram1.wrappedValue.isEmpty ? 0 : -35)
                                .scaleEffect($anagram1.wrappedValue.isEmpty ? 1 : 0.75, anchor: .leading)
                        }
                        TextField("First Word", text: $anagram1)
                            .padding(4)
                            .submitLabel(.go)
                            .modifier(ClearButton(text: $anagram1))
                            .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color.gray, lineWidth: 1))
                    }
                   
                    ZStack(alignment: .leading) {
                        if !anagram2.isEmpty{
                            Text("Second Word")
                                .padding(5)
                                .foregroundColor($anagram2.wrappedValue.isEmpty ? Color(.placeholderText) : .accentColor)
                                .offset(y: $anagram2.wrappedValue.isEmpty ? 0 : -35)
                                .scaleEffect($anagram2.wrappedValue.isEmpty ? 1 : 0.75, anchor: .leading)
                        }
                        TextField("Second Word", text: $anagram2)
                            .padding(4)
                            .submitLabel(.go)
                            .modifier(ClearButton(text: $anagram2))
                            .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color.gray, lineWidth: 1))
                    }
                    
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width-3)
                .accessibilityElement(children: .combine)
                
                
                Spacer()
                
                NavigationLink(destination: AnagramGameView(showingPicker: $viewingGame)){
                    Image(systemName: "gamecontroller.fill")
                }
                
                Spacer()
                
            }.onAppear(){
                viewingGame = true
            }.navigationBarTitle("")
                .navigationBarHidden(true)
                .onDisappear{
                    print("VIEW HAS DISAPPEARED!!!!")
                    print("screen size: \(screenSize)")
                    anagram2 = ""
                    anagram1 = ""
                }
        }
    }
    
    
    func anagramCheck(a: String, b: String) -> Bool {
        //a = a.filter{!$0.isWhitespace}
        //b = b.filter{!$0.isWhitespace}
        guard a.count == b.count else { return false }
        let aSet = NSCountedSet()
        let bSet = NSCountedSet()
        for c in a {
            aSet.add(c)
        }
        for c in b {
            bSet.add(c)
        }
        return aSet == bSet
    }
}


struct AnagramView_Previews: PreviewProvider {
    static var previews: some View {
        AnagramView(viewingGame: .constant(true))
    }
}
