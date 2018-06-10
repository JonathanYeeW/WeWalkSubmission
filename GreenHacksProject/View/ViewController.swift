//
//  ViewController.swift
//  GreenHacksProject
//
//  Created by Jonathan Yee on 6/9/18.
//  Copyright © 2018 Jonathan Yee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.mapLongPress(_ :)))
        longPress.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPress)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //Variables
    let locationManager = CLLocationManager()
    var droppedPinSwitch = false
    var locationArray: [CLLocationCoordinate2D] = []
    var startAppSwith = false
    var routeArray: [CLLocationCoordinate2D] = []
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var dummyRoutes: [Route] = []
    
    //Outlets
    @IBOutlet weak var mapView: MKMapView!
    let controller = Controller()
    
    @IBAction func selectRouteButtonPressed(_ sender: UIButton) {
        print("@@ selectRouteButtonPressed @@")
        print(locationArray)
        saveRoute()
        
    }
    
    @IBAction func meButtonPressed(_ sender: UIButton) {
        print("@@ meButtonPressed @@")
        startAppSwith = false
    }
    
    
    
    //Functions
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
    
    func saveRoute(){
        for coordinate in locationArray{
            let item = NSEntityDescription.insertNewObject(forEntityName: "Route", into: managedObjectContext) as! Route
            item.createdAt = Date()
            item.routeTitle = "Route 3"
            item.latitude = coordinate.latitude
            item.longitude = coordinate.longitude
            controller.save()
        }
        print("Route Saved!")
    }
    
    func setDummyRoute(){
        fetchRoutes()
        locationArray = []
        for object in dummyRoutes{
            let newCoord = CLLocationCoordinate2D(latitude: object.latitude, longitude: object.longitude)
            locationArray.append(newCoord)
        }
    }
    
    func fetchRoutes(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Route")
        do {
            let result = try managedObjectContext.fetch(request)
            dummyRoutes = result as! [Route]
        } catch {
            print("Error \(error)")
        }
    }
}//End Class
