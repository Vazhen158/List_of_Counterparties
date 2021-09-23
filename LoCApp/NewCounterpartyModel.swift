//
//  NewCounterpartyModel.swift
//  LoCApp
//
//  Created by Андрей Важенов on 21.09.2021.
//

import UIKit
import SQLite

 
class NewCounterpartyModel {
    private var counterpartyValues: Counterparty?
    
    let id: Int?
    let name: String?
    let phoneNumber: String?
    let email: String?
    let photo: UIImage?
    
    init(counterpartyValues: Counterparty?) {
        self.counterpartyValues = counterpartyValues
        self.id = counterpartyValues?.id
        self.name = counterpartyValues?.name
        self.phoneNumber = counterpartyValues?.phoneNumber
        self.email = counterpartyValues?.email
        self.photo = UIImage(data: counterpartyValues!.photo)
        }

    
}
