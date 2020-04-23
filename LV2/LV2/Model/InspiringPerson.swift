//
//  InspiringPeople.swift
//  LV2
//
//  Created by Zvonimir Pavlović on 22/04/2020.
//  Copyright © 2020 Zvonimir Pavlović. All rights reserved.
//

import Foundation

class InspiringPerson: Equatable {
    
    var id: String
    var imageName: String
    var name: String
    var sureName: String
    var dateOfBirth: String
    var dateOfDeath: String
    var description: String
    var quotes : [String] = []
    
    init(id: String, name: String, sureName: String, imageName: String, dateOfBirth: String,dateOfDeath: String, description: String,quotes: [String]) {
        self.id = id
        self.name = name
        self.sureName = sureName
        self.imageName = imageName
        self.dateOfBirth = dateOfBirth
        self.dateOfDeath = dateOfDeath
        self.description = description
        self.quotes = quotes
    }
    
    static func == (lhs: InspiringPerson, rhs: InspiringPerson) -> Bool {
        return lhs.id == rhs.id
    }
    
}
