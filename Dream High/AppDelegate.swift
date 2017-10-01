//
//  AppDelegate.swift
//  Dream High
//
//  Created by Miriam Hendler on 9/12/17.
//  Copyright © 2017 Miriam Hendler. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var currentUser: Any?
  var userAccount: account?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    IQKeyboardManager.sharedManager().enable = true
    
    // This state need some clarification
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    
    if launchedBefore  {
      Auth.auth().addStateDidChangeListener { auth, user in
        if let user = user {
          
          // User is signed in.
          let fireBaseHelper = FirebaseHelper()
          
          fireBaseHelper.uploadSchools()
          
          fireBaseHelper.retrieveUser(uid: user.uid, callback: { (person) in
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarC = storyboard.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
            let vc = tabBarC.viewControllers?.first as! DiscoverViewController
            
            if let mentor = person as? Mentor {
              let mentorVC = tabBarC.viewControllers?.last as! MentorHomeViewController
              mentorVC.mentor = mentor
              
              vc.mentor = mentor
              self.currentUser = mentor
              self.userAccount  = .mentor
              
              self.window?.rootViewController = tabBarC
              self.window?.makeKeyAndVisible()
            }
            if let dreamer = person as? Dreamer {
              let mentorVC = tabBarC.viewControllers?.last as! MentorHomeViewController
              mentorVC.dreamer = dreamer
              
              vc.dreamer = dreamer
              self.currentUser = dreamer
              self.userAccount  = .dreamer
              
              //                            fireBaseHelper.retrieveMentors(vc: mentorVC)
              self.window?.rootViewController = tabBarC
              self.window?.makeKeyAndVisible()
            }
            
          })
        } else {
          self.setInitialView(withIdentifier: "Login")
        }
      }
    } else {
      UserDefaults.standard.set(true, forKey: "launchedBefore")
      self.setInitialView(withIdentifier: "FirstLaunch")
    }
    return true
  }
  
  func setInitialView(withIdentifier: String) {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    let initialViewController = storyboard.instantiateViewController(withIdentifier: withIdentifier) as UIViewController
    self.window?.rootViewController = initialViewController
    self.window?.makeKeyAndVisible()
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  
}

class MyTabBarController: UITabBarController, UINavigationControllerDelegate {
  
  override func viewDidLoad() {
    
    // Sets the default color of the icon of the selected UITabBarItem and Title
    UITabBar.appearance().tintColor = UIColor.white
    
    // Sets the default color of the background of the UITabBar
    UITabBar.appearance().barTintColor = .white
    
    // Sets the background color of the selected UITabBarItem (using and plain colored UIImage with the width = 1/5 of the tabBar (if you have 5 items) and the height of the tabBar)
    UITabBar.appearance().selectionIndicatorImage = UIImage().makeImageWithColorAndSize(color: Helper.colorWithHexString(hex: "#02C576"), size: CGSize(width:tabBar.frame.width/2,height: tabBar.frame.height))
    let images: [UIImage] = [#imageLiteral(resourceName: "story"), #imageLiteral(resourceName: "user_unselected")]
    // Uses the original colors for your images, so they aren't not rendered as grey automatically.
    var count = 0
    for item in self.tabBar.items! as [UITabBarItem] {
      //            if let image = item.image {
      
      item.image = images[count].withRenderingMode(.alwaysOriginal)
      count += 1
      //            }
    }
  }
  
  
}
