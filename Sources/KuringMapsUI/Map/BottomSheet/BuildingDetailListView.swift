//
//  BuildingDetailListView.swift
//  package-kuring-maps
//
//  Created by Antigravity on 7/28/26.
//

import SwiftUI
import KuringMapsLink

struct BuildingDetailListView: View {
    let buildings: [BuildingDetailResponse]
    @ObservedObject var viewModel: KuringMapViewModel
    @Environment(\.mapAppearance) var appearance

    var body: some View {
        Group {
            if buildings.isEmpty {
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
                        ForEach(buildings) { building in
                            buildingRow(building)
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

    private func buildingRow(_ building: BuildingDetailResponse) -> some View {
        Button {
            viewModel.selectBuildingFromList(building)
        } label: {
            HStack(spacing: 14) {
                if let imageUrlString = building.imageUrl, let url = URL(string: imageUrlString) {
                    CachedAsyncImage(
                        url: url,
                        cacheKey: "building:\(building.id)"
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
                            Image("building", bundle: .module)
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(appearance.primary)
                        )
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text(building.name)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(appearance.body)
                        
                        Text("부속건물")
                            .font(.system(size: 14))
                            .foregroundStyle(appearance.caption1)
                    }

                    HStack(spacing: 8) {
                        Text(building.address)
                            .font(.system(size: 14))
                            .foregroundStyle(appearance.body)
                            .lineLimit(1)
                        
                        Divider()
                            .padding(.vertical, 5)
                        
                        let hoursStr = building.operatingHours.formattedCurrentHours
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
