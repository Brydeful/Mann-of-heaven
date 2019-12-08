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
    
    var diners = [Diner]()
    let networkService = NetworkService()
    
    lazy var refresher : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
    }
    
    fileprivate func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        tableView.refreshControl = refresher
    }
    
    @objc private func refreshData(_ sender: Any) {
        updateData()
        self.refresher.endRefreshing()
    }
    
    func updateData(){
        networkService.fetchDiner { (diner) in
            guard let dinersFetch = diner else { return }
            self.diners = dinersFetch
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
        return diners.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ItemCell
        let diner = diners[indexPath.row]
        cell.diner = diner
        
        return cell
    }
    
    // MARK: - Editing the table view
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let diner = diners[indexPath.row]
            networkService.deleteDiner(diner: diner) { (isSuccessfull) in
                if isSuccessfull{
                    self.diners.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
}

class ItemCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    var diner: Diner?{
        didSet{
            if let diner = diner{
                timeLabel.text = "Время кормления: \(diner.time)"
                sizeLabel.text = diner.size
            }
        }
    }
}
