//
//  ChamplainCompassDataStructures.swift
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
//  Purpose: This files is used to create the data models that will be used to store the data after it is retireved from the database.

import Foundation

//class to store the oreintation theme data
class OrientationTheme: NSObject, NSCoding {
    
    //create instance variables
    var Semester: String
    var Theme_Name: String
    var Description: String
    var Is_Current: Bool
    var Logo: ThemeLogo
    var Theme_Colors: ThemeColors
    
    //constructor
    override init() {
        self.Semester = ""
        self.Theme_Name = ""
        self.Description = ""
        self.Is_Current = false
        self.Logo = ThemeLogo()
        self.Theme_Colors = ThemeColors()
    }
    
    //constructor for Dictionary of data
    init(_ data: NSDictionary) {
        //save data found in the dictionary
        self.Theme_Name = data.value(forKey: "Theme_Name") as! String
        self.Description = data.value(forKey: "Description") as! String
        self.Semester = data.value(forKey: "Semester") as! String
        self.Is_Current = data.value(forKey: "Is_Current") as! Bool
        
        //create the logo object
        if let logo = data.value(forKey: "Logo") as? NSDictionary {
            self.Logo = ThemeLogo(logo)
        } else {
            self.Logo = ThemeLogo()
        }
        
        //create the theme colors object
        if let themeColors = data.value(forKey: "Theme_Colors") as? NSDictionary {
            self.Theme_Colors = ThemeColors(themeColors)
        } else {
            self.Theme_Colors = ThemeColors()
        }
    }
    
    //constructor
    init(themeName: String, description: String, semester: String, logo: ThemeLogo, themeColors: ThemeColors, current: Bool) {
        self.Theme_Name = themeName
        self.Description = description
        self.Semester = semester
        self.Logo = logo
        self.Theme_Colors = themeColors
        self.Is_Current = current
    }
    
    //convience constructor for the NSObject and NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        //decode the data so that it can be stored in a new instance object
        guard let themeName = aDecoder.decodeObject(forKey: "Theme_Name") as? String,
            let description = aDecoder.decodeObject(forKey: "Description") as? String,
            let semester = aDecoder.decodeObject(forKey: "Semester") as? String,
            let logo = aDecoder.decodeObject(forKey: "Logo") as? ThemeLogo,
            let themeColors = aDecoder.decodeObject(forKey: "Theme_Colors") as? ThemeColors
            else { return nil }
        
        //create instance object
        self.init(
            themeName: themeName,
            description: description,
            semester: semester,
            logo: logo,
            themeColors: themeColors,
            current: aDecoder.decodeBool(forKey: "Is_Current")
        )
    }
    
    //function to encode the object into a storable form
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.Theme_Name, forKey: "Theme_Name")
        aCoder.encode(self.Description, forKey: "Description")
        aCoder.encode(self.Semester, forKey: "Semester")
        aCoder.encode(self.Is_Current, forKey: "Is_Current")
        aCoder.encode(self.Logo, forKey: "Logo")
        aCoder.encode(self.Theme_Colors, forKey: "Theme_Colors")
    }
    
    //function to detemrine if two themes are equal
    static func == (lhs: OrientationTheme, rhs: OrientationTheme) -> Bool {
        return lhs.Theme_Name == rhs.Theme_Name &&
            lhs.Description == rhs.Description &&
            lhs.Semester == rhs.Semester &&
            lhs.Is_Current == rhs.Is_Current &&
            lhs.Logo == rhs.Logo &&
            lhs.Theme_Colors == rhs.Theme_Colors 
    }
}

//class to store the oreintation theme logo data
class ThemeLogo: NSObject, NSCoding {
    
    //create instance variables
    var File_Name: String
    var Description: String
    
    //constructor
    override init() {
        self.File_Name = ""
        self.Description = ""
    }
    
    //constructor for Dictionary of data
    init(_ data: NSDictionary) {
        //save data found in the dictionary
        self.File_Name = data.value(forKey: "File_Name") as! String
        self.Description = data.value(forKey: "Description") as! String
    }
    
