//
//  ContentView.swift
//  WordPlay
//
//  Created by Sanay Fatullayeva on 06.12.21.
//

import SwiftUI
import UIKit


import FloatingLabelTextFieldSwiftUI


struct PalindromeView: View {
    @State var palindrome = ""
    @State var popPresented = false
    
    var body: some View {
        VStack{
            HStack{
                Text("Palindrome Check")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .navigationBarTitleDisplayMode(.inline)
                    .padding()
                    .accessibilityAddTraits(.isHeader)
                
                Button(action: {
                    self.popPresented = true
                }){
                    Image(systemName: "info.circle")
                    
                }.accessibilityLabel("Palindrome Definition")
                .popover(isPresented: $popPresented) {
                    VStack{
                        HStack{
                            //Spacer()
                        Button(action: {
                            popPresented = false
                        }){
                            Spacer()
                            Image(systemName: "xmark")
                                .padding()
                        }.accessibilityLabel("Close Palindrome Definition Popover")
                        }
                        Spacer()
                        Spacer()
                        Text("Palindrome")
                            .font(.largeTitle)
                            .accessibilityAddTraits(.isStaticText)
                        HStack{
                            Text("Noun")
                                .italic()
                            
                            Text("/ˈpalɪndrəʊm/")
                                .font(.caption)
                            
                        }
                        Spacer()
                            .frame(width: 30, height: 90)
                        
                        Text("A word, phrase, or sequence that reads the same backwards as forwards")
                            .accessibilityAddTraits(.isStaticText)
                        Spacer()
                        Spacer()
                    }.accessibilityAddTraits(.isModal)
                    
                }
            }.accessibilityElement(children: .combine)
            
            Spacer()
            
            
            if isPalindrome(){
                Text("'\(palindrome)' is a Palindrome ✅")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isStaticText)
                
                
            }else if (palindrome != "") && (palindrome.count != 1){
                Text(" '\(palindrome)' isn't a Palindrome ❌")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isStaticText)
                    
            }
            
    
            
            Spacer()
            
            
            ZStack( alignment: .leading) {
                
                if !palindrome.isEmpty{
                    
                    Text("Palindrome")
                        .padding(30)
                        .foregroundColor($palindrome.wrappedValue.isEmpty ? Color(.placeholderText) : .accentColor)
                        .offset(y: $palindrome.wrappedValue.isEmpty ? 0 : -35)
                        .scaleEffect($palindrome.wrappedValue.isEmpty ? 1 : 0.75, anchor: .leading)
                }
                
                TextField("Palindrome", text: $palindrome)
                    .frame(width: 220)
                    .padding(4)
                    .submitLabel(.go)
                    .modifier(ClearButton(text: $palindrome))
                    .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color.gray, lineWidth: 1))
                    
                    .padding()
                
                
            }.accessibilityElement(children: .combine)
            .padding(.top, 15)
            Spacer()
            
        }
    }
    
    func isPalindrome() -> Bool {
       // palindrome = palindrome.filter{!$0.isWhitespace}
        let palindromeCase = (palindrome != "") && (palindrome.count != 1)
        return (palindromeCase && palindrome.lowercased() == String(palindrome.lowercased().reversed()))
    }
}

struct ClearButton: ViewModifier
{
    @Binding var text: String
    
    public func body(content: Content) -> some View
    {
        ZStack(alignment: .trailing)
        {
            content
            
            if !text.isEmpty
            {
                Button(action:
                        {
                    self.text = ""
                })
                {
                    Image(systemName: "delete.left")
                        .foregroundColor(Color(UIColor.opaqueSeparator))
                }
                .padding(.trailing, 8)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PalindromeView()
            
        }
    }
}
