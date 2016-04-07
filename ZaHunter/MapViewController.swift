//
//  MapViewController.swift
//  ZaHunter
//
//  Created by James Rochabrun on 06-04-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {
        
    @IBOutlet weak var mapView: MKMapView!
    
    var pizzaPlace = MKMapItem()
    
    var isButtonSegue = true
    
    var pizzaPlaces = [MKMapItem]()
    
    let pizzaAnotation = MKPointAnnotation()
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.showsUserLocation = true
        
        print(pizzaPlaces)
        
        
        //toggle between segues
        
        //toggle to execute each VC
        if self.isButtonSegue == true {
            self.createAnotation()
        }else {
            self.createSingleAnotation()
        }

        
        //calling the annotation function
        self.createAnotation()
        
        //zoom in Ali
//        let region = MKCoordinateRegionMake(CLLocationCoordinate2D(latitude:  37.791418, longitude:  -122.402516), MKCoordinateSpanMake(0.025, 0.025))
//        self.mapView.setRegion(region, animated: false)
        
        self.zoomToRegion()
        
        //setting the delegate programatically
        self.mapView.delegate = self
        
        }
    
    
    //MARK:- Zoom to region
    
    func zoomToRegion() {
        
        let location = CLLocationCoordinate2D(latitude: 37.791418, longitude:  -122.402516)
        
        let region = MKCoordinateRegionMakeWithDistance(location, 5000.0, 7000.0)
        
        self.mapView.setRegion(region, animated: true)
        
    }
    
    @IBAction func dismissButton(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    
    func createAnotation()
    {
        
        //this is what we need for the pins to show
        for pizzaPlace in self.pizzaPlaces
        {
            
            let annotation = MKPointAnnotation()
            let latitude = pizzaPlace.placemark.coordinate.latitude
            let longitude = pizzaPlace.placemark.coordinate.longitude
            annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            self.mapView.addAnnotation(annotation)
        }
    }

    
    func createSingleAnotation()
    {
        
        let annotation = MKPointAnnotation()
        let latitude = self.pizzaPlace.placemark.coordinate.latitude
        let longitude = self.pizzaPlace.placemark.coordinate.longitude
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.mapView.addAnnotation(annotation)
        
    }
    

    
    
  
   
    
    
    
    
}













