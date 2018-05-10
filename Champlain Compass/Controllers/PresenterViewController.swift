//
//  PresenterViewController.swift
//  Champlain Compass
//
//  Created by Travis Spinelli on 2/26/18.
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
//  Purpose: This file is used to create the PresenterViewController for the Presenter Details Screen of the application. The main purpose of this controller is to provide information on the presenter for an event for the user to view.

import UIKit

class PresenterViewController: UIViewController {

    //create outlet variables for connections to UI
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var titleTextView: UILabel!
    @IBOutlet weak var jobTitleTextView: UILabel!
    @IBOutlet weak var bioTextView: UILabel!
    
    //create instance variables
    var compassDataLab: CompassDataLab = CompassDataLab()
    var presenter: Presenter = Presenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //if data not cached
        if !compassDataLab.isCached() || !compassDataLab.retrieveCache() {
            //then return to start screen
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "StartViewController") as! StartViewController
            
            self.present(viewController, animated: true)
        }
        
        //set initial text of views
        titleTextView.text = presenter.Name
        jobTitleTextView.text = presenter.Job_Title
        bioTextView.text = presenter.Bio
        
        //setup the UI
        setColors()
    }
    
    //function to set colors of the UI
    func setColors() {
        if let theme = compassDataLab.getPreferedTheme() {
            titleTextView.textColor = UIColor(hex: theme.Theme_Colors.Title)
            titleTextView.shadowColor = UIColor(hex: theme.Theme_Colors.Shadow)
            
            mainView.backgroundColor = UIColor(hex: theme.Theme_Colors.Primary)
            
            jobTitleTextView.textColor = UIColor(hex: theme.Theme_Colors.Text_Secondary)
            bioTextView.textColor = UIColor(hex: theme.Theme_Colors.Text_Secondary)
        }
    }
}
