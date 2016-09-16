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
    
    var latitudeRecorded :String?
    var longitudeRecorded :String?
    var distanceRecorded :Int?
    
    
    
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
        initLocation()
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
        var point = CLLocationCoordinate2D()
        point.latitude = manager.location!.coordinate.latitude
        point.longitude = manager.location!.coordinate.longitude
        print(point.longitude)
        print(point.latitude)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error")
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation
        userLocation: MKUserLocation) {
            mapWidget.centerCoordinate = userLocation.location!.coordinate
    }
    
    func initLocation(){
        var point = CLLocationCoordinate2D()
        point = mapWidget.userLocation.coordinate
        let region = MKCoordinateRegionMakeWithDistance(point, 5000, 5000)
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

