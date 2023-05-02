//
//  CampusMapView.swift
//  
//
//  Created by Jaesung Lee on 2023/05/03.
//

import UIKit
import SwiftUI

struct CampusMapView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let campusMapViewController = CampusMapViewController()
        return campusMapViewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}

