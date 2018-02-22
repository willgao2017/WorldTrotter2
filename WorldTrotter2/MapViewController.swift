//
//  MapViewController.swift
//  WorldTrotter2
//
//  Created by Will GAO on 11/02/2018.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var mapView: MKMapView!
    var button: UIButton!
    
    
    override func loadView() {
        // Create a map view
        mapView = MKMapView()
        // Set it as *the* view of this view controller
        view = mapView
        
        mapView.delegate = self
        
        let segmentedControl
            = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor
            = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        //let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.topAnchor)
        let topConstraint =
            segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor,
                                                  constant: 8)
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
                
        button = UIButton(type: .contactAdd)
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(MapViewController.updateUserLocation), for: .touchDown)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonTrailingConstraint = button.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        let buttonBottomConstraint = button.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -8)
        buttonTrailingConstraint.isActive = true
        buttonBottomConstraint.isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded its view.")
    }
    
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break }
    }
    
    @objc func updateUserLocation() {
        print("updateUserLocation is clicked")
        
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("Log: did update user location")
        let currentLocation = mapView.userLocation.location
        
        if let currentLocation = currentLocation {
            let location = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            
            print("Log: currentLocation is \(location)")
            
            //mapView.setCenter(location, animated: true)
            
            let span = MKCoordinateSpanMake(0.01, 0.01) // 1 degree ~ 0.0175 radian
            let region = MKCoordinateRegion(center: location, span: span)
            
            mapView.setRegion(region, animated: true)
        }
    }
}
