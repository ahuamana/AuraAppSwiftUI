//
//  UserPresentationModel.swift
//  corebluetooth
//
//  Created by Antony Huaman Alikhan on 27/12/25.
//

import Foundation

struct UserPresentationModel:Identifiable {
    let id:String = UUID().uuidString
    let name:String
    let image:String
    let birthPlace:String
}
