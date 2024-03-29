//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Combine
import Foundation

@MainActor
public class PlaceService: ObservableObject {
    @Published public var text: String = "" {
        didSet { searchPlace() }
    }
    @Published public var selectedCategory: String? {
        didSet { searchCategory() }
    }
    
    @Published public var results: [Place]? = nil
    
    @Published public var searchKeyword = ""
    
    var cancellables: Set<AnyCancellable> = []
    
    var places: [Place]
    
    public init() {
        places = Place.places
        
        $text
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] keyword in
                self?.searchKeyword = keyword
            })
            .store(in: &cancellables)
    }
    
    public func clearSearchText() {
        self.text = ""
    }
    
    public func searchPlace() {
        guard !places.isEmpty else {
            results = nil
            return
        }
        let resultsByName = places.filter({ $0.name.contains(text) })
        let resultsByCategory = places.filter({ $0.category.contains(text) })
        let unionResults = Array(Set(resultsByName).union(Set(resultsByCategory)))
        results = unionResults.isEmpty ? nil : unionResults.sorted(by: { $0.name < $1.name })
        // []: No result found
        // nil: Reset state
        
        PlaceManager.shared.changePlaces(to: results ?? places)
    }
    
    public func searchCategory() {
        guard !places.isEmpty, let selectedCategory else {
            results = nil
            return
        }
        let resultsByCategory = places.filter({ $0.category.contains(selectedCategory) })
        results = resultsByCategory.isEmpty ? nil : resultsByCategory
        
        PlaceManager.shared.changePlaces(to: results ?? places)
    }
    
    public func resetText() {
        text = ""
    }
    
    public func resetSelectedCategory() {
        selectedCategory = nil
    }
    
    public func selectPlace(_ place: Place) {
        PlaceManager.shared.selectPlace(place)
    }
}

public protocol PlaceServiceDelegate: AnyObject {
    func placeServiceDidChange(places: [Place])
    
    func placeServiceDidSelect(place: Place)
}

public class PlaceManager {
    public static let shared = PlaceManager()
    
    public weak var delegate: PlaceServiceDelegate?
    
    public func changePlaces(to places: [Place]) {
        delegate?.placeServiceDidChange(places: places)
    }
    
    public func selectPlace(_ place: Place) {
        delegate?.placeServiceDidSelect(place: place)
    }
}

