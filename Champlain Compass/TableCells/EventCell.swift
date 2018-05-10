//
//  EventCell.swift
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
//  Purpose: This file is used to create a custom table cell for displaying event data in the UI. This object has four elements a date label, a time label, a title label for the name of the event, and a detail label.

import UIKit

class EventCell: UITableViewCell {

    //create outlet variables for connections to UI
    @IBOutlet var date: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var detail: UILabel!
    
    //function for when the cells are being managed and created
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title.adjustsFontForContentSizeCategory = true
        date.adjustsFontForContentSizeCategory = true
        time.adjustsFontForContentSizeCategory = true
    }
}
