//
//  HeartRatePoint.swift
//  corebluetooth
//
//  Created by Antony Huaman Alikhan on 28/12/25.
//

import Foundation

struct HeartRatePoint : Identifiable {
    let id = UUID()
    let date:Date  // The X Axis
    let value: Int // The Y Axis (BPM)
}
