//
//  QuestionsViewController.swift
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
//  Purpose: This file is used to create the QuestionsViewController for the Questions List Screen of the application. The main purpose of this controller is to provide a list of currently active questions.

import UIKit

class QuestionViewController: UITableViewController {
    
    //create outlet variables for connections to UI
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var titleTextView: UILabel!
    
    //create instance variables
    var compassDataLab: CompassDataLab = CompassDataLab()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create initial styles for the table view
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        tableView.rowHeight = UITableViewAutomaticDimension //allow rows to auto resize height
        tableView.estimatedRowHeight = 65 //set initial height
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
            
            mainView.backgroundColor = UIColor(hex: theme.Theme_Colors.Primary)
        }
    }
    
    /****************************************
     Table Functions
     ****************************************/
    
    //function to set the number of rows for the section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return compassDataLab.questions.count
    }
    
    //function to set the cell for the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //create the gell
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionCell
        
        //get the question data
        let question = compassDataLab.questions[indexPath.row]
        
        //set the cell text
        cell.question?.text = question.Question
        cell.answer?.text = question.Answer
        
        //set the cell colors
        if let theme = compassDataLab.getPreferedTheme() {
            cell.question?.textColor = UIColor(hex: theme.Theme_Colors.Text)
            cell.answer?.textColor = UIColor(hex: theme.Theme_Colors.Text)
            cell.backgroundColor = UIColor(hex: theme.Theme_Colors.Secondary)
        }
        
        //return cell
        return cell
    }
}
