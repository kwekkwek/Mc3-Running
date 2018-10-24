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
    var namas:String = "Benny"
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addRouteButton: UIButton!
    @IBOutlet weak var recenterButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    var mapHelp:MapHelper?
    //make array class
    var users:[RootClass] = []
    var group = String.random()
    var nama: String?
    let tabBarImageActive = ["groupTabBar_Active", "runTabBar_ActiveS", "historyTabBar_Active"]
    let tabBarImageInactive = ["groupTabBar_Inactive","runTabBar_Inactive","historyTabBar_Inactive" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapHelp = MapHelper(with: mapView)
        configurePermission()
        
        //CustumViewRun()
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
        mapHelp!.zoomToLocation(with: currentCoordinate!)
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
            mapHelp?.beginUpdate(with: locationManager)
        }
        if !CLLocationManager.locationServicesEnabled(){
            return
        }
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
            mapHelp?.DrawingAnnotation(Longitude: dataUser.longitude!, latitude: dataUser.latitude!, title: dataUser.id!)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "addRoute" {
            if let viewController = segue.destination as? AddRouteViewController {
                print(currentCoordinate!)
                if currentCoordinate != nil{
                    viewController.currentLocation = self.currentCoordinate
                }
            }
        }
    }
}
extension RunViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastlocation = locations.first else {return}
        if namas != nil{
            //sendLocation(lastlocation.coordinate)
            mapHelp?.sendLocation(lastlocation.coordinate, referensi: "\(namas)")
            getKey()
            Drawannotation(users)
        }
        if currentCoordinate == nil
        {
            mapHelp?.zoomToLocation(with: lastlocation.coordinate)
        }
        //limit time and distance update
        locationManager.allowDeferredLocationUpdates(untilTraveled: CLLocationDistanceMax, timeout: 30)
        currentCoordinate = lastlocation.coordinate
        
    }
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        manager.stopUpdatingLocation()
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
