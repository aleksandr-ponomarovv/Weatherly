//   
//  MapViewController.swift
//  Weatherly
//
//  Created by Aleksandr on 30.07.2022.
//

import UIKit
import MapKit

protocol MapViewType: AnyObject {
    func setupPin(coordinate: CLLocationCoordinate2D, title: String?)
}

class MapViewController: UIViewController {
    
    @IBOutlet private weak var mapView: MKMapView!
    
    var presenter: MapPresenterType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        configureUI()
        subscribeNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter?.viewDidAppear()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - MapViewType
extension MapViewController: MapViewType {
    func setupPin(coordinate: CLLocationCoordinate2D, title: String? = nil) {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = title
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(pin)
        let center = CLLocationCoordinate2D(latitude: coordinate.latitude,
                                            longitude: coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
}

// MARK: - LocationManagerDelegate
extension MapViewController: LocationManagerDelegate {
    func locationManagerDidUpdateLocations(location: Location) {
        presenter?.didUpdateLocations(location: location)
    }
}

// MARK: - Private methods
private extension MapViewController {
    func configureUI() {
        localizeUI()
        setupNavigationBar()
        setupMapView()
    }
    
    func subscribeNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(localizeUI), name: .languageChange, object: nil)
    }
    
    @objc func localizeUI() {
        title = Localizable.mapTitle.key.localized()
    }

    // MARK: - Navigation
    func setupNavigationBar() {
        guard let rightButtonImage = R.image.ic_my_location() else { return }
        
        setupNavigationRightButton(image: rightButtonImage, action: #selector(navigationRightButtonAction))
    }
    
    @objc func navigationRightButtonAction() {
        presenter?.didTapNavigationRightButton()
    }
    
    // MARK: - Map
    func setupMapView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnMap))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapOnMap(tapGeasture: UITapGestureRecognizer) {
        let touchLocation = tapGeasture.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        presenter?.didTapOnMap(latitude: locationCoordinate.latitude,
                               longitude: locationCoordinate.longitude)
    }
}
