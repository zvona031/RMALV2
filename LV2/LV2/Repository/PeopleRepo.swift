//
//  PeopleRepo.swift
//  LV2
//
//  Created by Zvonimir Pavlović on 22/04/2020.
//  Copyright © 2020 Zvonimir Pavlović. All rights reserved.
//

import Foundation

class PeopleRepo {
    
    static let shared : PeopleRepo = PeopleRepo()
    private var list : [InspiringPerson] = []
    
    func addToRepo(name: String, sureName: String,imageName: String,dateOfBirth: String,dateOfDeath: String,description: String,quotes: [String]) {
        let id = UUID().uuidString
        list.append(InspiringPerson(id: id,name: name, sureName: sureName, imageName: imageName, dateOfBirth: dateOfBirth, dateOfDeath: dateOfDeath, description: description,quotes: quotes))
    }
    
    func editInRepo(id: String,name: String, sureName: String,imageName: String,dateOfBirth: String,dateOfDeath: String,description: String,quotes: [String]){
        if let index = list.firstIndex(where: {$0.id == id}) {
            list[index].name = name
            list[index].sureName = sureName
            list[index].imageName = imageName
            list[index].dateOfBirth = dateOfBirth
            list[index].dateOfDeath = dateOfDeath
            list[index].description = description
            list[index].quotes = quotes
        }
    }
    
    func removeFromRepo(person: InspiringPerson){
        if let index = list.firstIndex(of: person){
            list.remove(at: index)
        }
    }
    
    func getAll() -> [InspiringPerson]{
        return list
    }
    
    func getPerson(at: Int)-> InspiringPerson {
        return list[at]
    }
}
