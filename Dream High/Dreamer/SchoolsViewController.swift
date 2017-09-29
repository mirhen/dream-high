//
//  SchoolsViewController.swift
//  Dream High
//
//  Created by Miriam Hendler on 9/14/17.
//  Copyright © 2017 Miriam Hendler. All rights reserved.
//

import UIKit
import Kingfisher

class SchoolsViewController: UIViewController {

    @IBOutlet weak var instituteLabel: UILabel!
    //Table View
    @IBOutlet weak var tableView: UITableView!
    @IBAction func exitToSchools(segue: UIStoryboardSegue) {}
    //Custom Variables
    var schools: [School] = []
    var institute: institution = .college
    var selectedSchool : School?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        instituteLabel.text = institute.rawValue.capitalized
        
        if institute == .college {
        let school1 = School(name: "UC Berkeley", image: UIImagePNGRepresentation(#imageLiteral(resourceName: "berkeley"))!, url: "https://undocu.berkeley.edu/")
        let school2 = School(name: "UCLA", image: UIImagePNGRepresentation(#imageLiteral(resourceName: "ucla"))!, url: "http://www.usp.ucla.edu/")
        let school3 = School(name: "UC Irvine", image: UIImagePNGRepresentation(#imageLiteral(resourceName: "uc_irvine"))!, url: "http://dreamers.uci.edu/")
        let school4 = School(name: "Stanford", image: UIImagePNGRepresentation(#imageLiteral(resourceName: "stanford"))!, url: "http://admission.stanford.edu/apply/undocumented/index.html")

        schools.append(school1!)
        schools.append(school2!)
        schools.append(school3!)
        schools.append(school4!)
            
        }
        // Do any additional setup after loading the view.
        
        let firebase = FirebaseHelper()
        firebase.retrieveSchools { (schools) in
            
            self.schools += schools
            self.tableView.reloadData()       
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "highSchoolSegue" {
            let destination = segue.destination as! HighSchoolViewController
            destination.school = selectedSchool
        }
    }
    func goToUrl(schoolUrl: String) {
        guard let url = URL(string: schoolUrl) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

extension SchoolsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schools.count
    }
    func tableView(_ tauntbleView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SchoolTableViewCell
        
        let school = schools[indexPath.row]
        
        if let image = school.image {
        cell.schoolImageView.image = UIImage(data: image)
        }
        
        if let image_url = school.image_url {
            let url = URL(string: image_url)
            cell.schoolImageView.kf.setImage(with: url)
        }
        cell.schoolLabel.text = school.name
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         selectedSchool = schools[indexPath.row]
        switch institute {
        case .college:
            goToUrl(schoolUrl: selectedSchool!.url)
        default:
           
            performSegue(withIdentifier: "highSchoolSegue", sender: self)
        }
        
        
        
    }
}
