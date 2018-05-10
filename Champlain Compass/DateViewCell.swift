//
//  DateViewCell.swift
//  Champlain Compass
//
//  Created by Travis Spinelli on 2/27/18.
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
// Purpose: This file is used to create a subclass of JTAppleCell to manage the calendar date views for the schedule of events calendar. This class has two elements which are the date label and the select view.

import UIKit
import JTAppleCalendar

class DateViewCell: JTAppleCell {
    
    //create outlet varibales for connections to the UI
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectView: UIView!
    
}
