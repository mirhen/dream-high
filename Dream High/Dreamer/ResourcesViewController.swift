//
//  ResourcesViewController.swift
//  Dream High
//
//  Created by Miriam Haart on 9/22/17.
//  Copyright © 2017 Miriam Hendler. All rights reserved.
//

import UIKit

class ResourcesViewController: UIViewController {
    @IBOutlet var tableview: UITableView!
    @IBAction func exitToResources(segue: UIStoryboardSegue) {}
    
    var resources: [School] = []
    var institute : institution = .college
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        
//        let resource1 = School(.name: "Daring High School", image: UIImagePNGRepresentation(#imageLiteral(resourceName: "high-schools"))!, url: "")
        let resource2 = School(name: "Daring Colleges", image: UIImagePNGRepresentation(#imageLiteral(resourceName: "colleges"))!, url: "")
        
//        resources.append(resource1!)
        resources.append(resource2!)
        
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "schoolsSegue" {
            let destination = segue.destination as! SchoolsViewController
            
            destination.institute = institute
        }
    }

}

extension ResourcesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resources.count
    }
    func tableView(_ tauntbleView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SchoolTableViewCell
        
        let school = resources[indexPath.row]
        
        if let image = school.image {
            cell.schoolImageView.image = UIImage(data: image)
        }

        cell.schoolLabel.text = school.name
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            institute = .high_school
        }
        else if indexPath.row == 0 {
            institute = .college
        }
        performSegue(withIdentifier: "schoolsSegue", sender: self)
    }
}
