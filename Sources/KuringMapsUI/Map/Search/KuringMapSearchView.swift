//
//  KuringMapSearchView.swift
//  package-kuring-maps
//
//  Created by Jung Hwan Park on 7/19/26.
//

import SwiftUI
import KuringMapsLink

struct KuringMapSearchView: View {
    @ObservedObject var viewModel: KuringMapViewModel
    let onSelect: (Building) -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(\.mapAppearance) var appearance
    @FocusState private var isSearchFocused: Bool

    private var isSearching: Bool { !viewModel.searchText.isEmpty }

    var body: some View {
        VStack(spacing: 0) {
            searchBar

            if isSearching {
                if viewModel.searchResults.isEmpty {
                    noResultsState
                } else {
                    resultsList
                }
            } else if viewModel.recentSearches.isEmpty {
                emptyState
            } else {
                recentSearchList
            }

            Spacer()
        }
        .background(appearance.bg)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            isSearchFocused = true
        }
    }

    private var searchBar: some View {
        HStack(spacing: 12) {
            Button {
                viewModel.searchText = ""
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .renderingMode(.template)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(appearance.gray600)
            }

            HStack(spacing: 8) {
                TextField("건물명 및 위치 검색", text: $viewModel.searchText)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(appearance.caption1)
                    .focused($isSearchFocused)
                    .submitLabel(.search)
                    .onSubmit {
                        viewModel.commitSearch(viewModel.searchText)
                    }

                if isSearching {
                    Button {
                        viewModel.searchText = ""
                        viewModel.searchResults = []
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(appearance.gray400)
                            .frame(width: 20, height: 20)
                    }
                } else {
                    Image("search2", bundle: .module)
                        .renderingMode(.template)
                        .foregroundStyle(appearance.gray400)
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.leading, 16)
            .padding(.trailing, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(appearance.gray100)
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(
            appearance.bg
                .ignoresSafeArea(edges: .top)
        )
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()

            Image("emptysearchimage", bundle: .module)
                .resizable()
                .frame(width: 150, height: 150)

            VStack {
                Text("최근 검색어가 아직 없습니다.")
                    .font(.system(size: 14))
                    .foregroundStyle(appearance.caption1)
            }
            .frame(height: 50, alignment: .top)
            .padding(.top, 12)

            Spacer()
            Spacer()
        }
    }

    private var noResultsState: some View {
        VStack(spacing: 16) {
            Spacer()

            Image("emptysearchimage", bundle: .module)
                .resizable()
                .frame(width: 150, height: 150)

            VStack(spacing: 4) {
                Text("관련 검색 결과가 없습니다.")
                Text("다른 검색어를 입력해주세요.")
            }
            .font(.system(size: 14))
            .foregroundStyle(appearance.caption1)
            .multilineTextAlignment(.center)
            .frame(height: 50, alignment: .top)
            .padding(.top, 12)

            Spacer()
            Spacer()
        }
    }

    // MARK: - Recent searches
    private var recentSearchList: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("최근 검색어")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(appearance.body)
                    .padding(.leading, 4)

                Spacer()

                Button {
                    viewModel.recentSearches.removeAll()
                } label: {
                    Text("전체삭제")
                        .font(.system(size: 16))
                        .foregroundStyle(appearance.caption1)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 8)

            ForEach(viewModel.recentSearches) { item in
                recentSearchRow(item)
            }
        }
    }

    private func recentSearchRow(_ item: RecentSearch) -> some View {
        HStack(spacing: 12) {
            Image("recentsearched-clock", bundle: .module)
                .renderingMode(.template)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(appearance.gray300)
                .padding(4)
                .background(
                    Circle()
                        .fill(appearance.gray100)
                )
                .padding(.leading, 4)

            Text(item.query)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(appearance.body)

            Spacer()

            Button {
                viewModel.recentSearches.removeAll { $0.id == item.id }
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(appearance.gray300)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.searchText = item.query
            viewModel.commitSearch(item.query)
        }
    }

    private var resultsList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.searchResults) { building in
                    resultRow(building)
                }
            }
        }
    }

    private func resultRow(_ building: Building) -> some View {
        let isInHistory = viewModel.recentSearches.contains { $0.query == building.name }
        let iconName = isInHistory ? "recentsearched-clock" : "building"
        
        return HStack(spacing: 8) {
            Image(iconName, bundle: .module)
                .renderingMode(.template)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(appearance.gray300)
                .padding(4)
                .background(
                    Circle()
                        .fill(appearance.gray100)
                )
                .padding(.leading, 8)

            highlightedText(building.name, matching: viewModel.searchText)
                .font(.system(size: 16, weight: .semibold))

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.addRecentSearch(building.name)
            onSelect(building)
        }
    }

    /// 검색어와 일치하는 부분을 primary 색상으로 강조 표시
    private func highlightedText(_ text: String, matching query: String) -> Text {
        guard !query.isEmpty,
              let range = text.range(of: query, options: .caseInsensitive) else {
            return Text(text).foregroundColor(appearance.body)
        }

        let before = String(text[text.startIndex..<range.lowerBound])
        let match = String(text[range])
        let after = String(text[range.upperBound...])

        return Text(before).foregroundColor(appearance.body)
            + Text(match).foregroundColor(appearance.primary)
            + Text(after).foregroundColor(appearance.body)
    }
}

public struct RecentSearch: Identifiable, Equatable {
    public let id = UUID()
    public let query: String
    public let iconName: String
}

#Preview {
    KuringMapSearchView(viewModel: KuringMapViewModel()) { building in
        print(building)
    }
}
