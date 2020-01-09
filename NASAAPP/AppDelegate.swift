//
//  AppDelegate.swift
//  NASAAPP
//
//  Created by Andrew Graves on 1/2/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

// MARK: Comment about app preformance testing

// To test the preformance, I used instruments to see which tasks were taking a longer time to load and the number of those tasks. I found that there were a large amount of calls being made to refresh the CollectionView that were taking away system resourses and causing some other problems. Then I went back and moved all the refreshing code for images from the ViewController to the image cell. After it was moved the app preformed much better and had much less of an overhead on system resourses!

