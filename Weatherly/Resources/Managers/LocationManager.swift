//
//  LocationManager.swift
//  Weatherly
//
//  Created by Aleksandr on 24.07.2022.
//

import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func locationManagerDidUpdateLocations(location: Location)
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    weak var delegate: LocationManagerDelegate?
    
    private let locationManager = CLLocationManager()
    
    override private init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func getLocation(latitude: Double, longitude: Double, completion: @escaping (Location?) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(location) { places, error in
            if error == nil,
               let place = places?.first,
               let name = place.locality,
               let country = place.country {
                
                completion(Location(name: name, country: country, latitude: latitude, longitude: longitude))
            } else {
                completion(nil)
            }
        }
    }
    
    func findLocations(text: String, completion: @escaping ([Location]) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(text) { places, error in
            if let places = places, error == nil {
                let cities: [Location] = places.compactMap { place in
                    guard let name = place.locality,
                          let country = place.country,
                          let coordinate = place.location?.coordinate else { return nil }
                    
                    return Location(name: name, country: country, latitude: coordinate.latitude, longitude: coordinate.longitude)
                }
                completion(cities)
            } else {
                completion([])
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
        
        locationManager.stopUpdatingLocation()
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        getLocation(latitude: latitude, longitude: longitude) { [weak self] location in
            guard let self = self,
                  let location = location else { return }
            
            self.delegate?.locationManagerDidUpdateLocations(location: location)
        }
    }
}
