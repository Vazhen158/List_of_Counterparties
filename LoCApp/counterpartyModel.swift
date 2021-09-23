//
//  counterpartyModel.swift
//  LoCApp
//
//  Created by Андрей Важенов on 21.09.2021.
//

import Foundation

class CounterpartyModel {
    
     var counterpartyArray = [Counterparty]()
    
    
    
    func connectToDatabase() {
        _ = SQLiteDatabase.sharedInstance
    }
    
    func loadDataFromSQLiteDatabase() {
        counterpartyArray = SQLiteCommands.presentRows() ?? []
    }
    
    func numberOfRowsInSection (section: Int) -> Int {
        if counterpartyArray.count != 0 {
            return counterpartyArray.count
        }
        return 0
    }
    
    func cellForRowAt (indexPath: IndexPath) -> Counterparty {
        return counterpartyArray[indexPath.row]
    }
}
