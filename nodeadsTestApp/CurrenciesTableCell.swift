//
//  CurrenciesTableCell.swift
//  nodeadsTestApp
//
//  Created by Artem on 4/13/17.
//  Copyright © 2017 Artem Velykyy. All rights reserved.
//

import UIKit

class CurrenciesTableCell: UITableViewCell {
    
    @IBOutlet weak var baseCurrencyLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var saleRateNB: UILabel!
    @IBOutlet weak var purchaseRateNB: UILabel!
    @IBOutlet weak var saleRate: UILabel!
    @IBOutlet weak var purchaseRate: UILabel!

    override var reuseIdentifier: String? {
        return String(describing: type(of: self))
    }
    
}
