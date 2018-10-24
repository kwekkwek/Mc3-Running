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
    var direction: [CLLocationCoordinate2D] = []
    var mapHelp: MapHelper?
    @IBOutlet weak var currentLoc: UILabel!
    
    @IBOutlet weak var enterPoint: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapHelp = MapHelper(with: mapView)
        setupConfig()
        getLocationName(with: currentLocation!)
        //setupGesture()
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(mapPressed(gestureReconizer:)))
        gesture.delegate = self
        gesture.delaysTouchesBegan = true
        gesture.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(gesture)

    }
    func setupConfig()
    {
        LocationManager.delegate = self
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapHelp?.beginUpdate(with: self.LocationManager)
        mapHelp?.zoomToLocation(with: currentLocation!)
        direction.append(currentLocation!)
    }
    @objc func mapPressed(gestureReconizer: UILongPressGestureRecognizer)
    {
        if gestureReconizer.state != .began{return}
        let touchLocation = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        print(coordinate)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        //annotation.title = coordinate
        //annotation.subtitle = ( "\(place.location!.coordinate)")
        self.direction.append(coordinate)
        self.mapView.addAnnotation(annotation)
        drawMap()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.tabBarController?.tabBar.isHidden = true
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
    func drawMap()
    {
        for directions in direction
        {
        print("ini adalah data direction ", directions)
        }
        let coordinate1 = CLLocation(latitude: direction[0].latitude, longitude: direction[0].longitude)
        let coordinate2 = CLLocation(latitude: direction[1].latitude, longitude: direction[1].longitude)
        let distanceInMeters = coordinate1.distance(from: coordinate2)
        print(distanceInMeters)
        //self.enterPoint.text = "\(Int(distanceInMeters))"
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: direction[0], addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: direction[1], addressDictionary: nil))
        //request.requestsAlternateRoutes = true
        request.transportType = .walking

        let directions = MKDirections(request: request)

        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            print("respon",unwrappedResponse)
            
            for route in unwrappedResponse.routes {
                self.enterPoint.text   = "\(Int(route.distance))"
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
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
