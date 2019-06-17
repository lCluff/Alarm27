//
//  Alarm.swift
//  Alarm27
//
//  Created by Leah Cluff on 6/17/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import Foundation

class Alarm: Codable {
    
    //MARK: - Properties
    var name: String
    var fireDate: Date
    var isEnabled: Bool
    var uuid: String 
    
    init(fireDate: Date, name: String, isEnabled: Bool = true, uuid: String = UUID().uuidString) {
        self.name = name
        self.fireDate = fireDate
        self.isEnabled = isEnabled
        self.uuid = uuid
    }
    
    var fireTimeAsString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: fireDate)
    }
}

//MARK: - Equatable
extension Alarm: Equatable {
    static func ==(rhs: Alarm, lhs:Alarm) -> Bool {
        return rhs.uuid == lhs.uuid
    }
}
