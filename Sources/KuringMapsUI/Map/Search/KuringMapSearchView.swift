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
    @FocusState private var isSearchFocused: Bool

    private var isSearching: Bool { !viewModel.searchText.isEmpty }

    var body: some View {
        VStack(spacing: 0) {
            searchBar

            if isSearching {
                resultsList
            } else if viewModel.recentSearches.isEmpty {
                emptyState
            } else {
                recentSearchList
            }

            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            isSearchFocused = true
        }
        .onChange(of: viewModel.searchText) { _, newValue in
            viewModel.performSearch(newValue)
        }
    }

    // MARK: - Search bar
    private var searchBar: some View {
        HStack(spacing: 12) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .renderingMode(.template)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.Kuring.gray600)
            }

            HStack(spacing: 8) {
                TextField("건물명 및 위치 검색", text: $viewModel.searchText)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.Kuring.caption1)
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
                        Image("search2", bundle: .module)
                    }
                } else {
                    Image("search2", bundle: .module)
                }
            }
            .padding(.leading, 16)
            .padding(.trailing, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.Kuring.gray100)
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }

    // MARK: - Empty state (no recent searches)
    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()

            Image("emptysearchimage", bundle: .module)
                .resizable()
                .frame(width: 150, height: 150)

            Text("최근 검색어가 아직 없습니다.")
                .font(.system(size: 14))
                .foregroundStyle(Color.Kuring.caption1)
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
                    .foregroundStyle(Color.Kuring.body)
                    .padding(.leading, 4)

                Spacer()

                Button {
                    viewModel.recentSearches.removeAll()
                } label: {
                    Text("전체삭제")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.Kuring.caption1)
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
            Image(item.iconName, bundle: .module)
                .renderingMode(.template)
                .frame(width: 20, height: 20)
                .foregroundStyle(Color.Kuring.gray300)
                .padding(4)
                .background(
                    Circle()
                        .fill(Color.Kuring.gray100)
                )
                .padding(.leading, 4)

            Text(item.query)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.Kuring.body)

            Spacer()

            Button {
                viewModel.recentSearches.removeAll { $0.id == item.id }
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(Color.Kuring.gray300)
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

    // MARK: - Autocomplete results
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
        HStack(spacing: 8) {
            Image("building", bundle: .module)
                .renderingMode(.template)
                .frame(width: 20, height: 20)
                .foregroundStyle(Color.Kuring.gray300)
                .padding(4)
                .background(
                    Circle()
                        .fill(Color.Kuring.gray100)
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
            viewModel.commitSearch(building.name)
            onSelect(building)
        }
    }

    /// 검색어와 일치하는 부분을 primary 색상으로 강조 표시
    private func highlightedText(_ text: String, matching query: String) -> Text {
        guard !query.isEmpty,
              let range = text.range(of: query, options: .caseInsensitive) else {
            return Text(text).foregroundColor(Color.Kuring.body)
        }

        let before = String(text[text.startIndex..<range.lowerBound])
        let match = String(text[range])
        let after = String(text[range.upperBound...])

        return Text(before).foregroundColor(Color.Kuring.body)
            + Text(match).foregroundColor(Color.Kuring.primary)
            + Text(after).foregroundColor(Color.Kuring.body)
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
