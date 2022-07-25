//
//  HourCell.swift
//  Weatherly
//
//  Created by Aleksandr on 24.07.2022.
//

import UIKit

protocol HourCellModel {
    var time: String { get }
    var temperature: String { get }
    var icon: UIImage? { get }
}

class HourCell: UICollectionViewCell {

    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    var model: HourCellModel? {
        willSet(model) {
            timeLabel.text = model?.time
            temperatureLabel.text = model?.temperature
            iconImageView.image = model?.icon
        }
    }
}
