//
//  CircularProgressView.swift
//  package-kuring-maps
//
//  Created by Geon Woo lee on 8/10/24.
//

import SwiftUI
@_spi(Tests) import KuringMapsLink

struct CircularProgressView: View {
    @Environment(\.mapAppearance) var appearance
    
    let room: KonkukLibraryLink.Room
    
    var body: some View {
        let from: CGFloat = CGFloat(room.seats.occupied) / CGFloat(room.seats.total)
        
        return ZStack {
            Circle()
                .stroke(
                    appearance.gray100,
                    lineWidth: 13
                )
            
            Circle()
                .trim(from: from, to: 1)
                .stroke(
                    Color.green,
                    style: StrokeStyle(
                        lineWidth: 13,
                        lineCap: .butt
                    )
                )
                .rotationEffect(.degrees(-90))
        }
    }
}
