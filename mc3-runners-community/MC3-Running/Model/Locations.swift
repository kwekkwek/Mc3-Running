//
//  Locations.swift
//  MC3-Running
//
//  Created by Benny Kurniawan on 24/10/18.
//  Copyright © 2018 Benny Kurniawan. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase
import MapKit

class MapHelper {
    var map:MKMapView?
    var ref: DatabaseReference!
    let locationManager = CLLocationManager()
    init(with map:MKMapView) {
        self.map = map
    }
    init()
    {
        self.map = nil
    }
    func beginUpdate(with locationManager: CLLocationManager)
    {
        self.map?.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        //locationManager.activityType = .fitness
    }
    func zoomToLocation(with coordinate:CLLocationCoordinate2D)
    {
        let dist = 1000
        let regionZoom = MKCoordinateRegion(center: coordinate, latitudinalMeters: CLLocationDistance(dist), longitudinalMeters: CLLocationDistance(dist))
        self.map?.setRegion(regionZoom, animated: true)
    }
    
    func sendLocation(_ locations: CLLocationCoordinate2D,referensi:String)
    {
        //let key = ref.childByAutoId().key
        ref = Database.database().reference().child("positions")
        let location:[String:Any] = [
            "id": "\(referensi)",
            "latitude":locations.latitude,
            "longitude":locations.longitude
        ]
        ref.child("\(referensi)").setValue(location)
        print("addData")
        
    }
    
    func sendGroup(name: String, key: String)
    {
        //let key = ref.childByAutoId().key
        ref = Database.database().reference().child("runners")
        let location:[String:Any] = [
            "id": "\(key)",
            "nama": name
        ]
        ref.childByAutoId().child("groups").setValue(location)
        print("addData")
        
    }
    
    func Drawannotation(_ user:[RootClass])  {
        let allAnnotation = self.map?.annotations
        
        if !allAnnotation!.isEmpty
        {
            self.map?.removeAnnotations(allAnnotation!)
        }
        for dataUser in user {
            
            let long = CLLocationDegrees(exactly: dataUser.longitude!)
            print(long!)
            let lat = CLLocationDegrees(exactly: dataUser.latitude!)
            print(lat!)
            let CLLCoordType = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            let anno = MKPointAnnotation();
            DispatchQueue.main.async {
                anno.title = dataUser.id
                anno.coordinate = CLLCoordType;
                self.map?.addAnnotation(anno);
            }
            
        }
        
    }
    func DrawingAnnotation(Longitude: Float ,latitude:Float, title: String)
    {
        let long = CLLocationDegrees(Longitude)
        //print(long!)
        let lat = CLLocationDegrees(latitude)
        //print(lat!)
        let CLLCoordType = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let anno = MKPointAnnotation();
        DispatchQueue.main.async {
            anno.title = title
            anno.coordinate = CLLCoordType;
            self.map?.addAnnotation(anno);
        }
    }
}
