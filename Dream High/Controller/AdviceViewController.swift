//
//  AdviceViewController.swift
//  Dream High
//
//  Created by Miriam Hendler on 9/13/17.
//  Copyright © 2017 Miriam Hendler. All rights reserved.
//

import UIKit

class AdviceViewController: UIViewController {
  @IBOutlet weak var doneButton: UIButton!
  @IBOutlet weak var adviceTextView: UITextView!
  
  @IBAction func doneButtonPressed(_ sender: Any) {
    if isCompleted() {
      let firebaseHelper = FirebaseHelper()
      story!.advice = adviceTextView.text
      firebaseHelper.uploadStory(story: story!)
      performSegue(withIdentifier: "unwindMentorHomeSegue", sender: self)
    } else {
      Helper.showAlert(controller: self)
    }
  }
  
  //Custom Vars
  var story: Story?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    adviceTextView.delegate = self
    adviceTextView.text = story!.advice
    
    if (story == nil) {
      adviceTextView.text = "Type Something"
      adviceTextView.textColor = .lightGray
    }
  }
  
  func isCompleted() -> Bool {
    if adviceTextView.text! != "Type Something"  || adviceTextView.text! != "" {
      return true
    }
    return false
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "unwindMentorHomeSegue" {
      let vc = segue.destination as! MentorHomeViewController
      vc.mentor!.story = story
      vc.story = story
    }
  }
}

extension AdviceViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
      textView.text = nil
      textView.textColor = UIColor.black
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "Type Something"
      textView.textColor = UIColor.lightGray
    }
  }
  
}
