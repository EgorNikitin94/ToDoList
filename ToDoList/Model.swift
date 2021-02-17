//
//  Model.swift
//  ToDoList
//
//  Created by Егор Никитин on 08.02.2021.
//

import Foundation

class ToDoItem {
    
    var text: String
    var isCompleted: Bool
    
    init(text: String) {
        self.text = text
        self.isCompleted = false
    }
}
