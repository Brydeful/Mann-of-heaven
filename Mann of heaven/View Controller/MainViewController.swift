//
//  MainViewController.swift
//  Mann of heaven
//
//  Created by Вячеслав on 08.06.2018.
//  Copyright © 2018 Вячеслав. All rights reserved.
//


import UIKit
import Alamofire
class MainViewController: UITableViewController {
    
    var jsonDic = [[String:Any]]()
    
    let sizeArray = ["S","M","L"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    func updateData(){
        DispatchQueue.main.async{
            request("\(ip):5000/mann/api/v1/dinner").responseJSON { responseJSON in
                print(responseJSON)
                switch responseJSON.result {
                case .success( _):
                    guard let jsonArray = responseJSON.result.value as? [[String: Any]] else { return }
                    self.jsonDic = jsonArray
                case .failure(let error):
                    print(error)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateData()
    }
    
    // Segue - AddViewController
    
    @objc func addTapped(){
        performSegue(withIdentifier: "addSegue", sender: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonDic.count
    }
    
    private func configureCell(cell: ItemCell, for indexPath: IndexPath) {
        let item = jsonDic[indexPath.row]
        let time = item["date"]! as! String
        let index = time.index(time.startIndex, offsetBy: 4)
        cell.timeLabel.text = "Time: \(time[...index])"
        cell.sizeLabel.text = "Size: \(sizeArray[(item["size"]! as! Int) - 1])"
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ItemCell
        configureCell(cell: cell, for: indexPath)
        return cell
    }
    
    // MARK: - Editing the table view
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let firstTodoEndpoint: String = "\(ip):5000/mann/api/v1/dinner/\(((self.jsonDic[indexPath.row])["id"])!)"
            request(firstTodoEndpoint, method: .delete).responseJSON
            jsonDic.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

class ItemCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
}
