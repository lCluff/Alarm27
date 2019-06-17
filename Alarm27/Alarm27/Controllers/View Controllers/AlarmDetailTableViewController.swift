//
//  AlarmDetailTableViewController.swift
//  Alarm27
//
//  Created by Leah Cluff on 6/17/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    
    var alarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            self.updateViews()
        }
    }
    
    var alarmIsOn: Bool = true
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var alarmEnabledButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateViews() {
        guard let alarm = alarm else {return}
        alarmIsOn = alarm.isEnabled
        datePicker.date = alarm.fireDate
        titleTextField.text = alarm.name
        setUpAlarmButton()
    }
    
    func setUpAlarmButton(){
        switch alarmIsOn {
        case true:
            alarmEnabledButton.backgroundColor = UIColor.lightGray
            alarmEnabledButton.setTitle("Enabled", for: .normal)
        case false:
            alarmEnabledButton.backgroundColor = UIColor.red
            alarmEnabledButton.setTitle("Disabled", for: .normal)
        }
    }
    
    @IBAction func alarmEnabledButtonTapped(_ sender: UIBarButtonItem) {
        if let alarm = alarm {
            AlarmController.sharedInstance.toggleIsEnabled(for: alarm)
            alarmIsOn = alarm.isEnabled
        }else {
            alarmIsOn = !alarmIsOn
            if let alarm = self.alarm{
                AlarmController.sharedInstance.update(alarm: alarm, name: title!, fireDate: datePicker.date, isEnabled: false)
            }
        }
        self.navigationController?.popViewController(animated: true)
        setUpAlarmButton()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text else {return}
        guard title != "" else {return}
        if let alarm = alarm{
            AlarmController.sharedInstance.update(alarm: alarm, name: title, fireDate: datePicker.date, isEnabled: alarmIsOn)
        } else {
            AlarmController.sharedInstance.create(name: title, fireDate: datePicker.date, isEnabled: alarmIsOn)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

