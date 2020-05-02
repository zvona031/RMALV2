//
//  PeopleViewModel.swift
//  LV2
//
//  Created by Zvonimir Pavlović on 23/04/2020.
//  Copyright © 2020 Zvonimir Pavlović. All rights reserved.
//

import Foundation

class PeopleViewModel {
    
    var db: SqlDatabase = SqlDatabase()
    var people: [InspiringPerson] = []
    
    init() {
        self.getAll()
    }
    
    func removePerson(at: Int){
        let person = people[at]
        db.deleteByID(id: person.id)
        people.remove(at: at)
    }
    
    func getCount() -> Int{
        return people.count
    }
    
    func getPerson(at: Int) -> InspiringPerson {
        return people[at]
    }
    
    func getAll(){
        people = db.read()
    }
    
}
