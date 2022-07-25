//
//  DaysCell.swift
//  Weatherly
//
//  Created by Aleksandr on 22.07.2022.
//

import UIKit

protocol DayCellModel {
    var dayOfWeek: String { get }
    var temperature: String { get }
    var icon: UIImage? { get }
}

class DayCell: UITableViewCell {

    @IBOutlet private weak var dayOfWeekLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var weatherImageView: UIImageView!
    
    var model: DayCellModel? {
        willSet(model) {
            dayOfWeekLabel.text = model?.dayOfWeek
            temperatureLabel.text = model?.temperature
            weatherImageView.image = model?.icon
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        updateUI()
    }
}

// MARK: - Private methods
private extension DayCell {
    func updateUI() {
        dayOfWeekLabel.textColor = isSelected ? R.color.daysCell_selected() : R.color.daysCell_unselected()
        temperatureLabel.textColor = isSelected ? R.color.daysCell_selected() : R.color.daysCell_unselected()
        weatherImageView.tintColor = isSelected ? R.color.daysCell_selected() : R.color.daysCell_unselected()
    }
}
