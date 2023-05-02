//
//  PlaceSearchResultRow.swift
//  
//
//  Created by Jaesung Lee on 2023/05/03.
//

import SwiftUI
import KuringMapsLink

struct PlaceSearchResultRow: View {
    let place: Place
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(place.name)
                    .font(.headline)
                
                Spacer()
                
                Text(place.category)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Text(place.address)
                .font(.footnote)
                .foregroundColor(.secondary)
            if let data = place.data {
                Text(data)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            if let phone = place.phone {
                Text(phone)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
    }
}
