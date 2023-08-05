//
//  popularPeopleCell.swift
//  PopularPeople
//
//  Created by NadaAshraf on 03/08/2023.
//

import UIKit

class popularPeopleCell: UITableViewCell {
 
    // MARK: - IBOutlets
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var knownFor: UILabel!
    @IBOutlet weak var peopleImage: UIImageView!
  
    // MARK: - Class Constants
    static let identifier = "personCell"

    //MARK: - Public functions
    func configure(popularPeopleDictionary: [String: Any]) {
        //Update Data
        title.text = popularPeopleDictionary[Constants.name] as? String ?? ""
        knownFor.text = popularPeopleDictionary[Constants.knownFor] as? String ?? ""
    }
    
    func configureImage( _ image : UIImage) {
        peopleImage.image = image
    }
    
}
