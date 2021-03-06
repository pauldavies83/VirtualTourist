//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Paul Davies on 04/04/2021.
//

import UIKit
import MapKit
import CoreData

class LocationsMapViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Pin>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFetchRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.delegate = self
        
        navigationController?.navigationBar.isHidden = true
        
        if MapPreferences.hasSavedRegion {
            mapView.region = MapPreferences.region
        }
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(addPin))
        mapView.addGestureRecognizer(recognizer)
        
        displayPins()
    }
    
    private func setupFetchRequest() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: true), NSSortDescriptor(key: "longitude", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "pins")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    private func displayPins() {
        mapView.removeAnnotations(mapView.annotations)
        let pins = fetchedResultsController.fetchedObjects!
        let annotations: [MKAnnotation] = pins.map {
            return $0.asAnnotation()
        }
        mapView.addAnnotations(annotations)
    }
    
    @objc func addPin(gestureRecognizer: UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: mapView)
        let pinLocation = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let pin = Pin(context: dataController.viewContext)
        pin.latitude = pinLocation.latitude
        pin.longitude = pinLocation.longitude
        try? dataController.viewContext.save()
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
        let lat = view.annotation?.coordinate.latitude
        let lon = view.annotation?.coordinate.longitude
        
        let fetchRequest = NSFetchRequest<Pin>(entityName: "Pin")
        fetchRequest.predicate = NSPredicate(format: "latitude == \(lat!) AND longitude == \(lon!)")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: true), NSSortDescriptor(key: "longitude", ascending: true)]
        
        do {
            let pin = try dataController.viewContext.fetch(fetchRequest)
            let nextVC = storyboard?.instantiateViewController(identifier: "PhotoAlbumViewController") as! PhotoAlbumViewController
            nextVC.pin = pin.first
            navigationController?.pushViewController(nextVC, animated: true)
        } catch {
            fatalError("The Pin could not be found: \(error.localizedDescription)")
        }
    }
    
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        let annotation = (anObject as! Pin).asAnnotation()
        switch type {
            case .insert:
                mapView.addAnnotation(annotation)
                break
            case .delete:
                mapView.removeAnnotation(annotation)
                break
            default:
                break
        }
    }
}
