//
//  TableViewController.swift
//  MC3-Running
//
//  Created by Benny Kurniawan on 29/10/18.
//  Copyright © 2018 Benny Kurniawan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol sentData{
    func directionUpdated(directions: CLLocationCoordinate2D , counter:Int)
}
class TableViewController: UITableViewController {
    
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    var currentLocation:CLLocationCoordinate2D?
    var localTimeZoneName: TimeZone { return TimeZone.current }
    var mapHelp:MapHelper?
    var counter:Int?
    var direction: [CLLocationCoordinate2D]?
    var delegate:sentData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ini adalah counter : ",counter)
        print("directions : ", direction?.count)
        mapHelp = MapHelper(with: mapView!)

    }
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return matchingItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pinAnnotation = matchingItems[indexPath.row].placemark
        print("this is pin = ",pinAnnotation)
//        let rootMapVC = storyboard!.instantiateViewController(withIdentifier: "addRouteVC") as! AddRouteViewController
        counter = counter! + 1
        direction?.append(pinAnnotation.coordinate)
//        self.directionUpdated(pinAnnotation)
        print(direction?.count)
        mapHelp?.DrawingAnnotation(Longitude: Float(pinAnnotation.coordinate.longitude), latitude: Float(pinAnnotation.coordinate.latitude), title: pinAnnotation.name!)

        mapHelp?.zoomToLocation(with: pinAnnotation.coordinate)
        print("ini jalan ngk?")
        self.dismiss(animated: true){
            guard let delegate = self.delegate else { print("Jalan ga nih");return}
            delegate.directionUpdated(directions: pinAnnotation.coordinate, counter: self.counter!)
            print("ini jalan ngk?")
        }
    }
}
extension TableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {

        if (searchController.searchBar.text?.count)! >= 3
        {
            matchingItems = []
            guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
            //print(searchBarText)
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = searchBarText
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start { response, Error in
                guard let responses = response else { return }
                //print(responses)
                for data in responses.mapItems
                {
                    if data.timeZone == self.localTimeZoneName
                    {
                        self.matchingItems.append(data)
                    }
                }
                //self.matchingItems = responses.mapItems
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }
    }
}
