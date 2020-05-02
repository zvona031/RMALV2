//
//  SqlDatabase.swift
//  LV2
//
//  Created by Zvonimir Pavlović on 29/04/2020.
//  Copyright © 2020 Zvonimir Pavlović. All rights reserved.
//
import Foundation
import SQLite3

class SqlDatabase {
    
    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?
    
    init()
    {
        db = openDatabase()
        if !UserDefaults.standard.bool(forKey: "FirstTimeLauched") {
            UserDefaults.standard.set(true, forKey: "FirstTimeLauched")
            UserDefaults.standard.synchronize()
            createPeopleTable()
            createQuotesTable()
        }
        
    }
    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createPeopleTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS person(Id TEXT PRIMARY KEY,name TEXT,sureName TEXT,imageName TEXT,dateOfBirth TEXT,dateOfDeath TEXT,description TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("person table created.")
            } else {
                print("person table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func createQuotesTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS quote(Id TEXT,quoteText TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("Quote table created.")
            } else {
                print("Quote table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func read() -> [InspiringPerson] {
        let queryStatementString = "SELECT * FROM person;"
        var queryStatement: OpaquePointer? = nil
        var psns : [InspiringPerson] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let sureName = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let imageName = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let dateOfBirth = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let dateOfDeath = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let description = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                let quotes = readQuotes(id: id)
                psns.append(InspiringPerson(id: id, name: name, sureName: sureName, imageName: imageName, dateOfBirth: dateOfBirth, dateOfDeath: dateOfDeath, description: description, quotes: quotes))
                print("Query Result:")
                print("\(id) | \(name) | \(sureName) | \(imageName) | \(dateOfBirth) | \(dateOfDeath) | \(description)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func readQuotes(id: String) -> [String] {
        let queryStatementString = "SELECT * FROM quote WHERE Id = ?;"
        var queryStatement: OpaquePointer? = nil
        var quotes : [String] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, (id as NSString).utf8String, -1, nil)
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let quote = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                quotes.append(quote)
                print("Quote results:")
                 print("\(id) | \(quote) ")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return quotes
    }
    
    func insert(name:String,sureName: String, imageName: String, dateOfBirth: String, dateOfDeath: String, description: String,quotes: [String])
    {
        let uuid = UUID().uuidString
        let persons = read()
        for p in persons
        {
            if p.id == uuid
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO person (Id, name, sureName, imageName, dateOfBirth, dateOfDeath, description) VALUES (?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (uuid as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (sureName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (imageName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (dateOfBirth as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (dateOfDeath as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, (description as NSString).utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
        for quote in quotes {
            insertQuotes(id: uuid, quote: quote)
        }
    }
    
    func insertQuotes(id:String, quote: String) {
        let insertStatementString = "INSERT INTO quote (Id, quoteText) VALUES (?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (quote as NSString).utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func deleteByID(id:String) {
        let deleteStatementStirng = "DELETE FROM person WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 1, (id as NSString).utf8String, -1, nil)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func edit(id: String, name:String,sureName: String, imageName: String, dateOfBirth: String, dateOfDeath: String, description: String,quotes: [String]){
        let updateStatementString = "UPDATE person SET name = ?, sureName = ?, imageName = ?, dateOfBirth = ?, dateOfDeath = ?, description = ? WHERE Id = ?"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (sureName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 3, (imageName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 4, (dateOfBirth as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 5, (dateOfDeath as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 6, (description as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 7, (id as NSString).utf8String, -1, nil)
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully edited row.")
            } else {
                print("Could not edit row.")
            }
        }else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
        editQuotes(id: id, quotes: quotes)
    }
    
    func editQuotes(id: String, quotes: [String]){
        deleteQuotes(id: id)
        for quote in quotes {
            insertQuotes(id: id, quote: quote)
        }
    }
    
    func deleteQuotes(id: String){
        let deleteStatementStirng = "DELETE FROM quote WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 1, (id as NSString).utf8String, -1, nil)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
}
