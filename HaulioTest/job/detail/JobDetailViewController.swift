//
//  JobDetailViewController.swift
//  HaulioTest
//
//  Created by Phyo Htet Arkar on 3/25/20.
//  Copyright © 2020 Haulio. All rights reserved.
//

import UIKit
import GoogleSignIn
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(_ placemark: MKPlacemark)
}

class JobDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var jobNumber: UILabel!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var mkMapView: MKMapView!
    
    var job: JobsModel.JobResponse?
    
    var searchController: UISearchController?
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    var selectedPin: MKPointAnnotation? = nil
    
    let zoomLevel = 0.02
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mkMapView.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            locationManager.delegate = self
        }
        
        userPhoto.layer.cornerRadius = userPhoto.bounds.width / 2
        userPhoto.layer.masksToBounds = true
        
        if let profile = GIDSignIn.sharedInstance()?.currentUser.profile {
            let url = profile.imageURL(withDimension: 60)
            userPhoto.load(imageUrl: url)
            userName.text = profile.givenName
        }
        
        if let j = job {
            jobNumber.text = "Job Number: \(j.jobId)"
            
            let annotation = MKPointAnnotation()
            annotation.title = j.company
            annotation.subtitle = j.address
            annotation.coordinate = CLLocationCoordinate2D(latitude: j.geolocation.latitude, longitude: j.geolocation.longitude)
            
            mkMapView.addAnnotation(annotation)
            mkMapView.isHidden = true
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let locationsViewController = storyboard.instantiateViewController(withIdentifier: "LocationsViewController") as! LocationsViewController
        locationsViewController.mapView = mkMapView
        locationsViewController.handleMapSearchDelegate = self
        
        searchController = UISearchController(searchResultsController: locationsViewController)
        searchController?.searchResultsUpdater = locationsViewController
        
        searchController?.searchBar.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        searchController?.searchBar.frame = searchBarView.frame
        
        searchBarView.addSubview(searchController!.searchBar)
        
        searchController?.hidesNavigationBarDuringPresentation = true
        searchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "annotationView"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if #available(iOS 11.0, *) {
            if view == nil {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            }
            view?.displayPriority = .required
        } else {
            if view == nil {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            }
        }
        view?.annotation = annotation
        view?.canShowCallout = true
        return view
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        
        let alert = UIAlertController(title: "Failure", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if mkMapView.isHidden {
            mkMapView.isHidden = false
        }
        
        if let location = locations.last {
            let span = MKCoordinateSpan(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            
            mkMapView.setRegion(region, animated: true)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            mkMapView.isHidden = false
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        default:
            break
        }
    }

}

extension JobDetailViewController: HandleMapSearch {
    func dropPinZoomIn(_ placemark: MKPlacemark){
        
        // clear existing pins
        if let pin = selectedPin {
            mkMapView.removeAnnotation(pin)
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        // cache the pin
        selectedPin = annotation
         
        mkMapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mkMapView.setRegion(region, animated: true)
    }
}
