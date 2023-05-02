//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
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
                
                if let buildingNumber = place.number {
                    Text("\(buildingNumber)번")
                        .font(.subheadline)
                }
                
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
