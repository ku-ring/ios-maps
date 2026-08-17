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
    @Environment(\.mapAppearance) var appearance

    var body: some View {
        Group {
            if places.isEmpty {
                VStack(spacing: 16) {
                    Spacer()
                    Image("emptysearchimage", bundle: .module)
                        .resizable()
                        .frame(width: 150, height: 150)
                    Text("관련 건물이 없습니다.")
                        .font(.system(size: 14))
                        .foregroundStyle(appearance.caption1)
                        .padding(.top, 12)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
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
            }
        }
        .background(appearance.bg)
    }

    private func placeRow(_ place: CampusPlaceItem) -> some View {
        Button {
            Task {
                await viewModel.selectPlaceFromList(place)
            }
        } label: {
            HStack(spacing: 14) {
                if let imageUrlString = place.imageUrl, let url = URL(string: imageUrlString) {
                    CachedAsyncImage(
                        url: url,
                        cacheKey: "building:\(place.building.id)"
                    ) { image in
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
                        .fill(appearance.primary.opacity(0.1))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(place.category, bundle: .module)
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(appearance.primary)
                        )
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text(place.name)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(appearance.body)
                        
                        Text(place.categoryKorName)
                            .font(.system(size: 14))
                            .foregroundStyle(appearance.caption1)
                    }

                    HStack(spacing: 8) {
                        let locationStr = "\(place.locationDetail ?? "위치 정보 없음")"
                        Text(locationStr)
                            .font(.system(size: 14))
                            .foregroundStyle(appearance.body)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                        
                        Divider()
                            .padding(.vertical, 5)
                        
                        let hoursStr = place.operatingHours.formattedCurrentHours
                        Text(hoursStr)
                            .font(.system(size: 14))
                            .foregroundStyle(appearance.body)
                    }
                }

                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(appearance.gray300)
                    .padding(.trailing, 8)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
     }
}
