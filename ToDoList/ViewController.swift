//
//  ViewController.swift
//  ToDoList
//
//  Created by Егор Никитин on 08.02.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var items: [ToDoItem] = []
    
    @IBOutlet var mainTableView: UITableView!
    
    @IBOutlet var addImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.initCell(item: items[indexPath.row], itemIndex: indexPath.row, viewController: self)
        return cell
    }
    
    private func addItem() {
        let alertController = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter new item"
        }
        let addButton = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            if alertController.textFields?[0].text != "" {
                self.items.insert(ToDoItem(text: alertController.textFields?[0].text ?? ""), at: 0)
                self.mainTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)
    }
    
    public func deleteItem(itemIndex: Int) {
        items.remove(at: itemIndex)
        mainTableView.deleteRows(at: [IndexPath(row: itemIndex, section: 0)], with: .automatic)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.mainTableView.reloadData()
        }
    }
}



// Add new item with animation
extension ViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var y = scrollView.contentOffset.y
        
        if y < -100 {
            y = -100
        }
        
        if y < -20 {
            addImageView.alpha = 1
            addImageView.frame = CGRect(x: 0, y: 98, width: UIScreen.main.bounds.width, height: -y)
        } else {
            addImageView.alpha = 0
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView.contentOffset.y < -100 {
            addItem()
        }
    }
    
}
