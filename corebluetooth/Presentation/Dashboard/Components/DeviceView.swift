//
//  DeviceView.swift
//  corebluetooth
//
//  Created by Antony Huaman Alikhan on 27/12/25.
//

import SwiftUI

struct DeviceView: View {
    
    private let iconNameDevice: String
    private let iconNameOptions: String
    private let colorOptions: Color
    private let colorDevice: Color?
    
    private let device : DevicePresentationModel
    
    init(device:DevicePresentationModel,
         iconNameDevice:String,
         iconNameOptions:String,
         colorOptions:Color,
         colorDevice:Color? = nil
    ) {
        self.device = device
        self.iconNameDevice = iconNameDevice
        self.iconNameOptions = iconNameOptions
        self.colorOptions = colorOptions
        self.colorDevice = colorDevice
    }
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: iconNameDevice)
                .foregroundColor(.white)
                .background(
                    Circle()
                        .foregroundColor(colorDevice ?? Color.gray )
                        .opacity(colorDevice == nil ? 0.3 : 1)
                        .frame(width: 50, height: 50)
            )
            VStack(alignment: .leading) {
                Text(device.name)
                    .font(.callout)
                    .lineLimit(1)
                    
                if device.isConnected {
                    Text("Connected")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    Text(device.id)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                
            }
            .padding(.leading, 10)
            
            Spacer()
            
            Divider()
                    .frame(width: 3, height: 24)
                    .foregroundColor(.black)
            
            Image(systemName: iconNameOptions)
                .foregroundColor(colorOptions)
                .rotationEffect(.degrees(90))

                
        }
        .padding(18)
    }
}

#Preview {
    DeviceView(
        device: DeveloperMock.shared.devices[0],
        iconNameDevice: "laptopcomputer",
        iconNameOptions: "gearshape",
        colorOptions: Color.blue
        
    )
    
    DeviceView(
        device: DeveloperMock.shared.devicesNonConnected[0],
        iconNameDevice: "laptopcomputer",
        iconNameOptions: "gearshape",
        colorOptions: Color.blue
        
    )
}
