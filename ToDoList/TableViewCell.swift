//
//  TableViewCell.swift
//  ToDoList
//
//  Created by Егор Никитин on 08.02.2021.
//

import UIKit

final class TableViewCell: UITableViewCell {
    
    private var item: ToDoItem!
    
    private var itemIndex: Int!
    
    private var viewController: ViewController!
    
    @IBOutlet private var parentView: UIView!
    @IBOutlet private var checkImageView: UIImageView!
    @IBOutlet private var toDoTextLabel: UILabel!
    @IBOutlet private var trashImageView: UIImageView!
    
    public func initCell(item: ToDoItem, itemIndex: Int, viewController: ViewController) {
        self.item = item
        self.viewController = viewController
        self.itemIndex = itemIndex
        self.toDoTextLabel.text = item.text
        self.parentView.transform = .identity
        setChecked()
        addTap()
        addPan()
    }
    
    private func setChecked() {
        if item.isCompleted {
            checkImageView.image = UIImage(systemName: "checkmark.circle")
            checkImageView.tintColor = .green
        } else {
            checkImageView.image = UIImage(systemName: "circle")
            checkImageView.tintColor = .red
        }
        UIView.animate(withDuration: 0.2) {
            self.checkImageView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        } completion: { (bool) in
            self.checkImageView.transform = .identity
        }
    }
    
    private func addTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap))
        checkImageView.addGestureRecognizer(tap)
    }
    
    @objc private func tap() {
        item.isCompleted.toggle()
        setChecked()
    }
    
    private func addPan() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.pan))
        pan.delegate = self
        parentView.addGestureRecognizer(pan)
    }
    
    @objc private func pan(panGestureRecognizer: UIPanGestureRecognizer) {
        
        let dx = panGestureRecognizer.translation(in: parentView).x
        
        if dx < 0 {
            contentView.backgroundColor = .red
        } else {
            contentView.backgroundColor = .orange
        }
        
        parentView.transform = CGAffineTransform(translationX: dx, y: 0)
        
        if panGestureRecognizer.state == .ended {
            if dx < -60 {
                
                UIView.animate(withDuration: 0.2) {
                    self.parentView.transform = CGAffineTransform(translationX: -500, y: 0)
                } completion: { (bool) in
                    self.viewController.deleteItem(itemIndex: self.itemIndex)
                }
                return
            }
            
            if dx > 60 {
                UIView.animate(withDuration: 0.2) {
                    self.parentView.transform = CGAffineTransform(translationX: -500, y: 0)
                } completion: { (bool) in
                    self.item.isCompleted.toggle()
                    self.setChecked()
                }
            }
            
            UIView.animate(withDuration: 0.2) {
                self.parentView.transform = .identity
            }
            
            
        }
        
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }

}
