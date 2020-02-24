//
//  AppDelegate.swift
//  TochkaNewsFeed
//
//  Created by den on 21.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let viewController = MainViewController(viewModel: MainScreenViewModel())
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.shared.saveContext()
    }
}
