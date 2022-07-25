//
//  UICollectionView+Extension.swift
//  Weatherly
//
//  Created by Aleksandr on 24.07.2022.
//

import UIKit

extension UICollectionView {
    func register<Cell: UICollectionViewCell>(cell: Cell.Type) {
        let cellClassName = String(describing: cell.self)
        let nib = UINib(nibName: cellClassName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: cellClassName)
    }
    
    func dequeueReusable<Cell: UICollectionViewCell>(cell: Cell.Type, for indexPath: IndexPath) -> Cell {
        let cellClassName = String(describing: cell.self)
        let cell = dequeueReusableCell(withReuseIdentifier: cellClassName, for: indexPath)
        guard let typedCell = cell as? Cell else { fatalError("Could not deque cell with type \(Cell.self)") }
        return typedCell
    }
}
