//
//  InformationCell.swift
//  Weatherly
//
//  Created by Aleksandr on 06.08.2022.
//

import UIKit

class InformationCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    
    var title: String? {
        willSet(title) {
            titleLabel.text = title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}
