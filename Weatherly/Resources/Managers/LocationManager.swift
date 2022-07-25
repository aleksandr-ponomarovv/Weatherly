//
//  LocationManager.swift
//  Weatherly
//
//  Created by Aleksandr on 24.07.2022.
//

import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func locationManagerDidUpdateLocations(lat: String, lon: String)
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    weak var delegate: LocationManagerDelegate?
    
    private let locationManager = CLLocationManager()
    
    var latitude: String? {
        guard let latitude = locationManager.location?.coordinate.latitude else { return nil }
        return String(latitude)
    }
    
    var longitude: String? {
        guard let longitude = locationManager.location?.coordinate.longitude else { return nil }
        return String(longitude)
    }
    
    override private init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func getPlaceName(lat: Double, lon: Double, completion: @escaping (String?) -> Void) {
        let locationCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error == nil,
               let placemarks = placemarks?.first,
               let locationName = placemarks.locality {
                completion(locationName)
            } else {
                completion(nil)
            }
        }
    }
    
    func checkPermission(authorizedHandler: @escaping (Bool) -> Void) {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                authorizedHandler(false)
            case .authorizedAlways, .authorizedWhenInUse:
                authorizedHandler(true)
            @unknown default:
                break
            }
        } else {
            authorizedHandler(false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else { return }
        
        delegate?.locationManagerDidUpdateLocations(lat: String(coordinate.latitude), lon: String(coordinate.longitude))
    }
}
