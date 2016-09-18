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

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    enum TypeMap: Int {
        case Satellite = 1
        case Normal = 0
        case Hybrid = 2
    }
    
    var totalDistance :Float = 0
    var initLocation :CLLocation?
    
    var handlerLocation = CLLocationManager()
    
    @IBOutlet weak var typeSegmentControl: UISegmentedControl!
    @IBOutlet weak var mapWidget: MKMapView!
    
    
    @IBAction func changeTypeMap(sender: UISegmentedControl) {
        let optionMap :Int = self.typeSegmentControl.selectedSegmentIndex
        changeTypeMapView(optionMap)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapWidget.delegate = self
        mapWidget.mapType = MKMapType.Standard
        handlerLocation.delegate = self
        handlerLocation.desiredAccuracy = kCLLocationAccuracyBest
        handlerLocation.requestWhenInUseAuthorization()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            handlerLocation.startUpdatingLocation()
            mapWidget.showsUserLocation = true
        }else{
            handlerLocation.stopUpdatingLocation()
            mapWidget.showsUserLocation = false
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let actualLocation: CLLocation = manager.location!
        if initLocation == nil{
            initLocation = actualLocation
            initMapLocation(initLocation!)
        }
        let distanceMeters = actualLocation.distanceFromLocation(initLocation!)
        if distanceMeters > 50.0{
            totalDistance += Float(distanceMeters)
            addAnotationDistance(actualLocation)
            initLocation = actualLocation
        }

    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let alert = UIAlertController(title: "Error", message: "Your location isn't available now", preferredStyle: .Alert)
        let approveAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(approveAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func addAnotationDistance(pointLocation: CLLocation){
        let pin = MKPointAnnotation()
        let latitude :String = "Lat: " + String(format: "%.4f", pointLocation.coordinate.latitude)
        let longitude :String = "Long: " + String(format: "%.4f", pointLocation.coordinate.longitude)
        pin.title = latitude + " " + longitude
        pin.subtitle = "Distance: " + String(format: "%.2f", totalDistance)
        pin.coordinate = pointLocation.coordinate
        mapWidget.addAnnotation(pin)
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation
        userLocation: MKUserLocation) {
            mapWidget.centerCoordinate = userLocation.location!.coordinate
    }
    
    func initMapLocation(initLocation :CLLocation){
        let region = MKCoordinateRegionMakeWithDistance(initLocation.coordinate, 500, 500)
        mapWidget.setRegion(region, animated: true)
    }

    
    func changeTypeMapView(optionMap: Int){
        switch optionMap{
            case TypeMap.Hybrid.rawValue:
                if self.mapWidget.mapType != MKMapType.Hybrid{
                    self.mapWidget.mapType = MKMapType.Hybrid
                }
            case TypeMap.Normal.rawValue:
                if self.mapWidget.mapType != MKMapType.Standard{
                    self.mapWidget.mapType = MKMapType.Standard
                }
            case TypeMap.Satellite.rawValue:
                if self.mapWidget.mapType != MKMapType.Satellite{
                    self.mapWidget.mapType = MKMapType.Satellite
                }
            default:
                print("Never way")
        }
        
    }


}

