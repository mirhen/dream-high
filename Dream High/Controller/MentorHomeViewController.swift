//
//  MentorHomeViewController.swift
//  Dream High
//
//  Created by Miriam Hendler on 9/13/17.
//  Copyright © 2017 Miriam Hendler. All rights reserved.
//

import UIKit
import SABlurImageView

class MentorHomeViewController: UIViewController {
  //MARK: - GLOBAL
  
  //Global UI Components
  @IBOutlet weak var profileButton: UIButton!
  
  //UIElements for user information
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var schoolLabel: UILabel!
  @IBOutlet weak var nationalityLabel: UILabel!
  @IBOutlet weak var backgroundImageView: SABlurImageView!
  
  //View Compontents
  @IBOutlet weak var mentorContainer: UIView!
  @IBOutlet weak var dreamerContainer: UIView!
  var firstLine = UIView()
  var secondLine = UIView()
  var firstSelected = true
  
  
  // Profile image variable initilization
  var imagePicker: UIImagePickerController?
  
  @IBAction func logoutButtonPressed(_ sender: Any) {
    let firebaseHelper = FirebaseHelper()
    firebaseHelper.logout()
  }
  
  @IBAction func profileButtonPressed(_ sender: Any) {
    presentPhotoOptions()
  }
  @IBAction func aboutButtonPressed(_ sender: Any) {
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    if  mentor != nil {
      setUpUI()
    } else if dreamer != nil {
      setUpDreamerUI()
      let firebaseHelper = FirebaseHelper()
      firebaseHelper.retrieveMentors(vc: self)
      
      //            if dreamer!.mentors != [] {
      //                for uid in dreamer!.mentors {
      //                    firebaseHelper.retrieveUser(uid: uid, callback: { (user) in
      //                        if let user = user as? Mentor {
      //                            var hasMentor = true
      //                            for mentor in self.mentors {
      //                                if user.email == mentor.email {
      //                                    hasMentor = false
      //                                }
      //                            }
      //                            if !hasMentor {
      //                                self.mentors.append(user)
      //                            }
      //                        }
      //                    })
      //                }
      //            }
      collectionView.reloadData()
    }
    
    // Do any additional setup after loading the view.
  }
  
  func updateButtonUI() {
    if firstSelected {
      firstLine.backgroundColor = Helper.colorWithHexString(hex: "#02C576")
      secondLine.backgroundColor = .clear
    } else {
      firstLine.backgroundColor = .clear
      secondLine.backgroundColor = Helper.colorWithHexString(hex: "#02C576")
    }
  }
  //MARK: - DREAMER
  
  //Buttons
  @IBOutlet weak var mentorsButton: UIButton!
  @IBOutlet weak var resourcesButton: UIButton!
  
  //Mentor Collection View
  @IBOutlet weak var collectionView: UICollectionView!
  
  
  //Button Actions
  @IBAction func mentorsButtonPressed(_ sender: Any) {
    firstSelected = true
    updateButtonUI()
  }
  @IBAction func resourcesButtonPressed(_ sender: Any) {
    firstSelected = false
    updateButtonUI()
    performSegue(withIdentifier: "resourcesSegue", sender: self)
  }
  
  //Custom Variables
  var dreamer: Dreamer?
  var mentors: [Mentor] = [] {
    didSet {
      collectionView.isHidden = false
      collectionView.reloadData()
    }
  }
  var selectedMentor: Mentor?
  
  func setUpDreamerUI() {
    
    if mentors.count == 0 {
      collectionView.isHidden = true
    } else {
      collectionView.isHidden = false
    }
    
    mentorContainer.isHidden = true
    
    firstLine = UIView(frame: CGRect(x: 0,y: mentorsButton.frame.size.height - 2, width: mentorsButton.frame.size.width,height: 2))
    firstLine.backgroundColor = Helper.colorWithHexString(hex: "#02C576")
    
    secondLine = UIView(frame: CGRect(x:0,y: resourcesButton.frame.size.height - 2,width: resourcesButton.frame.size.width,height: 2))
    secondLine.backgroundColor=UIColor.clear
    
    mentorsButton.addSubview(firstLine)
    resourcesButton.addSubview(secondLine)
    
    profileButton.setImage(dreamer!.profile.decodeToImage(), for: .normal)
    
    backgroundImageView.image = dreamer!.profile.decodeToImage()
    backgroundImageView.addBlurEffect(30, times: 1)
    
    profileButton.maskToCircle()
    nameLabel.text = dreamer!.name
    schoolLabel.text = dreamer!.nationality
  }
  //MARK: - MENTOR
  
