//  AnagramGameView.swift
//  WordPlay
//
//  Created by Sanay Fatullayeva on 10.12.21.
//

import SwiftUI
import Combine
import FloatingLabelTextFieldSwiftUI
import NaturalLanguage

//a game whose object is to make words by arranging letters from a common pool or by forming anagrams from other words
struct AnagramGameView: View {
    @State private var allWords: [String] = []
    @State private var gameWord = ""
    
    @State private var enteredWord = ""
    @State private var enteredWords: [String] = []
    @State private var letterSet = Set<Character>()
    
    
    @State private var enteredCorrectSet = true
    
    @Binding var showingPicker: Bool
    
    @State var incorrectWords = 0
    @State var correctWords = 0
    
    @State var correct = false
    
    @State var correctAnagram = false
    @State var correctColor =  Color.green.opacity(0.5)
    @State var enabled = false
    @State var chipColor = Color.teal.opacity(0.25)
    @State var letterDict: [Int] = []
    
    @State var letterArray: Array = []
    
    @State var popPresented = false
    
    @State var brandGradient = Gradient(colors: [Color(.systemRed), Color(.systemOrange), Color(.systemYellow), Color(.systemGreen), Color(.systemBlue), Color(.systemPurple)])
    var body: some View {
        
        VStack{
            
            HStack{
                Text("Anagram Game")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .navigationBarTitleDisplayMode(.inline)
                    .accessibilityAddTraits(.isHeader)
                
                Button(action: {
                    self.popPresented = true
                }){
                    Image(systemName: "info.circle")
                }.accessibilityLabel("Anagram Game Definition")
                .popover(isPresented: $popPresented) {
                    
                    VStack{
                        
                        HStack{
                            
                        Button(action: {
                            popPresented = false
                        }){
                            Spacer()
                            Image(systemName: "xmark")
                                .padding()
                        }.accessibilityLabel("Close Anagram Game Definition Popover")
                        }
                        
                        Spacer()
                        Spacer()
                        Text("Anagram Game")
                            .font(.largeTitle)
                            .bold()
                        Spacer()
                            .frame(width: 30, height: 90)
                        Text("A game whose objective is to make words by arranging letters from a common pool or by forming anagrams from other words")
                            .font(.largeTitle)
                        Spacer()
                        Spacer()
                    }.accessibilityAddTraits(.isModal)
                }
            }.accessibilityElement(children: .combine)
            Spacer()
            Spacer()
            Spacer()
            
            HStack{
                Spacer()
                VStack{
                    Text("✅")
                    Text(" \(correctWords) ")
                    
                }
                Spacer()
                
                VStack{
                    Text("❌")
                    Text("\(incorrectWords)")
                    
                }
                Spacer()
            }.accessibilityElement(children: .combine)
            
            
            ScrollView{
                List(enteredWords, id: \.self, rowContent:{ word in
                    Text("\(word.capitalized)")
                        .overlay(RoundedRectangle(cornerRadius: 70)
                                    .scale(1.2)
                                    .fill(Color.cyan.opacity(0.25))
                        )
                        .listRowSeparator(.hidden)
                        .accessibilityAddTraits(.isStaticText)
                    
                }).scaledToFit()
            }.listStyle(.plain)
                .background(.white)
                .accessibilityElement(children: .combine)
            
            
            HStack{
                
                Text("\(gameWord.uppercased())")
                    .accessibilityAddTraits(.updatesFrequently)
                    .font(.title)
                    .shadow(
                            color: Color(UIColor.label.withAlphaComponent(0.3)), /// shadow color
                            radius: 3, /// shadow radius
                            x: 0, /// x offset
                            y: 2 /// y offset
                        )
                
                Button(action: {
                    gameWord = allWords.randomElement() ?? "ERROR"
                    enteredWords = []
                    enteredWord = ""
                    letterSet = []
                    letterArray = []
                    
                    correctWords = 0
                    incorrectWords = 0
                    
                }){
                    Image(systemName: "arrow.triangle.2.circlepath.circle")
                }.accessibilityLabel("Refresh game word")
            }
            
            
            HStack{
                Spacer()
                ZStack(alignment: .leading) {
                    if !enteredWord.isEmpty{
                        Text("'\(gameWord.capitalized)' anagram")
                            .padding(23)
                            .foregroundColor($enteredWord.wrappedValue.isEmpty ? Color(.placeholderText) : .accentColor)
                            .offset(y: $enteredWord.wrappedValue.isEmpty ? 0 : -35)
                            .scaleEffect($enteredWord.wrappedValue.isEmpty ? 1 : 0.75, anchor: .leading)
                    }
                    
                    
                    TextField("'\(gameWord.capitalized)' anagram", text: $enteredWord)
                        .padding(4)
                        .submitLabel(.go)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50).stroke(Color.gray.opacity(1.0), lineWidth: 1 )
                        ).background(RoundedRectangle(cornerRadius: 50).fill(correctAnagram ? Color.green.opacity(0.5) : Color.gray.opacity(0.0)))
                        .modifier(ClearButton(text: $enteredWord))
                        .frame(minWidth: 20, minHeight: 40)
                        .padding()
                }
                
                Button(action: {
                    
                    checkIfAnagram()
                    enteredWord = ""
                }){
                        Image(systemName: "checkmark")
                        .padding(17)
                        .overlay(
                            Circle()
                                .stroke(
                                    AngularGradient(gradient: brandGradient, center: .center)
                                    ,lineWidth: 2)
                        )
                            .foregroundColor(Color.green)
                }.accessibilityLabel("Submit entered word")
                Spacer()
            }.accessibilityElement(children: .combine)
            Spacer()
        }
        .onAppear(){
            startGame()
            showingPicker = false
        }
    }
    
    func startGame(){
        if let startWordsURL = Bundle.main.url(forResource: "words", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL){
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty{
            allWords = ["silkworm"]
        }
        
        gameWord = allWords.randomElement() ?? "ERROR"
        
    }
    
    func setGameWord(){
        
        gameWord = gameWord.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        for char in gameWord.lowercased(){
            
            
            if !letterSet.contains(char){
                //print("LETTER \(char) hss not appeared in letterSet")
                letterSet.insert(char)
                letterArray.append(char)
            }else{
                //print("LETTER \(char) HAS APPEARED in letterSet ")
                letterArray.append(char)
            }
        }
    }
    
    func checkBeenEntered(s: String) -> Bool{
        
        for ent in enteredWords{
            if ent == enteredWord{
                return false
            }
            
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        for ltr in enteredWord.lowercased(){
            
            if gameWord.lowercased().contains(ltr){
                
                enteredCorrectSet = true
            }else{
                
                enteredCorrectSet = false
                break
            }
            
        }
        return misspelledRange.location == NSNotFound
    }
    
    //this returns true if enteredWord is an anagram that consists of each and every letter of gameWord
    func isAnagram( word: String, word2: String) -> Bool {
        guard
            let word1Dictionary = countChars(word: word),
            let word2Dictionary = countChars(word: word2) else {
                print("**IS NOT AN ANAGRAM **")
                return false
            }
        
        print("GAME WORD: \(word1Dictionary)")
        print("ENTERED WORD: \(word2Dictionary)")
        
        for (k, v) in word2Dictionary {
            //if occurence of a letter (v) in enteredWord is larger than occurence of letter [k] in gameWord then is not an anagram
            if v > word1Dictionary[k]!{
                print("if \(v) > \(String(describing: word1Dictionary[k]))")
                return false
            }
            
        }
        //space makes it crash
        print("----\(enteredWord) IS AN ANAGRAM OF \(gameWord) ----")
        return true
    }
    
    func countChars(word: String?) -> [Character: Int]? {
        guard let word = word, word != "" else {
            return nil
        }
        var dictionary = [Character: Int]()
        
        for char in word {
            if let currentValue = dictionary[char] {
                dictionary.updateValue(currentValue + 1, forKey: char)
            } else {
                dictionary[char] = 1
            }
        }
        return dictionary
    }
    
    func checkAnagram() -> Bool{
        enteredWord = enteredWord.filter{!$0.isWhitespace}
        return enteredCorrectSet && checkBeenEntered(s: enteredWord) && enteredWord != "" && isReal(word: enteredWord) && enteredWord.count != 1 && isAnagram(word: gameWord.lowercased(), word2: enteredWord.lowercased())
    }
    
    func checkIfAnagram(){
        setGameWord()
        
        if checkAnagram(){
            enteredWords.append(enteredWord)
            correctWords += 1
            correct = true
            correctAnagram = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.28 ) {
                correctAnagram = false
            }
        }else{
            if !(enteredWord.isEmpty) {
                incorrectWords += 1
            }
            print("Word has been entered, letter not in letterSet, or enteredWord is ''")
        }
    }
    
    func generateRandomColor() -> Color {
        let redValue = CGFloat.random(in: 0...1)
        let greenValue = CGFloat.random(in: 0...1)
        let blueValue = CGFloat.random(in: 0...1)
        
        let randomColor = Color(red: redValue, green: greenValue, blue: blueValue).opacity(0.25)
        
        return randomColor
    }
    
}

struct AnagramGameView_Previews: PreviewProvider {
    static var previews: some View {
        AnagramGameView(showingPicker: .constant(false))
    }
}





