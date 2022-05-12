//
//  ViewController.swift
//  lharris_mapGPS
//
//  Created by Liana Harris on 4/19/22.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var mapSwitch: UISwitch!
    @IBOutlet weak var zoomSlider: UISlider!
    
    let myAnnotation = MKPointAnnotation()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myMap.delegate = self
        myMap.mapType = .hybrid
        myMap.isZoomEnabled = true
        myMap.isScrollEnabled = true
        
        myMap.addAnnotation(myAnnotation)
        
        //set up default map region
        let tempRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.092540, longitude: -95.990437), latitudinalMeters: 500, longitudinalMeters: 500)
        myMap.setRegion(tempRegion, animated: true)
        
        // setup the switch
        mapSwitch.setOn(true, animated: true)
        
        //setup the slider
        zoomSlider.maximumValue = 3.0
        zoomSlider.minimumValue = 0.0
        zoomSlider.setValue(1.05, animated: true)
        
        // set up GPS thinga
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue = manager.location!.coordinate
        let myNewLoc = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        myMap.setCenter(myNewLoc, animated: true)
        myAnnotation.coordinate = myNewLoc
    }

    @IBAction func changeMapTypeAction(_ sender: Any) {
        if mapSwitch.isOn{
            myMap.mapType = .hybrid
        } else {
            myMap.mapType = .standard
        }
    }
    
    @IBAction func zoomInOutMap(_ sender: Any) {
        let miles = Double(zoomSlider.value)
        
        let delta = miles / 69.0
        
        var currentRegion = myMap.region
        currentRegion.span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        
        myMap.region = currentRegion
    }
}

