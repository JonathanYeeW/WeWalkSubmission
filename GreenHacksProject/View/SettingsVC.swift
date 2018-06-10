//
//  SettingsVC.swift
//  GreenHacksProject
//
//  Created by Jonathan Yee on 6/10/18.
//  Copyright © 2018 Jonathan Yee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class SettingsVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    override func viewDidLoad() {
        print("")
        print("xX_ SettingsVC _Xx")
        print("## viewDidLoad() ##")
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        populateTableView()
        
        //MARK: Commmented Below, code for creating new Routes
        //let longPress = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.mapLongPress(_ :)))
        //longPress.minimumPressDuration = 0.5
        //mapView.addGestureRecognizer(longPress)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Variables
    let locationManager = CLLocationManager()
    var startAppSwith = false
    var locationArray: [CLLocationCoordinate2D] = []
    let objectController = Controller()
    var allRouteObjects:[Route] = []
    var threeDummyRoutes: [[Route]] = []
    
    
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func walkThisRouteButtonPressed(_ sender: UIButton) {
        print("## walkThisRouteButtonPressed ##")
        self.tabBarController?.selectedIndex = 1
    }
    
    //Functions
    //MARK: Update and zoom in on the User Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startAppSwith == false {
            startAppSwith = true
            let location = locations[0]
            let center = location.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    //MARK: Handler for the longPress
    @objc func mapLongPress(_ recognizer: UIGestureRecognizer){
        print("...")
        if recognizer.state == UIGestureRecognizerState.ended{
            print("@@ mapLongPress() @@")
            let myCoordinate: CGPoint = recognizer.location(in: mapView)
            let myNewPoint = self.mapView.convert(myCoordinate, toCoordinateFrom: self.mapView)
            locationArray.append(myNewPoint)
            makeAnnotation()
        }
    }
    
    //MARK: Update mapView, Show all Annotations
    func makeAnnotation(){
        print("## makeAnnotation() ##")
        for locationCoordiation in locationArray{
            let annotation = MKPointAnnotation()
            let centerCoordinate = CLLocationCoordinate2DMake(locationCoordiation.latitude, locationCoordiation.longitude)
            annotation.coordinate = centerCoordinate
            annotation.title = "Location Breh"
            mapView.addAnnotation(annotation)
        }
    }
    
    //MARK: Show Annotations from Saved Route
    func displayRouteAnnotations(array: [Route]){
        print("## displayRouteAnnotations ##")
        var counter = 0
        let titleArray = ["Start", "Marker 1", "Marker 2", "Marker 3", "Maker 4", "Marker 5"]
        for routeObject in array{
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2DMake(routeObject.latitude, routeObject.longitude)
            annotation.coordinate = coordinate
            annotation.title = titleArray[counter]
            mapView.addAnnotation(annotation)
            counter += 1
        }
    }
    
}//End Class










extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(">>> threeDummyRoutes.count: \(threeDummyRoutes.count)")
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titleArray = ["Route 1", "Route 2", "Route 3"]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        tableView.rowHeight = 50
        cell?.textLabel?.text = titleArray[indexPath.row]
        return cell!
    }
    
    func populateTableView(){
        print("## populateTableView ##")
        allRouteObjects = objectController.fetchAllRoutes()
        threeDummyRoutes = sortRoutesByTitle()
        tableView.reloadData()
    }
    
    func sortRoutesByTitle() -> [[Route]]{
        var array: [[Route]] = []
        var route1Array: [Route] = []
        var route2Array: [Route] = []
        var route3Array: [Route] = []
        for object in allRouteObjects{
            if object.routeTitle == "Route 1"{
                route1Array.append(object)
            } else if object.routeTitle == "Route 2" {
                route2Array.append(object)
            } else if object.routeTitle == "Route 3" {
                route3Array.append(object)
            }
        }
        array = [route1Array, route2Array, route3Array]
        print(">>>>>>>>>>> \(array)")
        return array
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("## didSelectRowAt() \(indexPath.row) ##")
        print(">>> appSettings.routeNumber is starting as \(appSettings.routeNumber)")
        let allAnnotations = mapView.annotations
        mapView.removeAnnotations(allAnnotations)
        if indexPath.row == 0 {
            displayRouteAnnotations(array: threeDummyRoutes[0])
            appSettings.routeNumber = 0
        } else if indexPath.row == 1 {
            displayRouteAnnotations(array: threeDummyRoutes[1])
            appSettings.routeNumber = 1
        } else if indexPath.row == 2 {
            displayRouteAnnotations(array: threeDummyRoutes[2])
            appSettings.routeNumber = 2
        }
        print(">>> appSettings.routeNumber is now \(appSettings.routeNumber)")
    }
}
