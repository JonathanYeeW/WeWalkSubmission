//
//  MapVC.swift
//  GreenHacksProject
//
//  Created by Jonathan Yee on 6/10/18.
//  Copyright © 2018 Jonathan Yee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    override func viewDidLoad() {
        print("")
        print("xX_ MapVC _Xx")
        print("## viewDidLoad() ##")
        super.viewDidLoad()
        selectedRoute = controller.getSelectedRoute(routeNumber: appSettings.routeNumber)
        mapView.showsUserLocation = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        walkTogetherButton.layer.backgroundColor = UIColor(red:0.54, green:0.00, blue:0.33, alpha:1.0).cgColor
        walkTogetherButton.setTitleColor(UIColor.white, for: .normal)
        walkAloneButton.layer.backgroundColor = UIColor.lightGray.cgColor
        walkAloneButton.setTitleColor(UIColor.black, for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        print("## viewWillAppear ##")
        //MARK: Remove all annotations on load to prevent issues
        //when switched back and forth between views
        let allAnnotations = mapView.annotations
        mapView.removeAnnotations(allAnnotations)
        if locationSafetySwitch == true {
            //MARK: Using locationSafetySwitch to protect from unwrapping nil Waiting for the locaitonManager to have location before dropping annotations
            print("Making new Annottations")
            selectedRoute = controller.getSelectedRoute(routeNumber: appSettings.routeNumber)
            makeAnnotation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    //Variables
    var selectedRoute: [Route] = []
    var allRoutes: [Route] = []
    let controller = Controller()
    let locationManager = CLLocationManager()
    var startAppSwith = false
    var locationSafetySwitch = false

    
    //Outlets
    @IBOutlet weak var walkAloneButton: UIButton!
    @IBOutlet weak var walkTogetherButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func walkAloneButtonPressed(_ sender: UIButton) {
        walkAloneButton.layer.backgroundColor = UIColor(red:0.54, green:0.00, blue:0.33, alpha:1.0).cgColor
        walkAloneButton.setTitleColor(UIColor.white, for: .normal)
        walkTogetherButton.layer.backgroundColor = UIColor.lightGray.cgColor
        walkTogetherButton.setTitleColor(UIColor.black, for: .normal)
    }
    @IBAction func walkTogetherButtonPressed(_ sender: UIButton) {
        walkTogetherButton.layer.backgroundColor = UIColor(red:0.54, green:0.00, blue:0.33, alpha:1.0).cgColor
        walkTogetherButton.setTitleColor(UIColor.white, for: .normal)
        walkAloneButton.layer.backgroundColor = UIColor.lightGray.cgColor
        walkAloneButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    
    //Functions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startAppSwith == false {
            print("## Started To Update Locations ##")
            startAppSwith = true
            let location = locations[0]
            let center = location.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: true)
            makeAnnotation()
            locationSafetySwitch = true
        }
    }
    
    func makeAnnotation(){
        print("## makeAnnotation() ##")
        var counter = 0
        let titleArray = ["Start", "Marker 1", "Marker 2", "Marker 3", "Maker 4", "Marker 5", "Marker 6", "Marker 7"]
        for locationCoordiation in selectedRoute{
            let annotation = MKPointAnnotation()
            let centerCoordinate = CLLocationCoordinate2DMake(locationCoordiation.latitude, locationCoordiation.longitude)
            annotation.coordinate = centerCoordinate
            annotation.title = titleArray[counter]
            mapView.addAnnotation(annotation)
            counter += 1
        }
    }
    
    
}//End Class
