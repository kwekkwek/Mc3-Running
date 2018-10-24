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
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    var mapHelp:MapHelper?
    //make array class
    var users:[RootClass] = []
    var group = String.random()
    var nama: String?
    var timer = Timer()
    var secs = 0
    var times : String = ""
    
    let tabBarImageActive = ["groupTabBar_Active", "runTabBar_ActiveS", "historyTabBar_Active"]
    let tabBarImageInactive = ["groupTabBar_Inactive","runTabBar_Inactive","historyTabBar_Inactive" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapHelp = MapHelper(with: mapView)
        configurePermission()
        ReadyRun()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func StartRun(_ sender: UIButton) {
        
        if sender.tag >  1 { sender.tag = 0}
        print("ini tag awal   = \(sender.tag)")
        
        switch sender.tag {
        case 0:
            self.startButton.setBackgroundImage(UIImage(named: "pauseRun_button"), for : UIControl.State.normal)
           self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TimerCount), userInfo: nil, repeats: true)
            TimerCount()
            sender.tag += 1
            
        case 1:
            StopRun()
            
        default:
            return
        }
    }
    
//    @objc func UpdateTimer()  {
//        self.counter = counter + 0.1
//        self.timeLabel.text = String(format: "%.0f", counter)
//    }
  
//   @objc func StartTimer() {
//
//        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TimerDiscount), userInfo: nil, repeats: true)
//    }
    
    @objc func TimerCount() {
        self.secs = self.secs + 1
        let hours = self.secs / 3600
        let mins = self.secs / 60 % 60
        let secs = self.secs % 60
         self.times = ((hours<10) ? "0" : "") + String(hours) + " : " + ((mins<10) ? "0" : "") + String(mins) + " : " + ((secs<10) ? "0" : "") + String(secs)
        timeLabel.text = times
        
        print("ini second = \(secs)")
    }
    func ReadyRun() {
        self.timeLabel.text = "00:00:00"
        self.startButton.tag = 0
        self.secs =  0
        self.startButton.setBackgroundImage(UIImage(named: "startRun_button"), for : UIControl.State.normal)
        self.startButton.isHidden = false
        self.resumeButton.isHidden = true
        self.endButton.isHidden = true
        
    }
    
    func StopRun() {
        timer.invalidate()
        self.startButton.isHidden = true
        self.resumeButton.isHidden = false
        self.endButton.isHidden = false
    }
    
    func ResumeAct()  {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerCount), userInfo: nil, repeats: true)
        self.startButton.isHidden = false
        self.resumeButton.isHidden = true
        self.endButton.isHidden = true
        self.startButton.setBackgroundImage(UIImage(named: "pauseRun_button"), for : UIControl.State.normal)
    }
    
    func notifyUser()  {
        let alert = UIAlertController(title: "Confirm", message: "Do you want to end your run?", preferredStyle: UIAlertController.Style.alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default){ (_) in
            //record data ke data base
            //clearing value
        }
        
        let noAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel){(_) in
            self.ReadyRun()
            
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func ResumeRun(_ sender: UIButton) {
        ResumeAct()
    }
    
    @IBAction func EndRun(_ sender: UIButton) {
        notifyUser()
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
