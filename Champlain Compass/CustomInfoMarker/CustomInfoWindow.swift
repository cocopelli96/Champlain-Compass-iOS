//
//  CustomInfoMarker.swift
//  Champlain Compass
//
//  Created by Travis Spinelli on 3/3/18.
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
//  Purpose: This file is used to create a custom information window for the campus map. This information window is design in the UI file CustomInfoMarker.xib and has three elements which are the title label for the name of the building, the subtitle label for the address of the building, and the directions buttons which is used to indicate that clicking the information window will open the map application on this device and provide walking directions to the location.

import UIKit

class CustomInfoWindow: UIView {
    
    //create outlet variables or connections to the UI
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var directionsButton: UIButton!
    
}
