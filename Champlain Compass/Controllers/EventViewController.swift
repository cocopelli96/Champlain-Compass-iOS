//
//  EventViewController.swift
//  Champlain Compass
//
//  Created by Travis Spinelli on 2/20/18.
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
//  Purpose: This file is used to create the EventViewController for the Event Details Screen of the application. The main purpose of this controller is to provide the data of a selected event for the user to view. It also allows the user to proceed to view data on the presenter of the event and to add the event to the user's calendar.

import UIKit
import EventKit

class EventViewController: UIViewController {
    
    //create outlet variables for connections to UI
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var titleTextView: UILabel!
    @IBOutlet weak var dateTextView: UILabel!
    @IBOutlet weak var timeTextView: UILabel!
    @IBOutlet weak var locationTextView: UILabel!
    @IBOutlet weak var presenterButton: UIButton!
    @IBOutlet weak var descriptionTextView: UILabel!
    @IBOutlet weak var addToCalendarButton: UIButton!
    
    //create instance variables
    var compassDataLab: CompassDataLab = CompassDataLab()
    var event: Event = Event()
    
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
        
        //set the initial text of the screen
        titleTextView.text = event.Name
        dateTextView.text = event.getFullDateString()
        timeTextView.text = event.getTimeString()
        locationTextView.text = event.Location
        if let presenter = compassDataLab.getPresenter(event) {
            presenterButton.setTitle(presenter.Name, for: .normal)
        } else {
            presenterButton.isHidden = true
        }
        descriptionTextView.text = event.Description
        addToCalendarButton.setTitle("\u{f271} Add Event to My Calendar", for: .normal)
        
        //setup the UI
        setColors()
    }
    
    //function to set colors of the UI
    func setColors() {
        if let theme = compassDataLab.getPreferedTheme() {
            titleTextView.textColor = UIColor(hex: theme.Theme_Colors.Title)
            titleTextView.shadowColor = UIColor(hex: theme.Theme_Colors.Shadow)
            
            mainView.backgroundColor = UIColor(hex: theme.Theme_Colors.Primary)
            
            dateTextView.textColor = UIColor(hex: theme.Theme_Colors.Text_Secondary)
            timeTextView.textColor = UIColor(hex: theme.Theme_Colors.Text_Secondary)
            locationTextView.textColor = UIColor(hex: theme.Theme_Colors.Text_Secondary)
            descriptionTextView.textColor = UIColor(hex: theme.Theme_Colors.Text_Secondary)
            
            presenterButton.setTitleColor(UIColor(hex: theme.Theme_Colors.Text), for: .normal)
            presenterButton.backgroundColor = UIColor(hex: theme.Theme_Colors.Secondary)
            addToCalendarButton.setTitleColor(UIColor(hex: theme.Theme_Colors.Text), for: .normal)
            addToCalendarButton.backgroundColor = UIColor(hex: theme.Theme_Colors.Secondary)
        }
    }
    
    //prepare for next controller by setting the presenter
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presenterSegue" {
            if let avc = segue.destination as? PresenterViewController {
                avc.presenter = compassDataLab.getPresenter(event)!
            }
        }
    }
    
    //create action function to add event to user's calendar
    @IBAction func addToCalendar(_ sender: UIButton) {
        let eventStore: EKEventStore = EKEventStore()
        
        //request access to event store
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted && error == nil {
                //create event item
                let eventItem: EKEvent = EKEvent(eventStore: eventStore)
                
                //set the values of the event item
                eventItem.title = self.event.Name
                eventItem.notes = self.event.Description
                eventItem.startDate = self.event.getStartTime()
                eventItem.endDate = self.event.getEndTime()
                eventItem.location = self.event.Location
                eventItem.alarms = [EKAlarm(relativeOffset: -60 * 10)]
                eventItem.calendar = eventStore.defaultCalendarForNewEvents
                
                do {
                    //try saving the event item to the user's calendar
                    try eventStore.save(eventItem, span: .thisEvent)
                    
                    //create alert controller to alert user of event creation
                    let alertController = UIAlertController(title: "Event Added to Calendar", message: "The event \(self.event.Name) has been added to your calendar.", preferredStyle: .alert)
                    let endAction = UIAlertAction(title: "Close", style: .default, handler: nil)
                    alertController.addAction(endAction)
                    self.present(alertController, animated: true, completion: nil)
                } catch let error as NSError {
                    print("Failed to save event with error: \(error)")
                }
            } else {
                print("There was an error: \(String(describing: error))")
            }
        }
    }
}
