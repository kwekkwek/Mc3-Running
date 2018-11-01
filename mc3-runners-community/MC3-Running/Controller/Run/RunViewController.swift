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
import FirebaseDatabase
import Foundation

class RunViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var ref: DatabaseReference!
    var currentCoordinate:CLLocationCoordinate2D?
    var namas:String = "Eight"
    var userName:String?
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addRouteButton: UIButton!
    @IBOutlet weak var recenterButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    
    var mapHelp:MapHelper?
    //make array class
    var users:[RootClass] = []
    var group = String.random()
    var nama: String?
    var launch : Bool = true
    
    let tabBarImageActive = ["groupTabBar_Active", "runTabBar_Active", "historyTabBar_Active"]
    let tabBarImageInactive = ["groupTabBar_Inactive","runTabBar_Inactive","historyTabBar_Inactive" ]
    
    //variabels for calculate pace, distance and calorie
    var timer = Timer()
    var secs = 0
    var forTime : String = ""
    var forPace : String = ""
    var forDistance : String = ""
    var forCalorie : String = ""
    var distanceCurrent = Measurement(value: 0, unit: UnitLength.meters)
    var locationList :[CLLocation] = []
    var paceTemp : String = ""
    var dateRun : String = ""
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapHelp = MapHelper(with: mapView)
        configurePermission()
        ReadyRun()
        setTabItem()
        CustomUIGroup()
        guard let groupId = UserDefaults.standard.string(forKey: "groupId") else {return}
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {return}
        userName = UserDefaults.standard.string(forKey: "userName")
        print("ini user name ", userName!)
