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
import FirebaseDatabase

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
        locationManager.activityType = .fitness
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
        guard let userName = UserDefaults.standard.string(forKey: "userName") else {return}
        ref = Database.database().reference().child("runners")
        print("ini ref loh     \(ref)")
        let location:[String:Any] = [
            "latitude":locations.latitude,
            "longitude":locations.longitude
        ]
        ref.child("\(referensi)/location").setValue(location)
        print("addDataLokasi")
        
    }
    
    func sendGroup(name: String, key: String)
    {
//        let keyG = ref.childByAutoId().key
        ref = Database.database().reference().child("runners")
        let location:[String:Any] = [
            "id": "\(key)",
            "nama": name
        ]
        ref.childByAutoId().child("groups").setValue(location)
        print("addDataSend")
    }
    
    func memberInput(name: String, key: String)
    {
        //let key = ref.childByAutoId().key
        ref = Database.database().reference().child("runners/groups")
        let member:[String:Any] = [
            "idMember": "\(key)",
            "namaMember": name
        ]
        ref.child("member").setValue(member)
        print("addDataSend")
        
    }
    func SetRoute(routes: [CLLocationCoordinate2D])
    {
        var counter = 0
        guard let groupId = UserDefaults.standard.string(forKey: "groupId") else {return}
        ref = Database.database().reference().child("runners/\(groupId)/groups/")
    
        var array2D = [[String]]()
        for route in routes
        {
            array2D.append(["\(route.latitude )","\(route.longitude)"])
        }
        //print("ini adalah array 2d",array2D)
        ref.child("route").setValue(array2D)
        
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
