//
//  UITableView+Extension.swift
//  Weatherly
//
//  Created by Aleksandr on 22.07.2022.
//

import UIKit

extension UITableView {
    func register<Cell: UITableViewCell>(cell: Cell.Type) {
        let cellClassName = String(describing: cell.self)
        let nib = UINib(nibName: cellClassName, bundle: nil)
        register(nib, forCellReuseIdentifier: cellClassName)
    }

    func dequeueReusable<Cell: UITableViewCell>(cell: Cell.Type, for indexPath: IndexPath) -> Cell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: cell.self), for: indexPath)
        guard let typedCell = cell as? Cell else { fatalError("Could not deque cell with type \(Cell.self)") }
        return typedCell
    }
}
