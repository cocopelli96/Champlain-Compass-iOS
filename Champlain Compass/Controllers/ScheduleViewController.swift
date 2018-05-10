//
//  ScheduleViewController.swift
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
//  Purpose: This file is used to create the ScheduleViewController for the Schedule Screen of the application. The main purpose of this controller is to provide a calendar of events. When a date is selected the list of events occuring on that date are provided below the calendar.

import UIKit
import JTAppleCalendar

class ScheduleViewController: UITableViewController, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    //create outlet variables for connections to UI
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleTextView: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var nextMonthButton: UIButton!
    @IBOutlet weak var previousMonthButton: UIButton!
    
    //create instance variables
    var compassDataLab: CompassDataLab = CompassDataLab()
    var dateFormatter: DateFormatter = DateFormatter()
    var groupName: String = "Residential Students"
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create initial styles for the table view
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        tableView.rowHeight = UITableViewAutomaticDimension //allow rows to auto resize height
        tableView.estimatedRowHeight = 60 //set initial height
        
        //setup calendar
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        
        //set initial selected date
        let currentDate = Date()
        calendarView.scrollToDate(currentDate, animateScroll: false)
        calendarView.selectDates([currentDate])
        
        //load events
        if let date = calendarView.selectedDates.first {
            loadEventsFor(date: date)
        }
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
        setButtonIcons()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //reload table data when view is disappearing
        tableView.reloadData()
    }
    
    //function to set the text of buttons
    func setButtonIcons() {
        previousMonthButton.setTitle("\u{f053}", for: .normal)
        nextMonthButton.setTitle("\u{f054}", for: .normal)
    }
    
    //function to set colors of the UI
    func setColors() {
        if let theme = compassDataLab.getPreferedTheme() {
            titleTextView.textColor = UIColor(hex: theme.Theme_Colors.Title)
            titleTextView.shadowColor = UIColor(hex: theme.Theme_Colors.Shadow)
            
            mainView.backgroundColor = UIColor(hex: theme.Theme_Colors.Primary)
            
            monthLabel.textColor = UIColor(hex: theme.Theme_Colors.Text_Secondary)
            previousMonthButton.setTitleColor(UIColor(hex: theme.Theme_Colors.Text_Secondary), for: .normal)
            nextMonthButton.setTitleColor(UIColor(hex: theme.Theme_Colors.Text_Secondary), for: .normal)
        }
    }
    
    //function to load the event data for a specified date
    func loadEventsFor(date: Date) {
        //get date value strings
        dateFormatter.dateFormat = "MM"
        let monthString: String = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "dd"
        let dayString: String = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "yyyy"
        let yearString: String = dateFormatter.string(from: date)
        
        //convert date values to integers
        let month: Int = Int(monthString)!
        let day: Int = Int(dayString)!
        let year: Int = Int(yearString)!
        
        //get events
        events = compassDataLab.getEventsForDay(group: groupName, month: month, day: day, year: year)
    }
    
    /****************************************
     Table Functions
     ****************************************/
    
    //function to set number of rows in sections
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count + 1
    }
    
    //function to set cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //if the cell is not an event
        if indexPath.row >= events.count {
            //create default cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyTableCell", for: indexPath)
            
            //set colors of the cell
            if let theme = compassDataLab.getPreferedTheme() {
                cell.textLabel?.textColor = UIColor(hex: theme.Theme_Colors.Text)
                cell.backgroundColor = UIColor(hex: theme.Theme_Colors.Secondary)
            }
            
            //hide the cell is there are events in the list
            if events.count > 0 {
                cell.isHidden = true
            }
            
            //return cell
            return cell
        }
        
        //otherwise load event cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventCell
        
        //grab event data
        let event = events[indexPath.row]
        
        //set the text of the event cell
        cell.date?.text = event.getDateString()
        cell.time?.text = event.getStartTimeString()
        cell.title?.text = event.Name
        cell.detail?.text = "\u{f054}"
        
        //set the colors of the event cell
        if let theme = compassDataLab.getPreferedTheme() {
            cell.title?.textColor = UIColor(hex: theme.Theme_Colors.Text)
            cell.date?.textColor = UIColor(hex: theme.Theme_Colors.Text)
            cell.time?.textColor = UIColor(hex: theme.Theme_Colors.Text)
            cell.detail?.textColor = UIColor(hex: theme.Theme_Colors.Text)
            cell.backgroundColor = UIColor(hex: theme.Theme_Colors.Secondary)
        }
        
        //return the cell
        return cell
    }
    
    //prepare for the next controller by setting the event
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventDetailsSegue" {
            if let avc = segue.destination as? EventViewController, let row = tableView.indexPathForSelectedRow?.row {
                avc.event = events[row]
            }
        }
    }
    
    /****************************************
    Calendar Functions
    ****************************************/
    
    //function to set the date cell of the calendar
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        //create a date cell
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateViewCell
        
        //set the date text
        cell.dateLabel.text = cellState.text
        
        //set the color of the date
        setCalendarDateColor(cell: cell, cellState: cellState, isCurrentDate: compareDate(cellDate: date, to: Date()))
        
        //set selected state styles of the cell
        if cellState.isSelected && cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.white
            cell.selectView.isHidden = false
        } else {
            cell.selectView.isHidden = true
        }
        
        //set whether the cell can be interacted with by the user
        if cellState.dateBelongsTo != .thisMonth {
            cell.isUserInteractionEnabled = false
        } else {
            cell.isUserInteractionEnabled = true
        }
        
        //return cell
        return cell
    }
    
    //function to configure the inital settings of the calendar
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        //prepare the date formatter
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        
        //set start and end dates
        let startDate = dateFormatter.date(from: "2000-01-01")!
        let endDate = dateFormatter.date(from: "2100-12-31")!
        
        //create parameters for the calendar
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, generateOutDates: .tillEndOfRow)
        return parameters
    }
    
    //function to set cell needed for special display style
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        //get date cell
        guard let customCell = cell as? DateViewCell else { return }
        
        //set calendar colors
        setCalendarDateColor(cell: customCell, cellState: cellState, isCurrentDate: compareDate(cellDate: date, to: Date()))
        
        //set visibility of the cell
        customCell.isHidden = false
    }
    
    //function to run when scrolling through calendar
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
    
    //function to run when calendar dates are selected
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        //grab the date cell
        guard let validCell = cell as? DateViewCell else { return }
        
        //set the select view to visible and change text color
        validCell.dateLabel.textColor = UIColor.white
        validCell.selectView.isHidden = false
        
        //load events for selected date and update the table
        loadEventsFor(date: date)
        tableView.reloadData()
    }
    
    //function to run when calendar dates are deselected
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        //grab the date cell
        guard let validCell = cell as? DateViewCell else { return }
        
        //set calendar colors
        setCalendarDateColor(cell: validCell, cellState: cellState, isCurrentDate: compareDate(cellDate: date, to: Date()))
        
        //set select view to hidden
        validCell.selectView.isHidden = true
    }
    
    //function to setup calendar header views
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        //get the first date of the visible month
        let date = visibleDates.monthDates.first!.date
        
        //set month label
        self.dateFormatter.dateFormat = "MMMM yyyy"
        self.monthLabel.text = self.dateFormatter.string(from: date)
    }
    
    //function to set calendar colors
    func setCalendarDateColor(cell: DateViewCell, cellState: CellState, isCurrentDate: Bool) {
        if isCurrentDate && cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor(hex: "#206030")
        } else if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.black
        } else {
            cell.dateLabel.textColor = UIColor.gray
        }
    }
    
    //function to compare dates for equality
    func compareDate(cellDate: Date, to date: Date) -> Bool {
        //get date strings
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let cellDateString = dateFormatter.string(from: cellDate)
        let dateString = dateFormatter.string(from: date)
        
        //compare and return
        return cellDateString == dateString
    }
    
    //create action function to move to previous month
    @IBAction func previousMonth(_ sender: UIButton) {
        calendarView.scrollToSegment(.previous)
    }
    
    //create action function to move to next month
    @IBAction func nextMonth(_ sender: UIButton) {
        calendarView.scrollToSegment(.next)
    }
}
