//
//  RunViewController.swift
//  MC3-Running
//
//  Created by Gun Eight  on 12/10/18.
//  Copyright © 2018 Benny Kurniawan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class RunViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var ref: DatabaseReference!
    var currentCoordinate:CLLocationCoordinate2D?
    var namas = "Benny"
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addRouteButton: UIButton!
    @IBOutlet weak var recenterButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
  
    //make array class
    var users:[RootClass] = []
    var group = String.random()
    var nama: String?
    let tabBarImageActive = ["groupTabBar_Active", "runTabBar_ActiveS", "historyTabBar_Active"]
    let tabBarImageInactive = ["groupTabBar_Inactive","runTabBar_Inactive","historyTabBar_Inactive" ]
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePermission()
        //CustumViewRun()
        // Do any additional setup after loading the view.
    }
    

    func CustumViewRun()  {
        
        addRouteButton.layer.shadowOpacity = 0.1
        addRouteButton.layer.shadowOffset = CGSize.zero
        addRouteButton.layer.shadowRadius = 5
        addRouteButton.layer.cornerRadius = 5
        
        recenterButton.layer.shadowOpacity = 0.1
        recenterButton.layer.shadowOffset = CGSize.zero
        recenterButton.layer.shadowRadius = 5
        recenterButton.layer.cornerRadius = 5
        
        startButton.layer.shadowOpacity = 0.1
        startButton.layer.shadowOffset = CGSize.zero
        startButton.layer.shadowRadius = 5
        
    }
    @IBAction func reCenterMap(_ sender: Any) {
        zoomToLocation(with: currentCoordinate!)
    }
    func configurePermission()
    {
        locationManager.delegate = self
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined
        {
            locationManager.requestAlwaysAuthorization()
        } else if authStatus != .authorizedAlways || authStatus != .authorizedWhenInUse
        {
            beginUpdate(with: locationManager)
        }
        if !CLLocationManager.locationServicesEnabled(){
            return
        }
    }
    func beginUpdate(with locationManager: CLLocationManager)
    {
        mapView.showsUserLocation = true
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
        mapView.setRegion(regionZoom, animated: true)
    }
    func sendLocation(_ locations: CLLocationCoordinate2D)
    {
        //let key = ref.childByAutoId().key
        ref = Database.database().reference().child("positions")
        let location:[String:Any] = [
            "id": "\(namas)",
            "latitude":locations.latitude,
            "longitude":locations.longitude
        ]
        ref.child("\(namas)").setValue(location)
        print("addData")
        
    }
    func getKey()
    {
        var arrayUsers:[RootClass] = []
        Database.database().reference().child("positions").observe(.value) { snapshot in
            guard let value = snapshot.value as? [String:[String:Any]] else {return}
            print(value)
            do{
                for values in value
                {
                    print(values.value)
                    //dictionary = values.value
                    let jsonData = try JSONSerialization.data(withJSONObject: values.value , options: [] )
                    //print("ini jsonData = ", values,"\n")
                    //let dataString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)!
                    //print("ini datastring = ",dataString,"\n")
                    let post = try? JSONDecoder().decode(RootClass.self, from: jsonData)
                    //print(post!)
                    arrayUsers.append(post!)
                }
                self.users = arrayUsers
                for user in self.users
                {
                    print(user)
                }
            }
            catch {}
        }
    }
    func Drawannotation(_ user:[RootClass])  {
        let allAnnotation = self.mapView.annotations
     
        if !allAnnotation.isEmpty
        {
            self.mapView.removeAnnotations(allAnnotation)
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
                self.mapView.addAnnotation(anno);
            }
            
        }
        
    }

}
extension RunViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        mapView.mapType = MKMapType.standard
        //        let location = locations[0]
        //        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        //        let regionRadius: CLLocationDistance = 1000
        //        let coordinateRegion = MKCoordinateRegion(center: myLocation,
        //                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        //        mapView.setRegion(coordinateRegion, animated: true)
        
        guard let lastlocation = locations.first else {return}
        if namas != nil{
            sendLocation(lastlocation.coordinate)
            getKey()
            Drawannotation(users)
        }
        if currentCoordinate == nil
        {
            zoomToLocation(with: lastlocation.coordinate)
        }
        //limit time and distance update
        locationManager.allowDeferredLocationUpdates(untilTraveled: CLLocationDistanceMax, timeout: 20)
        currentCoordinate = lastlocation.coordinate
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "addRoute" {
            if let viewController = segue.destination as? AddRouteViewController {
                if currentCoordinate != nil{
                    viewController.currentLocation = self.currentCoordinate
                }
            }
        }
    }
    
}

extension RunViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //namaTxt.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension RunViewController: MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil;
        }else{
            let pinIdent = "Pin";
            var pinView: MKPinAnnotationView;
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdent) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation;
                pinView = dequeuedView;
            }else{
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdent);
                
            }
            return pinView;
        }
    }
}
