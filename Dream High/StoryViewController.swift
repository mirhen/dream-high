//
//  StoryViewController.swift
//  Dream High
//
//  Created by Miriam Hendler on 9/13/17.
//  Copyright © 2017 Miriam Hendler. All rights reserved.
//

import UIKit
import MessageUI
import Firebase
import FirebaseAuth
import SABlurImageView

class StoryViewController: UIViewController {
  //IBOutlet Buttons
  @IBOutlet weak var contactButton: UIButton!
  
  //UIElements for user information
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var schoolLabel: UILabel!
  @IBOutlet weak var nationalityLabel: UILabel!
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var backgroundImageView: SABlurImageView!
  
  //Story UIElements
  @IBOutlet weak var dreamDescriptionTextView: UITextView!
  @IBOutlet weak var adviceDescriptionTextView: UITextView!
  
  //Custom User Initilization
  var story: Story?
  var dreamer: Dreamer?
  //IBAction
  @IBAction func contactButtonPressed(_ sender: Any) {
    var hasMentor = false
    if dreamer != nil {
      for mentor in dreamer!.mentors {
        if mentor == story!.uid {
          hasMentor = true
          break
        }
      }
      if !hasMentor {
        addMentor()
      }
    }
    sendEmail()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpUI()
  }
  
  func setUpUI() {
    if let story = story {
      
      profileImageView.image = story.mentor.profile.decodeToImage()
      backgroundImageView.image = story.mentor.profile.decodeToImage()
      profileImageView.maskToCircle()
      contactButton.setTitle("Talk to \(story.mentor.name)", for: .normal)
      nameLabel.text = story.mentor.name
      schoolLabel.text = "\(story.mentor.college) • \(story.mentor.major)"
      nationalityLabel.text = story.mentor.nationality
      
      dreamDescriptionTextView.text = story.about
      adviceDescriptionTextView.text = story.advice
    }
    
    contactButton.roundAndShadow(radius: 20, opacity: 0.0, borderWidth: 1, borderColor: Helper.colorWithHexString(hex: "#02C576").cgColor)
  }
  
  func addMentor() {
    let fireBaseHelper = FirebaseHelper()
    if let uid = story!.uid {
      fireBaseHelper.updateUserValue(key: "mentors/\(Helper.getCurrentTime())", value: uid)
      fireBaseHelper.updateUserValue(key: "has_mentors", value: "true")
    }
  }
}

//TODO: We have effectivly the same exact code in 3 places - subclass (alex)
extension StoryViewController: MFMailComposeViewControllerDelegate {
  func sendEmail() {
    let composeVC = MFMailComposeViewController()
    composeVC.mailComposeDelegate = self
    // Configure the fields of the interface.
    var userName = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    if let user = appDelegate.currentUser as? Mentor {
      userName = user.name
    } else if let user = appDelegate.currentUser as? Dreamer {
      userName = user.name
    }
    
    composeVC.setToRecipients([story!.mentor.email])
    composeVC.setSubject("Dream High Mentor Request")
    composeVC.setMessageBody("Hi \(story!.mentor.name), \nThank you for sharing your experience on pursuing higher education while being a dreamer. You have now inspired me to Dream High! I would love to learn more about you achieved your dream. Some of the questions I have are:  \n\nBest,  \n \(userName) ", isHTML: false)
    // Present the view controller modally.
    self.present(composeVC, animated: true, completion: nil)
  }
  
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true, completion: nil)
  }
}
