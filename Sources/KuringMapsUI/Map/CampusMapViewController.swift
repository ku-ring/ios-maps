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
    let viewModel: KuringMapViewModel
    
    let locationManager = CLLocationManager()
    lazy var mapView = MKMapView()
    
    // 렌더링 상태 캐싱을 위함
    private var lastCategoryNames: Set<String> = []
    private var lastBuildingsCount: Int = 0
    private var lastCampusPlacesCount: Int = 0
    private var lastSearchResultsCount: Int = 0
    private var lastSearchPlaceResultsCount: Int = 0
    private var lastIsSearchActive: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    var appearance: Appearance
    
    init(viewModel: KuringMapViewModel, appearance: Appearance) {
        self.viewModel = viewModel
        self.appearance = appearance
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupInitialCamera()
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        viewModel.compassActionSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.resetMapHeading()
            }
            .store(in: &cancellables)
    }
    
    private func resetMapHeading() {
        let camera = mapView.camera
        camera.heading = 0
        mapView.setCamera(camera, animated: true)
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
    
    func setupInitialCamera() {
        /// 초기 좌표는 일감호의 좌표
        let mapCamera = MKMapCamera()
        mapCamera.centerCoordinate = CLLocationCoordinate2D(
            latitude: 37.540893,
            longitude: 127.076572
        )
        mapCamera.heading = 20
        mapCamera.altitude = 4000
        mapView.setCamera(mapCamera, animated: false)
    }
    
    func updateAnnotations() {
        let categoryNames = viewModel.selectedCategoryNames
        let buildingsCount = viewModel.allBuildings.count
        let campusPlacesCount = viewModel.campusPlaces.count
        let searchResultsCount = viewModel.searchResults.count
        let searchPlaceResultsCount = viewModel.searchPlaceResults.count
        let isSearchActive = viewModel.searchBarState.isActive

        if lastCategoryNames == categoryNames &&
            lastBuildingsCount == buildingsCount &&
            lastCampusPlacesCount == campusPlacesCount &&
            lastSearchResultsCount == searchResultsCount &&
            lastSearchPlaceResultsCount == searchPlaceResultsCount &&
            lastIsSearchActive == isSearchActive {
            return
        }

        lastCategoryNames = categoryNames
        lastBuildingsCount = buildingsCount
        lastCampusPlacesCount = campusPlacesCount
        lastSearchResultsCount = searchResultsCount
        lastSearchPlaceResultsCount = searchPlaceResultsCount
        lastIsSearchActive = isSearchActive
        
        mapView.removeAnnotations(mapView.annotations)
        
        if viewModel.selectedCategoryNames.isEmpty {
            if isSearchActive {
                // 검색 결과 건물들만 보여주기 (건물명 + 시설명 매칭)
                var shownBuildingIds = Set<Int>()
                for building in viewModel.searchResults {
                    guard shownBuildingIds.insert(building.id).inserted else {
                        continue
                    }
                    addAnnotation(
                        buildingId: building.id,
                        latitudeValue: building.latitude,
                        longitudeValue: building.longitude,
                        title: building.name,
                        subtitle: "",
                        iconName: "building"
                    )
                }
                for place in viewModel.searchPlaceResults {
                    let building = place.building
                    guard shownBuildingIds.insert(building.id).inserted else {
                        continue
                    }
                    addAnnotation(
                        buildingId: building.id,
                        latitudeValue: building.latitude,
                        longitudeValue: building.longitude,
                        title: building.name,
                        subtitle: "",
                        iconName: "building"
                    )
                }
            } else {
                // 모든 건물 보여주기
                for building in viewModel.allBuildings {
                    addAnnotation(
                        buildingId: building.id,
                        latitudeValue: building.latitude,
                        longitudeValue: building.longitude,
                        title: building.name,
                        subtitle: "",
                        iconName: "building"
                    )
                }
            }
        } else {
            // 필터된 건물만 보여주기
            for place in viewModel.campusPlaces {
                addAnnotation(
                    buildingId: place.building.id,
                    latitudeValue: place.building.latitude,
                    longitudeValue: place.building.longitude,
                    title: place.name,
                    subtitle: place.building.name,
                    iconName: place.category
                )
            }
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
        guard let location = locations.last else {
            return
        }
        
        _ = goLocation(
            latitudeValue: location.coordinate.latitude,
            longitudeValue: location.coordinate.longitude,
            delta: 0.01
        )
        locationManager.stopUpdatingLocation()
    }
    
    /// 어노테이션을 추가
    func addAnnotation(
        buildingId: Int,
        latitudeValue: CLLocationDegrees,
        longitudeValue: CLLocationDegrees,
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
            iconName: iconName,
            buildingId: buildingId
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
        guard let annotation = view.annotation as? KuringAnnotation else {
            return
        }

        mapView.setCenter(annotation.coordinate, animated: true)
        
        Task {
            await viewModel.selectBuilding(id: annotation.buildingId)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
        viewModel.deselectBuilding()
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

        view.markerTintColor = UIColor(appearance.primary)
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
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        let heading = mapView.camera.heading
        let isRotated = abs(heading) > 1.0
        if viewModel.isMapRotated != isRotated {
            viewModel.isMapRotated = isRotated
        }
        if viewModel.mapHeading != heading {
            viewModel.mapHeading = heading
        }
    }
}
