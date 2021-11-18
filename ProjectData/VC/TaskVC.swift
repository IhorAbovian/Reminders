//
//  TaskVC.swift
//  ProjectData
//
//  Created by Igor Abovyan on 29.10.2021.
//

import UIKit

class TaskVC: UITableViewController {
    
    enum Rows: Int {
        case textField
        case datePicker
    }
    
    var task: Task!
    
}

//MARK: Life cycle
extension TaskVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.endEditing(true)
        CoreDataManager.shered.saveContext()
    }
}

//MARK: Config
extension TaskVC {
    
    private func config() {
        self.addTitle()
    }
    
    private func addTitle() {
        navigationItem.title = "Create Task"
    }
    
}

//MARK: Table view daat source
extension TaskVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let rows = Rows.init(rawValue: indexPath.row)
        switch rows {
        case .textField: return createCellTextField(indexPath: indexPath)
        case .datePicker: return createCellDatePicker(indexPath: indexPath)
        default: return UITableViewCell.init()
        }
    }
    
    private func createCellTextField(indexPath: IndexPath) -> Cell_textField {
        let identifier = "cellTextField"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? Cell_textField
        if cell == nil {
            cell = Cell_textField.init(style: .subtitle, reuseIdentifier: identifier)
            // Становимся делегатом
            cell?.textField.delegate = self
        }
        
        cell?.textField.placeholder = "Write task name"
        cell?.textField.text = task.name
        
        return cell!
    }
    
    private func createCellDatePicker(indexPath: IndexPath) -> Cell_datePicker {
        let identifier = "cellDatePicker"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? Cell_datePicker
        if cell == nil {
            cell = Cell_datePicker.init(style: .subtitle, reuseIdentifier: identifier)
        }
        
        cell?.textLabel?.text = "Duration task"
        cell!.picker.dataSource = self
        cell?.picker.delegate = self
        return cell!
    }
}

//MARK: Table view Delegate
extension TaskVC {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // создаем тип rows
        let rows = Rows.init(rawValue: indexPath.row)
        switch rows {
        case .textField: return Cell_textField.height
        case .datePicker: return Cell_datePicker.height
        // все неопознаные значение попадают в раздел дефолт
        default: return 0
        }
    }
}

//MARK: Picker data source
extension TaskVC: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 20
    }
    
}

//MARK: Picker Delegate
extension TaskVC: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        task.duration = Int16(row + 1)
    }
}

//MARK:
extension TaskVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        task.name = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}