    //constructor
    init(fileName: String, description: String) {
        self.File_Name = fileName
        self.Description = description
    }
    
    //convience constructor for the NSObject and NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        //decode the data so that it can be stored in a new instance object
        guard let fileName = aDecoder.decodeObject(forKey: "File_Name") as? String,
            let description = aDecoder.decodeObject(forKey: "Description") as? String
            else { return nil }
        
        //create instance object
        self.init(
            fileName: fileName,
            description: description
        )
    }
    
    //function to encode the object into a storable form
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.File_Name, forKey: "File_Name")
        aCoder.encode(self.Description, forKey: "Description")
    }
    
    //function to detemrine if two theme logos are equal
    static func == (lhs: ThemeLogo, rhs: ThemeLogo) -> Bool {
        return lhs.File_Name == rhs.File_Name &&
            lhs.Description == rhs.Description
    }
}

//class to store the oreintation theme color data
class ThemeColors: NSObject, NSCoding {
    
    //create instance variables
    var Primary: String
    var Secondary: String
    var Text: String
    var Text_Secondary: String
    var Text_Click: String
    var Shadow: String
    var Title: String
    
    //constructor
    override init() {
        self.Primary = ""
        self.Secondary = ""
        self.Text = ""
        self.Text_Secondary = ""
        self.Text_Click = ""
        self.Shadow = ""
        self.Title = ""
    }
    
    //constructor for Dictionary of data
    init(_ data: NSDictionary) {
        //save data found in the dictionary
        self.Primary = data.value(forKey: "Primary") as! String
        self.Secondary = data.value(forKey: "Secondary") as! String
        self.Text = data.value(forKey: "Text") as! String
        self.Text_Click = data.value(forKey: "Text_Click") as! String
        self.Text_Secondary = data.value(forKey: "Text_Secondary") as! String
        self.Title = data.value(forKey: "Title") as! String
        self.Shadow = data.value(forKey: "Shadow") as! String
    }
    
    //constructor
    init(primary: String, secondary: String, shadow: String, text: String, textSecondary: String, textClick: String, title: String) {
        self.Primary = primary
        self.Secondary = secondary
        self.Shadow = shadow
        self.Text = text
        self.Text_Secondary = textSecondary
        self.Text_Click = textClick
        self.Title = title
    }
    
    //convience constructor for the NSObject and NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        //decode the data so that it can be stored in a new instance object
        guard let primary = aDecoder.decodeObject(forKey: "Primary") as? String,
            let secondary = aDecoder.decodeObject(forKey: "Secondary") as? String,
            let shadow = aDecoder.decodeObject(forKey: "Shadow") as? String,
            let text = aDecoder.decodeObject(forKey: "Text") as? String,
            let textSecondary = aDecoder.decodeObject(forKey: "Text_Secondary") as? String,
            let textClick = aDecoder.decodeObject(forKey: "Text_Click") as? String,
            let title = aDecoder.decodeObject(forKey: "Title") as? String
            else { return nil }
        
        //create instance object
        self.init(
            primary: primary,
            secondary: secondary,
            shadow: shadow,
            text: text,
            textSecondary: textSecondary,
            textClick: textClick,
            title: title
        )
    }
    
    //function to encode the object into a storable form
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.Primary, forKey: "Primary")
        aCoder.encode(self.Secondary, forKey: "Secondary")
        aCoder.encode(self.Shadow, forKey: "Shadow")
        aCoder.encode(self.Text, forKey: "Text")
        aCoder.encode(self.Text_Secondary, forKey: "Text_Secondary")
        aCoder.encode(self.Text_Click, forKey: "Text_Click")
        aCoder.encode(self.Title, forKey: "Title")
    }
    
    //function to detemrine if two theme colors are equal
    static func == (lhs: ThemeColors, rhs: ThemeColors) -> Bool {
        return lhs.Primary == rhs.Primary &&
            lhs.Secondary == rhs.Secondary &&
            lhs.Shadow == rhs.Shadow &&
            lhs.Text == rhs.Text &&
            lhs.Text_Secondary == rhs.Text_Secondary &&
            lhs.Text_Click == rhs.Text_Click &&
            lhs.Title == rhs.Title
    }
}

