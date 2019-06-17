//
//  AlarmDetailsTableViewCell.swift
//  Alarm27
//
//  Created by Leah Cluff on 6/17/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import UIKit

protocol AlarmTableViewCellDelegate: class {
    func alarmWasToggled(sender: AlarmDetailsTableViewCell)
}


class AlarmDetailsTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var alarmSwitch: UISwitch!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var alarm: Alarm?{
        didSet{
            updateViews()
        }
    }
    
    weak var delegate: AlarmTableViewCellDelegate?
    
    //MARK: - Functions
    func updateViews() {
        guard let alarm = alarm else {return}
        timeLabel.text = alarm.fireTimeAsString
        nameLabel.text = alarm.name
        alarmSwitch.isOn = alarm.isEnabled
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Actions
    @IBAction func switchValueChanged(_ sender: Any) {
        delegate?.alarmWasToggled(sender: self)
    }
}

