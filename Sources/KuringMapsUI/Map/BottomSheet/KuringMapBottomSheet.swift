//
//  KuringMapBottomSheet.swift
//  package-kuring-maps
//
//  Created by Jung Hwan Park on 7/19/26.
//

import SwiftUI
import UIKit
import KuringMapsLink

struct KuringMapBottomSheet: View {
    let detail: BuildingDetailResponse
    var onDismiss: (() -> Void)? = nil
    @Environment(\.dismiss) private var dismiss
    @Environment(\.mapAppearance) var appearance

    @State private var selectedImage: Image? = nil
    @State private var isBuildingHoursExpanded: Bool = false
    @State private var expandedPlaceIds: Set<Int64> = []
    @State private var showCopyToast: Bool = false

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
        .background(appearance.bg)
        .imagePreview(image: $selectedImage)
        .overlay(alignment: .bottom) {
            if showCopyToast {
                copyToast
                    .padding(.bottom, 8)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
    }
}

// MARK: Views
extension KuringMapBottomSheet {
    /// 헤더영역
    private var header: some View {
        HStack {
            Text(detail.name)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(appearance.title)

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
                    .foregroundStyle(appearance.gray400)
                    .padding(6)
                    .background(Circle().fill(appearance.caption2))
            }
        }
    }