  //UIButtons
  @IBOutlet weak var shareButton: UIButton!
  @IBOutlet weak var dreamButtom: UIButton!
  @IBOutlet weak var adviceButton: UIButton!
  
  //UIElements
  @IBOutlet weak var storyTextView: UITextView!
  
  //Custom User Initilization
  var mentor: Mentor?
  var story: Story? {
    didSet {
      setTextViewUI()
    }
  }
  
  
  //IBActons for buttons and exit segue
  @IBAction func dreamButtonPressed(_ sender: Any) {
    firstSelected = true
    updateButtonUI()
    setTextViewUI()
  }
  @IBAction func adviceButtonPressed(_ sender: Any) {
    firstSelected = false
    updateButtonUI()
    setTextViewUI()
  }
  
  @IBAction func shareButtonPressed(_ sender: Any) {
    performSegue(withIdentifier: "createStorySegue", sender: self)
  }
  
  @IBAction func exitToMentor(segue: UIStoryboardSegue) { }
  func setUpUI() {
    if let mentor = mentor {
      
      dreamerContainer.isHidden = true
      
      firstLine = UIView(frame: CGRect(x: 0,y: dreamButtom.frame.size.height - 2, width: dreamButtom.frame.size.width,height: 2))
      firstLine.backgroundColor = Helper.colorWithHexString(hex: "#02C576")
      
      secondLine = UIView(frame: CGRect(x:0,y: adviceButton.frame.size.height - 2,width: adviceButton.frame.size.width,height: 2))
      secondLine.backgroundColor=UIColor.clear
      
      dreamButtom.addSubview(firstLine)
      adviceButton.addSubview(secondLine)
      
      updateButtonUI()
      
      profileButton.setImage(mentor.profile.decodeToImage(), for: .normal)
      
      backgroundImageView.image = mentor.profile.decodeToImage()
      backgroundImageView.addBlurEffect(30, times: 1)
      
      profileButton.maskToCircle()
      nameLabel.text = mentor.name
      schoolLabel.text = "\(mentor.college) • \(mentor.major)"
      nationalityLabel.text = mentor.nationality
      
      if mentor.story != nil {
        setTextViewUI()
      }
      
    }
    
    shareButton.roundAndShadow(opacity: 0.0)
  }
  
  func setTextViewUI() {
    if firstSelected {
      storyTextView.text = mentor!.story?.about ?? ""
    } else {
      storyTextView.text = mentor!.story?.advice ?? ""
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "createStorySegue" {
      let vc = segue.destination as! CreateStoryViewController
      if let mentor = mentor {
        let story = mentor.story!
        print(story.advice)
        vc.story = story
        
      }
    }
    else if segue.identifier == "myMentorSegue" {
      let vc = segue.destination as! MyMentorViewController
      vc.story = selectedMentor!.story
      vc.dreamer = dreamer
    }
  }
}

extension MentorHomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
    
    let lowResImage = image.resizeImageWith(newSize: CGSize(width: 100, height: 100))
    profileButton.setImage(image, for: .normal)
    profileButton.maskToCircle()
    backgroundImageView.image = image
    backgroundImageView.addBlurEffect(30, times: 1)
    
    let firebaseHelper = FirebaseHelper()
    firebaseHelper.updateUserValue(key: "profile", value: lowResImage.encodeTo64())
    
    dismiss(animated:true, completion: nil)
  }
  
  func presentPhotoOptions() {
    let optionMenu = UIAlertController(title: nil, message: "Choose A Photo", preferredStyle: .actionSheet)
    let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: {
      (alert: UIAlertAction!) -> Void in
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
      {
        self.getProfilePic(fromSource: .camera)
      }
    })
    let choosePhotoAction = UIAlertAction(title: "Choose From Library", style: .default, handler: {
      (alert: UIAlertAction!) -> Void in
      
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
      {
        self.getProfilePic(fromSource: .photoLibrary)
      }
      
      print("choosing a photo from the library")
    })
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
    {
      (alert: UIAlertAction!) -> Void in
    })
    
    optionMenu.addAction(takePhotoAction)
    optionMenu.addAction(choosePhotoAction)
    optionMenu.addAction(cancelAction)
    
    self.present(optionMenu, animated: true, completion: nil)
  }
}

extension MentorHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return mentors.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StoryCollectionViewCell
    let mentor = mentors[indexPath.row]
    
    cell.profileImageView.image = mentor.profile.decodeToImage()
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedMentor = mentors[indexPath.row]
    performSegue(withIdentifier: "myMentorSegue", sender: self)
  }
}

extension MentorHomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let widthPerItem = (collectionView.frame.width) / 3
    
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
