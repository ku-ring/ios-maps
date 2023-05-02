//
//  PlaceService.swift
//  
//
//  Created by Jaesung Lee on 2023/05/03.
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
    
    var subscriptions: Set<AnyCancellable> = []
    
    var places: [Place]
    
    public init() {
        places = (try? Place.places) ?? []
        
        $text
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] keyword in
                self?.searchKeyword = keyword
            }
            )
            .store(in: &subscriptions)
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

