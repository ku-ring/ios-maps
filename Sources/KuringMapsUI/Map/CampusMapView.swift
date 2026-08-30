//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import UIKit
import SwiftUI
import KuringMapsLink

struct CampusMapView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: KuringMapViewModel
    @Environment(\.mapAppearance) var appearance
    
    func makeUIViewController(context: Context) -> CampusMapViewController {
        let campusMapViewController = CampusMapViewController(viewModel: viewModel, appearance: appearance)
        return campusMapViewController
    }

    func updateUIViewController(_ uiViewController: CampusMapViewController, context: Context) {
        uiViewController.appearance = appearance
        uiViewController.updateAnnotations()
    }
}
