//
//  AddViewController.swift
//  Mann of heaven
//
//  Created by Вячеслав on 18.06.2018.
//  Copyright © 2018 Вячеслав. All rights reserved.
//

import UIKit
import Alamofire

class AddViewController: UIViewController{
    
    let sizeArray = ["Маленькая","Средняя","Большая"]
    let networkService = NetworkService()
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var sizePicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
    }
    
    fileprivate func setupDatePicker() {
        sizePicker.delegate = self
        sizePicker.dataSource = self
    }
    
    @IBAction func addButton(_ sender: Any) {
        let dateFormatter = DateFormatter()
        var dateString = String()
        dateFormatter.dateFormat = "HH:mm"
        dateString = dateFormatter.string(from: datePicker.date)
        let parameters: [String: String] = [
            "date": dateString,
            "size": String(sizePicker.selectedRow(inComponent: 0) + 1)
        ]
        
        networkService.addDiner(parameters: parameters)

        navigationController?.popViewController(animated: true)
    }
    
}
extension AddViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sizeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sizeArray[row]
    }
}

