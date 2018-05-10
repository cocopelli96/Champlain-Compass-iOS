//
//  ViewController.swift
//  Champlain Compass
//
//  Created by Travis Spinelli on 1/26/18.
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
//  Purpose: This file is used to create the StartViewController for the Start Screen of the application. The main purpose of this controller is to introduce the user to the application and retrieve data from the database.

import UIKit
import Firebase
import SDWebImage
import Foundation

class StartViewController: UIViewController {
    
    //create outlet variables for connections to UI
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var clickTextView: UIButton!
    @IBOutlet weak var loadingTextView: UILabel!
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    
    //create instance variables
    let rootRef = Database.database().reference()
    let compassDataLab: CompassDataLab = CompassDataLab()
    var refreshData: Bool = false;

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //authenticate user as an anymous user for Firebase
        Auth.auth().signInAnonymously() { (user, error) in
            if !user!.isAnonymous {
                print("Error: failed to login ")
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //create Firebase references
        let themeRef = rootRef.child("Orientation")
        let eventRef = rootRef.child("Events")
        let questionRef = rootRef.child("Frequently_Asked_Questions")
        let resourceRef = rootRef.child("Resources")
        let presenterRef = rootRef.child("Presenters")
        let buildingRef = rootRef.child("Building")
        
        //if data is cached
        if compassDataLab.isCached() && !refreshData && compassDataLab.retrieveCache() {
            //set colors of the interface and proceed
            setColors()
            setLogo()
        } else {
            //else grab the data from Firebase
            
            /*************************************
            Create connections to the Orientation Theme Data
            *************************************/
            
            themeRef.observe(.childAdded) { (snap: DataSnapshot) in
                //get theme and cache data
                var theme: OrientationTheme = OrientationTheme()
                if let data = snap.value as? NSDictionary {
                    theme = OrientationTheme(data)
                }
                self.compassDataLab.themes[snap.key] = theme
                self.compassDataLab.cache()
                
                //reload logos and colors
                self.setColors()
                self.setLogo()
            }
            
            themeRef.observe(.childChanged) { (snap: DataSnapshot) in
                //get update theme and cache data
                var theme: OrientationTheme = OrientationTheme()
                if let data = snap.value as? NSDictionary {
                    theme = OrientationTheme(data)
                }
                self.compassDataLab.themes[snap.key] = theme
                self.compassDataLab.cache()
                
                //reload logos and colors
                self.setColors()
                self.setLogo()
            }
            
            themeRef.observe(.childRemoved) { (snap: DataSnapshot) in
                //get remove theme and cache data
                self.compassDataLab.themes.removeValue(forKey: snap.key)
                self.compassDataLab.cache()
                
                //reload logos and colors
                self.setColors()
                self.setLogo()
            }
            
            /*************************************
             Create connections to the Event Data
             *************************************/
            
            eventRef.observe(.childAdded) { (snap: DataSnapshot) in
                //get event and cache data
                var event: Event = Event()
                if let data = snap.value as? NSDictionary {
                    event = Event(data)
                }
                self.compassDataLab.events.append(event)
                self.compassDataLab.cache()
            }
            
            eventRef.observe(.childChanged) { (snap: DataSnapshot) in
                //get update event and cache data
                var event: Event = Event()
                if let data = snap.value as? NSDictionary {
                    event = Event(data)
                }
                if let index = self.compassDataLab.events.index(where: { $0 == event }) {
                    self.compassDataLab.events[index] = event
                }
                self.compassDataLab.cache()
            }
            
            eventRef.observe(.childRemoved) { (snap: DataSnapshot) in
                //get remove event and cache data
                var event: Event = Event()
                if let data = snap.value as? NSDictionary {
                    event = Event(data)
                }
                if let index = self.compassDataLab.events.index(where: { $0 == event }) {
                    self.compassDataLab.events.remove(at: index)
                }
                self.compassDataLab.cache()
            }
            
            /*************************************
             Create connections to the Frequently Asked Questions Data
             *************************************/
            
            questionRef.observe(.childAdded) { (snap: DataSnapshot) in
                //get question and cache data
                var question: FrequentlyAskedQuestion = FrequentlyAskedQuestion()
                if let data = snap.value as? NSDictionary {
                    question = FrequentlyAskedQuestion(data)
                }
                self.compassDataLab.questions.append(question)
                self.compassDataLab.cache()
            }
            
            questionRef.observe(.childChanged) { (snap: DataSnapshot) in
                //get update question and cache data
                var question: FrequentlyAskedQuestion = FrequentlyAskedQuestion()
                if let data = snap.value as? NSDictionary {
                    question = FrequentlyAskedQuestion(data)
                }
                if let index = self.compassDataLab.questions.index(where: { $0 == question }) {
                    self.compassDataLab.questions[index] = question
                }
                self.compassDataLab.cache()
            }
            
            questionRef.observe(.childRemoved) { (snap: DataSnapshot) in
                //get remove question and cache data
                var question: FrequentlyAskedQuestion = FrequentlyAskedQuestion()
                if let data = snap.value as? NSDictionary {
                    question = FrequentlyAskedQuestion(data)
                }
                if let index = self.compassDataLab.questions.index(where: { $0 == question }) {
                    self.compassDataLab.questions.remove(at: index)
                }
                self.compassDataLab.cache()
            }
            
            /*************************************
             Create connections to the Resource Data
             *************************************/
            
            resourceRef.observe(.childAdded) { (snap: DataSnapshot) in
                //get resource and cache data
                var resource: OrientationResource = OrientationResource()
                if let data = snap.value as? NSDictionary {
                    resource = OrientationResource(data)
                }
                self.compassDataLab.resources.append(resource)
                self.compassDataLab.cache()
            }
            
            resourceRef.observe(.childChanged) { (snap: DataSnapshot) in
                //update resource and cache data
                var resource: OrientationResource = OrientationResource()
                if let data = snap.value as? NSDictionary {
                    resource = OrientationResource(data)
                }
                if let index = self.compassDataLab.resources.index(where: { $0 == resource }) {
                    self.compassDataLab.resources[index] = resource
                }
                self.compassDataLab.cache()
            }
            
            resourceRef.observe(.childRemoved) { (snap: DataSnapshot) in
                //remove resource and cache data
                var resource: OrientationResource = OrientationResource()
                if let data = snap.value as? NSDictionary {
                    resource = OrientationResource(data)
                }
                if let index = self.compassDataLab.resources.index(where: { $0 == resource }) {
                    self.compassDataLab.resources.remove(at: index)
                }
                self.compassDataLab.cache()
            }
            
            /*************************************
             Create connections to the Presenter Data
             *************************************/
            
            presenterRef.observe(.childAdded) { (snap: DataSnapshot) in
                //get presenter and cache data
                var presenter: Presenter = Presenter()
                if let data = snap.value as? NSDictionary {
                    presenter = Presenter(data)
                }
                self.compassDataLab.presenters.append(presenter)
                self.compassDataLab.cache()
            }
            
            presenterRef.observe(.childChanged) { (snap: DataSnapshot) in
                //update presenter and cache data
                var presenter: Presenter = Presenter()
                if let data = snap.value as? NSDictionary {
                    presenter = Presenter(data)
                }
                if let index = self.compassDataLab.presenters.index(where: { $0 == presenter }) {
                    self.compassDataLab.presenters[index] = presenter
                }
                self.compassDataLab.cache()
            }
            
            presenterRef.observe(.childRemoved) { (snap: DataSnapshot) in
                //remove presenter and cache data
                var presenter: Presenter = Presenter()
                if let data = snap.value as? NSDictionary {
                    presenter = Presenter(data)
                }
                if let index = self.compassDataLab.presenters.index(where: { $0 == presenter }) {
                    self.compassDataLab.presenters.remove(at: index)
                }
                self.compassDataLab.cache()
            }
            
            /*************************************
             Create connections to the Building Data
             *************************************/
            
            buildingRef.observe(.childAdded) { (snap: DataSnapshot) in
                //get building and cache data
                var building: Building = Building()
                if let data = snap.value as? NSDictionary {
                    building = Building(data)
                }
                self.compassDataLab.buildings.append(building)
                self.compassDataLab.cache()
            }
            
            buildingRef.observe(.childChanged) { (snap: DataSnapshot) in
                //update building and cache data
                var building: Building = Building()
                if let data = snap.value as? NSDictionary {
                    building = Building(data)
                }
                if let index = self.compassDataLab.buildings.index(where: { $0 == building }) {
                    self.compassDataLab.buildings[index] = building
                }
                self.compassDataLab.cache()
            }
            
            buildingRef.observe(.childRemoved) { (snap: DataSnapshot) in
                //remove building and cache data
                var building: Building = Building()
                if let data = snap.value as? NSDictionary {
                    building = Building(data)
                }
                if let index = self.compassDataLab.buildings.index(where: { $0 == building }) {
                    self.compassDataLab.buildings.remove(at: index)
                }
                self.compassDataLab.cache()
            }
            
            //set inital app state
            clickTextView.isHidden = true
        }
    }
    
    //function to set colors of the UI
    func setColors() {
        if let theme = compassDataLab.getPreferedTheme() {
            clickTextView.setTitleColor(UIColor(hex: theme.Theme_Colors.Text_Click), for: .normal)
            clickTextView.setTitleShadowColor(UIColor(hex: theme.Theme_Colors.Shadow), for: .normal)
        }
    }
    
    //function to set logo on the screen
    func setLogo() {
        if let theme = compassDataLab.getPreferedTheme() {
            //get the reference to the logo image
            let storageRef = Storage.storage().reference()
            let fileRef = storageRef.child(theme.Logo.File_Name)
            let placeholderImage = UIImage(named: "champlain_logo.png")
            
            //load the image into the UI
            fileRef.downloadURL { (url: URL?, error: Error?) in
                if let e = error {
                    print("Error: \(e)")
                } else {
                    self.logoImage.sd_setImage(with: url, placeholderImage: placeholderImage)
                }
            }
            
            //change visible state of labels
            loadingTextView.isHidden = true
            loadingIcon.isHidden = true
            clickTextView.isHidden = false
        }
    }
    
    //create action function for when the screen is tapped
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        //move to the next controller
        performSegue(withIdentifier: "groupSelectionSegue", sender: self)
    }
}

