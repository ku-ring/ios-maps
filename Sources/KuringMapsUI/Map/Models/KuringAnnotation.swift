//
//  KuringAnnotation.swift
//  package-kuring-maps
//
//  Created by Jung Hwan Park on 7/19/26.
//

import MapKit

final class KuringAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let iconName: String
    let buildingId: Int

    init(
        coordinate: CLLocationCoordinate2D,
        title: String?,
        subtitle: String?,
        iconName: String,
        buildingId: Int
    ) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
        self.buildingId = buildingId
    }
}