//class to store the event data
class Event: NSObject, NSCoding {
    
    //create instance variables
    var Name: String
    var Description: String
    var Location: String
    var Presenter: String
    var Start_Time: String
    var End_Time: String
    var Groups: [String]
    
    //constructor
    override init() {
        self.Name = ""
        self.Description = ""
        self.Location = ""
        self.Presenter = ""
        self.Start_Time = ""
        self.End_Time = ""
        self.Groups = []
    }
    
    //constructor for Dictionary of data
    init(_ data: NSDictionary) {
        //save data found in the dictionary
        self.Name = data.value(forKey: "Name") as! String
        self.Description = data.value(forKey: "Description") as! String
        self.Location = data.value(forKey: "Location") as! String
        self.Presenter = data.value(forKey: "Presenter") as! String
        self.Start_Time = data.value(forKey: "Start_Time") as! String
        self.End_Time = data.value(forKey: "End_Time") as! String
        self.Groups = data.value(forKey: "Groups") as! [String]
    }
    
    //constructor
    init(name: String, description: String, location: String, presenter: String, startTime: String, endTime: String, groups: [String]) {
        self.Name = name
        self.Description = description
        self.Location = location
        self.Presenter = presenter
        self.Start_Time = startTime
        self.End_Time = endTime
        self.Groups = groups
    }
    
    //convience constructor for the NSObject and NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        //decode the data so that it can be stored in a new instance object
        guard let name = aDecoder.decodeObject(forKey: "Name") as? String,
            let description = aDecoder.decodeObject(forKey: "Description") as? String,
            let location = aDecoder.decodeObject(forKey: "Location") as? String,
            let presenter = aDecoder.decodeObject(forKey: "Presenter") as? String,
            let startTime = aDecoder.decodeObject(forKey: "Start_Time") as? String,
            let endTime = aDecoder.decodeObject(forKey: "End_Time") as? String,
            let groups = aDecoder.decodeObject(forKey: "Groups") as? [String]
            else { return nil }
        
        //create instance object
        self.init(
            name: name,
            description: description,
            location: location,
            presenter: presenter,
            startTime: startTime,
            endTime: endTime,
            groups: groups
        )
    }
    
    //function to encode the object into a storable form
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.Name, forKey: "Name")
        aCoder.encode(self.Description, forKey: "Description")
        aCoder.encode(self.Location, forKey: "Location")
        aCoder.encode(self.Presenter, forKey: "Presenter")
        aCoder.encode(self.Start_Time, forKey: "Start_Time")
        aCoder.encode(self.End_Time, forKey: "End_Time")
        aCoder.encode(self.Groups, forKey: "Groups")
    }
    
    //function to detemrine if two events are equal
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.Name == rhs.Name &&
            lhs.Description == rhs.Description &&
            lhs.Location == rhs.Location &&
            lhs.Presenter == rhs.Presenter &&
            lhs.Start_Time == rhs.Start_Time &&
            lhs.End_Time == rhs.End_Time &&
            lhs.Groups == rhs.Groups
    }
    
    //funciton to get start date of event as a Date object
    func getStartTime() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        let date = dateFormatter.date(from: Start_Time)
        return date
    }
    
    //function to get End date of event as a Date object
    func getEndTime() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        let date = dateFormatter.date(from: End_Time)
        return date
    }
    
    //function to get a formatted date string for month and day of the event
    func getDateString() -> String {
        if let date = getStartTime() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    //function to get a formatted date string for the month, day, and year of the event
    func getFullDateString() -> String {
        if let date = getStartTime() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    //function to get a formatted start time string for the event
    func getStartTimeString() -> String {
        if let startDate = getStartTime() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: startDate)
        }
        return ""
    }
    
    //function to get a formatted end time string for the event
    func getEndTimeString() -> String {
        if let endDate = getEndTime() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: endDate)
        }
        return ""
    }
    
    //function to get a formatted time string for the event
    func getTimeString() -> String {
        if let startDate = getStartTime(), let endDate = getEndTime() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            return "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
        }
        return ""
    }
}

