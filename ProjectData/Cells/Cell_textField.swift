//
//  Cell_textField.swift
//  ProjectData
//
//  Created by Igor Abovyan on 29.10.2021.
//

import UIKit

class Cell_textField: UITableViewCell {
    
    var textField: UITextField!
    
    private static let textFieldHeight: CGFloat = 30
    
    static var height: CGFloat {
        let h = CGFloat.offset * 2 + Cell_textField.textFieldHeight
        return h
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension Cell_textField {
    
    private func createTextField() {
        textField = UITextField.init()
        textField.frame.size.width = UIScreen.main.bounds.width - CGFloat.offset * 2
        textField.frame.size.height = Cell_textField.textFieldHeight
        textField.frame.origin.x = CGFloat.offset
        textField.frame.origin.y = CGFloat.offset
        self.contentView.addSubview(textField)
    }
}
