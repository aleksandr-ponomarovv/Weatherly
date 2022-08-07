//
//  DescriptionCell.swift
//  Weatherly
//
//  Created by Aleksandr on 07.08.2022.
//

import UIKit

protocol DescriptionCellModel {
    var title: String { get }
    var value: String { get }
}

class DescriptionCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
    var model: DescriptionCellModel? {
        willSet(model) {
            titleLabel.text = model?.title
            valueLabel.text = model?.value
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}
