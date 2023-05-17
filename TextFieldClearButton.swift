//
//  TextFieldClearButton.swift
//  WordPlay
//
//  Created by Sanay Fatullayeva on 09.12.21.
//

import SwiftUI

struct TextFieldClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack {
            content
            
            if !text.isEmpty {
                Button(
                    action: { self.text = "" },
                    label: {
                        Image(systemName: "delete.left")
                            .foregroundColor(Color(UIColor.opaqueSeparator))
                    }
                )
            }
        }
    }
}

/*struct TextFieldClearButton_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldClearButton()
    }
}*/
