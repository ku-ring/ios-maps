//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import UIKit
import SwiftUI
import KuringMapsLink

struct CampusMapView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: KuringMapViewModel
    
    func makeUIViewController(context: Context) -> CampusMapViewController {
        let campusMapViewController = CampusMapViewController(viewModel: viewModel)
        return campusMapViewController
    }

    func updateUIViewController(_ uiViewController: CampusMapViewController, context: Context) {
        uiViewController.updateAnnotations()
    }
}
