//
//  ResourcesViewController.swift
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
//  Purpose: This file is used to create the ResourcesViewController for the Resource List Screen of the application. The main purpose of this controller is to provide a list of currently active resources. Clicking on a resource will open a view of the file in the applciation.

import UIKit
import Firebase
import QuickLook

class ResourcesViewController: UITableViewController, QLPreviewControllerDataSource {
    
    //create outlet variables for connections to UI
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var titleTextView: UILabel!
    
    //create instance variables
    var quickLookController: QLPreviewController = QLPreviewController()
    var compassDataLab: CompassDataLab = CompassDataLab()
    var previewItem: PreviewItem = PreviewItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create initial styles for the table view
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        tableView.rowHeight = UITableViewAutomaticDimension //allow rows to auto resize height
        tableView.estimatedRowHeight = 60 //set initial height
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
        return compassDataLab.getActiveResources().count
    }
    
    //function to set the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "resourceCell", for: indexPath) as! ResourceCell
        
        //grab the resource data
        let resource = compassDataLab.getActiveResources()[indexPath.row]
        
        //set the text of the cell
        cell.title?.text = resource.Name
        cell.detail?.text = "\u{f054}"
        
        //set the colors of the cell
        if let theme = compassDataLab.getPreferedTheme() {
            cell.title?.textColor = UIColor(hex: theme.Theme_Colors.Text)
            cell.detail?.textColor = UIColor(hex: theme.Theme_Colors.Text)
            cell.backgroundColor = UIColor(hex: theme.Theme_Colors.Secondary)
        }
        
        //return cell
        return cell
    }
    
    //function to run when rows are selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //get resource reference
        let storageRef = Storage.storage().reference().child("Resources")
        let resource = compassDataLab.getActiveResources()[indexPath.row]
        let fileRef = storageRef.child(resource.File_Name)
        let localUrl = URL(fileURLWithPath: "\(NSTemporaryDirectory())/\(resource.File_Name)")
        
        fileRef.write(toFile: localUrl) { (url: URL?, error: Error?) in
            if let e = error {
                print("Error: \(e)")
            } else {
                //prepare the preview item and store it
                self.previewItem = PreviewItem()
                self.previewItem.previewItemTitle = "Champlain Compass"
                self.previewItem.previewItemURL = url
                
                //if can preview the file
                if QLPreviewController.canPreview(self.previewItem) {
                    //create preview controller and open it
                    self.quickLookController = QLPreviewController()
                    self.quickLookController.currentPreviewItemIndex = 0
                    self.quickLookController.dataSource = self
                    self.navigationController?.pushViewController(self.quickLookController, animated: true)
                }
            }
        }
    }
    
    /****************************************
     Preview Functions
     ****************************************/
    
    
    //function to get the number of items to be viewed by the preview controller
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    //function to set the item to be viewed by the preview controller
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return previewItem
    }
}

//create preview item class for use with viewing resources
class PreviewItem: NSObject, QLPreviewItem {
    //create instance variables
    var previewItemURL: URL?
    var previewItemTitle: String?
}
