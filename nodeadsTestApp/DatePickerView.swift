//
//  DatePickerView.swift
//  nodeadsTestApp
//
//  Created by Artem on 4/12/17.
//  Copyright © 2017 Artem Velykyy. All rights reserved.
//

import UIKit


class DatePickerView: UIViewController {
    
    var window: UIWindow?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var superClass: ViewController!
    
    @IBAction func pickDate(_ sender: UIDatePicker) {
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd-MM-yyyy"
//        superClass.date = datePicker.date
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
        
        self.view.removeFromSuperview()
    }
    
    func showInView(_ parentView:UIView, animated: Bool = true) {
        parentView.addSubview(self.view)
        if animated {
            self.showAnimated()
        }
    }
    
    func showAnimated() {
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.viewToShow.transform = CGAffineTransform.identity
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
    }

    
    //Outlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var viewToShow: UIView!
    
}
