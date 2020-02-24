//
//  CreateViewController.swift
//  localnotificaitonlab
//
//  Created by Ahad Islam on 2/20/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import UIKit

protocol CreateViewControllerDelegate: AnyObject {
    func buttonDidPressed()
}

class CreateViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: CreateViewControllerDelegate?
    
    private var timeInterval: TimeInterval = Date().timeIntervalSinceNow + 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func pickerValueChanged(_ sender: UIDatePicker) {
        timeInterval = sender.date.timeIntervalSinceNow
    }

    @IBAction func buttonPressed(_ sender: UIBarButtonItem) {
        guard let text = textField.text else {
            print("No text in textfield")
            return
        }
        NotificationWrapper.helper.createNotification(text, timeInterval: timeInterval)
        delegate?.buttonDidPressed()
        dismiss(animated: true, completion: nil)
    }
}
