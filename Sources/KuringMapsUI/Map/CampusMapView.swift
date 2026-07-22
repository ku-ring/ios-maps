//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import UIKit
import SwiftUI
import KuringMapsLink

struct CampusMapView: UIViewControllerRepresentable {
    let selectedCategory: KuringMapCategory?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let campusMapViewController = CampusMapViewController()
        return campusMapViewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if let uiViewController = uiViewController as? CampusMapViewController {
            uiViewController.selectedCategory = selectedCategory
        }
    }
}

import Combine

let placeSeletionPublisher = PassthroughSubject<Place?, Never>()
