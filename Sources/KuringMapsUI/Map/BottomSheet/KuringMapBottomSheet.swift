//
//  KuringMapBottomSheet.swift
//  package-kuring-maps
//
//  Created by Jung Hwan Park on 7/19/26.
//

import SwiftUI
import KuringMapsLink

struct KuringMapBottomSheet: View {
    let place: Place
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
    }
}

// MARK: Views
extension KuringMapBottomSheet {
    /// 헤더영역
    private var header: some View {
        HStack {
            Text(place.name)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color.Kuring.title)

            Spacer()

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(Color.Kuring.gray400)
                    .padding(6)
                    .background(Circle().fill(Color.Kuring.caption2))
            }
        }
    }

    /// 카테고리 영역
    private var categoryRow: some View {
        HStack(spacing: 8) {
            Text(place.category)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.Kuring.caption1)

            ForEach(place.facilityIcons, id: \.self) { iconName in
                Image(iconName, bundle: .module)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.Kuring.caption1)
                    .padding(2)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.Kuring.gray100)
                    )
            }
        }
    }

    /// 정보 영역
    private var infoSection: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                addressRow
                hoursSubRow(label: "운영시간", value: place.hours.closingNote, emphasized: false)
                hoursSubRow(label: "학기 중", value: place.hours.duringTerm, emphasized: true)
                hoursSubRow(label: "방학 중", value: place.hours.duringVacation, emphasized: false)
            }

            Spacer()

            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.Kuring.primary)
                .frame(width: 80, height: 80)
        }
    }

    /// 정보 영역 - 주소
    private var addressRow: some View {
        HStack {
            Text("주소")
                .font(.system(size: 14))
                .foregroundStyle(Color.Kuring.caption1)

            Spacer()
            
            HStack(spacing: 6) {
                Text(place.address)
                    .font(.system(size: 15))
                    .foregroundStyle(Color.Kuring.body)

                Button {
                    UIPasteboard.general.string = place.address
                } label: {
                    Image("copy", bundle: .module)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.Kuring.gray300)
                }
            }
        }
    }

    private func hoursSubRow(label: String, value: String, emphasized: Bool) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14, weight: emphasized ? .semibold : .regular))
                .foregroundStyle(emphasized ? Color.Kuring.body : Color.Kuring.caption1)

            Spacer()

            Text(value)
                .font(.system(size: 14, weight: emphasized ? .semibold : .regular))
                .foregroundStyle(emphasized ? Color.Kuring.body : Color.Kuring.caption1)
        }
    }

    /// 편의시설
    private var amenitySection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("편의시설 상세 정보")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.Kuring.body)

            ForEach(place.amenities) { amenity in
                amenityCard(amenity)
            }
        }
    }

    /// 편의시설 영역
    private func amenityCard(_ amenity: Amenity) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image("smoke", bundle: .module)
                    .renderingMode(.template)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.Kuring.primary)
                    .padding(2)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.Kuring.gray100)
                    )

                Text(amenity.name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.black)
            }

            hoursSubRow(label: "위치", value: amenity.location, emphasized: false)
            
            VStack(spacing: 4) {
                hoursSubRow(label: "운영시간", value: amenity.hours.closingNote, emphasized: false)
                hoursSubRow(label: "학기 중", value: amenity.hours.duringTerm, emphasized: true)
                hoursSubRow(label: "방학 중", value: amenity.hours.duringVacation, emphasized: false)
            }
        }
    }
}

#Preview {
    KuringMapBottomSheet(place: .init(id: "공학관C동", name: "공학관 C동", category: "공과대학", address: "서울특별시 광진구 능동로 120", inCampus: true, number: 21, iconUrl: nil, latitude: 37.54118, longitude: 127.079535, phone: nil, data: nil, places: [:], parentId: "konkuk"))
}
