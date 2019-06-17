//
//  AppDelegate.swift
//  Alarm27
//
//  Created by Leah Cluff on 6/17/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AlarmController.sharedInstance.alarms = AlarmController.sharedInstance.loadFromPersistentStore()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]){  (accepted, error) in
            if !accepted{
                print("Notification access has been denied")
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}


