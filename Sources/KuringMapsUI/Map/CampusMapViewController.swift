//
//  CampusMapViewController.swift
//  
//
//  Created by Jaesung Lee on 2023/05/03.
//

import UIKit
import MapKit
import KuringMapsLink

class CampusMapViewController: UIViewController, PlaceServiceDelegate {
    
    /// 학교 건물 정보
    var places: [Place] = [] {
        didSet {
            self.mapView.removeAnnotations(self.mapView.annotations)
            places.forEach { place in
                addAnnotation(
                    latitudeValue: place.latitude,
                    longitudeValue: place.longitude,
                    delta: 0.1,
                    title: place.name,
                    subtitle: place.category
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
    }
    
    let locationManager = CLLocationManager()
    lazy var mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            let remotePlaces = try? await KuringMapsLink.allPlaces
            if let remotePlaces {
                places = remotePlaces
            } else {
                
                places = Place.places
            }
        }
        PlaceManager.shared.delegate = self
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
    }
    
    /// 핀 위치를 세팅
    func setupAnnotation() {
        places.forEach { place in
            addAnnotation(
                latitudeValue: place.latitude,
                longitudeValue: place.longitude,
                delta: 0.1,
                title: place.name,
                subtitle: place.category
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
        subtitle: String
    ) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = goLocation(latitudeValue: latitudeValue, longitudeValue: longitudeValue, delta: span)
        
        annotation.title = title
        annotation.subtitle = subtitle
        mapView.addAnnotation(annotation)
    }
}

extension CampusMapViewController: MKMapViewDelegate {
    /// 맵뷰에서 annotation을 선택했을 때
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        let annotation = view.annotation!
//
//        mapView.setCenter(annotation.coordinate, animated: true)
    }
}
