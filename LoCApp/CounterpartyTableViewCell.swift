//
//  CounterpartyTableViewCell.swift
//  LoCApp
//
//  Created by Андрей Важенов on 21.09.2021.
//

import UIKit

class CounterpartyTableViewCell: UITableViewCell {

    @IBOutlet var counterpartyNameLabel: UILabel!
    @IBOutlet var counterpartyPhoneLabel: UILabel!
    @IBOutlet var counterpartyEmailLabel: UILabel!
    @IBOutlet var counterpartyPhotoImageView: UIImageView!
    
    func setCellWithValuesOf(_ counterparty: Counterparty) {
        
        counterpartyNameLabel.text = counterparty.name
        counterpartyPhoneLabel.text = counterparty.phoneNumber
        counterpartyEmailLabel.text = counterparty.email
        
        let image = UIImage(data: counterparty.photo)
        counterpartyPhotoImageView.image = image
        counterpartyPhotoImageView.makeRounded()
    
    }

}
extension UIImageView {
    func makeRounded() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
