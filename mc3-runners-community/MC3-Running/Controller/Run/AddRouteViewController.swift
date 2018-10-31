//
//  AddRouteViewController.swift
//  MC3-Running
//
//  Created by Gun Eight  on 20/10/18.
//  Copyright © 2018 Benny Kurniawan. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddRouteViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var LocationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D?
    var mapHelp: MapHelper?
    @IBOutlet weak var currentLoc: UILabel!
    @IBOutlet weak var enterPoint: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceKm: UILabel!
    var counter:Int = 0
    var totalDistance: Int = 0
    var searchResults = UISearchController(searchResultsController: nil)
    var direction: [CLLocationCoordinate2D] = []
    
    //@IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapHelp = MapHelper(with: mapView)
        setupConfig()
        //setupGesture()
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(mapPressed(gestureReconizer:)))
        gesture.delegate = self
        gesture.delaysTouchesBegan = true
        gesture.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(gesture)
        
        print("asd",direction.count)
        
    }
    func setupConfig()
    {
        LocationManager.delegate = self
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapHelp?.beginUpdate(with: self.LocationManager)
        mapHelp?.zoomToLocation(with: currentLocation!)
        //direction.append(currentLocation!)
        SetupSearchBar()
        
    }
    
    private func SetupSearchBar()
    {
        //func to setup searchbar
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "SearchLocation") as! TableViewController
        searchResults = UISearchController(searchResultsController: locationSearchTable)
        searchResults.searchResultsUpdater = locationSearchTable
        let searching = searchResults.searchBar
        searching.sizeToFit()
        searching.placeholder = "Search Location"
        
        searchResults.hidesNavigationBarDuringPresentation = false
        searchResults.dimsBackgroundDuringPresentation = true
        searchResults.searchBar.delegate = self
        navigationItem.titleView = searching
        definesPresentationContext = true
        
        // func to sent variable
        
        locationSearchTable.mapView = self.mapView
        locationSearchTable.currentLocation = self.currentLocation
        locationSearchTable.counter = self.counter
        locationSearchTable.direction = self.direction
        locationSearchTable.delegate = self
    }
    @objc func mapPressed(gestureReconizer: UILongPressGestureRecognizer)
    {
        if gestureReconizer.state != .began{return}
        let touchLocation = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        print(coordinate)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = String("checkpoint \(counter+1)")
        //annotation.subtitle = ( "\(place.location!.coordinate)")
        self.direction.append(coordinate)
        self.mapView.addAnnotation(annotation)
        //self.counter = counter + 1
        checkRoute()
    }
    
    @IBAction func drawing(_ sender: Any) {
        drawMultipleRoute()
    }
    
    func drawMultipleRoute()
    {
        totalDistance = 0
        for i in 0 ..< direction.count
        {
            //print(direction.count)
            if i == direction.count-1
            { return }
            else
            {
                //print(direction[i],direction[i+1])
                drawMap(source: direction[i], destination: direction[i+1])
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.tabBarController?.tabBar.isHidden = false
    }
    func getLocationName(with loc: CLLocationCoordinate2D)
    {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: loc.latitude, longitude: loc.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Location name
            if let locationName = placeMark.location {
                print("ini adalah lokasi anda: ",locationName)
                
            }
            if let address = placeMark.addressDictionary
            {
                let katas = address["FormattedAddressLines"] as! [String]
                var add = ""
                for kata in katas
                {
                    add += kata+" "
                }
                self.currentLoc.text = add
            }
        })
    }
    func checkRoute()
    {
        if direction.count >= 2
        {
            //self.saveButton.isHidden = false
        }
    }
    func drawMap(source:CLLocationCoordinate2D, destination:CLLocationCoordinate2D)
    {
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        //request.requestsAlternateRoutes = true
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            print("respon",unwrappedResponse)
            
            for route in unwrappedResponse.routes {
                DispatchQueue.main.async {
                    print("ini adalah route ",Int(route.distance))
                    self.totalDistance += Int(route.distance)
                    self.enterPoint.text = "\(self.totalDistance)"
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
                
            }
        }
    }
}
extension AddRouteViewController: CLLocationManagerDelegate
{
    //getting location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastlocation = locations.first else {return}
        currentLocation = lastlocation.coordinate
    }
}
extension AddRouteViewController: MKMapViewDelegate
{
    //drawing line
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.lightGray
        renderer.lineWidth = 5
        renderer.alpha = 1
        return renderer
    }
    
}
extension AddRouteViewController: UISearchBarDelegate
{
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = nil
        checkRoute()
    }
    
}
extension AddRouteViewController: sentData
{
    func directionUpdated(directions: CLLocationCoordinate2D, counter: Int) {
        
        print("ini adalah sebelum : ",direction.count)
        self.direction.append(directions)
        self.counter = self.counter + counter
        print("ini adalah setelah : ",direction.count)
    }
    
}
