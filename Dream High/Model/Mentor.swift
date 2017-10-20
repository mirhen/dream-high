//
//  Mentor.swift
//  Dream High
//
//  Created by Miriam Hendler on 9/13/17.
//  Copyright © 2017 Miriam Hendler. All rights reserved.
//

import Foundation

class Mentor {
  var name: String
  var email: String
  var profile: String
  var nationality: String
  var college: String
  var major: String
  var story: Story?
  var has_story = false
  
  init(name: String,
       email: String,
       profile: String,
       nationality: String,
       college: String,
       major: String) {
    self.name = name
    self.email = email
    self.profile = profile
    self.nationality = nationality
    self.college = college
    self.major = major
  }
  
}
