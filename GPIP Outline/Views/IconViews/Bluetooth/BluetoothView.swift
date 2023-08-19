//
//  BluetoothView.swift
//  GPIP Outline
//
//  Created by Albert Huynh on 7/14/23.
//

import SwiftUI
import CoreBluetooth
import Foundation
import Charts
import os

class BluetoothViewModel: NSObject, ObservableObject {
    private var centralManager: CBCentralManager?
    private var peripherals: [CBPeripheral] = []
    @Published var peripheralNames: [String] = []
    @Published var connectedPeripheral: CBPeripheral?

    private var txCharacteristic: CBCharacteristic?
    private var rxCharacteristic: CBCharacteristic?

    @Published var isConnected = false

    @Published var receivedData: String = ""
    
    @Published var receivedDataList = [Double]()
    
    var connectedDeviceCount: Int {
        return BluetoothManager.shared.connectedDeviceCount
    }

    override init(){
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
        guard let centralManager = centralManager else {
                fatalError("Central Manager could not be initialized.")
            }
        centralManager.delegate = self
        
    }

    func getPeripheralName(peripheralName: String) -> CBPeripheral? {
        return peripherals.first { $0.name == peripheralName }
    }

    func pair(with peripheral: CBPeripheral) {
        //self.centralManager?.connect(peripheral, options: nil)
        //changed
        DispatchQueue.main.async {
                self.centralManager?.connect(peripheral, options: nil)
            }
    }

    func handleReceivedData(_ data: Data) {
        if let receivedString = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async {
                print("APPENDING DATA")
//                self.receivedData.append("\(receivedString)")
                
                self.receivedData = receivedString
                
                //CHANGING CODE 08/15
                let convertedData = Double(self.receivedData) ?? 0
                self.receivedDataList.append(convertedData)
                
            }
        }
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

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {

        self.connectedPeripheral = peripheral
            peripheral.delegate = self // Set the delegate
            peripheral.discoverServices(nil) // Discover services
        
        //this was changed
        BluetoothManager.shared.incrementDeviceCount()
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?){
        print("Failed to connect to peripheral: \(peripheral.name ?? "unnamed device"). Error: \(error?.localizedDescription ?? "Unknown error")")
    }
}

extension BluetoothViewModel {
    func startReceivingData() {
        

        DispatchQueue.main.async {
            guard let peripheral = self.connectedPeripheral, let rxCharacteristic = self.rxCharacteristic else {
                    return
                }
                peripheral.setNotifyValue(true, for: rxCharacteristic)
            }
        
    }

    func stopReceivingData() {

        DispatchQueue.main.async {
            guard let peripheral = self.connectedPeripheral, let rxCharacteristic = self.rxCharacteristic else {
                return
            }
            peripheral.setNotifyValue(false, for: rxCharacteristic)
        }
    }


}

extension BluetoothViewModel: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            return
        }

        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }

        for characteristic in characteristics {
            if characteristic.properties.contains(.notify) {
                rxCharacteristic = characteristic
                startReceivingData()
            }
        }
        
        
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
            if let error = error {
                print("error: \(error)")
                return
            }

            if let characteristicData = characteristic.value,
               let stringFromData = String(data: characteristicData, encoding: .utf8) {
                os_log("Received %d bytes: %s", characteristicData.count, stringFromData)
                
                // Call a function to handle received data in your SwiftUI views
                handleReceivedData(characteristicData)
            }
        }
}

//This is the view
struct BluetoothView: View {
    @ObservedObject private var bluetoothViewModel = BluetoothManager.shared.bluetoothViewModel
    @State private var showDevices = false
    
    var body: some View {
        ZStack{
            Color("Background")
            NavigationView {
                VStack {
                    Button("Toggle Devices") {
                        showDevices.toggle()
                    }
                    .padding()
                    
                    if showDevices { // Show the device list when showDevices is true
                        List(bluetoothViewModel.peripheralNames.filter { $0 != "unnamed device" }, id: \.self) { peripheralName in
                            Button(action: {
                                if let peripheral = bluetoothViewModel.getPeripheralName(peripheralName: peripheralName) {
                                    bluetoothViewModel.pair(with: peripheral)
                                }
                            }) {
                                Text(peripheralName)
                            }
                        }
                        .navigationTitle("Devices")
                    }
                    Text("connected devices: \(bluetoothViewModel.connectedDeviceCount)")
                    
                    if bluetoothViewModel.connectedPeripheral != nil{
                        ReceivedDataView(receivedData: bluetoothViewModel.receivedData)
                            .onAppear {
                                bluetoothViewModel.startReceivingData()
                            }
                            .onDisappear {
                                bluetoothViewModel.stopReceivingData()
                            }
                    }
                }
            }
        }
    }
}

struct ReceivedDataView: View {
    var receivedData: String

    var body: some View {
        VStack {
            
            Text("Received Data:")
                .font(.headline)
                .padding(.top)

            ScrollView {
                Text(receivedData)
                    .font(.body)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

//PREVIEW PROVIDER
struct BluetoothView_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothView()
    }
}
