//
//  TextCell.swift
//  Weatherly
//
//  Created by Aleksandr on 25.07.2022.
//

import UIKit

class TextCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    
    var title: String? {
        willSet {
            titleLabel.text = newValue
        }
    }
}
