//
//  AddBandageView.swift
//  GPIP Outline
//
//  Created by Albert Huynh on 6/27/23.
//

import Foundation
import SwiftUI
import Charts

struct HeaderView: View{
    var body: some View{
        HStack{
            Spacer()
            Image(systemName: "staroflife.fill")
            
            Text("Bandage Data")
                .bold()
            
            Image(systemName: "staroflife.fill")
            Spacer()
        }
    }
}
    
struct SavingsPoint: Identifiable {
    let date: Date
    let value: Double
    var id = UUID()
}


struct AddBandageView: View{
    
    var chartData: [SavingsPoint]{
        return generateChartData()
    }
    
    var currentVal: Double {
        return chartData.last?.value ?? 0
    }
    
    var currentValList: Double {
        return bluetoothManager.receivedDataList.last ?? 0
    }
    
    @ObservedObject private var bluetoothManager = BluetoothManager.shared.bluetoothViewModel
    
    var body: some View{

        let nameBandage = "Elbow"
        let receivedValue = bluetoothManager.receivedData
        
        ZStack{
            Color("Background").ignoresSafeArea()
            
            VStack(alignment: .center){
                HeaderView()
                    .padding(.horizontal)
                
                if currentValList < 7.0{
                    Text("Current PH Level: \(currentValList)" )
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(.green)
                }
                else {
                    Text("Current PH Level: \(currentValList)" )
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(.yellow)
                }
                
                    //                Spacer()
                    Group {
                        Text("History of Wound (Time Stamps Included)")
                    }
                    .font(.callout)
                    .fontWeight(.light)
                    
                
                ScrollView{
                    Chart{
                        ForEach(chartData){ item in
                            LineMark(
                                x: .value("date", item.date),
                                y: .value("pH level", item.value)
                            )
                        }
                    }
                    .frame(minHeight: 200)
                    
                        if currentVal > 7.0 && currentVal < 8.0 {
                            VStack{
                                Text("Great Progress! \nYour doctor would like to see you!")
                                    .bold()
                                    .font(.title2)
                                
                                Section{
                                    Text("If your PH level is higher than 8, your wound may be infected!")
                                    Text("Your PH level is less than 7, your wound is healing!")
                                    Text("If your PH level is between 7 and 8, your wound is making progress!")
                                }
                                .font(.callout)
                                .padding()
                                .overlay{
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 2)
                                }
                                
                                Link("Want to learn More About Your Wound's PH Level?\nLink Here!", destination: URL(string: "https://ieeexplore.ieee.org/abstract/document/10182338")!)
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10.0)
                                            .stroke(lineWidth: 2.0)
                                    )
                            }
                        }
                        else if currentVal > 8.0 {
                            VStack{
                                Text("Your doctor would like to see you!")
                                    .bold()
                                    .font(.title2)
                                
                                Section{
                                    Text("If your PH level is higher than 8, your wound may be infected!")
                                    Text("your PH level is less than 7, your wound is healing!")
                                    Text("If your PH level is between 7 and 8, your wound is making progress!")
                                }
                                .font(.callout)
                                .padding()
                                .overlay{
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 2)
                                }
                                
                                Link("Want to learn More About Your Wound's PH Level?\nLink Here!", destination: URL(string: "https://ieeexplore.ieee.org/abstract/document/10182338")!)
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10.0)
                                            .stroke(lineWidth: 2.0)
                                    )
                            }
                        }
                        else{
                            VStack{
                                Text("Your Wound is Healing!")
                                    .foregroundColor(.green)
                                    .bold()
                                    .font(.title2)
                                
                                Section{
                                    Text("If your PH level is higher than 8, your wound may be infected!")
                                    Text("If your PH level is less than 7, your wound is healing!")
                                    Text("If your PH level is between 7 and 8, your wound is making progress!")
                                }
                                .padding()
                                .font(.callout)
                                .overlay{
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 2)
                                }
                                
                                Link("Want to learn More About Your Wound's PH Level?\nLink Here!", destination: URL(string: "https://ieeexplore.ieee.org/abstract/document/10182338")!)
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10.0)
                                            .stroke(lineWidth: 2.0)
                                    )
                            }
                        }
                }
            }
            
        }
        
    }
}

//func generateChartData() -> [SavingsPoint] {
//    let bluetoothManager = BluetoothManager.shared.bluetoothViewModel
//
//    // date formatter
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "MM/dd/yy"
//
//    // time formatter
//    let timeFormatter = DateFormatter()
//    timeFormatter.dateFormat = "HH:mm"
//
//    // Get the current date
//    let currentDate = Date()
//
//    // Determine the range for the past 7 days
//    let startIndex = max(bluetoothManager.receivedDataList.count - 7, 0)
//    let endIndex = bluetoothManager.receivedDataList.count
//
//    // Generate data for the specified range
//    var data: [SavingsPoint] = []
//    for index in startIndex..<endIndex {
//        let date = Calendar.current.date(byAdding: .day, value: -(endIndex - index - 1), to: currentDate)!
////        let dateString = dateFormatter.string(from: date)
//        let receivedPHValue = bluetoothManager.receivedDataList[index]
//        data.append(SavingsPoint(date: date, value: receivedPHValue))
//    }
//
//    // Sort data by date in ascending order
////    data.sort { dateFormatter.date(from: $0.date)! < dateFormatter.date(from: $1.date)! }
//
//    return data
//}

func generateChartData() -> [SavingsPoint] {
    let bluetoothManager = BluetoothManager.shared.bluetoothViewModel
    
    // Get the current date and time
    let currentDate = Date()

    // Get the most recent data from bluetoothManager
    let receivedDataList = bluetoothManager.receivedDataList
    
    // Generate data for the most recent receivedDataList
    var data: [SavingsPoint] = []
    for (index, receivedValue) in receivedDataList.enumerated() {
        let date = Calendar.current.date(byAdding: .second, value: index, to: currentDate)!
        data.append(SavingsPoint(date: date, value: receivedValue))
    }

    return data
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
