//
//  ViewController.swift
//  ZaHunter
//
//  Created by James Rochabrun on 06-04-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
        
    var searchQuery  = String()
    
    var location = CLLocation()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //creating a location manager property
    let locationManager = CLLocationManager()
    
    var pizzaPlaces = [MKMapItem]()
    let pizzaDistances = NSMutableArray()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1 creates alert to request access from the user
        locationManager.requestWhenInUseAuthorization()
        
        
        // 2 sets the location managers delegates to this VC
        locationManager.delegate = self
        
        //4 start tracking user
        self.startLookingForUserLocation()
        
        self.searchQuery = "Pizza"


    }
    
    //3 prints error if we cant find the user
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print(error)
    }
    
    
    //4 start tracking user
    func startLookingForUserLocation()
    {
        locationManager.startUpdatingLocation()
        
        print("got location of the user")

    }
    
    //5 returns and array of locations
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        //the first result of the CLLocation array
        let location = locations.first
        
        //we have accuracy of the location with in meters
        
        if location?.verticalAccuracy < 1000 && location?.horizontalAccuracy < 1000  {
            textView.text = "location found , reverse geo coding"
            
            //calling the reverseGeoCode function (step 6)
            self.reverseGeoCode(location!)
            
            //stops tracking the location
            self.locationManager.stopUpdatingLocation()
            
        }
        
    }
    
    //6 find the user location
    func reverseGeoCode(location: CLLocation)
    {
        
        //create new Clgeocoder
        let geoCoder = CLGeocoder()
        
        
        geoCoder.reverseGeocodeLocation(location){ (placemarks:[CLPlacemark]?, error ) in
            
            let placemark = placemarks?.first
            
            //sets address (subthor) and city (locality) text
            let address = "\(placemark!.subThoroughfare!)\(placemark!.locality)"
            self.textView.text = "Found you: \(address)"
            
            //calling the findJail function
            self.findPizzaNearLocation(location)
            
        }
        
    }
    
    
    @IBAction func cc(sender: AnyObject) {
        self.searchQuery = self.searchBar.text!
        self.findPizzaNearLocation(location)
        self.searchBar.resignFirstResponder()
    }
    
    
    //making a search request
//    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//    
//    }
    
    
    //7 remember to import mapkit , this  find the place
    func findPizzaNearLocation(location: CLLocation)
    {
        
        //create a new request
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = self.searchQuery
        request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.5, 0.5))
        
        //run the search based on the request
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler { (response: MKLocalSearchResponse?, error )  in
            
            //response has  2 parts array and boundingregion.Array = mapItems
            let mapItems = response?.mapItems
            
            
            for item in response!.mapItems
            {
                self.pizzaPlaces.append(item)
                
                //getting the distance from the user and adding it 
                self.pizzaDistances.addObject((item.placemark.location?.distanceFromLocation(location))!)
            }
            
            
            print(self.pizzaPlaces)
            self.tableView.reloadData()
            let mapItem = mapItems?.first
            self.textView.text = "Go directly to \(mapItem?.name)"
            self.getDirectionToMapItem(mapItem!)
            
        }
    }
    
    func getDirectionToMapItem(mapItem : MKMapItem)
    {
        
        //builds request
        let request = MKDirectionsRequest()
        request.source = MKMapItem.mapItemForCurrentLocation()
        request.destination = mapItem
        let direction = MKDirections(request: request)
        
        //fires request
        direction.calculateDirectionsWithCompletionHandler { (response: MKDirectionsResponse?, error) in
            
            let routes = response?.routes
            let route = routes?.first
            
            var x = 1
            let directionsString = NSMutableString()
            
            //steps is an array   and we are appending a number to enumerate the steps
            for step:MKRouteStep in route!.steps {
                directionsString.appendString("\(x): \(step.instructions) \n")
                x = x + 1
            }
            
            //show the instructions in steps
            self.textView.text = directionsString as String
        }
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("CellId")! as UITableViewCell
        
        
        if self.pizzaPlaces.count > 0 {
            let pizzaPlace = self.pizzaPlaces[indexPath.row]
            let pizzaDistance = self.pizzaDistances[indexPath.row]

            
            cell.textLabel?.text = pizzaPlace.name
            cell.detailTextLabel!.text = "\(pizzaDistance)"
        }
        
        return cell

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pizzaPlaces.count
    }
    
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "mapButton" {
            
            let destVc = segue.destinationViewController as! MapViewController
            destVc.pizzaPlaces = self.pizzaPlaces
            
            destVc.isButtonSegue = true
    
        } else{
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            
            let pizzaPlace = self.pizzaPlaces[indexPath!.row]
            
            let destVC = segue.destinationViewController as! MapViewController
            
            //passing the dictionary to the next VC
            destVC.pizzaPlace = pizzaPlace
            destVC.isButtonSegue = false
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}

