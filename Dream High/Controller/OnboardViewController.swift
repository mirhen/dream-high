//
//  OnboardViewController.swift
//  Dream High
//
//  Created by Miriam Hendler on 9/12/17.
//  Copyright © 2017 Miriam Hendler. All rights reserved.
//

import UIKit

class OnboardViewController: UIViewController {

    //Button IBOutlets
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    //Exit Segue
    @IBAction func exitToOnboard(segue: UIStoryboardSegue){}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //IBActions
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "signUpSegue", sender: self)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "loginSegue", sender: self)
    }
    
    
    // Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! LoginViewController
        if segue.identifier == "loginSegue" {
            vc.isLogin = true
        } else {
            vc.isLogin = false
        }
    }
    

    // Helpers
    
    func setUpUI() {
        signUpButton.roundAndShadow(radius: 20, opacity: 0.0, borderWidth: 1, borderColor: UIColor.white.cgColor)
        loginButton.roundAndShadow(radius: 20, opacity: 0.0)

    }
    

}
