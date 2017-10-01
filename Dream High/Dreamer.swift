//
//  Dreamer.swift
//  Dream High
//
//  Created by Miriam Hendler on 9/13/17.
//  Copyright © 2017 Miriam Hendler. All rights reserved.
//

import Foundation

enum account: String {
  case dreamer = "dreamer"
  case mentor = "mentor"
}

class Dreamer {
  var name: String
  var profile: String
  var nationality: String
  var mentors: [String] = []
  
  init(name: String, nationality: String, profile: String) {
    self.name = name
    self.nationality = nationality
    self.profile = profile
  }
}
