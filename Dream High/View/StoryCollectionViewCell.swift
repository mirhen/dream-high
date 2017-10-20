//
//  StoryCollectionViewCell.swift
//  Dream High
//
//  Created by Miriam Hendler on 9/13/17.
//  Copyright © 2017 Miriam Hendler. All rights reserved.
//

import UIKit

class StoryCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var profileImageView: UIImageView!
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.profileImageView.image = nil
  }
}
