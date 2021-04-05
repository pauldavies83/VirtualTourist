//
//  Pin+Extensions.swift
//  VirtualTourist
//
//  Created by Paul Davies on 05/04/2021.
//

import Foundation
import MapKit

extension Pin {
    func asAnnotation() -> MKAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        return annotation
    }
}
