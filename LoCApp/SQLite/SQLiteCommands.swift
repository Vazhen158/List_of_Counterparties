//
//  SQLiteCommands.swift
//  LoCApp
//
//  Created by Андрей Важенов on 21.09.2021.
//

import Foundation
import SQLite

class SQLiteCommands {
    static var table = Table("counterparty")
    
    static let id = Expression<Int>("id")
    static let name = Expression<String>("name")
    static let phoneNumber = Expression<String>("phoneNumber")
    static let photo = Expression<Data>("photo")
    static let email = Expression<String>("email")
    static func createTable() {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return
        }
        
        do {
            // ifNotExists: true - Will NOT create a table if it already exists
            try database.run(table.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(email)
                table.column(phoneNumber, unique: true)
                table.column(photo)
            })
        } catch {
            print("Table already exists: \(error)")
        }
    }
    static func insertRow(_ counterpartyValues:Counterparty) -> Bool? {
        
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        do {
            try database.run(table.insert(name <- counterpartyValues.name, email <- counterpartyValues.email, phoneNumber <- counterpartyValues.phoneNumber, photo <- counterpartyValues.photo))
            return true
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
            print("Insert row failed: \(message), in \(String(describing: statement))")
            return false
        } catch let error {
            print("Insertion failed: \(error)")
            return false
        }
        
    }
    static func updateRow(_ counterpartyValues: Counterparty) -> Bool? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        let counterparty = table.filter(id == counterpartyValues.id).limit(1)
        
        do {
            // Update the Counterparty values
            if try database.run(counterparty.update(name <- counterpartyValues.name, email <- counterpartyValues.email, phoneNumber <- counterpartyValues.phoneNumber, photo <- counterpartyValues.photo)) > 0 {
                print("Updated Counterparty")
                return true
            } else {
                print("Could not update Counterparty: Counterparty not found")
                return false
            }
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
            print("Update row faild: \(message), in \(String(describing: statement))")
            return false
        } catch let error {
            print("Updation failed: \(error)")
            return false
        }
        
    
}
    static func presentRows() -> [Counterparty]? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        
        // counterparty Array
        var counterpartyArray = [Counterparty]()
        
        // Sorting data in descending order by ID
        table = table.order(id.desc)
        
        do {
            for counterparty in try database.prepare(table) {
                
                let idValue = counterparty[id]
                let nameValue = counterparty[name]
                let phoneNumberValue = counterparty[phoneNumber]
                let photoValue = counterparty[photo]
                let emailValue = counterparty[email]
                
                // Create object
                let counterpartyObject = Counterparty(id: idValue, name: nameValue, phoneNumber: phoneNumberValue, photo: photoValue, email: emailValue)
                
                // Add object to an array
                counterpartyArray.append(counterpartyObject)
                
                print("id \(counterparty[id]), name: \(counterparty[name]), email: \(counterparty[email]), phoneNumber: \(counterparty[phoneNumber]), photo: \(counterparty[photo])")
            }
        } catch {
            print("Present row error: \(error)")
        }
        return counterpartyArray
    }
    static func deleteRow(counterpartyId: Int) {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return
        }
        
        do {
            let counterparty = table.filter(id == counterpartyId).limit(1)
            try database.run(counterparty.delete())
        } catch {
            print("Delete row error: \(error)")
        }
    }
    
}
