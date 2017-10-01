//
//  SignUpViewController.swift
//  Dream High
//
//  Created by Miriam Hendler on 9/12/17.
//  Copyright © 2017 Miriam Hendler. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
  // Profile image variable initilization
  var imagePicker: UIImagePickerController?
  
  //Firebase Initialization
  var ref: DatabaseReference?
  
  //Get New Users nationality and email
  var email = "mjammer18@gmail.com"
  var nationality = "american"
  
  //Button IBOutlets for sign up form
  @IBOutlet weak var collegeButton: UIButton!
  @IBOutlet weak var highSchoolButton: UIButton!
  @IBOutlet weak var profileButton: UIButton!
  @IBOutlet weak var nextButton: UIButton!
  
  //Text field IBOutlets
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  //IBActions
  @IBAction func signUpButtonPressed(_ sender: Any) {
    if isTextFieldsCompleted() {
      if highSchoolButton.alpha == 1 {
        signUpDreamer()
        performSegue(withIdentifier: "dreamerSignUp", sender: self)
      } else {
        performSegue(withIdentifier: "collegeSignUp", sender: self)
      }
    }
  }
  
  @IBAction func collegeButtonPressed(_ sender: Any) {
    enableCollegeStudent()
  }
  @IBAction func highSchoolButtonPressed(_ sender: Any) {
    enableHighSchoolStudent()
  }
  @IBAction func profileButtonPressed(_ sender: Any) {
    presentPhotoOptions()
  }
  
  //Exit Segue
  @IBAction func exitToSignUp(segue: UIStoryboardSegue){}
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpDelegates()
    setUpUI()
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
    view.addGestureRecognizer(tap)
  }
  
  func dismissKeyboard() {
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    view.endEditing(true)
  }

  func setUpUI() {
    //Set Button UI
    let green = Helper.colorWithHexString(hex: "#02C576").cgColor
    
    highSchoolButton.roundAndShadow(opacity: 0.0, borderWidth: 1, borderColor: green)
    collegeButton.roundAndShadow(opacity: 0.0, borderWidth: 1, borderColor: green)
    profileButton.maskToCircle()
    
    //Set Intitial button value
    collegeButton.alpha = 0.4
    nextButton.alpha = 0.4
  }
  
  func enableHighSchoolStudent() {
    highSchoolButton.alpha = 1
    collegeButton.alpha = 0.4
    nextButton.setTitle("Sign up", for: .normal)
  }
  
  func enableCollegeStudent() {
    highSchoolButton.alpha = 0.4
    collegeButton.alpha = 1
    nextButton.setTitle("Next", for: .normal)
  }
  
  func setUpDelegates(){
    //Image Delegates
    imagePicker =  UIImagePickerController()
    imagePicker!.delegate = self
    
    //Textfield Delegates
    nameTextField.delegate = self
    passwordTextField.delegate = self
    
    //Firebase setUp
    ref = Database.database().reference()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "collegeSignUp" {
      let vc = segue.destination as! CollegeSignUpViewController
      
      vc.nationality = nationality
      vc.email = email
      let lowResImage = profileButton.imageView!.image!.resizeImageWith(newSize: CGSize(width: 100, height: 100))
      vc.profile = lowResImage.encodeTo64()
      vc.name = nameTextField.text!
      vc.password = passwordTextField.text!
    } else if segue.identifier == "dreamerSignUp" {
      
      let tabBarC = segue.destination as! UITabBarController
      let vc = tabBarC.viewControllers?.first as! DiscoverViewController
      
      vc.dreamer = createDreamer()
      
      let home = tabBarC.viewControllers?.last as! MentorHomeViewController
      
      home.dreamer = createDreamer()
    }
  }
  func createDreamer() -> Dreamer {
    let lowResImage = profileButton.imageView!.image!.resizeImageWith(newSize: CGSize(width: 100, height: 100))
    var profile = lowResImage.encodeTo64()
    if profileButton.imageView!.image! == #imageLiteral(resourceName: "take_photo") {
      profile = #imageLiteral(resourceName: "placeholder").encodeTo64()
    }
    let dreamer = Dreamer(name: nameTextField.text!, nationality: nationality, profile: profile)
    return dreamer
  }
  
  //MARK: Firebase functions
  func signUpDreamer() {
    if !isTextFieldsCompleted() {
      Helper.showAlert(controller: self)
    } else {
      Auth.auth().createUser(withEmail: email, password: passwordTextField.text!) { (user, error) in
        
        if error == nil {
          print("You have successfully signed up")
          //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
          //Create the user in the database
          let dreamer = self.createDreamer()
          
          self.ref!.child("users").child(user!.uid).setValue(["name": dreamer.name,
                                                              "nationality": dreamer.nationality,
                                                              "profile": dreamer.profile,
                                                              "user": "dreamer",
                                                              "has_story": "false",
                                                              "has_mentors": "false"])
          let appDelegate=AppDelegate()
          appDelegate.currentUser = dreamer
          appDelegate.userAccount = .dreamer
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

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func getProfilePic(fromSource: UIImagePickerControllerSourceType) {
    imagePicker = UIImagePickerController()
    imagePicker!.delegate = self
    
    switch fromSource {
    case .camera:
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
        imagePicker!.sourceType = .camera;
        imagePicker!.allowsEditing = true
        self.present(imagePicker!, animated: true, completion: nil)
      }
    case .photoLibrary:
      if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        imagePicker!.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        imagePicker!.allowsEditing = true
        present(imagePicker!, animated: true, completion: nil)
      }
    default:
      break
    }
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
    profileButton.setImage(image, for: .normal)
    dismiss(animated:true, completion: nil)
  }
  
  func presentPhotoOptions() {
    let optionMenu = UIAlertController(title: nil, message: "Choose A Photo", preferredStyle: .actionSheet)
    let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: {
      (alert: UIAlertAction!) -> Void in
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
        self.getProfilePic(fromSource: .camera)
      }
    })
    let choosePhotoAction = UIAlertAction(title: "Choose From Library", style: .default, handler: {
      (alert: UIAlertAction!) -> Void in
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
        self.getProfilePic(fromSource: .photoLibrary)
      }
    })
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
      (alert: UIAlertAction!) -> Void in
    })
    
    optionMenu.addAction(takePhotoAction)
    optionMenu.addAction(choosePhotoAction)
    optionMenu.addAction(cancelAction)
    
    self.present(optionMenu, animated: true, completion: nil)
  }
}

extension SignUpViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if isTextFieldsCompleted() {
      nextButton.alpha = 1
    }
    return true
  }
  
  func isTextFieldsCompleted() -> Bool {
    if nameTextField.text != "" && passwordTextField.text != "" {
      return true
    }
    return false
  }
}
