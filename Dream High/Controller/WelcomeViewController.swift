//
//  WelcomeViewController.swift
//  Dream High
//
//  Created by Miriam Hendler on 9/12/17.
//  Copyright © 2017 Miriam Hendler. All rights reserved.
//

import UIKit

final class WelcomeViewController: UIViewController {
    @IBOutlet weak var welcomeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        welcomeButton.roundAndShadow()
    }
}
