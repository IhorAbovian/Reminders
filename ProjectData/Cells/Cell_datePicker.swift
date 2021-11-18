//
//  Cell_dataPicker.swift
//  ProjectData
//
//  Created by Igor Abovyan on 29.10.2021.
//

import UIKit

class Cell_datePicker: UITableViewCell {
    
    var picker: UIPickerView!
    
    static let height: CGFloat = 150
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createPicker()
        self.createLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Cell_datePicker {
    
    private func createPicker() {
        picker = UIPickerView.init()
        picker.frame.size.width = UIScreen.main.bounds.width / 2
        picker.frame.size.height = Cell_datePicker.height
        picker.frame.origin.x = UIScreen.main.bounds.width - picker.frame.size.width - CGFloat.offset
        picker.backgroundColor = .systemGray6
        self.contentView.addSubview(picker)
    }
    
    private func createLabel() {
        let label = UILabel.init()
        label.frame.size.width = UIScreen.main.bounds.width / 2 - CGFloat.offset * 2
        label.frame.size.height = 30
        label.frame.origin.x = CGFloat.offset
        label.frame.origin.y = CGFloat.offset
        self.contentView.addSubview(label)
    }
}
