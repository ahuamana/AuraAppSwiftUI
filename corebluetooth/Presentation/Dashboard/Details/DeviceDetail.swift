//
//  DeviceDetail.swift
//  corebluetooth
//
//  Created by Antony Huaman Alikhan on 28/12/25.
//

import SwiftUI
import Charts

struct DeviceDetail: View {
    
    let points: [HeartRatePoint]
    
    init(points: [HeartRatePoint]) {
        self.points = points
    }
    
    var body: some View {
        VStack() {
            
            VStack(alignment:.center) {
                Text(String((points.last?.value ?? 0)))
                    .font(.system(size: 50, weight: .bold, design: .rounded)) // Custom massive size
                    .fontWeight(.bold)
                
                Text("BPM")
                    .font(.system(size: 15, weight: .bold, design: .rounded)) // Custom
                    .foregroundColor(.secondary)
                
            }
            
            
            VStack(alignment: .leading) {
                Text("History")
                    .bold()
                    .padding(.top)
                    .padding(.leading)
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
            }
            
            Chart {
                ForEach(points) { point in
                    LineMark(
                        // X-AXIS: The Time
                        x: .value("Time", point.date),
                        
                        // Y-AXIS: The Heart Rate
                        y: .value("BPM", point.value)
                    )
                    .interpolationMethod(.catmullRom) // Makes the line curvy/smooth
                }
            }
            // Set the range for human heart rates (usually 40-180)
            .chartYScale(domain: 40...120)
            .frame(maxWidth: .infinity, maxHeight: 300)
            
            Button(action: {
                
            }, label: {
                HStack {

                    Image(systemName: "network")
                        .foregroundColor(.white)
                    
                    Text("Log Data")
                        .foregroundColor(.white)
                    
                        
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .padding(.horizontal, 15)
                .background(RoundedRectangle(cornerRadius: 10))
                .padding(.top)
                .padding(.horizontal)
            })
            
            Spacer()
        }
        
    }
}

#Preview {
    DeviceDetail(points: DeveloperMock.shared.points)
}
