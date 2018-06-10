//
//  Controller.swift
//  GreenHacksProject
//
//  Created by Jonathan Yee on 6/10/18.
//  Copyright © 2018 Jonathan Yee. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Controller {
    
    //Variables
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Functions
    func fetchAllRoutes() -> [Route]{
        var array: [Route] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Route")
        do {
            let result = try managedObjectContext.fetch(request)
            array = result as! [Route]
        } catch {
            print("Error \(error)")
        }
        return array
    }
    
    func deleteAllRoutes(){
        var array = fetchAllRoutes()
        for item in array {
            managedObjectContext.delete(item)
        }
        save()
    }
    
    func save(){
        do {
            try managedObjectContext.save()
        } catch {
            print("There was an error trying to save", error)
        }
    }
    
    func getSelectedRoute(routeNumber: Int) -> [Route]{
        print("<> getSelectedRoute() <>")
        let allRouteArray: [Route] = fetchAllRoutes()
        let newTitleArray = ["Route 1", "Route 2", "Route 3"]
        var selectedRoutes: [Route] = []
        for object in allRouteArray{
            if object.routeTitle == newTitleArray[routeNumber] {
                selectedRoutes.append(object)
            }
        }
        return selectedRoutes
    }
}//End Class
