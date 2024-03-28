//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import KuringMapsLink

@MainActor
class KonkukLibrary: ObservableObject {
    @Published var rooms: [KonkukLibraryLink.Room] = []
    @Published var loadingState: LoadingState = .none
    
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
            do {
                self.rooms = try await link.fetchRooms()
                self.loadingState = .succeeded
                try await Task.sleep(nanoseconds: 1_000_000)
                self.resetLoadingState()
            } catch {
                print(error.localizedDescription)
                self.loadingState = .failed
                self.resetLoadingState()
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
