//
//  ViewController.swift
//  nodeadsTestApp
//
//  Created by Artem on 4/12/17.
//  Copyright © 2017 Artem Velykyy. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var graphView: ScrollableGraphView!
    @IBOutlet weak var seconView: UIView!
    
    var columnNames = [String]()
    var points = [Double]()
    var date = Date()
    var pickedDate = Date()
    var currencies: [NSManagedObject] = []
    var currenciesArray = [CurrencyModel]()
    
    var datePickerView: DatePickerView!
    var arch = [ArchiveCurrencyModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //getData(forDate: "01.02.2015")
        setupGraphDate()
    }
    
    
    func setupGraphDate() {
        var today = Calendar.current.date(byAdding: .day, value: -5, to: Date())
        var dateArray = [String]()
        for _ in 1...30{
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today!)
            let date = DateFormatter()
            date.dateFormat = "dd.MM.yyyy"
            let stringDate : String = date.string(from: today!)
            today = yesterday!
            self.getData(forDate: stringDate)
            
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//            print("shit")
//            self.setupData()
//        }
    }
    
    
    func convertDate(date: Date) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd.MM.yyyy"
        
        let result = formatter.string(from: date)
        return result
    }

    func getData(forDate: String) {
        let request = RequestManager(requestLink: "https://api.privatbank.ua/p24api/exchange_rates?json&date=\(forDate)", parametrs: [:], reqType: .GET)
        
        
        request.requestTask { (json, error) in
            let object = CurrencyParser(json: (json?["exchangeRate"] as? [[String: Any]]) ?? [], for: forDate).parse()
            
            self.arch.append(object)
            self.arch = self.arch.sorted(by: { $0.0.date < $0.1.date })
            for (index, a) in self.arch.enumerated() {
                self.arch[index].currency = a.currency.filter { $0.currency == "USD" }
            }
            self.columnNames = self.arch.map { $0.date.toString() }
            self.points = self.arch.map { ($0.currency.first?.purchaseRateNB) ?? 0 }
            self.setupData(data: self.points, labels: self.columnNames)
        }
        
    }
    
    func getTodaysRate() {
        let request = RequestManager(requestLink: "https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=3", parametrs: [:], reqType: .GET)
        
//        request.requestTask {
//(json, error) in
//            let object = CurrencyParser(json: (json?["exchangeRate"] as? [[String: Any]]) ?? [], for: forDate).parse()
//            
//            self.arch.append(object)
//            self.arch = self.arch.sorted(by: { $0.0.date < $0.1.date })
//            for (index, a) in self.arch.enumerated() {
//                self.arch[index].currency = a.currency.filter { $0.currency == "USD" }
//            }
//
//        }
    }
    
    func saveCurrency(name: String) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Currency",
                                       in: managedContext)!
        
        let currency = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        currency.setValue(name, forKeyPath: "currency")
        
        do {
            try managedContext.save()
            currencies.append(currency)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    
    func setupData(data: [Double], labels: [String]) {
        print(data)
        print(labels)
        
        
        graphView.backgroundFillColor = UIColor(hexString: "#333333")
        
        graphView.rangeMin = 26
        graphView.rangeMax = 28
        
        graphView.lineWidth = 1
        graphView.lineColor = UIColor(hexString:"#777777")
        graphView.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        graphView.shouldFill = true
        graphView.fillType = ScrollableGraphViewFillType.gradient
        graphView.fillColor = UIColor(hexString:"#555555")
        graphView.fillGradientType = ScrollableGraphViewGradientType.linear
        graphView.fillGradientStartColor = UIColor(hexString:"#555555")
        graphView.fillGradientEndColor = UIColor(hexString:"#444444")
        
        graphView.dataPointSpacing = 80
        graphView.dataPointSize = 2
        graphView.dataPointFillColor = UIColor.white
        
        graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        graphView.referenceLineLabelColor = UIColor.white
        graphView.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
        
        graphView.set(data: data, withLabels: labels)
        }
    
    
    @IBAction func goToCurrenciesTVButton(_ sender: UIButton) {
        let destinationVC = CurrenciesViewController()
        destinationVC.currenciesArray = currenciesArray
        self.navigationController?.pushViewController(destinationVC, animated: true)
       // self.performSegue(withIdentifier: "toDetail", sender: currenciesArray)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toDetail"  {
//            if let currencies = sender as? [CurrencyModel] {
//                let destVC = segue.destination as? CurrenciesViewController
//                destVC?.currenciesArray = currencies
//            }
//        }
//    }
    
    
    
    @IBAction func pickDateButton(_ sender: UIButton) {
        datePickerView = DatePickerView(nibName: "DatePickerView", bundle: nil)
        datePickerView.superClass = self
        datePickerView.view.frame = UIScreen.main.bounds
        datePickerView.showInView(self.view)
    }
    
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
}

