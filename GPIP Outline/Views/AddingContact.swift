//
//  AddingContact.swift
//  GPIP Outline
//
//  Created by Albert Huynh on 7/14/23.
//

import SwiftUI
import CoreData
import Combine

struct TextFieldsView: View {
    @Binding var name: String
       @Binding var contact: String
       @Binding var isShowingTextFields: Bool
       var addContact: () -> Void
       
       @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Add name here...", text: $name)
                .font(.headline)
                .padding(.leading)
                .frame(height: 55)
                .background(Color(.lightGray))
                .cornerRadius(10)
                .padding(.horizontal)
                .focused($isFocused)
            
            TextField("Add number here... EX 6301721121", text: $contact)
                .onReceive(Just(contact)) { newValue in
                    let filtered = newValue.filter { "0123456789-".contains($0) }
                    if filtered != newValue {
                        self.contact = filtered
                    }
                }
                .font(.headline)
                .padding(.leading)
                .frame(height: 55)
                .background(Color(.lightGray))
                .cornerRadius(10)
                .padding(.horizontal)
                .focused($isFocused)
            
            Button(action: {
                addContact()
                isShowingTextFields = false
            }) {
                Text("Done")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color(.blue))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
    }
}


