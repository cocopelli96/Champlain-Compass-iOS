//
//  CompassDataLab.swift
//  Champlain Compass
//
//  Created by Travis Spinelli on 2/19/18.
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
//  Purpose: This file is used to create a class to store the data that is found in the database. This is most important part of the application as the data in this class runs the actual functionality of the rest of the application.

import Foundation

class CompassDataLab: NSObject, NSCoding {

    //create instance variables
    var themes: [String: OrientationTheme]
    var resources: [OrientationResource]
    var events: [Event]
    var questions: [FrequentlyAskedQuestion]
    var presenters: [Presenter]
    var buildings: [Building]
    var timeStamp: Date
    
    //constructor
    override init() {
        self.timeStamp = Date()
        self.themes = [:]
        self.resources = []
        self.events = []
        self.buildings = []
        self.presenters = []
        self.questions = []
        super.init()
    }
    
    //constructor
    init(themes: [String: OrientationTheme], resources: [OrientationResource], events: [Event], buildings: [Building], presenters: [Presenter], questions: [FrequentlyAskedQuestion], timeStamp: Date) {
        self.timeStamp = timeStamp
        self.themes = themes
        self.resources = resources
        self.events = events
        self.buildings = buildings
        self.presenters = presenters
        self.questions = questions
        super.init()
    }
    
    //convience constructor for the NSObject and NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        //decode the data so that it can be stored in a new instance object
        guard let time = aDecoder.decodeObject(forKey: "TimeStamp") as? Date,
            let themeList = aDecoder.decodeObject(forKey: "Themes") as? [String: OrientationTheme],
            let resourceList = aDecoder.decodeObject(forKey: "Resources") as? [OrientationResource],
            let eventList = aDecoder.decodeObject(forKey: "Events") as? [Event],
            let buildingList = aDecoder.decodeObject(forKey: "Buildings") as? [Building],
            let presenterList = aDecoder.decodeObject(forKey: "Presenters") as? [Presenter],
            let questionList = aDecoder.decodeObject(forKey: "Questions") as? [FrequentlyAskedQuestion]
            else { return nil }
        
