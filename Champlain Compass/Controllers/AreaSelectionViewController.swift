//
//  AreaSelectionViewController.swift
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
//  Purpose: This file is used to create the AreaSelectionViewController for the Area Selection Screen of the application. The main purpose of this controller is to provide the options for the feature sof the application and allow the user to select them to proceed.

import UIKit

class AreaSelectionViewController: UIViewController {
    
    //create outlet variables for connections to UI
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var titleTextView: UILabel!
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var resourcesButton: UIButton!
    @IBOutlet weak var campusMapButton: UIButton!
    
    //create instance variables
    var compassDataLab: CompassDataLab = CompassDataLab()
    var groupName: String = "Residential Students"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //if data is not cached
        if !compassDataLab.isCached() || !compassDataLab.retrieveCache() {
            //then return to start screen
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "StartViewController") as! StartViewController
            
            self.present(viewController, animated: true)
        }
        
        //setup the UI
        setColors()
        setButtonIcons()
        
        //if the group is Family & Friends hide the resource button
        if groupName == "Family & Friends" {
            resourcesButton.isHidden = true
        }
    }
    
    //function to set the text of the buttons
    func setButtonIcons() {
        scheduleButton.setTitle("\u{f073} Schedule", for: .normal)
        resourcesButton.setTitle("\u{f15b} Resources", for: .normal)
        campusMapButton.setTitle("\u{f14e} Campus Map", for: .normal)
    }
    
    //function to set the colors of the UI
    func setColors() {
        if let theme = compassDataLab.getPreferedTheme() {
            titleTextView.textColor = UIColor(hex: theme.Theme_Colors.Title)
            titleTextView.shadowColor = UIColor(hex: theme.Theme_Colors.Shadow)
            titleTextView.text = groupName
            
            mainView.backgroundColor = UIColor(hex: theme.Theme_Colors.Primary)
            
            scheduleButton.backgroundColor = UIColor(hex: theme.Theme_Colors.Secondary)
            scheduleButton.setTitleColor(UIColor(hex: theme.Theme_Colors.Text), for: .normal)
            resourcesButton.backgroundColor = UIColor(hex: theme.Theme_Colors.Secondary)
            resourcesButton.setTitleColor(UIColor(hex: theme.Theme_Colors.Text), for: .normal)
            campusMapButton.backgroundColor = UIColor(hex: theme.Theme_Colors.Secondary)
            campusMapButton.setTitleColor(UIColor(hex: theme.Theme_Colors.Text), for: .normal)
        }
    }
    
    //prepare for next controller by setting group name
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scheduleSegue" {
            if let avc = segue.destination as? ScheduleViewController {
                avc.groupName = groupName
            }
        }
    }
}
