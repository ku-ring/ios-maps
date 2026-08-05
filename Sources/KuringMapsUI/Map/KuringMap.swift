//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import MapKit
import SwiftUI
import KuringMapsLink

/**
 캠퍼스 지도를 띄워주는 `View`.
 
 ```swift
  struct KonkukCampusMap: View {
     private let configuration = MapConfiguration(
         appID = "B1D6861E-E40E-4CF9-AB7F-E574FB835037"
     )
  
     var body: some View {
         KuringMap(configuration: configuration)
             .environment(\.mapConfiguration, configuration)
     }
  }
 ```
 */
public struct KuringMap: View {
    @Environment(\.mapAppearance) var appearance
    
    @StateObject private var viewModel = KuringMapViewModel()
    @State private var path: [NavigationPath] = []
    
    public var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                CampusMapView(viewModel: viewModel)
                    .ignoresSafeArea()
                
                topSearchArea
                
                libraryCapsule
                mapActionButtons
            }
            .navigationTitle("")
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationDestination(for: NavigationPath.self) { path in
                switch path {
                case .libraryRoom:
                    LibraryRoomList()
                        .environment(\.mapAppearance, appearance)
                case .search:
                    KuringMapSearchView(viewModel: viewModel) { building in
                        self.path.removeLast()
                        Task {
                            await viewModel.selectSearchResult(building)
                        }
                    }
                    .environment(\.mapAppearance, appearance)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadInitialData()
            }
        }
        .sheet(item: $viewModel.bottomSheetState) { state in
            switch state {
            case .list(let places):
                CategoryPlaceListView(places: places, viewModel: viewModel)
                    .environment(\.mapAppearance, appearance)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            case .buildingList(let buildings):
                BuildingDetailListView(buildings: buildings, viewModel: viewModel)
                    .environment(\.mapAppearance, appearance)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            case .detail(let detail, let parentList):
                KuringMapBottomSheet(detail: detail) {
                    viewModel.dismissDetailView(parentList: parentList)
                }
                .environment(\.mapAppearance, appearance)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
        }
    }

    public init(
        linkConfig: LinkConfiguration?,
        libConfig: LibraryConfiguration?
    ) {
        KuringMapsLink.linkHost = linkConfig?.host ?? ""
        KuringMapsLink.libraryHost = libConfig?.host ?? ""
    }
    
    public struct LinkConfiguration {
        let host: String
        
        public init(host: String = "") {
            self.host = host
        }
    }
    
    public struct LibraryConfiguration {
        let host: String
        
        public init(host: String = "") {
            self.host = host
        }
    }
    
    enum NavigationPath {
        /// 도서관 잔여 좌석
        case libraryRoom
        /// 위치 검색
        case search
    }
}

// MARK: Views
extension KuringMap {
    /// 검색 + 카테고리칩 영역
    private var topSearchArea: some View {
        VStack(spacing: 0) {
            switch viewModel.searchBarState {
            case .normal:
                searchBar
                    .padding(.top, 8)
                    .padding(.bottom, 12)
            case .active(let keyword):
                activeSearchBar(keyword: keyword)
                    .padding(.top, 8)
                    .padding(.bottom, 12)
                    .background(
                        appearance.bg
                            .ignoresSafeArea(edges: .top)
                    )
            }
            
            categoryPills
            
            Spacer()
        }
    }
    
    /// 검색창 (일반 상태)
    private var searchBar: some View {
        HStack(spacing: 8) {
            TextField("건물명 및 위치 검색", text: .constant(""))
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(appearance.caption1)
                .disabled(true)
            
            Image("search2", bundle: .module)
                .renderingMode(.template)
                .foregroundStyle(appearance.gray400)
                .frame(width: 20, height: 20)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(appearance.bg)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(radius: 4)
        .padding(.horizontal, 20)
        .onTapGesture {
            path.append(.search)
        }
    }
    
    /// 검색창 (활성화/키워드 입력 상태)
    private func activeSearchBar(keyword: String) -> some View {
        HStack(spacing: 12) {
            // 뒤로가기 버튼
            Button {
                viewModel.tapBackOnSearchBar()
            } label: {
                Image(systemName: "chevron.left")
                    .renderingMode(.template)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.black)
            }
            
            // 검색 키워드 표시창
            HStack(spacing: 8) {
                TextField("", text: .constant(keyword))
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(appearance.title)
                    .disabled(true)
                
                Spacer()
                
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(appearance.gray400)
                    .frame(width: 20, height: 20)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(appearance.gray100)
            )
            .onTapGesture {
                viewModel.tapClearOnSearchBar()
                path.append(.search)
            }
        }
        .padding(.horizontal, 20)
    }
    
    /// 카테고리칩 ScrollView
    private var categoryPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.categories) { category in
                    categoryPill(category)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
        }
        .scrollClipDisabled()
    }
    
    /// 카테고리칩 컴포넌트
    @ViewBuilder
    private func categoryPill(_ category: MapCategory) -> some View {
        let isSelected = viewModel.selectedCategoryNames.contains(category.name)
        let iconName = category.name
        
        HStack(spacing: 6) {
            Image(iconName, bundle: .module)
                .renderingMode(.template)
                .font(.system(size: 13))
            
            Text(category.korName)
                .font(.system(size: 14, weight: .medium))
        }
        .foregroundStyle(isSelected ? appearance.primary : appearance.body)
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
        .background(
            Capsule()
                .fill(appearance.bg)
                .stroke(
                    isSelected ? appearance.primary : appearance.bg,
                    lineWidth: isSelected ? 1 : 0
                )
                .shadow(color: .black.opacity(0.08), radius: 4)
        )
        .onTapGesture {
            viewModel.toggleCategory(category)
        }
    }
    
    private var libraryCapsule: some View {
        VStack {
            Spacer()
            HStack {
                Button {
                    path.append(.libraryRoom)
                } label: {
                    HStack(spacing: 6)  {
                        Image("icon.library.book", bundle: .module)
                            .renderingMode(.template)
                            .foregroundStyle(appearance.primary)
                        
                        Text("열람실 좌석 현황")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(appearance.primary)
                    }
                }
                .padding(12)
                .background(appearance.bg)
                .clipShape(.capsule)
                .overlay(
                    Capsule()
                        .stroke(appearance.primary, lineWidth: 1)
                )
                
                Spacer()
            }
        }
        .padding(.leading, 20)
        .padding(.bottom, 24)
        .shadow(color: .black.opacity(0.08), radius: 4)
    }

    private var mapActionButtons: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack(spacing: 10) {
                    if viewModel.isMapRotated {
                        Button {
                            viewModel.compassActionSubject.send()
                        } label: {
                            Image("compass", bundle: .module)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .rotationEffect(.degrees(-viewModel.mapHeading))
                        }
                        .buttonStyle(.plain)
                        .frame(width: 50, height: 50)
                        .shadow(color: .black.opacity(0.2), radius: 4)
                    }
                    
                    Button {
                        viewModel.locationActionSubject.send()
                    } label: {
                        Image("crosshair", bundle: .module)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 26, height: 26)
                    }
                    .buttonStyle(.plain)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(appearance.bg))
                    .shadow(color: .black.opacity(0.2), radius: 4)
                }
            }
        }
        .padding(.trailing, 20)
        .padding(.bottom, 24)
    }
}

struct KuringMap_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            KuringMap(
                linkConfig: .init(host: ""),
                libConfig: .init(host: "")
            )
            .tabItem { Text("maps") }
        }
    }
}