    /// 카테고리 영역 (건물 내 존재하는 시설 카테고리 목록 표시)
    private var categoryRow: some View {
        let categoryIcons = Array(Set(detail.campusPlaces.map { $0.category })).sorted()
        
        return HStack(spacing: 8) {
            ForEach(categoryIcons, id: \.self) { iconName in
                Image(resolvedIconName(iconName), bundle: .module)
                    .renderingMode(.template)
                    .foregroundStyle(appearance.caption1)
                    .padding(2)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(appearance.gray100)
                    )
            }
        }
    }

    /// 정보 영역 (건물 상세 및 운영시간)
    private var infoSection: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                addressRow
                
                foldableHoursRow(
                    label: "운영시간",
                    value: detail.operatingHours.formattedCurrentHours,
                    isExpanded: isBuildingHoursExpanded,
                    hasDetail: detail.operatingHours.hasKnownHours
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isBuildingHoursExpanded.toggle()
                    }
                }
                
                if isBuildingHoursExpanded {
                    VStack(alignment: .leading, spacing: 8) {
                        hoursSubRow(label: "학기 중", value: detail.operatingHours.formattedPeriodHours(for: .semester), emphasized: detail.operatingHours.isCurrent(for: .semester))
                        hoursSubRow(label: "방학 중", value: detail.operatingHours.formattedPeriodHours(for: .vacation), emphasized: detail.operatingHours.isCurrent(for: .vacation))
                    }
                }
            }
            
            Spacer()

            if let imageUrlString = detail.imageUrl, let url = URL(string: imageUrlString) {
                CachedAsyncImage(
                    url: url,
                    cacheKey: "building:\(detail.id)"
                ) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .onTapGesture {
                            selectedImage = image
                        }
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            } else {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(appearance.primary.opacity(0.1))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image("building", bundle: .module)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 36, height: 36)
                            .foregroundStyle(appearance.primary)
                    )
            }
        }
        .frame(maxWidth: .infinity)
    }

    /// 정보 영역 - 주소
    private var addressRow: some View {
        HStack(alignment: .top, spacing: 4) {
            Text("주소")
                .font(.system(size: 14))
                .foregroundStyle(appearance.caption1)
                .frame(width: 76, alignment: .leading)
            
            HStack(spacing: 6) {
                Text(detail.address)
                    .font(.system(size: 15))
                    .foregroundStyle(appearance.body)

                Button {
                    UIPasteboard.general.string = detail.address
                    presentCopyToast()
                } label: {
                    Image("copy", bundle: .module)
                        .font(.system(size: 12))
                        .foregroundStyle(appearance.gray300)
                }
            }
        }
    }

    /// 서버가 알 수 없는 카테고리 값을 내려줘도 빈 아이콘이 뜨지 않도록 기본 아이콘으로 대체
    private func resolvedIconName(_ category: String) -> String {
        UIImage(named: category, in: .module, compatibleWith: nil) != nil ? category : "general"
    }

    /// 주소 복사 토스트
    private var copyToast: some View {
        Text("주소가 복사되었습니다")
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Capsule().fill(Color.black.opacity(0.75)))
    }

    private func presentCopyToast() {
        withAnimation(.easeInOut(duration: 0.2)) {
            showCopyToast = true
        }
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            withAnimation(.easeInOut(duration: 0.2)) {
                showCopyToast = false
            }
        }
    }

    private func hoursSubRow(label: String, value: String, emphasized: Bool) -> some View {
        HStack(alignment: .top, spacing: 4) {
            Text(label)
                .font(.system(size: 14, weight: emphasized ? .semibold : .regular))
                .foregroundStyle(emphasized ? appearance.body : appearance.caption1)
                .frame(width: 76, alignment: .leading)

            Text(value)
                .font(.system(size: 14, weight: emphasized ? .semibold : .regular))
                .foregroundStyle(emphasized ? appearance.body : appearance.caption1)
                .lineSpacing(2)
        }
    }

    private func foldableHoursRow(label: String, value: String, isExpanded: Bool, hasDetail: Bool, onToggle: @escaping () -> Void) -> some View {
        let rowContent = HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text(label)
                .font(.system(size: 14))
                .foregroundStyle(appearance.caption1)
                .frame(width: 76, alignment: .leading)

            HStack(alignment: .center, spacing: 6) {
                Text(value)
                    .font(.system(size: 14))
                    .foregroundStyle(appearance.body)
                    .lineSpacing(2)

                if hasDetail {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(appearance.gray300)
                        .contentTransition(.opacity)
                }
            }
        }

        return Group {
            if hasDetail {
                Button(action: onToggle) {
                    rowContent
                }
                .buttonStyle(.plain)
            } else {
                rowContent
            }
        }
    }

    /// 편의시설 (내부 시설 목록)
    private var amenitySection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("편의시설 상세 정보")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(appearance.body)

            ForEach(detail.campusPlaces) { campusPlace in
                amenityCard(campusPlace)
            }
        }
    }

    /// 편의시설 영역
    private func amenityCard(_ campusPlace: CampusPlaceDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(resolvedIconName(campusPlace.category), bundle: .module)
                    .renderingMode(.template)
                    .font(.system(size: 12))
                    .foregroundStyle(appearance.primary)
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(appearance.gray100)
                    )
                
                Text(campusPlace.name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(appearance.caption1)
            }
            
            let floorStr = campusPlace.floor.map { "\($0) " } ?? ""
            let locationStr = "\(floorStr)\(campusPlace.locationDetail ?? "")"
            hoursSubRow(
                label: "위치",
                value: locationStr != "" ? locationStr : "위치 정보 없음",
                emphasized: false
            )
            
            if let quantity = campusPlace.quantity {
                hoursSubRow(label: "수량", value: "\(quantity)개", emphasized: false)
            }
            
            let isExpanded = expandedPlaceIds.contains(campusPlace.id)
            foldableHoursRow(
                label: "운영시간",
                value: campusPlace.operatingHours.formattedCurrentHours,
                isExpanded: isExpanded,
                hasDetail: campusPlace.operatingHours.hasKnownHours
            ) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    if isExpanded {
                        expandedPlaceIds.remove(campusPlace.id)
                    } else {
                        expandedPlaceIds.insert(campusPlace.id)
                    }
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    hoursSubRow(label: "학기 중", value: campusPlace.operatingHours.formattedPeriodHours(for: .semester), emphasized: campusPlace.operatingHours.isCurrent(for: .semester))
                    hoursSubRow(label: "방학 중", value: campusPlace.operatingHours.formattedPeriodHours(for: .vacation), emphasized: campusPlace.operatingHours.isCurrent(for: .vacation))
                }
            }
        }
    }
}
