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
    
    var jsonDictionary = [[String:Any]]()

    lazy var refresher : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = .white
        return refreshControl
    }()
    let sizeArray = ["Маленькая","Средняя","Большая"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        tableView.refreshControl = refresher
    }
    @objc private func refreshData(_ sender: Any) {
        updateData()
        self.refresher.endRefreshing()
    }
    func updateData(){
        DispatchQueue.main.async{
            request("\(ip):5000/mann/api/v1/dinner").responseJSON { responseJSON in
                print(responseJSON)
                switch responseJSON.result {
                case .success( _):
                    guard let jsonArray = responseJSON.result.value as? [[String: Any]] else { return }
                    self.jsonDictionary = jsonArray
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
                
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {

        navigationController?.navigationBar.barTintColor = UIColor(red:0.20, green:0.46, blue:0.89, alpha:1.0)
        updateData()
    }
    
    // Segue - AddViewController
    
    @objc func addTapped(){
        performSegue(withIdentifier: "addSegue", sender: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonDictionary.count
    }
    
    private func configureCell(cell: ItemCell, for indexPath: IndexPath) {
        let item = jsonDictionary[indexPath.row]
        let time = item["date"]! as! String
        let index = time.index(time.startIndex, offsetBy: 4)
        cell.timeLabel.text = "Время кормления: \(time[...index])"
        cell.sizeLabel.text = "Размер порции: \(sizeArray[(item["size"]! as! Int) - 1])"
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ItemCell
        configureCell(cell: cell, for: indexPath)
        return cell
    }
    
    // MARK: - Editing the table view
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let firstTodoEndpoint: String = "\(ip):5000/mann/api/v1/dinner/\(((self.jsonDictionary[indexPath.row])["id"])!)"
            request(firstTodoEndpoint, method: .delete)
            jsonDictionary.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
}

class ItemCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
}
