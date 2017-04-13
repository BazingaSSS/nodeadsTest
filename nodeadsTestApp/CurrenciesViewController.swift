//
//  CurrenciesViewController.swift
//  nodeadsTestApp
//
//  Created by Artem on 4/13/17.
//  Copyright © 2017 Artem Velykyy. All rights reserved.
//

import UIKit

class CurrenciesViewController: UIViewController {

   
    @IBOutlet weak var tableView: UITableView!
    
    var currenciesArray: [CurrencyModel]! = []
    var date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(currenciesArray)
        self.tableView.register(CurrenciesTableCell.self)
        //self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Do any additional setup after loading the view.
    }

    
    }

extension CurrenciesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currenciesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CurrenciesTableCell = self.tableView.dequeueReusableCell(withCellClass: CurrenciesTableCell.self, for: indexPath)
        
        
        cell.baseCurrencyLabel.text = currenciesArray[indexPath.row].baseCurrency
        cell.currencyLabel.text = currenciesArray[indexPath.row].currency
        cell.purchaseRate.text = String(describing: currenciesArray[indexPath.row].purchaceRate)
        cell.purchaseRateNB.text = String(currenciesArray[indexPath.row].purchaseRateNB)
        cell.saleRate.text = String(describing: currenciesArray[indexPath.row].saleRate)
        cell.saleRateNB.text = String(currenciesArray[indexPath.row].saleRateNB)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

