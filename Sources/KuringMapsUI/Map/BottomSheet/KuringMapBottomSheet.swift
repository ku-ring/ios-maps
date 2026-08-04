//
//  KuringMapBottomSheet.swift
//  package-kuring-maps
//
//  Created by Jung Hwan Park on 7/19/26.
//

import SwiftUI
import KuringMapsLink

struct KuringMapBottomSheet: View {
    let detail: BuildingDetailResponse
    var onDismiss: (() -> Void)? = nil
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                categoryRow
                infoSection
                Divider()
                amenitySection
            }
            .padding(.horizontal, 20)
            .padding(.top, 32)
            .padding(.bottom, 32)
        }
        .background(Color.Kuring.bg)
    }
}

// MARK: Views
extension KuringMapBottomSheet {
    /// 헤더영역
    private var header: some View {
        HStack {
            Text(detail.name)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color.Kuring.title)

            Spacer()

            Button {
                if let onDismiss {
                    onDismiss()
                } else {
                    dismiss()
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(Color.Kuring.gray400)
                    .padding(6)
                    .background(Circle().fill(Color.Kuring.caption2))
            }
        }
    }

    /// 카테고리 영역 (건물 내 존재하는 시설 카테고리 목록 표시)
    private var categoryRow: some View {
        let categoryIcons = Array(Set(detail.campusPlaces.map { $0.category })).sorted()
        
        return HStack(spacing: 8) {
            Text("부속건물")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.Kuring.caption1)

            ForEach(categoryIcons, id: \.self) { iconName in
                Image(iconName, bundle: .module)
                    .renderingMode(.template)
                    .foregroundStyle(Color.Kuring.caption1)
                    .padding(2)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.Kuring.gray100)
                    )
            }
        }
    }

    /// 정보 영역 (건물 상세 및 운영시간)
    private var infoSection: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                addressRow
                hoursSubRow(label: "운영시간", value: detail.operatingHours.formattedCurrentHours, emphasized: true)
                hoursSubRow(label: "학기 중", value: detail.operatingHours.formattedPeriodHours(for: .semester), emphasized: false)
                hoursSubRow(label: "방학 중", value: detail.operatingHours.formattedPeriodHours(for: .vacation), emphasized: false)
            }

            if let imageUrlString = detail.imageUrl, let url = URL(string: imageUrlString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            } else {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.Kuring.primary.opacity(0.1))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image("building", bundle: .module)
                            .renderingMode(.template)
                            .foregroundStyle(Color.Kuring.primary)
                    )
            }
        }
        .frame(maxWidth: .infinity)
    }

    /// 정보 영역 - 주소
    private var addressRow: some View {
        HStack(spacing: 4) {
            Text("주소")
                .font(.system(size: 14))
                .foregroundStyle(Color.Kuring.caption1)
                .frame(width: 76, alignment: .leading)
            
            HStack(spacing: 6) {
                Text(detail.address)
                    .font(.system(size: 15))
                    .foregroundStyle(Color.Kuring.body)

                Button {
                    UIPasteboard.general.string = detail.address
                } label: {
                    Image("copy", bundle: .module)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.Kuring.gray300)
                }
            }
        }
    }

    private func hoursSubRow(label: String, value: String, emphasized: Bool) -> some View {
        HStack(alignment: .top, spacing: 4) {
            Text(label)
                .font(.system(size: 14, weight: emphasized ? .semibold : .regular))
                .foregroundStyle(emphasized ? Color.Kuring.body : Color.Kuring.caption1)
                .frame(width: 76, alignment: .leading)

            Text(value)
                .font(.system(size: 14, weight: emphasized ? .semibold : .regular))
                .foregroundStyle(emphasized ? Color.Kuring.body : Color.Kuring.caption1)
                .lineSpacing(2)
        }
    }

    /// 편의시설 (내부 시설 목록)
    private var amenitySection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("편의시설 상세 정보")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.Kuring.body)

            ForEach(detail.campusPlaces) { campusPlace in
                amenityCard(campusPlace)
            }
        }
    }

    /// 편의시설 영역
    private func amenityCard(_ campusPlace: CampusPlaceDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                let iconName = campusPlace.category
                Image(iconName, bundle: .module)
                    .renderingMode(.template)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.Kuring.primary)
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.Kuring.gray100)
                    )

                Text(campusPlace.name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.Kuring.caption1)
            }

            let floorStr = campusPlace.floor.map { "\($0)층 " } ?? ""
            let locationStr = "\(floorStr)\(campusPlace.locationDetail ?? "")"
            hoursSubRow(label: "위치", value: locationStr, emphasized: false)
            
            if let quantity = campusPlace.quantity {
                hoursSubRow(label: "수량", value: "\(quantity)개", emphasized: false)
            }
            
            hoursSubRow(label: "운영시간", value: campusPlace.operatingHours.formattedCurrentHours, emphasized: true)
            hoursSubRow(label: "학기 중", value: campusPlace.operatingHours.formattedPeriodHours(for: .semester, separator: " / "), emphasized: false)
            hoursSubRow(label: "방학 중", value: campusPlace.operatingHours.formattedPeriodHours(for: .vacation, separator: " / "), emphasized: false)
        }
    }
}
