//
//  CreateStoryViewController.swift
//  Dream High
//
//  Created by Miriam Hendler on 9/13/17.
//  Copyright © 2017 Miriam Hendler. All rights reserved.
//

import UIKit

class CreateStoryViewController: UIViewController {
    
    //UI Outlets
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    
    //IBActions
    @IBAction func nextButtonPressed(_ sender: Any) {
        if isCompleted() {
        performSegue(withIdentifier: "adviceSegue", sender: self)
        } else {
            Helper.showAlert(controller: self)
        }
    }
    @IBAction func backButtonPressed(_ sender: Any) {
    }
    @IBAction func exitToCreateStory(segue: UIStoryboardSegue) {}
    
    //Custom Vars
    var story: Story?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answerTextView.delegate = self
        answerTextView.text = story!.about
        
        if (story == nil) {
        answerTextView.text = "Type Something"
        answerTextView.textColor = .lightGray
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isCompleted() -> Bool {
        if answerTextView.text! != "Type Something"  || answerTextView.text! != "" {
            return true
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "adviceSegue" {
            let vc = segue.destination as! AdviceViewController
            story!.about = answerTextView.text!
            vc.story = story!
            
        }
    }
}

extension CreateStoryViewController: UITextViewDelegate {

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
