//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import UIKit
import MapKit
import Combine
import SwiftUI
import KuringMapsLink

class CampusMapViewController: UIViewController {
    private var allPlaces: [Place] = []
    /// 학교 건물 정보
    var places: [Place] = [] {
        didSet {
            allPlaces = places
            reloadAnnotations()
        }
    }
    
    var selectedCategory: KuringMapCategory? {
        didSet {
            reloadAnnotations()
        }
    }
    
    let locationManager = CLLocationManager()
    lazy var mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            let remotePlaces = try? await KuringMapsLink.placesInKonkukUniv
            if let remotePlaces {
                places = remotePlaces
            } else {
                places = Place.places
            }
        }
        setupMapView()
        setupAnnotation()
    }
    
    func setupMapView() {
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.mapType = .mutedStandard
        mapView.userTrackingMode = .followWithHeading
        mapView.showsTraffic = false
        mapView.showsCompass = false
        mapView.pointOfInterestFilter = .excludingAll
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        mapView.register(
            MKMarkerAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: AnnotationIdentifier.reuseIdentifier
        )
    }
    
    /// 핀 위치를 세팅
    func setupAnnotation() {
        places.forEach { place in
            addAnnotation(
                latitudeValue: place.latitude,
                longitudeValue: place.longitude,
                delta: 0.1,
                title: place.name,
                subtitle: place.category,
                iconName: "building"
            )
        }
        
        /// 초기 좌표는 일감호의 좌표
        let mapCamera = MKMapCamera()
        mapCamera.centerCoordinate = CLLocationCoordinate2D(
            latitude: 37.538744,
            longitude: 127.076451
        )
        mapCamera.heading = 20
        mapCamera.altitude = 5000
        mapView.setCamera(mapCamera, animated: false)
    }
    
    func placeServiceDidChange(places: [Place]) {
        self.places = places
    }
    
    func placeServiceDidSelect(place: Place) {
        guard let annotation = self.mapView.annotations.first(where: { $0.title == place.name }) as? MKPointAnnotation else { return }
        self.mapView.selectAnnotation(annotation, animated: true)
    }
    
    private func reloadAnnotations() {
        mapView.removeAnnotations(mapView.annotations)

        let filteredPlaces: [Place]
        if let category = selectedCategory {
            filteredPlaces = allPlaces.filter {
                $0.category == category.rawValue
            }
        } else {
            filteredPlaces = allPlaces
        }

        for place in filteredPlaces {
            addAnnotation(
                latitudeValue: place.latitude,
                longitudeValue: place.longitude,
                delta: 0.1,
                title: place.name,
                subtitle: "",
                iconName: selectedCategory?.icon ?? "building"
            )
        }
    }
}

extension CampusMapViewController {
    /// 위도와 경도로 원하는 위치를 표시하고, 위치를 반환
    func goLocation(
        latitudeValue: CLLocationDegrees,
        longitudeValue: CLLocationDegrees,
        delta span: Double
    ) -> CLLocationCoordinate2D {
        
        let location = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let region = MKCoordinateRegion(center: location, span: spanValue)
        
        mapView.setRegion(region, animated: true)
        
        return location
    }
    
    /// 위치가 업데이트 되었을 때 지도에 나타내기 위한 메서드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        _ = goLocation(
            latitudeValue: location.coordinate.latitude,
            longitudeValue: location.coordinate.longitude,
            delta: 0.01
        )
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error -> Void in
            let placemark = placemarks?.first
            let country = placemark?.country
            var address: String = country!
            if placemark?.locality != nil {
                address += " "
                address += placemark!.thoroughfare!
            }
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    /// 어노테이션을 추가
    func addAnnotation(
        latitudeValue: CLLocationDegrees,
        longitudeValue: CLLocationDegrees,
        delta span: Double,
        title: String,
        subtitle: String,
        iconName: String
    ) {
        let coordinate = CLLocationCoordinate2D(
            latitude: latitudeValue,
            longitude: longitudeValue
        )

        let annotation = KuringAnnotation(
            coordinate: coordinate,
            title: title,
            subtitle: subtitle,
            iconName: iconName
        )

        mapView.addAnnotation(annotation)
    }
}

extension CampusMapViewController: MKMapViewDelegate {
    enum AnnotationIdentifier {
        static let reuseIdentifier = "AnnotationView"
    }
    
    /// 맵뷰에서 annotation을 선택했을 때
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation!

        mapView.setCenter(annotation.coordinate, animated: true)
        
        let selectedPlace = self.places.first {
            view.annotation?.title == $0.name
        }
        placeSeletionPublisher.send(selectedPlace)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
        placeSeletionPublisher.send(nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard annotation is KuringAnnotation else {
            return nil
        }

        let view = mapView.dequeueReusableAnnotationView(
            withIdentifier: AnnotationIdentifier.reuseIdentifier,
            for: annotation
        ) as? MKMarkerAnnotationView
        ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: AnnotationIdentifier.reuseIdentifier)

        view.markerTintColor = UIColor(Color.Kuring.primary)
        if let annotation = annotation as? KuringAnnotation {
            view.glyphImage = UIImage(
                named: annotation.iconName,
                in: .module,
                with: nil
            )
        }
        view.glyphTintColor = .white
        view.titleVisibility = .visible
        view.canShowCallout = false

        return view
    }
}


