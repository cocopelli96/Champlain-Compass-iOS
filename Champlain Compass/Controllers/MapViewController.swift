//
//  MapViewController.swift
//  Champlain Compass
//
//  Created by Travis Spinelli on 2/16/18.
//  Copyright © 2018 Travis Spinelli
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//  Purpose: This file is used to create the MapViewController for the Map Screen of the application. The main purpose of this controller is to provide a map interface to view the locations of buildings around campus. A list of currently active buildings is provide below the map and selecting one drops a marker on the map. Selecting the marker provide more information on the building in an information window which if clicked will open the user's map application to provide walking directions to that building.

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UITableViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    //create outlet variables for connections to UI
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var titleTextView: UILabel!
    @IBOutlet weak var listTitleTextView: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    //create instance variables
    var compassDataLab: CompassDataLab = CompassDataLab()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var markerList: [GMSMarker] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create initial styles for the table view
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        tableView.rowHeight = UITableViewAutomaticDimension //allow rows to auto resize height
        tableView.estimatedRowHeight = 60 //set initial height
        
        //initialize location services
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        placesClient = GMSPlacesClient.shared()
        
        //create the Google Map
        let camera = GMSCameraPosition.camera(withLatitude: 44.4731, longitude: -73.2041, zoom: 17.0)
        mapView.camera = camera
        mapView.delegate = self
        mapView.isBuildingsEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.rotateGestures = true
        mapView.settings.tiltGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.scrollGestures = true
        mapView.settings.allowScrollGesturesDuringRotateOrZoom = true
        mapView.animate(to: camera)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //if data not cached
        if !compassDataLab.isCached() || !compassDataLab.retrieveCache() {
            //then return to the start screen
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "StartViewController") as! StartViewController
            
            self.present(viewController, animated: true)
        }
        
        //setup the UI
        setColors()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //reload data if view is disappearing
        tableView.reloadData()
    }
    
    //function to set colors of the UI
    func setColors() {
        if let theme = compassDataLab.getPreferedTheme() {
            titleTextView.textColor = UIColor(hex: theme.Theme_Colors.Title)
            titleTextView.shadowColor = UIColor(hex: theme.Theme_Colors.Shadow)
            
            listTitleTextView.textColor = UIColor(hex: theme.Theme_Colors.Title)
            listTitleTextView.shadowColor = UIColor(hex: theme.Theme_Colors.Shadow)
            
            mainView.backgroundColor = UIColor(hex: theme.Theme_Colors.Primary)
        }
    }
    
    /****************************************
     Table Functions
     ****************************************/
    
    //function to set the number of rows in the section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return compassDataLab.getActiveBuildings().count
    }
    
    //function to set the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "buildingCell", for: indexPath) as! BuildingCell
        
        //get building data
        let building = compassDataLab.getActiveBuildings()[indexPath.row]
        
        //set text of the cell
        cell.title?.text = building.Name
        cell.detail?.text = "\u{f041}"
        
        //set the cell color
        if let theme = compassDataLab.getPreferedTheme() {
            cell.title?.textColor = UIColor(hex: theme.Theme_Colors.Text)
            cell.detail?.textColor = UIColor(hex: theme.Theme_Colors.Text)
            cell.backgroundColor = UIColor(hex: theme.Theme_Colors.Secondary)
        }
        
        //return cell
        return cell
    }
    
    //function to run when row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //get building
        let building = compassDataLab.getActiveBuildings()[indexPath.row]
        
        //get address location
        addressToLocation(building.Address, forBuilding: building)
    }
    
    /****************************************
     Map Functions
     ****************************************/
    
    //function to setup location manager
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //check for authorization
        guard status == .authorizedWhenInUse else {
            return
        }
        
        //enable location features
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    //function to get building address location
    func addressToLocation(_ address: String, forBuilding building: Building) {
        //create URL to query for location based on building address
        var components = URLComponents(string: "https://maps.googleapis.com/maps/api/geocode/json")!
        let key = URLQueryItem(name: "key", value: "AIzaSyBTur2TOKS242whBrpbXFDw_Gd3bwcuz4Q")
        let address = URLQueryItem(name: "address", value: address.replacingOccurrences(of: " ", with: "+"))
        components.queryItems = [key, address]
        print(components)
        
        //get the location from the URL
        let task = URLSession.shared.dataTask(with: components.url!) { data, response, error in
            //if the was a bad HTTP Response print errors
            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, error == nil else {
                print("Response: \(String(describing: response))")
                print("Error: \(String(describing: error))")
                return
            }
            
            //if the response was not JSON print errors
            guard let json = try! JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("Data was not the expected JSON format. Instead used format: \(String(data: data, encoding: .utf8) ?? "Not string?!?")")
                return
            }
            
            //if the results do not include an OK status code print errors
            guard let results = json["results"] as? [[String: Any]],
                let status = json["status"] as? String,
                status == "OK" else {
                    print("No results found, instead recieved: \(String(describing: json))")
                    return
            }
            
            //use location data
            DispatchQueue.main.async {
                //get the longitude and latitude
                let strings = results.compactMap { $0["geometry"] as? [String: Any] }
                if let location = strings[0]["location"] as? [String: Any] {
                    if let lat = location["lat"] as? Double, let lng = location["lng"] as? Double {
                        //create a map marker for the building location
                        self.makeMapMarker(longitude: lng, latitude: lat, forBuilding: building)
                    }
                }
            }
        }
        
        //resume task
        task.resume()
    }
    
    //function to create map marker
    func makeMapMarker(longitude: Double, latitude: Double, forBuilding building: Building) {
        //make map marker and set initial data
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = building.Name
        marker.snippet = building.Address
        
        //if the marker doesn't exist already add it to the map
        if !markerList.contains(marker) {
            marker.map = mapView
            markerList.append(marker)
        }
        
        //center map on new marker
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 17)
        mapView.animate(to: camera)
    }
    
    //function to run when information window is tapped
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        //create variables
        var url: String
        var mapUrl: String
        
        //grab latitude and longitude of the marker
        let lat = marker.position.latitude
        let lng = marker.position.longitude
        
        //grab the current location if possible and set URLs
        if let currentLat: Double = locationManager.location?.coordinate.latitude, let currentLng: Double = locationManager.location?.coordinate.longitude {
            url = "comgooglemaps://?center=\(currentLat),\(currentLng)&zoom=17&directionsmode=walking&saddr=\(currentLat),\(currentLng)&daddr=\(lat),\(lng)"
            mapUrl = "http://maps.apple.com/?dirflg=w&saddr=\(currentLat),\(currentLng)&daddr=\(lat),\(lng)"
        } else {
            url = "comgooglemaps://?center=\(lat),\(lng)&zoom=17&directionsmode=walking&daddr=\(lat),\(lng)"
            mapUrl = "http://maps.apple.com/?dirflg=w&daddr=\(lat),\(lng)"
        }
        
        //if can use google map app
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            //open the app using url
            UIApplication.shared.open(URL(string: url)!, options: [:])
        } else {
            //otherwise open default map app
            print("Can't use comgooglemaps://");
            UIApplication.shared.open(URL(string: mapUrl)!, options: [:])
        }
    }
    
    //function to set the contents of the information window
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        //try to grab the information window class
        if let infoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)![0] as? CustomInfoWindow {
            //set text of the information window
            infoWindow.titleLabel.text = marker.title
            infoWindow.subtitleLabel.text = marker.snippet
            infoWindow.directionsButton.setTitle("Directions \u{f054}", for: .normal)
            
            //set the view size for the informaiton window
            let windowView = UIView(frame: CGRect.init(x: 0, y: 0, width: infoWindow.frame.width, height: infoWindow.frame.height))
            windowView.addSubview(infoWindow)
            
            //return the informaiton window
            return windowView
        }
        //otherwise return nil
        return nil
    }
}
