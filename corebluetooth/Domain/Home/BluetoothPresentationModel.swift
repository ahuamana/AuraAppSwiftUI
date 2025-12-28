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
}


extension BluetoothPresentationModel {
    static func fromCBPheriphericalDevice(_ peripheral: CBPeripheral) -> BluetoothPresentationModel {
        return BluetoothPresentationModel(
            id: peripheral.identifier.uuidString,
            name: peripheral.name ?? "Unknown"
        )
        
    }
    
    func toDevicePresentationModelNotConnected() -> DevicePresentationModel {
        return DevicePresentationModel(
            id: self.id,
            name: self.name,
            icon: "lanyardcard",
            isConnected: false
        )
    }
}


struct DevicePresentationModel : Identifiable{
    let id: String
    let name:String
    let icon: String
    let isConnected:Bool
}




