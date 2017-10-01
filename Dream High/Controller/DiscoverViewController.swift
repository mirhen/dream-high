//
//  DiscoverViewController.swift
//  Dream High
//
//  Created by Miriam Hendler on 9/13/17.
//  Copyright © 2017 Miriam Hendler. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
  //Posts UI Element
  @IBOutlet weak var collectionView: UICollectionView!
  
  //User Initilizing
  var dreamer: Dreamer?
  var mentor: Mentor?
  
  //Stories Array
  var stories: [Story] = [] {
    didSet {
      collectionView.reloadData()
    }
  }
  var selectedStory: Story?
  
  //IBAction exitSegues
  @IBAction func exitToDiscovery(segue: UIStoryboardSegue) {}
  
  //Collection vars
  let itemsPerRow: CGFloat = 3
  let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.delegate = self
    collectionView.dataSource = self
    
    let firebaseHelper = FirebaseHelper()
    firebaseHelper.retrieveStories(vc: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "storySegue" {
      let vc = segue.destination as! StoryViewController
      if let story = selectedStory {
        vc.story = story
        vc.dreamer = dreamer
      }
    }
  }
}

extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return stories.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "storyCell", for: indexPath) as! StoryCollectionViewCell
    let story = stories[indexPath.row]
    
    cell.profileImageView.image = story.mentor.profile.decodeToImage()
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedStory = stories[indexPath.row]
    performSegue(withIdentifier: "storySegue", sender: self)
  }
  
}
extension DiscoverViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    
    let widthPerItem = (collectionView.frame.width) / itemsPerRow
    
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}

