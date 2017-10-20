//
//  School.swift
//  Dream High
//
//  Created by Miriam Hendler on 9/14/17.
//  Copyright © 2017 Miriam Hendler. All rights reserved.
//

import Foundation

// TODO: Capitalize Enums (alex)
enum institution: String {
  case college = "college"
  case high_school = "high_school"
}

class School {
  var name: String = ""
  var institution: institution = .college
  var image: Data?
  var image_url: String?
  var url: String = ""
  var information: String?
  
  init?(name: String, image: Data, url: String) {
    self.name = name
    self.image = image
    self.url = url
  }
  
  init?(name: String, image: String, url: String, information: String?) {
    self.name = name
    self.image_url = image
    self.url = url
    if let info = information { self.information = info }
  }
}
