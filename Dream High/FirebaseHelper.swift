//
//  FirebaseHelper.swift
//  Dream High
//
//  Created by Miriam Hendler on 9/14/17.
//  Copyright © 2017 Miriam Hendler. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SwiftyJSON

class FirebaseHelper {
  var ref: DatabaseReference = Database.database().reference()
  
  func login(email: String, password: String, controller: UIViewController, callback: @escaping (Any?)->()) {
    Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
      if error == nil {
        print("You have successfully logged in")
        self.retrieveUser(uid: user!.uid, callback: { (userInfo) in
          callback(userInfo)
        })
      } else {
        //Tells the user that there is an error and then gets firebase to tell them the error
        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        controller.present(alertController, animated: true, completion: nil)
      }
    }
  }
  
  //TODO: Force unwraping will not be good for deserialization (alex)
  func retrieveSchools(callback: @escaping ([School])->()) {
    var schools: [School] = []
    // only need to fetch once so use single event
    // TODO: If these schools are not being updated (hardcoded) we should def cache these (alex)
    ref.child("schools").observeSingleEvent(of: .value, with: { snapshot in
      
      if !snapshot.exists() { return }
      print(snapshot)
      if let value = snapshot.value as? [Any] {
        
        for i in value {
          
          if let current = i as? [String: String] {
            let schoolName = current["name"]
            let institute = current["institution"]
            let link = current["link"]
            let image_url = current["image_url"]
            let info = current["info"] ?? ""
            
            let school = School(name: schoolName!, image: image_url!, url: link!, information: info)
            school!.institution = institution(rawValue: institute!)!
            
            schools.append(school!)}
        }
      }
      
      callback(schools)
    })
  }
  
  //TODO: Force unwraping will not be good for deserialization (alex)
  func retrieveUser(uid: String, callback:@escaping (Any?)->()) {
    ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
      
      print(snapshot)
      if let value = snapshot.value as? [String: Any] {
        let user = value["user"] as! String
        let name = value["name"] as! String
        let nationality = value["nationality"] as! String
        let profile = value["profile"] as! String
        
        if user == "dreamer" {
          let hasMentor = value["has_mentors"] as! String
          let dreamer = Dreamer(name: name, nationality: nationality, profile: profile)
          
          if hasMentor.toBool()! {
            let mentors = value["mentors"] as? [String: String] ?? ["":""]
            dreamer.mentors = Array(mentors.values)
          }
          
          callback(dreamer)
        } else {
          let college = value["college"] as! String
          let major = value["major"] as! String
          let about = value["about"] ?? ""
          let advice = value["advice"] ?? ""
          let email = value["email"] ?? "mjammer18@gmail.com"
          let has_story = value["has_story"] ?? "false"
          
          let mentor = Mentor(name: name,email: email as! String, profile: profile, nationality: nationality, college: college, major: major)
          
          let story = Story(mentor: mentor, about: about as! String, advice: advice as! String)
          mentor.story = story
          mentor.has_story = (has_story as! String).toBool() ?? false
          
          callback(mentor)
          
        }
      }
    })
  }
  
  func logout() {
    if Auth.auth().currentUser != nil {
      do {
        try Auth.auth().signOut()
        
      } catch let error as NSError {
        print(error.localizedDescription)
      }
    }
  }
  
  func uploadStory(story: Story) {
    if let user = Auth.auth().currentUser {
      ref.child("users").child(user.uid).updateChildValues(["about": story.about, "advice": story.advice, "has_story": "true"])
    }
  }
  
  func updateUserValue(key: String, value: String) {
    if let currentUser = Auth.auth().currentUser {
      ref.child("users").child(currentUser.uid).updateChildValues([key:value])
    }
  }
  
  func retrieveStories(vc: DiscoverViewController) {
    ref.child("users").queryOrdered(byChild: "has_story").queryEqual(toValue: "true").observe(.childAdded, with: { (snapshot) in
      
      if let value = snapshot.value as? [String: String] {
        let name = value["name"]
        let nationality = value["nationality"]
        let profile = value["profile"]
        
        let college = value["college"]
        let major = value["major"]
        let about = value["about"] ?? ""
        let advice = value["advice"] ?? ""
        let email = value["email"] ?? "mjammer18@gmail.com"
        
        let mentor = Mentor(name: name!,email: email, profile: profile!, nationality: nationality!, college: college!, major: major!)
        let story = Story(mentor: mentor, about: about, advice: advice)
        
        let uid = snapshot.key
        print(uid)
        story.uid = uid
        
        vc.stories.append(story)
      }
    })
  }
  
  func retrieveMentors(vc: MentorHomeViewController) {
    if let user = Auth.auth().currentUser {
      ref.child("users").child(user.uid).observe(.value, with: { (snapshot) in
        
        if let value = snapshot.value as? [String: Any] {
          if (value["has_mentors"] as! String).toBool()! {
            let mentors = value["mentors"] as! [String: String]
            var uids:[String] = []
            vc.mentors = []
            for i in mentors.keys {
              let uid = mentors[i]
              
              if !uids.contains(uid!) {
                self.retrieveUser(uid: uid!, callback: { (user) in
                  if let user = user as? Mentor {
                    vc.mentors.append(user)
                    //                                vc.dreamer!.mentors.append(uid!)
                  }
                })
              }
              uids.append(uid!)
            }
          }
        }
      })
    }
  }
  
  func uploadSchools() {
    var count = 0
    //        let schools = dumpJson(file: "school")
    var data = readDataFromCSV(fileName: "school", fileType: "csv")
    data = cleanRows(file: data!)
    let csvRows = csv(data: data!)
    
    for school in csvRows {
      count += 1
      print(school)
      if count > 1 {
        ref.child("schools").child("\(count)").setValue(["name": school[0], "institution": "college", "link": school[1], "image_url": school[2], "info": ""])
      }
    }
    
  }
  
  func dumpJson(file: String) -> JSON {
    let path = Bundle.main.path(forResource: file, ofType: "json")
    let jsonData = NSData(contentsOfFile:path!)
    let json = JSON(data: jsonData! as Data)
    return json
    //        println(json["DDD"].string)
  }
  
  func readDataFromCSV(fileName:String, fileType: String)-> String!{
    guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
      else {
        return nil
    }
    do {
      var contents = try String(contentsOfFile: filepath, encoding: .utf8)
      contents = cleanRows(file: contents)
      return contents
    } catch {
      print("File Read Error for file \(filepath)")
      return nil
    }
  }
  
  func cleanRows(file:String)->String{
    var cleanFile = file
    cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
    cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
    //        cleanFile = cleanFile.replacingOccurrences(of: ";;", with: "")
    //        cleanFile = cleanFile.replacingOccurrences(of: ";\n", with: "")
    return cleanFile
  }
  
  func csv(data: String) -> [[String]] {
    var result: [[String]] = []
    let rows = data.components(separatedBy: "\n")
    for row in rows {
      let columns = row.components(separatedBy: ",")
      result.append(columns)
    }
    return result
  }
}
