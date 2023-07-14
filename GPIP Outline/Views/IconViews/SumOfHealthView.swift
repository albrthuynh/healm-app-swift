//
//  SumOfHealthView.swift
//  GPIP Outline
//
//  Created by Albert Huynh on 7/5/23.
//

import SwiftUI

struct SumOfHealthView: View {
    var body: some View {
        
        NavigationStack{
            List{
                ForEach(0..<ContentView.numOfBandages, id: \.self){ index in
                    NavigationLink(destination: Text("You are okay!")){
                        Text("Bandage " + String(index + 1))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationBarTitle("General Health")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SumOfHealthView_Previews: PreviewProvider {
    static var previews: some View {
        SumOfHealthView()
    }
}
