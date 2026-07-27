//
//  CategoryPlaceListView.swift
//  package-kuring-maps
//
//  Created by Jung Hwan Park on 7/27/26.
//

import SwiftUI
import KuringMapsLink

struct CategoryPlaceListView: View {
    let places: [CampusPlaceItem]
    @ObservedObject var viewModel: KuringMapViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(places) { place in
                    placeRow(place)
                    Divider()
                        .padding(.horizontal, 20)
                }
            }
            .padding(.top, 32)
            .padding(.bottom, 24)
        }
        .background(Color.Kuring.bg)
    }

    private func placeRow(_ place: CampusPlaceItem) -> some View {
        Button {
            Task {
                await viewModel.selectPlaceFromList(place)
            }
        } label: {
            HStack(spacing: 14) {
                if let imageUrlString = place.imageUrl, let url = URL(string: imageUrlString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                } else {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color.Kuring.primary.opacity(0.1))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(place.category, bundle: .module)
                                .renderingMode(.template)
                                .font(.system(size: 16))
                                .foregroundStyle(Color.Kuring.primary)
                        )
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text(place.name)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color.Kuring.body)
                        
                        Text(place.categoryKorName)
                            .font(.system(size: 14))
                            .foregroundStyle(Color.Kuring.caption1)
                    }

                    HStack(spacing: 8) {
                        let locationStr = "\(place.locationDetail ?? "")"
                        Text(locationStr)
                            .font(.system(size: 14))
                            .foregroundStyle(Color.Kuring.body)
                        
                        Divider()
                            .padding(.vertical, 5)
                        
                        let hoursStr = formatHours(place.currentOperatingHours)
                        Text(hoursStr)
                            .font(.system(size: 14))
                            .foregroundStyle(Color.Kuring.body)
                    }
                }

                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.Kuring.gray300)
                    .padding(.trailing, 8)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func formatHours(_ hours: CurrentOperatingHours) -> String {
        if let opens = hours.opensAt, let closes = hours.closesAt {
            return "\(opens) ~ \(closes)"
        } else {
            return hours.status
        }
    }
}
