//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Paul Davies on 04/04/2021.
//

import UIKit
import MapKit

class LocationsMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.delegate = self
        
        navigationController?.navigationBar.isHidden = true
        
        if MapPreferences.hasSavedRegion {
            mapView.region = MapPreferences.region
        }
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(addPin))
        mapView.addGestureRecognizer(recognizer)
    }
    
    @objc func addPin(gestureRecognizer: UIGestureRecognizer) {
        let annotation = MKPointAnnotation()
        let touchPoint = gestureRecognizer.location(in: mapView)
        let pinLocation = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        annotation.coordinate = CLLocationCoordinate2D(latitude: pinLocation.latitude, longitude: pinLocation.longitude)
        mapView.addAnnotation(annotation)
    }
    
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        MapPreferences.save(mapView.region)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "annotation"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let nextVC = storyboard?.instantiateViewController(identifier: "PhotoAlbumViewController") as! PhotoAlbumViewController
        navigationController?.pushViewController(nextVC, animated: true)
    }

}