//class to store the oreintation resource data
class OrientationResource: NSObject, NSCoding {
    
    //create instance variables
    var Name: String
    var Description: String
    var File_Name: String
    var File_Type: String
    var Is_Active: Bool
    
    //constructor
    override init() {
        self.Name = ""
        self.Description = ""
        self.File_Name = ""
        self.File_Type = ""
        self.Is_Active = false
    }
    
    //constructor for Dictionary of data
    init(_ data: NSDictionary) {
        //save data found in the dictionary
        self.Name = data.value(forKey: "Name") as! String
        self.Description = data.value(forKey: "Description") as! String
        self.File_Name = data.value(forKey: "File_Name") as! String
        self.File_Type = data.value(forKey: "File_Type") as! String
        self.Is_Active = data.value(forKey: "Is_Active") as! Bool
    }
    
    //constructor
    init(name: String, description: String, fileName: String, fileType: String, active: Bool) {
        self.Name = name
        self.Description = description
        self.File_Name = fileName
        self.File_Type = fileType
        self.Is_Active = active
    }
    
    //convience constructor for the NSObject and NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        //decode the data so that it can be stored in a new instance object
        guard let name = aDecoder.decodeObject(forKey: "Name") as? String,
            let description = aDecoder.decodeObject(forKey: "Description") as? String,
            let fileName = aDecoder.decodeObject(forKey: "File_Name") as? String,
            let fileType = aDecoder.decodeObject(forKey: "File_Type") as? String
            else { return nil }
        
        //create instance object
        self.init(
            name: name,
            description: description,
            fileName: fileName,
            fileType: fileType,
            active: aDecoder.decodeBool(forKey: "Is_Active")
        )
    }
    
    //function to encode the object into a storable form
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.Name, forKey: "Name")
        aCoder.encode(self.Description, forKey: "Description")
        aCoder.encode(self.File_Name, forKey: "File_Name")
        aCoder.encode(self.File_Type, forKey: "File_Type")
        aCoder.encode(self.Is_Active, forKey: "Is_Active")
    }
    
    //function to detemrine if two resources are equal
    static func == (lhs: OrientationResource, rhs: OrientationResource) -> Bool {
        return lhs.Name == rhs.Name &&
            lhs.Description == rhs.Description &&
            lhs.File_Name == rhs.File_Name &&
            lhs.File_Type == rhs.File_Type &&
            lhs.Is_Active == rhs.Is_Active
    }
}

//class to store the frequently asked questions data
class FrequentlyAskedQuestion: NSObject, NSCoding {
    
    //create instance variables
    var Question: String
    var Answer: String
    var Is_Active: Bool
    
    //constructor
    override init() {
        self.Question = ""
        self.Answer = ""
        self.Is_Active = false
    }
    
    //constructor for Dictionary of data
    init(_ data: NSDictionary) {
        //save data found in the dictionary
        self.Question = data.value(forKey: "Question") as! String
        self.Answer = data.value(forKey: "Answer") as! String
        self.Is_Active = data.value(forKey: "Is_Active") as! Bool
    }
    
    //constructor
    init(question: String, answer: String, active: Bool) {
        self.Question = question
        self.Answer = answer
        self.Is_Active = active
    }
    
    //convience constructor for the NSObject and NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        //decode the data so that it can be stored in a new instance object
        guard let question = aDecoder.decodeObject(forKey: "Question") as? String,
            let answer = aDecoder.decodeObject(forKey: "Answer") as? String
            else { return nil }
        
