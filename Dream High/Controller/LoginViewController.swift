//
//  LoginViewController.swift
//  Dream High
//
//  Created by Miriam Hendler on 9/12/17.
//  Copyright © 2017 Miriam Hendler. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var nextTextField: UITextField!
  
  @IBOutlet weak var nextIconImageView: UIImageView!
  @IBOutlet weak var nextButton: UIButton!
  
  //Button IB Actions
  @IBAction func nextButtonPressed(_ sender: Any) {
    if isTextFieldsCompleted() {
      if isLogin {
        loginUser()
      } else {
        performSegue(withIdentifier: "infoSegue", sender: self)
      }
    }
  }
  
  //Exit Segue
  @IBAction func exitToLogin(segue: UIStoryboardSegue){}
  
  //Custom Variables
  var isLogin = false
  var dreamer: Dreamer?
  var mentor: Mentor?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if isLogin {
      setUIForLogin()
    }
    setTextFieldDelegates()
    
    nextButton.alpha = 0.4
    
    //Looks for single or multiple taps.
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
    
    //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
    //tap.cancelsTouchesInView = false
    
    view.addGestureRecognizer(tap)
  }
  
  //Calls this function when the tap is recognized.
  func dismissKeyboard() {
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    view.endEditing(true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "infoSegue" {
      let vc = segue.destination as! SignUpViewController
      vc.email = emailTextField.text!
      vc.nationality = nextTextField.text!
    } else if segue.identifier == "discoverLoginSegue" {
      let tabBarC = segue.destination as! UITabBarController
      let vc = tabBarC.viewControllers?.first as! DiscoverViewController
      
      if let mentor = mentor {
        vc.mentor = mentor
        
        let mentorVC = tabBarC.viewControllers?.last as! MentorHomeViewController
        mentorVC.mentor = mentor
      }
      if let dreamer = dreamer {
        vc.dreamer = dreamer
      }
    }
  }
  
  func setUIForLogin() {
    nextTextField.placeholder = "Password"
    nextTextField.isSecureTextEntry = true
    nextIconImageView.image = #imageLiteral(resourceName: "key")
    nextButton.setTitle("Login", for: .normal)
    descriptionLabel.text! = "Login to learn about undocumented students who dreamed high."
  }
  
  func loginUser() {
    let firebaseHelper = FirebaseHelper()
    if isTextFieldsCompleted() {
      
      firebaseHelper.login(email: emailTextField.text!, password: nextTextField.text!, controller: self, callback: { (user) in
        
        let appDelegate=AppDelegate()
        appDelegate.currentUser = user
        
        if let user = user as? Dreamer {
          self.dreamer = user
          appDelegate.userAccount = .dreamer
        }
        else if let user = user as? Mentor {
          self.mentor = user
          appDelegate.userAccount = .mentor
        }
        self.performSegue(withIdentifier: "discoverLoginSegue", sender: self)
      })
    }
  }
}

extension LoginViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if isTextFieldsCompleted() {
      nextButton.alpha = 1
    }
    return true
  }
  
  func isTextFieldsCompleted() -> Bool {
    if emailTextField.text != "" && nextTextField.text != "" {
      return true
    }
    return false
  }
  
  func setTextFieldDelegates() {
    emailTextField.delegate = self
    nextTextField.delegate = self
  }
}