        //create instance object
        self.init(
            themes: themeList,
            resources: resourceList,
            events: eventList,
            buildings: buildingList,
            presenters: presenterList,
            questions: questionList,
            timeStamp: time
        )
    }
    
    //function to encode the object into a storable form
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.timeStamp, forKey: "TimeStamp")
        aCoder.encode(self.themes, forKey: "Themes")
        aCoder.encode(self.resources, forKey: "Resources")
        aCoder.encode(self.events, forKey: "Events")
        aCoder.encode(self.questions, forKey: "Questions")
        aCoder.encode(self.presenters, forKey: "Presenters")
        aCoder.encode(self.buildings, forKey: "Buildings")
    }
    
    //function to get a theme from the list of themes using a specified string key
    func getTheme(forKey key: String) -> OrientationTheme? {
        return themes[key];
    }
    
    //function to function to get the current theme
    func getCurrentTheme() -> OrientationTheme? {
        var themeList: [OrientationTheme] = []
        
        //loop through the list and get all current themes
        for (_, theme) in themes {
            if theme.Is_Current {
                themeList.append(theme)
            }
        }
        
        //determine how many themes were found to be current
        if themeList.count > 1 {
            //if more than 1 sort the list by semester and return the first
            themeList.sort { $0.Semester > $1.Semester }
            return themeList[0]
        } else if themeList.count == 1 {
            //if only 1 return it
            return themeList[0]
        } else {
            //else return nothing
            return nil
        }
    }
    
    //function to get the basic Champlain College theme
    func getBasicTheme() -> OrientationTheme? {
        //if the theme with the key FALL exists
        if let theme = themes["FALL"] {
            //return it
            return theme
        } else {
            //else return nothing
            return nil
        }
    }
    
    //function to get preferred theme
    func getPreferedTheme() -> OrientationTheme? {
        //get the user default and determine if the user wants to us the current theme or basic theme
        var useOrientationTheme = UserDefaults.standard.bool(forKey: "UseOrientationTheme")
        if UserDefaults.standard.object(forKey: "UseOrientationTheme") == nil {
            useOrientationTheme = true
        }
        
        //get the theme and return it
        if useOrientationTheme {
            return getCurrentTheme()
        } else {
            return getBasicTheme()
        }
    }
    
    //function to get the events for a specified month
    func getEventsForMonth(month: Int, year: Int) -> [Event] {
        //make a date string to compare against
        var date: String = "\(year)"
        if (month < 10) {
            date = "\(date)-0\(month)"
        } else {
            date = "\(date)-\(month)"
        }
        
        //get a list of the events which makes this date string
        var eventList: [Event] = []
        for event in events {
            if event.Start_Time.contains(date) {
                eventList.append(event)
            }
        }
        
        //sort the list by start date
        eventList.sort { $0.getStartTime()! < $1.getStartTime()! }
        
        //return the list
        return eventList
    }
    
    //function to return events for the specified month that belong to the specified group
    func getEventsForMonth(group: String, month: Int, year: Int) -> [Event] {
        //make a date string to compare against
        var date: String = "\(year)"
        if (month < 10) {
            date = "\(date)-0\(month)"
        } else {
            date = "\(date)-\(month)"
        }
        
        //get a list of the events which makes this date string
        var eventList: [Event] = []
        for event in events {
            if event.Start_Time.contains(date) && event.Groups.contains(group) {
                eventList.append(event)
            }
        }
        
        //sort the list by start date
        eventList.sort { $0.getStartTime()! < $1.getStartTime()! }
        
        //return the list
        return eventList
    }
    
    //function to return events for the specified day
    func getEventsForDay(month: Int, day: Int, year: Int) -> [Event] {
        //make a date string to compare against
        var date: String = "\(year)"
        if (month < 10) {
            date = "\(date)-0\(month)"
        } else {
            date = "\(date)-\(month)"
        }
        if (day < 10) {
            date = "\(date)-0\(day)"
        } else {
            date = "\(date)-\(day)"
        }
        
        //get a list of the events which makes this date string
        var eventList: [Event] = []
        for event in events {
            if event.Start_Time.contains(date) {
                eventList.append(event)
            }
        }
        
        //sort the list by start date
        eventList.sort { $0.getStartTime()! < $1.getStartTime()! }
        
        //return the list
        return eventList
    }
    
    //function to return events for the specified day that belong to the specified group
    func getEventsForDay(group: String, month: Int, day: Int, year: Int) -> [Event] {
        //make a date string to compare against
        var date: String = "\(year)"
        if (month < 10) {
            date = "\(date)-0\(month)"
        } else {
            date = "\(date)-\(month)"
        }
        if (day < 10) {
            date = "\(date)-0\(day)"
        } else {
            date = "\(date)-\(day)"
        }
        
        //get a list of the events which makes this date string
        var eventList: [Event] = []
        for event in events {
            if event.Start_Time.contains(date) && event.Groups.contains(group) {
                eventList.append(event)
            }
        }
        
        //sort the list by start date
        eventList.sort { $0.getStartTime()! < $1.getStartTime()! }
        
        //return the list
        return eventList
    }
    
    //function to get list of events for specified group type
    func getEventsForGroup(group: String) -> [Event] {
        var eventList: [Event] = []
        
        //get a list of the events which makes this date string
        for event in events {
            if event.Groups.contains(group) {
                eventList.append(event)
            }
        }
        
        //sort the list by start date
        eventList.sort { $0.getStartTime()! < $1.getStartTime()! }
        
        //return the list
        return eventList
    }
    
    //function to get list of active questions
    func getActiveQuestions() -> [FrequentlyAskedQuestion] {
        var questionList: [FrequentlyAskedQuestion] = []
        
        //get the list of active questions
        for question in questions {
            if question.Is_Active {
                questionList.append(question)
            }
        }
        
        //return the list
        return questionList
    }
    
    //function to get list of active resources
    func getActiveResources() -> [OrientationResource] {
        var resourceList: [OrientationResource] = []
        
        //get the list of active resources
        for resource in resources {
            if resource.Is_Active {
                resourceList.append(resource)
            }
        }
        
        //sort the resources by name
        resourceList.sort { $0.Name < $1.Name }
        
        //return the list
        return resourceList
    }
    
    //function to get presenter based on specified event
    func getPresenter(_ event: Event) -> Presenter? {
        //get the presenter listed on the event
        for presenter in presenters {
            if presenter.Name == event.Presenter {
                return presenter
            }
        }
        
        //if no presneter was found return nil
        return nil
    }
    
    //function to get list of active buildings
    func getActiveBuildings() -> [Building] {
        var buildingList: [Building] = []
        
        //get the list of active buildings
        for building in buildings {
            if building.Is_Active {
                buildingList.append(building)
            }
        }
        
        //sort the list of buildings by name
        buildingList.sort { $0.Name < $1.Name }
        
        //return the list
        return buildingList
    }
    
    //function to determine if the data was cached
    func isCached() -> Bool {
        //if the data can be retrieved from the cache
        if let decodedData = UserDefaults.standard.object(forKey: "CompassDataLab") as? Data, let cachedVersion = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as? CompassDataLab {
            //if the cache has
            let cachePeriod: TimeInterval = 3 * 60.0 // hours * minutes
            if cachedVersion.timeStamp > self.timeStamp.addingTimeInterval(cachePeriod) {
                //set the cache data to nil and return false
                UserDefaults.standard.setValue(nil, forKey: "CompassDataLab")
                return false
            }
            
            //otherwise the cache is still active so return true
            return true
        }
        //otherwise the cache is empty so return false
        return false
    }
    
    //function to cache the data
    func cache() {
        //encode and store the data in the cache
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(encodedData, forKey: "CompassDataLab")
    }
    
    //function to retrieve the cached data
    func retrieveCache() -> Bool {
        //if the data can be retrieved
        if let decodedData = UserDefaults.standard.object(forKey: "CompassDataLab") as? Data, let cachedVersion = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as? CompassDataLab {
            //store the data in this object
            self.timeStamp = cachedVersion.timeStamp
            self.themes = cachedVersion.themes
            self.events = cachedVersion.events
            self.buildings = cachedVersion.buildings
            self.presenters = cachedVersion.presenters
            self.resources = cachedVersion.resources
            self.questions = cachedVersion.questions
            
            //return true because data was retireved successfully
            return true
        } else {
            //otherwise return false because failed to retrieve data
            return false
        }
    }
}
