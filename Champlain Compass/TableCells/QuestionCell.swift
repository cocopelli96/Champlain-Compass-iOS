//
//  QuestionCell.swift
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
//  Purpose: This file is used to create a custom table cell for displaying question data in the UI. This object has two elements a question label and an answer label.

import UIKit

class QuestionCell: UITableViewCell {
    
    //create outlet variables for connections to UI
    @IBOutlet var question: UILabel!
    @IBOutlet var answer: UILabel!

    //function for when the cells are being managed and created
    override func awakeFromNib() {
        super.awakeFromNib()
        
        question.adjustsFontForContentSizeCategory = true
        answer.adjustsFontForContentSizeCategory = true
    }
}
