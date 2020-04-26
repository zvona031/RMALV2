//
//  AddEditViewModel.swift
//  LV2
//
//  Created by Zvonimir Pavlović on 22/04/2020.
//  Copyright © 2020 Zvonimir Pavlović. All rights reserved.
//

import Foundation

class AddEditViewModel {
        
    var person: InspiringPerson?
    var quotes: [String] = []
    
    init(person: InspiringPerson? = nil) {
        self.person = person
    }
    
    func addPeople(name: String, sureName: String,imageName: String,dateOfBirth: String,dateOfDeath: String,description: String){
        PeopleRepo.shared.addToRepo(name: name, sureName: sureName,imageName: imageName,dateOfBirth: dateOfBirth,dateOfDeath: dateOfDeath,description: description,quotes: quotes)
    }
    
    func editPeople(id: String,name: String, sureName: String,imageName: String,dateOfBirth: String,dateOfDeath: String,description: String){
        PeopleRepo.shared.editInRepo(id: id, name: name, sureName: sureName, imageName: imageName, dateOfBirth: dateOfBirth, dateOfDeath: dateOfDeath, description: description,quotes: quotes)
    }
    
    func addQuote(quote: String){
        quotes.append(quote)
    }
    
    func removeQuote(at: Int){
        quotes.remove(at: at)
    }
    
    func getQouteNumber() -> Int{
        return quotes.count
    }
    
    
    
}
