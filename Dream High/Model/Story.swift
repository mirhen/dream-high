//
//  Story.swift
//  Dream High
//
//  Created by Miriam Hendler on 9/13/17.
//  Copyright © 2017 Miriam Hendler. All rights reserved.
//

import Foundation

class Story {
    var mentor: Mentor
    var about: String
    var advice: String
    var views: Int = 0
    var uid: String?
    
    init(mentor: Mentor, about: String, advice: String) {
        self.mentor = mentor
        self.about = about
        self.advice = advice
    }
    
}
