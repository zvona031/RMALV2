//
//  PersonCell.swift
//  LV2
//
//  Created by Zvonimir Pavlović on 22/04/2020.
//  Copyright © 2020 Zvonimir Pavlović. All rights reserved.
//

import Foundation
import UIKit

protocol PersonCellDelegate: class {
    func imageClicked(quote: String)
}

class PersonCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var delegate: PersonCellDelegate?
    
    var person: InspiringPerson? {
        didSet{
            bindView()
        }
    }
    
    func bindView(){
        if let person = self.person {
            let imageData = try? Data(contentsOf: URL(string: person.imageName)!)
            let image = UIImage(data: imageData!)
            let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onImageClicked))
            profileImage.isUserInteractionEnabled = true
            profileImage.addGestureRecognizer(imageTapRecognizer)
            profileImage.contentMode = .scaleAspectFill
            profileImage.image = image
            nameLabel.text = person.name + " " + person.sureName
            dateLabel.text = person.dateOfBirth + "-" + person.dateOfDeath
            descriptionLabel.text = person.description
            descriptionLabel.sizeToFit()
        }
    }
    
    @objc func onImageClicked(){
        if let printedQuote = person?.quotes.randomElement(){
            delegate?.imageClicked(quote: printedQuote)
        }else{
            delegate?.imageClicked(quote: "No quotes!")
        }
        
    }
}
