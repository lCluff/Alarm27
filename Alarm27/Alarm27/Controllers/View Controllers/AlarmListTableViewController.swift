//
//  AlarmListTableViewController.swift
//  Alarm27
//
//  Created by Leah Cluff on 6/17/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import UIKit

protocol AlarmTableViewCellDelegate: class {
    func alarmWasToggled(sender: AlarmDetailsTableViewCell)
}


class AlarmListTableViewController: UITableViewController, AlarmTableViewCellDelegate, AlarmScheduler {
    
    func alarmWasToggled(sender: AlarmDetailsTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else {return}
        let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
        AlarmController.sharedInstance.toggleIsEnabled(for: alarm)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.sharedInstance.alarms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? AlarmDetailsTableViewCell else {return UITableViewCell()}
        let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
        cell.alarm = alarm
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
            AlarmController.sharedInstance.delete(alarm: alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }    
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlarmVController"{
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
            let destinationVC = segue.destination as? AlarmDetailTableViewController
            destinationVC?.alarm = alarm
        }
    }
}
