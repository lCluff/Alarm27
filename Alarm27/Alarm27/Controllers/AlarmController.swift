//
//  AlarmController.swift
//  Alarm27
//
//  Created by Leah Cluff on 6/17/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import Foundation
import UserNotifications

class AlarmController: AlarmScheduler {
    
    static let sharedInstance = AlarmController()
    
    var alarms: [Alarm] = []
    
    //MARK: - CRUD FUNCTIONS
    func create(name: String, fireDate: Date, isEnabled: Bool) {
       
        let alarm = Alarm(fireDate: fireDate, name: name)
        alarm.isEnabled = isEnabled
        AlarmController.sharedInstance.alarms.append(alarm)
        scheduleUserNotification(for: alarm)
        
        saveToPersistentStore()
    }
    
    func update(alarm: Alarm, name: String, fireDate: Date, isEnabled: Bool) {
        alarm.name = name
        alarm.fireDate = fireDate
        alarm.isEnabled = isEnabled
        scheduleUserNotification(for: alarm)
        cancelUserNotification(for: alarm)
       
        saveToPersistentStore()
    }
    
    func delete(alarm: Alarm) {
        guard let index = AlarmController.sharedInstance.alarms.firstIndex(of: alarm) else {return}
        alarms.remove(at: index)
        scheduleUserNotification(for: alarm)
       
        saveToPersistentStore()
    }
    
    func toggleIsEnabled(for alarm: Alarm) {
        alarm.isEnabled = !alarm.isEnabled
        if alarm.isEnabled{
            scheduleUserNotification(for: alarm)
        } else {
            cancelUserNotification(for: alarm)
        }
        
    }
    
    //MARK: - Persistence
    func fileURL() -> URL{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = path[0]
        let fileName = "alarm.json"
        let filelURL = documentsDirectory.appendingPathComponent(fileName)
        
        return filelURL
    }
    
    func saveToPersistentStore() {
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let data = try jsonEncoder.encode(alarms)
            try data.write(to: fileURL())
        } catch {
            print("Failed to save to persistent store\(error) \(error.localizedDescription)")
        }
    }
    
    func loadFromPersistentStore() -> [Alarm]{
        let jsonDecoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: fileURL())
            let alarms = try jsonDecoder.decode([Alarm].self, from: data)
            return alarms
        } catch {
            print("Failed to load from persistent store \(error) \(error.localizedDescription)")
        }
        return []
    }
}

//MARK: - Notification set up
protocol AlarmScheduler: class{
    func scheduleUserNotification(for alarm: Alarm)
    func cancelUserNotification(for alarm: Alarm)
}

extension AlarmScheduler{
    
    func scheduleUserNotification(for alarm: Alarm) {
        
        let content = UNMutableNotificationContent()
        content.title = "Wakey wakey eggs 'n bakey!"
        content.body = "\(alarm.name) is going off!"
        content.sound = UNNotificationSound.default
        
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: alarm.fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling user notifications \(error.localizedDescription) : \(error)")
            }
        }
    }
    
    func cancelUserNotification(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}