//        if userName != ""{
//            //sendLocation(lastlocation.coordinate)
//            mapHelp?.sendLocation(currentCoordinate!, referensi: "\(groupId)/groups/member/\(userId)")
//            getKey()
//            Drawannotation(users)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.tabBarController?.tabBar.isHidden = false
        print("Jalankan ini")
    }
    func CustomUIGroup()  {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9098039216, green: 0.9725490196, blue: 0.9960784314, alpha: 1)
        tabBarController?.tabBar.barTintColor = #colorLiteral(red: 0.9098039216, green: 0.9725490196, blue: 0.9960784314, alpha: 1)
    }
    
    func setTabItem() {
        for i in 0 ..< tabBarImageActive.count
        {
            print("Ini item")
            self.tabBarController?.tabBar.items?[i].image = UIImage(named: tabBarImageInactive[i])
            self.tabBarController?.tabBar.items?[i].selectedImage = UIImage(named: tabBarImageActive[i])
            
            print(i)
            
        }
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
    
    
    
    @IBAction func StartRun(_ sender: UIButton) {
        
        print("ini tag awal   = \(sender.tag)")
        
        switch sender.tag {
        case 0:
            self.startButton.setBackgroundImage(UIImage(named: "pauseRun_button"), for : UIControl.State.normal)
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                self.TimerCount()
            }
            updateDisplay()
            sender.tag += 1
            
        case 1:
            StopRun()
            
        default:
            return
        }
    }
    
    @objc func TimerCount() {
        self.secs = self.secs + 1
        updateDisplay()
        
        print("ini second = \(secs)")
    }
    
    func  updateDisplay() {
        forDistance = FormatDisplay.distances(distanceCurrent)
        print("current distance \(distanceCurrent)")
        
        forPace = paceTemp
        forTime = FormatDisplay.time(secs)
        
        DispatchQueue.main.async {
           self.distanceLabel.text = self.forDistance
            self.timeLabel.text = self.forTime
            self.paceLabel.text = self.forPace
            self.calorieLabel.text = self.forCalorie
            self.dateRun = FormatDisplay.date(Date())
            print("the date \(FormatDisplay.date(Date()))")
            print("ini display jarak =\(self.forDistance)")
        }
    }
    
    func ReadyRun() {
        self.timeLabel.text = "0:00:00"
        self.paceLabel.text = "0 min/km"
        self.distanceLabel.text = "0 km"
        self.calorieLabel.text = "0 kcal"
        self.distanceCurrent = Measurement(value: 0, unit: UnitLength.meters)
         paceTemp = FormatDisplay.pace(distance: distanceCurrent, seconds: secs, outputUnit: UnitSpeed.minutesPerKilometer)
        self.startButton.tag = 0
        self.secs =  0
        self.startButton.setBackgroundImage(UIImage(named: "startRun_button"), for : UIControl.State.normal)
        self.startButton.isHidden = false
        self.resumeButton.isHidden = true
        self.endButton.isHidden = true
        locationList.removeAll()

    }
    
    func StopRun() {
        timer.invalidate()
        self.startButton.isHidden = true
        self.resumeButton.isHidden = false
        self.endButton.isHidden = false
//        locationManager.stopUpdatingLocation()
    }
    
    func ResumeAct()  {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerCount), userInfo: nil, repeats: true)
        self.startButton.isHidden = false
        self.resumeButton.isHidden = true
        self.endButton.isHidden = true
        self.startButton.setBackgroundImage(UIImage(named: "stopRun_button"), for : UIControl.State.normal)
        
    }
    
    func SaveRun() {
        
        

            let groupId = UserDefaults.standard.string(forKey: "groupId")
            let userId = UserDefaults.standard.string(forKey: "userId")

            let ref = Database.database().reference().child("runners/\(groupId!)/groups/member/\(userId!)/history")
    
            let member:[String:Any] = [
                "pace": "\(forPace)",
                "distance": "\(forDistance)",
                "calorie": "\(forCalorie)",
                "timeTotal": "\(forTime)",
                "date" : "\(dateRun)"
        ]
            ref.childByAutoId().setValue(member)
            print("addDataSend")
        
        
        
        let totalTime = self.forTime
        let totalDistance = self.forDistance
        let avePace = self.forPace
        let totalCalorie = self.forCalorie
        
        print(totalTime)
         print(totalDistance)
         print(avePace)
         print(totalCalorie)
    }
    func notifyUser()  {
        let alert = UIAlertController(title: "Confirm", message: "Do you want to save your run?", preferredStyle: UIAlertController.Style.alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default){ (_) in
            //record data ke data base
            //clearing value
            self.SaveRun()
            self.ReadyRun()
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
        guard let groupId = UserDefaults.standard.string(forKey: "groupId") else {return}
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {return}
        userName = UserDefaults.standard.string(forKey: "userName")
        print("ini user name ", userName!)
        if userName != ""{
            //sendLocation(lastlocation.coordinate)
            mapHelp?.sendLocation(lastlocation.coordinate, referensi: "\(groupId)/groups/member/\(userId)")
            getKey()
            Drawannotation(users)
        }
        
        if currentCoordinate == nil
        {
            mapHelp?.zoomToLocation(with: lastlocation.coordinate)

        }
        
        //limit time and distance update
        locationManager.allowDeferredLocationUpdates(untilTraveled: 5, timeout: 5 )
        currentCoordinate = lastlocation.coordinate

        
        for newLocation in locations {
//            let howRecent = newLocation.timestamp.timeIntervalSinceNow
//            guard newLocation.horizontalAccuracy < 5 && abs(howRecent) < 5 else { continue }

            if let lastLocation = locationList.last {
                print("Ini last location = \(lastLocation)")
                let delta = newLocation.distance(from: lastLocation)
                distanceCurrent = distanceCurrent + Measurement(value: delta, unit: UnitLength.meters)
                paceTemp = FormatDisplay.pace(distance: distanceCurrent, seconds: secs, outputUnit: UnitSpeed.minutesPerKilometer)
                print("ini lokasi =\( delta)")
                print("ini jarak  update =  \(distanceCurrent)")
                let tempCalorie = distanceCurrent*60/1000
                let forcal = String(format: "%.2f", tempCalorie as CVarArg)
                print("ini kalori \(tempCalorie)")
                DispatchQueue.main.async {
                    self.forPace = self.paceTemp
                    self.forDistance = "\(self.distanceCurrent)"
                    self.forCalorie = forcal
                    print("new distance = \(self.forDistance)")
                }
                
            }
            locationList.append(newLocation)
            print(locationList)
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
