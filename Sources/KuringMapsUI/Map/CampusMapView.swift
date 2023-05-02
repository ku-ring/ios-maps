//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import UIKit
import SwiftUI
import KuringMapsLink

struct CampusMapView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let campusMapViewController = CampusMapViewController()
        return campusMapViewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}

import Combine

let placeSeletionPublisher = PassthroughSubject<Place?, Never>()
