//
//  CollegeSignUpViewController.swift
//  Dream High
//
//  Created by Miriam Hendler on 9/12/17.
//  Copyright © 2017 Miriam Hendler. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CollegeSignUpViewController: UIViewController {
    
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var collegeTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    //Mentor information
    var name = ""
    var nationality = "american"
    var email = "mjammer18@gmail.com"
    var profile = #imageLiteral(resourceName: "placeholder").encodeTo64()
    var password = ""
    
    //Firebase Initialization
    var ref: DatabaseReference?
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        if isTextFieldsCompleted() {
            signUpMentor()
            performSegue(withIdentifier: "discoverCollegeSegue", sender: self)
        } else {
            Helper.showAlert(controller: self)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFieldDelegates()
        
        //Firebase setUp
        ref = Database.database().reference()
        
        // Do any additional setup after loading the view.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CollegeSignUpViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "discoverCollegeSegue" {
            let tabBarC = segue.destination as! UITabBarController
            let vc = tabBarC.viewControllers?.first as! DiscoverViewController
            vc.mentor = createMentor()
            
            let home = tabBarC.viewControllers?.last as! MentorHomeViewController
            home.mentor = createMentor()
        }
    }
    //MARK: Firebase functions
    
    func createMentor() -> Mentor {
        
        if profile == #imageLiteral(resourceName: "take_photo").encodeTo64() {
            profile = #imageLiteral(resourceName: "placeholder").encodeTo64()
        }
        let mentor = Mentor(name: name, email: email, profile: profile, nationality: nationality, college: collegeTextField.text!, major: majorTextField.text!)
        
        mentor.has_story = false
        
        return mentor
    }
    func signUpMentor() {
        
        if !isTextFieldsCompleted() {
            Helper.showAlert(controller: self)
            
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    
                    //Create the user in the database
                    let mentor = self.createMentor()
                    
                    self.ref!.child("users").child(user!.uid).setValue(["name": mentor.name,
                                                                        "email": mentor.email,
                                                               "nationality": mentor.nationality,
                                                               "profile": mentor.profile,
                                                               "college": mentor.college,
                                                               "major": mentor.major,
                                                               "user": "mentor",
                                                               "has_story": "false",
                                                               "has_mentors": "false"
                                        ])
                    
                    let appDelegate=AppDelegate()
                    appDelegate.currentUser = mentor
                    appDelegate.userAccount = .mentor
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

extension CollegeSignUpViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if isTextFieldsCompleted() {
            signUpButton.alpha = 1
        }
        return true
    }
    
    func isTextFieldsCompleted() -> Bool {
        if collegeTextField.text != "" && majorTextField.text != "" {
            return true
        }
        return false
    }
    
    func setTextFieldDelegates() {
        collegeTextField.delegate = self
        majorTextField.delegate = self
    }
}
