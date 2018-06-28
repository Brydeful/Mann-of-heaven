//
//  AddViewController.swift
//  Mann of heaven
//
//  Created by Вячеслав on 18.06.2018.
//  Copyright © 2018 Вячеслав. All rights reserved.
//

import UIKit
import Alamofire

class AddViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource{
    
    let sizeArray = ["S","M","L"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sizeArray.count
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var sizePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sizePicker.delegate = self
        sizePicker.dataSource = self
        navigationItem.largeTitleDisplayMode = .never
    }
    
    @IBAction func addButton(_ sender: Any) {
        let dateFormatter = DateFormatter()
        var dateString = String()
        dateFormatter.dateFormat = "HH:mm"
        dateString = dateFormatter.string(from: datePicker.date)
        let params: [String: Any] = [
            "date": dateString,
            "size": sizePicker.selectedRow(inComponent: 0) + 1
        ]
        request("\(ip):5000/mann/api/v1/dinner", method: .post, parameters: params, encoding:  JSONEncoding.default)
        navigationController?.popViewController(animated: true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sizeArray[row]
    }
}
