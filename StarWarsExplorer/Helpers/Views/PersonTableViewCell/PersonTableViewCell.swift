//
//  PersonTableViewCell.swift
//  StarWarsExplorer
//
//  Created by Максим Скрябин on 30/11/2018.
//  Copyright © 2018 MSKR. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var filmsCounterView: CounterView!
    @IBOutlet weak var speciesCounterView: CounterView!
    @IBOutlet weak var vehiclesCounterView: CounterView!
    @IBOutlet weak var starshipsCounterView: CounterView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        filmsCounterView.backgroundColor = UIColor.white
        filmsCounterView.iconImageView.image = UIImage(named: "icon_film")
        speciesCounterView.backgroundColor = UIColor.white
        speciesCounterView.iconImageView.image = UIImage(named: "icon_species")
        vehiclesCounterView.backgroundColor = UIColor.white
        vehiclesCounterView.iconImageView.image = UIImage(named: "icon_vehicle")
        starshipsCounterView.backgroundColor = UIColor.white
        starshipsCounterView.iconImageView.image = UIImage(named: "icon_starship")
        
        nameLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
    }
    
}