        //create instance object
        self.init(
            question: question,
            answer: answer,
            active: aDecoder.decodeBool(forKey: "Is_Active")
        )
    }
    
    //function to encode the object into a storable form
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.Question, forKey: "Question")
        aCoder.encode(self.Answer, forKey: "Answer")
        aCoder.encode(self.Is_Active, forKey: "Is_Active")
    }
    
    //function to detemrine if two questions are equal
    static func == (lhs: FrequentlyAskedQuestion, rhs: FrequentlyAskedQuestion) -> Bool {
        return lhs.Question == rhs.Question &&
            lhs.Answer == rhs.Answer &&
            lhs.Is_Active == rhs.Is_Active
    }
}

//class to store the presenters data
class Presenter: NSObject, NSCoding {
    
    //create instance variables
    var Name: String
    var Job_Title: String
    var Bio: String
    
    //constructor
    override init() {
        self.Name = ""
        self.Job_Title = ""
        self.Bio = ""
    }
    
    //constructor for Dictionary of data
    init(_ data: NSDictionary) {
        //save data found in the dictionary
        self.Name = data.value(forKey: "Name") as! String
        self.Job_Title = data.value(forKey: "Job_Title") as! String
        self.Bio = data.value(forKey: "Bio") as! String
    }
    
    //constructor
    init(name: String, job: String, bio: String) {
        self.Name = name
        self.Job_Title = job
        self.Bio = bio
    }
    
    //convience constructor for the NSObject and NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        //decode the data so that it can be stored in a new instance object
        guard let name = aDecoder.decodeObject(forKey: "Name") as? String,
            let job = aDecoder.decodeObject(forKey: "Job_Title") as? String,
            let bio = aDecoder.decodeObject(forKey: "Bio") as? String
            else { return nil }
        
        //create instance object
        self.init(
            name: name,
            job: job,
            bio: bio
        )
    }
    
    //function to encode the object into a storable form
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.Name, forKey: "Name")
        aCoder.encode(self.Job_Title, forKey: "Job_Title")
        aCoder.encode(self.Bio, forKey: "Bio")
    }
    
    //function to detemrine if two presenters are equal
    static func == (lhs: Presenter, rhs: Presenter) -> Bool {
        return lhs.Name == rhs.Name &&
            lhs.Job_Title == rhs.Job_Title &&
            lhs.Bio == rhs.Bio
    }
}

//class to store the buildings data
class Building: NSObject, NSCoding {
    
    //create instance variables
    var Name: String
    var Address: String
    var Is_Active: Bool
    
    //constructor
    override init() {
        self.Name = ""
        self.Address = ""
        self.Is_Active = false
    }
    
    //constructor for Dictionary of data
    init(_ data: NSDictionary) {
        //save data found in the dictionary
        self.Name = data.value(forKey: "Name") as! String
        self.Address = data.value(forKey: "Address") as! String
        self.Is_Active = data.value(forKey: "Is_Active") as! Bool
    }
    
    //constructor
    init(name: String, address: String, active: Bool) {
        self.Name = name
        self.Address = address
        self.Is_Active = active
    }
    
    //convience constructor for the NSObject and NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        //decode the data so that it can be stored in a new instance object
        guard let name = aDecoder.decodeObject(forKey: "Name") as? String,
            let address = aDecoder.decodeObject(forKey: "Address") as? String
            else { return nil }
        
        //create instance object
        self.init(
            name: name,
            address: address,
            active: aDecoder.decodeBool(forKey: "Is_Active")
        )
    }
    
    //function to encode the object into a storable form
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.Name, forKey: "Name")
        aCoder.encode(self.Address, forKey: "Address")
        aCoder.encode(self.Is_Active, forKey: "Is_Active")
    }
    
    //function to detemrine if two buildings are equal
    static func == (lhs: Building, rhs: Building) -> Bool {
        return lhs.Name == rhs.Name &&
            lhs.Address == rhs.Address &&
            lhs.Is_Active == rhs.Is_Active
    }
}

