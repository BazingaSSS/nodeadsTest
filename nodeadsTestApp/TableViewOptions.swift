//
//  TableViewOptions.swift
//  nodeadsTestApp
//
//  Created by Artem on 4/12/17.
//  Copyright © 2017 Artem Velykyy. All rights reserved.
//

import UIKit

public func toStringType(_ cls: AnyClass) -> String {
    return String(describing: cls)
}

extension UINib {
    convenience init(_ viewClass: AnyClass) {
        self.init(nibName: toStringType(viewClass.self), bundle: nil)
    }
}

extension UITableView {
    func registerCells(_ cells: [UITableViewCell]) {
        cells.forEach {self.register(type(of: $0))}
    }
    
    
    func register(_ cellClass: AnyClass) {
        self.register(UINib(cellClass), forCellReuseIdentifier: toStringType(cellClass))
    }
    
    func dequeueReusableCell<T: UITableViewCell>(withCellClass cellClass: AnyClass, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: toStringType(cellClass), for: indexPath) as? T else {
            fatalError()
        }
        
        return cell
        
    }
    
}
