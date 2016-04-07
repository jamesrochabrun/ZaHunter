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
    
    var pizzaPlaces = [MKMapItem]()
    
    let pizzaAnotation = MKPointAnnotation()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.showsUserLocation = true
        
        print(pizzaPlaces)

        
        //calling the annotation function
        self.createAnotation()
        
        //zoom in
        let region = MKCoordinateRegionMake(CLLocationCoordinate2D(latitude:  37.791418, longitude:  -122.402516), MKCoordinateSpanMake(0.025, 0.025))
        self.mapView.setRegion(region, animated: false)
        

        
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
    
   
    
    
    
    
}













