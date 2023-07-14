//
//  AddBandageView.swift
//  GPIP Outline
//
//  Created by Albert Huynh on 6/27/23.
//

import Foundation
import SwiftUI

struct AddBandageView: View{

    
    //core data implementation
    var body: some View{
        ZStack {
           Color("Background")
            .edgesIgnoringSafeArea(.all)

           Text("Hello, world!")
               .padding()
       }
    }
}

struct AddBandageView_Previews: PreviewProvider{
    static var previews: some View{
        Group{
            AddBandageView()
            
            AddBandageView()
                .environment(\.colorScheme, .dark)
        }
    }
}
