//
//  Bandage Data.swift
//  GPIP Outline
//
//  Created by Albert Huynh on 6/23/23.
//

import Foundation
import SwiftUI
import Charts

struct Bandage1: Identifiable, Hashable{
    
    let id = UUID()
    
    let title: String
    let PH: Double
//    let UricAcid: Double
    let createAt: Date //These are the dates for when the bandage is on
    
    }

struct GraphView: View{
    
    @Environment(\.managedObjectContext) var moc
//    @FetchRequest(sortDescriptors: []) var students: FetchedResults<Bandage>
    
    let list = [
        Bandage1(title: "Bandage 1", PH: 4.00, createAt: dateFormatter.date(from: "03/11/2023") ?? Date()),
        Bandage1(title: "Bandage 1", PH: 3.00, createAt: dateFormatter.date(from: "04/11/2023") ?? Date()),
        Bandage1(title: "Bandage 1", PH: 7.00, createAt: dateFormatter.date(from: "05/11/2023") ?? Date()),
        Bandage1(title: "Bandage 1", PH: 3.00, createAt: dateFormatter.date(from: "06/11/2023") ?? Date()),
        Bandage1(title: "Bandage 1", PH: 1.00, createAt: dateFormatter.date(from: "07/11/2023") ?? Date()),
        Bandage1(title: "Bandage 1", PH: 7.00, createAt: dateFormatter.date(from: "08/11/2023") ?? Date()),
    ]
    
    static var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yy"
        return df
    }()
    
    
    
    var body: some View{
        
        let nameBandages = ["Elbow Bandage", "Arm Bandage", "Leg Bandage"]
        let variousPH = ["7", "6", "4", "3"]
        
        VStack(spacing: 2.0){
            Text("\(nameBandages.randomElement()!)")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
   
//            Chart(list){ Bandage in
//                LineMark(x: .value("Month", Bandage.createAt), y: .value("PH LEVEL", Bandage.PH))
//            }.foregroundStyle(.red).aspectRatio(contentMode: .fit).padding(.horizontal).background(.white).chartXAxisLabel("Date", position: .bottom, alignment: .center).chartYAxisLabel("PH Levels", position: .leading, alignment: .center)
            
            Text("The current PH Level is \(variousPH.randomElement()!)\n")
          
            
            Text("If the PH level is above 7 the wound is considered severe")
            Text("If the PH level is below 7 the wound is healing")
            Spacer()
        }.font(/*@START_MENU_TOKEN@*/.callout/*@END_MENU_TOKEN@*/)
    }
}



//not important
struct ContentView_Previews2: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}


