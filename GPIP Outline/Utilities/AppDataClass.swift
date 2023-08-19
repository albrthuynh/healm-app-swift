//
//  AppDataClass.swift
//  GPIP Outline
//
//  Created by Albert Huynh on 8/14/23.
//

import Foundation

class BluetoothManager: ObservableObject {
    static let shared = BluetoothManager()

    private init() {}

    @Published var bluetoothViewModel = BluetoothViewModel()
    @Published var connectedDeviceCount: Int = 0
    
    func updateConnectedDeviceCount(_ count: Int) {
            connectedDeviceCount = count
        }
    
    func incrementDeviceCount(){
        connectedDeviceCount += 1
    }
}
