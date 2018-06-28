//
//  InterfaceController.swift
//  Mann of heaven Watch Extension
//
//  Created by Вячеслав on 24.06.2018.
//  Copyright © 2018 Вячеслав. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var tableView: WKInterfaceTable!
    
    let sizeArray = ["S","M","L"]
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
    }
    
    func makeGetCall() {
        let todoEndpoint: String = "\(ip):5000/mann/api/v1/dinner"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                if let jsonDic = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [[String: Any]]{
                    self.tableView.setNumberOfRows(jsonDic.count, withRowType: "rowTime")
                    print(jsonDic)
                    for i in 0..<jsonDic.count {
                        if let row = self.tableView.rowController(at: i) as? RowType {
                            let time = (jsonDic[i])["date"]! as! String
                            let size = (jsonDic[i])["size"]! as! Int
                            let index = time.index(time.startIndex, offsetBy: 4)
                            row.timeLabel.setText("Время: \(time[...index])")
                            row.sizeLabel.setText("Размер: \(self.sizeArray[size - 1])")
                        }
                    }
                    return
                }
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
        
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        makeGetCall()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
