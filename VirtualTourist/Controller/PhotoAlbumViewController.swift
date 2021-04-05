//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Paul Davies on 04/04/2021.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var pin: Pin!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
     
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        mapView.isUserInteractionEnabled = false
        mapView.addAnnotation(pin.asAnnotation())
        mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
    }

}
