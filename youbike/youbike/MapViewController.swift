//
//  MapViewController.swift
//  youbike
//
//  Created by Ian on 4/26/16.
//  Copyright © 2016 AppWorks School Ian Cheng. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var stationView: UIView!
    
    let locationManager = CLLocationManager()
    
    var isShowStationCell: Bool = false
    var station: Station = Station()
    let cell: StationCell = UINib(nibName: StationCell.identifier, bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! StationCell
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initNavigationBar()
        
        initMap()
        
        appendStationCell()
        
        resizeComponents()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initNavigationBar() {
        
        //        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController!.navigationBar.barTintColor = UIColor.ybkCharcoalGreyColor()
        self.navigationController!.navigationBar.tintColor = UIColor.ybkPaleGoldColor()
        self.navigationController!.navigationBar.topItem?.title = "YouBike"
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.ybkPaleGoldColor(), NSFontAttributeName: UIFont.ybkTextStyle2Font(17)!]
        self.title = "\(self.station.title)"
        
    }
    
    func appendStationCell() {
        
        if self.isShowStationCell == true {
            
            cell.title.text = self.station.title
            cell.address.text = self.station.address
            cell.remainingBikes.attributedText = StationCell.getRemainingBike(self.station.remainingBikes)
            self.stationView.addSubview(cell)
            
        }
    }
    
    func initMap() {

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.myMapView.delegate = self
        self.myMapView.showsUserLocation = true
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let userLocation = locations.last {
            
            let centerLocation = CLLocationCoordinate2D(
                latitude: (userLocation.coordinate.latitude + self.station.latitude) / 2,
                longitude: (userLocation.coordinate.longitude + self.station.longitude) / 2
            )
            
            locateToMap(centerLocation)
            
            let stationLocation = CLLocationCoordinate2D(latitude: self.station.latitude, longitude: self.station.longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = stationLocation
            annotation.title = self.station.title
            annotation.subtitle = self.station.address
            
            self.myMapView.addAnnotation(annotation)
            
            self.locationManager.stopUpdatingLocation()
            
            requestDirections(stationLocation)
        }
        
    }
    
    
    func requestDirections(destination: CLLocationCoordinate2D) {
        
        let req = MKDirectionsRequest()
        req.source = MKMapItem.mapItemForCurrentLocation()
        req.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        req.transportType = .Automobile
        let dir = MKDirections(request: req)
        dir.calculateDirectionsWithCompletionHandler() {
            (response: MKDirectionsResponse?, error: NSError?) in
            guard let response = response else { print(error); return }
            let route = response.routes[0]
            for step in route.steps {
                print(step.instructions)
            }
        }
    }
    
    func locateToMap(location: CLLocationCoordinate2D) {
        
        let span = MKCoordinateSpanMake(0.07, 0.07)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.myMapView.setRegion(region, animated: true)
        
    }
    
    func resizeComponents() {
        resizeStationCell(CGSize(width: self.view.bounds.width, height: 122.0))
    }
    
    func resizeStationCell(size: CGSize) {
        cell.frame = CGRectMake(0, 0, size.width, size.height)
    }
    
    func setStationInfo(station: Station, isShowStationCell: Bool = false) {
        self.isShowStationCell = isShowStationCell
        self.station = station
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        resizeStationCell(CGSize(width: size.width, height: 122.0))
        
    }
    
}