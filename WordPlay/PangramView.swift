//
//  Pangram.swift
//  WordPlay
//
//  Created by Sanay Fatullayeva on 06.12.21.
//

import SwiftUI
import FloatingLabelTextFieldSwiftUI

struct PangramView: View {
    @State var pangram = ""
    
    @State var popPresented = false
    
    var body: some View {
        VStack{
            HStack{
                Text("Pangram Check")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .navigationBarTitleDisplayMode(.inline)
                    .padding()
                    .accessibilityAddTraits(.isHeader)
                
                
                Button(action: {
                    self.popPresented = true
                }){
                    Image(systemName: "info.circle")
                }.accessibilityLabel("Pangram Definition")
                .popover(isPresented: $popPresented) {
                    VStack{
                        HStack{
                        Button(action: {
                            popPresented = false
                        }){
                            Spacer()
                            Image(systemName: "xmark")
                                .padding()
                        }.accessibilityLabel("Close Pangram Definition Popover")
                        }
                        Spacer()
                        Spacer()
                        Text("Pangram")
                            .font(.largeTitle)
                            .accessibilityAddTraits(.isStaticText)
                        
                        HStack{
                            Text("Noun")
                                .italic()
                            Text("/ˈpanɡram/")
                                .font(.caption)
                        }
                        Spacer()
                            .frame(width: 30, height: 90)
                        Text("A word or a sentence containing all the letters of the alphabet")
                            .accessibilityAddTraits(.isStaticText)
                        Spacer()
                        Spacer()
                        
                    }.accessibilityAddTraits(.isModal)
                }
            }.accessibilityElement(children: .combine)
            
            Spacer()
            
            let pangramCase = (pangram != "") && (pangram.count != 1)
            
            
            if isPangram(str: pangram.lowercased()) && pangramCase{
                Text(" '\(pangram)' is a pangram ✅")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isStaticText)
                
                
                Button("Copy Pangram",action: {
                    UIPasteboard.general.string = pangram
                }).accessibilityLabel("Copy Pangram")
                
            }else if pangramCase {
                
                Text("'\(pangram)' isn't a pangram ❌")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isStaticText)
            }
            
            
            Spacer()
            
            
            ZStack{
                
                ZStack(alignment: .leading) {
                    if !pangram.isEmpty{
                        Text("Pangram")
                            .padding(19)
                            .foregroundColor($pangram.wrappedValue.isEmpty ? Color(.placeholderText) : .accentColor)
                            .offset(y: $pangram.wrappedValue.isEmpty ? 0 : -35)
                            .scaleEffect($pangram.wrappedValue.isEmpty ? 1 : 0.75, anchor: .leading)
                    }
                    TextField("Pangram", text: $pangram)
                        .padding(4)
                        .submitLabel(.go)
                        .modifier(ClearButton(text: $pangram))
                        .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color.gray, lineWidth: 1))
                        .multilineTextAlignment(.leading)
                        .padding()
                    
                }
                .padding(.top, 15)
                
                Spacer()
                Spacer()
                Spacer()
                
            }.accessibilityElement(children: .combine)
            
            Spacer()
        }
    }
    
    func returnCorrextText() -> String{
        let pangramCase = (pangram != "") && (pangram.count != 1)
        let txt = (isPangram(str: pangram.lowercased()) && pangramCase) ? " is a pangram ✅" : " is not a pangram ❌"
        return txt
    }
    
    func isPangram(str: String) -> Bool {
        let (char, alph) = (Set(str), "abcdefghijklmnopqrstuvwxyz")
        return !alph.contains {!char.contains($0)}
    }
    
}

struct Pangram_Previews: PreviewProvider {
    static var previews: some View {
        PangramView()
    }
}
