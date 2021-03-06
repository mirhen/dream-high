//
//  AboutViewController.swift
//  moonshot_test
//
//  Created by Miriam Hendler on 9/5/17.
//  Copyright © 2017 Miriam Hendler. All rights reserved.
//

import UIKit
import MessageUI

final class AboutViewController: UIViewController {
  @IBAction func emailButtonPressed(_ sender: Any) {
    sendEmail()
  }
  
  @IBAction func designershipButtonPressed(_ sender: Any) {
    goToWebsite("designership.stanford.edu")
  }
  
  @IBAction func websiteButtonPressed(_ sender: Any) {
    goToWebsite("miriamhendler.com")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func goToWebsite(_ name: String) {
    let name_url = "http://\(name)"
    if let url = URL(string: name_url) {
      if #available(iOS 10.0, *) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      } else {
        UIApplication.shared.openURL(url)
        // Fallback on earlier versions
      }
    }
  }
}

extension AboutViewController: MFMailComposeViewControllerDelegate {
  func sendEmail() {
    let composeVC = MFMailComposeViewController()
    composeVC.mailComposeDelegate = self
    // Configure the fields of the interface.
    composeVC.setToRecipients(["miriamthendler@gmail.com"])
    composeVC.setSubject("Moonshot Feedback")
    composeVC.setMessageBody("", isHTML: false)
    // Present the view controller modally.
    self.present(composeVC, animated: true, completion: nil)
  }
  
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    // Dismiss the mail compose view controller.
    controller.dismiss(animated: true, completion: nil)
  }
  
}
