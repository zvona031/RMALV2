//
//  PeopleViewModel.swift
//  LV2
//
//  Created by Zvonimir Pavlović on 23/04/2020.
//  Copyright © 2020 Zvonimir Pavlović. All rights reserved.
//

import Foundation

class PeopleViewModel {
    
    func removePerson(at: Int){
        let person = PeopleRepo.shared.getPerson(at: at)
        PeopleRepo.shared.removeFromRepo(person: person)
    }
    
    func getCount() -> Int{
        return PeopleRepo.shared.getAll().count
    }
    
    func getPerson(at: Int) -> InspiringPerson {
        return PeopleRepo.shared.getPerson(at: at)
    }
    
}
