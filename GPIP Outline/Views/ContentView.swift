//
//  ContentView.swift
//  GPIP Outline
//
//  Created by Albert Huynh on 6/21/23.
//

import SwiftUI
import CoreBluetooth
import CoreData

struct ContentView: View {
    
    static let numOfBandages = 10
    @State var phLevel = 1
    static let column = 3
    static let row = Int(ceil(Double(numOfBandages) / Double(column)))
    
    let width = (UIScreen.main.bounds.width / 3) - 20
    
    @Binding var showSignInView: Bool
    
    @ObservedObject private var bluetoothManager = BluetoothManager.shared

    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20){
                        
                        
                        ForEach(0..<ContentView.row, id: \.self) { i in
                            HStack(spacing: 20){
                                ForEach(0..<ContentView.column, id: \.self) { j in
                                    let index = i * ContentView.column + j
                                    
                                    //changed
                                    if index < bluetoothManager.bluetoothViewModel.connectedDeviceCount {
                                        let destination = AddBandageView()
                                        let icon = VStack(spacing: 8){
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .frame(height: 80)
                                                    .foregroundColor(phLevel < 7 ? .blue : .red)
                                                
                                                Image(systemName: "cross.case.fill")
                                            }
                                            Text("Bandage " + String(i * ContentView.column + j + 1))
                                                .font(.headline)
                                        }
                                            .frame(width: 100)
                                        
                                        NavigationLink(destination: destination) {
                                            icon
                                        }.buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .navigationBarTitle(Text("Heal'm"))
                    
                    
                    //icons
                    ZStack {
                        VStack(spacing: 17) {
                            HStack(spacing: 35) {
                                Spacer()
                                
                                let bluetoothDestination = LogOutView(showSignInView: .constant(false))
                                let bluetoothImage = Image(systemName: "gearshape").font(.title)
                                
                                NavigationLink(destination: bluetoothDestination) {
                                    bluetoothImage
                                }.buttonStyle(PlainButtonStyle())
                                
                                Spacer()
                                
                                let sumOfHealthDestination = BluetoothView()
                                let sumOfHealthImage = Image(systemName: "cloud").font(.title)
                                
                                NavigationLink(destination: sumOfHealthDestination) {
                                    sumOfHealthImage
                                }.buttonStyle(PlainButtonStyle())
                                
                                Spacer()
                                
                                let addContactDestination = AddContactView()
                                let addContactImage = Image(systemName: "phone").font(.title)
                                
                                NavigationLink(destination: addContactDestination) {
                                    addContactImage
                                }.buttonStyle(PlainButtonStyle())
                                
                                Spacer()
                            }
                        }
                    }
                }
                
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView( showSignInView: .constant(false))
                
    }
}
