//
//  ContentView.swift
//  GPIP Outline
//
//  Created by Albert Huynh on 6/21/23.
//

import SwiftUI
import CoreBluetooth
import CoreData

class BluetoothViewModel: NSObject, ObservableObject {
    private var centralManager: CBCentralManager?
    private var peripherals: [CBPeripheral] = []
    @Published var peripheralNames: [String] = []
    
    override init(){
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
}

extension BluetoothViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn{
            self.centralManager?.scanForPeripherals(withServices: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral){
            self.peripherals.append(peripheral)
            self.peripheralNames.append(peripheral.name ?? "unnamed device")
        }
    }
}

struct ContentView: View {
    @ObservedObject private var bluetoothViewModel = BluetoothViewModel()
    
    static let numOfBandages = 10
    @State var phLevel = 1
    static let column = 3
    static let row = Int(ceil(Double(numOfBandages) / Double(column)))
    
    let width = (UIScreen.main.bounds.width / 3) - 20
    
    var body: some View {
        
        NavigationStack{
            ZStack{
                
                ScrollView{
                    VStack(alignment: .center){
                        
                        Color("Background")
                        //
                        //                        Text("Heal'm").font(.largeTitle).fontWeight(.semibold).foregroundColor(.black)
                        ForEach(0..<ContentView.row, id: \.self) { i in
                            HStack{
                                ForEach(0..<ContentView.column, id: \.self) { j in
                                    let index = i * ContentView.column + j
                                    if index < ContentView.numOfBandages{
                                        NavigationLink(destination:GraphView()) {
                                            //Icon Itself Start
                                            VStack{
                                                ZStack{
                                                    if phLevel < 7{
                                                        Rectangle().frame(height: UIScreen.main.bounds.height / CGFloat(ContentView.numOfBandages)).foregroundColor(.blue).cornerRadius(20).frame(width: 100)
                                                    }
                                                    else{
                                                        Rectangle().frame(height: UIScreen.main.bounds.height / CGFloat(ContentView.numOfBandages)).foregroundColor(.red).cornerRadius(20).frame(width: 50)
                                                    }
                                                    
                                                    Image(systemName: "cross.case.fill")
                                                    
                                                    //                                                    Image("bandagePROFESSOR").resizable().aspectRatio(contentMode: .fit)
                                                }
                                                Text("Bandage #" + String(i * ContentView.column + j + 1))
                                                
                                            }
                                            //Icon itself end
                                        }.buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                        }
                        .padding()
                        
                    }
                    .navigationBarTitle(Text("Heal'm")).padding()
                    //bottom icons
                    ZStack{
                        VStack{
                            HStack{
                               
                                Spacer()
                                NavigationLink(destination:
                                                List(bluetoothViewModel.peripheralNames, id: \.self){peripheral in
                                    Text(peripheral)
                                }.navigationTitle("Peripherals")
                                ){
                                    Image(systemName: "icloud")
                                }.buttonStyle(PlainButtonStyle())
                                Spacer()
                                NavigationLink(destination: SumOfHealthView()) {
                                    Image(systemName: "cross")
                                }.buttonStyle(PlainButtonStyle())
                                Spacer()
                                
                                NavigationLink(destination: AddContactView()){
                                    Image(systemName: "phone")
                                    
                                }.buttonStyle(PlainButtonStyle())
                                Spacer()
                            }
                            
                        }
                    }
                }
    
            }
        }
        //end of body: some view
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView()
            .environment(\.colorScheme, .dark)
        GraphView()
        
    }
}
