//
//  ViewController.swift
//  MapsChallenge
//
//  Created by Mario on 14/09/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import UIKit

import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    var latitudeRecorded :String?
    var longitudeRecorded :String?
    var distanceRecorded :Int?
    
    var handlerLocation = CLLocationManager()
    
    @IBOutlet weak var mapWidget: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handlerLocation.delegate = self
        handlerLocation.desiredAccuracy = kCLLocationAccuracyBest
        handlerLocation.requestWhenInUseAuthorization()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            handlerLocation.startUpdatingLocation()
        }else{
            handlerLocation.stopUpdatingLocation()
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(String(manager.location!.coordinate.latitude))
        print(String(manager.location!.coordinate.longitude))
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error")
    }


}

