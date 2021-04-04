//
//  MapPreferences.swift
//  VirtualTourist
//
//  Created by Paul Davies on 04/04/2021.
//

import Foundation
import MapKit

class MapPreferences {
    static let latDelta = "centerLatDelta"
    static let lonDelta = "centerLonDelta"
    static let lat = "centerLat"
    static let lon = "centerLon"
    
    static func save(_ region: MKCoordinateRegion) {
        UserDefaults.standard.set(region.span.latitudeDelta, forKey: MapPreferences.latDelta)
        UserDefaults.standard.set(region.span.latitudeDelta, forKey: MapPreferences.latDelta)
        UserDefaults.standard.set(region.center.latitude, forKey: MapPreferences.lat)
        UserDefaults.standard.set(region.center.longitude, forKey: MapPreferences.lon)
    }
    
    static var hasSavedRegion: Bool {
        return UserDefaults.standard.dictionaryRepresentation().keys.contains(lat)
    }
    
    static var region: MKCoordinateRegion {
        let lat = UserDefaults.standard.double(forKey: MapPreferences.lat)
        let lon = UserDefaults.standard.double(forKey: MapPreferences.lon)
        let latDelta = UserDefaults.standard.double(forKey: MapPreferences.latDelta)
        let lonDelta = UserDefaults.standard.double(forKey: MapPreferences.lonDelta)

        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta))
    }
}
