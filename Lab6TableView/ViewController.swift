//
//  ViewController.swift
//  Lab6TableView
//
//  Created by user237598 on 2/19/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var itemTableView: UITableView!
    
    let defaults = UserDefaults.standard
    
    var itemArr = [String](){
        didSet{
            defaults.set(itemArr, forKey: "items")
        }
    }
    
    @IBAction func addBtn(_ sender: UIBarButtonItem) {
        
        let showAlert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "cancel", style: .default){
            (cancel) in
        }
        
        let ok = UIAlertAction(title: "OK", style: .default){
            (save) in
            if let textField = showAlert.textFields?.first, let newItem = textField.text, !newItem.isEmpty {
                self.itemArr.append(textField.text!)
                self.itemTableView.reloadData()
            }
        }
    
        showAlert.addTextField { (textField) in
            textField.placeholder = "write an item"
        }
        
        showAlert.addAction(cancel)
        showAlert.addAction(ok)
        
        self.present(showAlert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedItems = defaults.array(forKey: "items") as? [String] {
            itemArr = savedItems
        }
        
        itemTableView.dataSource = self
        itemTableView.delegate = self
        }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = itemArr[indexPath.row]
        
        let deleteButton = UIButton(type: .system)
            deleteButton.setTitle("Delete", for: .normal)
            deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
            cell.accessoryView = deleteButton
        
        return cell
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: itemTableView)
        if let indexPath = itemTableView.indexPathForRow(at: point) {
          itemArr.remove(at: indexPath.row)
          itemTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
              itemArr.remove(at: indexPath.row)
              tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
}

