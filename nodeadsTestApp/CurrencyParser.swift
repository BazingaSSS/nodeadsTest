//
//  CurrencyParser.swift
//  nodeadsTestApp
//
//  Created by Artem on 4/13/17.
//  Copyright © 2017 Artem Velykyy. All rights reserved.
//

import UIKit

class CurrencyParser: NSObject {
    typealias Model = ArchiveCurrencyModel
    
    var jsonDictionary: [[String:Any]]!
    
    var date: String
    
    init(json:[[String:Any]], for Date: String) {
        self.jsonDictionary = json
        self.date = Date
    }

    func parse() -> Model {
        var objectNews = [CurrencyModel]()
        for object in jsonDictionary {
            objectNews.append(CurrencyModel(
                //date: object["date"] as! Date,
                baseCurrency: object["baseCurrency"] as? String ?? "",
                currency: object["currency"] as? String ?? "",
                saleRateNB: object["saleRateNB"] as? Double ?? 0,
                purchaseRateNB: object["purchaseRateNB"] as? Double ?? 0,
                saleRate: object["saleRate"] as? Double ?? 0,
                purchaceRate: object["purchaseRate"] as? Double ?? 0))
        }
        return Model(date: self.stringToDate(from: self.date), currency: objectNews)
    }
    
    private func stringToDate(from String: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.date(from: String) ?? Date()
    }
    

}
