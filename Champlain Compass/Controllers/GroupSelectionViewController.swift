//
//  GroupSelectionViewController.swift
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
//  Purpose: This file is used to create the GroupSelectionViewController for the Group Selection Screen of the application. The main purpose of this controller is to provide the user group options to the user and have them select one to continue.

import UIKit

class GroupSelectionViewController: UIViewController {
    
    //create outlet variables for connections to UI
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var titleTextView: UILabel!
    @IBOutlet weak var familyGroupButton: UIButton!
    @IBOutlet weak var residentialStudentGroupButton: UIButton!
    @IBOutlet weak var commuterStudentGroupButton: UIButton!
    
    //create instance variables
    let compassDataLab: CompassDataLab = CompassDataLab()
    
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
            //go back to the start screen
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "StartViewController") as! StartViewController
            
            self.present(viewController, animated: true)
        }
        
        //setup UI
        setColors()
        setButtonIcons()
    }
    
    //function to set the text of the UI buttons
    func setButtonIcons() {
        familyGroupButton.setTitle("\u{f0c0} Family & Friends", for: .normal)
        residentialStudentGroupButton.setTitle("\u{f015} Residential Students", for: .normal)
        commuterStudentGroupButton.setTitle("\u{f1b9} Commuter Students", for: .normal)
    }
    
    //function to set the colors of the UI
    func setColors() {
        if let theme = compassDataLab.getPreferedTheme() {
            titleTextView.textColor = UIColor(hex: theme.Theme_Colors.Title)
            titleTextView.shadowColor = UIColor(hex: theme.Theme_Colors.Shadow)
            titleTextView.text = theme.Theme_Name
            
            mainView.backgroundColor = UIColor(hex: theme.Theme_Colors.Primary)
            
            familyGroupButton.backgroundColor = UIColor(hex: theme.Theme_Colors.Secondary)
            familyGroupButton.setTitleColor(UIColor(hex: theme.Theme_Colors.Text), for: .normal)
            residentialStudentGroupButton.backgroundColor = UIColor(hex: theme.Theme_Colors.Secondary)
            residentialStudentGroupButton.setTitleColor(UIColor(hex: theme.Theme_Colors.Text), for: .normal)
            commuterStudentGroupButton.backgroundColor = UIColor(hex: theme.Theme_Colors.Secondary)
            commuterStudentGroupButton.setTitleColor(UIColor(hex: theme.Theme_Colors.Text), for: .normal)
        }
    }
    
    //prepare for next controller by setting the group name
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "familyGroupSegue" {
            if let avc = segue.destination as? AreaSelectionViewController {
                avc.groupName = "Family & Friends"
            }
        } else if segue.identifier == "residentialGroupSegue" {
            if let avc = segue.destination as? AreaSelectionViewController {
                avc.groupName = "Residential Students"
            }
        } else if segue.identifier == "commuterGroupSegue" {
            if let avc = segue.destination as? AreaSelectionViewController {
                avc.groupName = "Commuter Students"
            }
        }
    }
}
