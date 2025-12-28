//
//  BluetoothPresentationModel.swift
//  corebluetooth
//
//  Created by Antony Huaman Alikhan on 27/12/25.
//

import Foundation
import CoreBluetooth

struct BluetoothPresentationModel : Identifiable{
    let id: String
    let name:String
    var connected:Bool
}


extension BluetoothPresentationModel {
    static func fromCBPheriphericalDeviceToNewDevice(_ peripheral: CBPeripheral) -> BluetoothPresentationModel {
        return BluetoothPresentationModel(
            id: peripheral.identifier.uuidString,
            name: peripheral.name ?? "Unknown",
            connected: false
        )
        
    }
    
    func toDevicePresentationModel() -> DevicePresentationModel {
        return DevicePresentationModel(
            id: self.id,
            name: self.name,
            icon: "lanyardcard",
            isConnected: self.connected
        )
    }
}


struct DevicePresentationModel : Identifiable{
    let id: String
    let name:String
    let icon: String
    let isConnected:Bool
}




