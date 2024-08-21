//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import KuringMapsLink

@MainActor
class KonkukLibrary: ObservableObject {
    @Published var rooms: [KonkukLibraryLink.Room] = []
    @Published var loadingState: LoadingState = .none {
        didSet {
            switch loadingState {
            case .none, .loading:
                isAnimating = true
            case .succeeded, .failed:
                isAnimating = false
            }
        }
    }
    
    @Published var isAnimating = false
    
    let link = KonkukLibraryLink()
    
    enum LoadingState: Equatable {
        case none
        case loading
        case succeeded
        case failed
    }
    
    enum Action {
        case onAppear
        case refreshButtonTapped
        case resetLoadingState
    }
    
    func fetchRooms() {
        Task {
            resetLoadingState()
            
            do {
                self.rooms = try await link.fetchRooms()
                self.loadingState = .succeeded
                try await Task.sleep(nanoseconds: 1_000_000)
            } catch {
                print(error.localizedDescription)
                self.loadingState = .failed
            }
            
        }
    }
    
    func resetLoadingState() {
        self.loadingState = .none
    }
    
    
    func send(_ action: Action) {
        switch action {
        case .onAppear:
            guard self.rooms.isEmpty else { return }
            self.loadingState = .loading
            self.fetchRooms()
        case .refreshButtonTapped:
            self.loadingState = .loading
            self.fetchRooms()
        case .resetLoadingState:
            self.resetLoadingState()
        }
    }
}
