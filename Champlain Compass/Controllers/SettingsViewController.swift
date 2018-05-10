//
//  SettingsViewController.swift
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
//  Purpose: This file is used to create the SettingsViewController for the Settings Screen of the application. The main purpose of this controller is to provide a settings interface for the applciation to adjust various application settings like the color scheme.

import UIKit

class SettingsViewController: UIViewController {
    
    //create outlet variables for connections to UI
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var titleTextView: UILabel!
    @IBOutlet weak var defaultColorLabel: UILabel!
    @IBOutlet weak var defaultColorSegmentControl: UISegmentedControl!
    @IBOutlet weak var refreshDataButton: UIButton!
    
    //create instance variables
    var compassDataLab: CompassDataLab = CompassDataLab()
    var useOrientationColors: [Bool] = [true, false]
    var groups: [String] = ["Family & Friends", "Residential Students", "Commuter Students"]
    
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
            //then return to the start screen
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "StartViewController") as! StartViewController
            
            self.present(viewController, animated: true)
        }
        
        //current default color for control
        var useOrientationTheme = true
        if UserDefaults.standard.object(forKey: "UseOrientationTheme") != nil {
            useOrientationTheme = UserDefaults.standard.bool(forKey: "UseOrientationTheme")
        }
        defaultColorSegmentControl.selectedSegmentIndex = useOrientationColors.index(of: useOrientationTheme)!
        
        //setup the UI
        setColors()
    }
    
    //function to set the colors for the UI
    func setColors() {
        if let theme = compassDataLab.getPreferedTheme() {
            titleTextView.textColor = UIColor(hex: theme.Theme_Colors.Title)
            titleTextView.shadowColor = UIColor(hex: theme.Theme_Colors.Shadow)
            
            mainView.backgroundColor = UIColor(hex: theme.Theme_Colors.Primary)
            
            defaultColorLabel.textColor = UIColor(hex: theme.Theme_Colors.Text_Secondary)
            defaultColorSegmentControl.backgroundColor = UIColor(hex: theme.Theme_Colors.Text)
            defaultColorSegmentControl.tintColor = UIColor(hex: theme.Theme_Colors.Secondary)
            
            refreshDataButton.setTitleColor(UIColor(hex: theme.Theme_Colors.Text), for: .normal)
            refreshDataButton.backgroundColor = UIColor(hex: theme.Theme_Colors.Secondary)
        }
    }
    
    //create action function for selecting default color
    @IBAction func selectDefaultColor(_ sender: UISegmentedControl){
        //save the new data setting
        UserDefaults.standard.set(useOrientationColors[sender.selectedSegmentIndex], forKey: "UseOrientationTheme")
        
        //reset the UI colors
        setColors()
    }
    
    //createaction function for refreshing data
    @IBAction func refreshData(_ sender: UIButton) {
        //return to start view controller
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "StartViewController") as! StartViewController
        viewController.refreshData = true
        
        self.present(viewController, animated: true)
    }
}
