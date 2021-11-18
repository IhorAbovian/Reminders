//
//  ViewController.swift
//  ProjectData
//
//  Created by Igor Abovyan on 29.10.2021.
//

import UIKit
import UserNotifications

class HomeVC: UIViewController {

    var picker: UIPickerView!
    var tableView: UITableView!
    var label: UILabel!
    var button: UIButton!
    private var tasksFavorites = [Task].init()
    
}

//MARK: Controller lify cycle
extension HomeVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadTasks()
        picker.reloadAllComponents()
        let userDefaults = UserDefaults.standard
        //пoлучаем число
        let amountTasks = userDefaults.integer(forKey: String.amountTaskKey)
        picker.selectRow(amountTasks - 1, inComponent: 0, animated: false)
    }
}

//MARK: Configuration
extension HomeVC {
    
    private func config() {
        self.view.backgroundColor = .white
        self.createLabel()
        self.createPicker()
        self.createTableview()
        self.createPlayButton()
        self.registerNotification()
        UNUserNotificationCenter.current().delegate = self
    }
    
    private func createLabel() {
        label = UILabel.init()
        label.frame.size.width = self.view.frame.size.width / 2 - CGFloat.offset * 2
        label.frame.size.height = 30
        label.frame.origin.x = CGFloat.offset
        label.frame.origin.y = self.view.frame.size.height * 0.1
        label.text = "Count tasks:"
        self.view.addSubview(label)
    }
    
    private func createPlayButton() {
        button = UIButton.init()
        button.frame.size.width = self.view.frame.size.width / 2 - CGFloat.offset * 2
        button.frame.size.height = button.frame.size.width / 2
        button.frame.origin.x = CGFloat.offset
        button.frame.origin.y = label.frame.origin.y + label.frame.size.height + CGFloat.offset
        button.setImage("play.circle".getSymbol(size: 40, bold: .medium), for: .normal)
        self.view.addSubview(button)
        
        button.addTarget(self, action: #selector(startNotification), for: .touchUpInside)
        
    }
    
    @objc private func startNotification() {
        let durationBetweenTasks = 1.0
        var totalDuration = durationBetweenTasks
        for i in 0 ..< tasksFavorites.count {
            let task = tasksFavorites[i]
            self.createNotification(task: task, state: "start", totalDuration: totalDuration)
            self.createNotification(task: task, state: "end", totalDuration: totalDuration + Double(task.duration))
            totalDuration += durationBetweenTasks
            
        }
    }
    
    private func createPicker() {
        picker = UIPickerView.init()
        picker.dataSource = self
        picker.delegate = self
        picker.frame.size.width = self.view.frame.size.width / 2 - CGFloat.offset * 2
        picker.frame.size.height = self.view.frame.size.height * 0.25
        picker.frame.origin.x = self.view.frame.size.width / 2 + CGFloat.offset
        picker.frame.origin.y = self.view.frame.size.height * 0.1
        self.view.addSubview(picker)
    }
    
    private func createTableview() {
        tableView = UITableView.init()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame.size.width = self.view.frame.size.width
        tableView.frame.size.height = self.view.frame.size.height - picker.frame.origin.y - picker.frame.size.height - self.tabBarController!.tabBar.frame.height - 64
        tableView.frame.origin.y = picker.frame.origin.y + picker.frame.size.height + CGFloat.offset
        self.view.addSubview(tableView)
        
    }
    
    private func loadTasks() {
        tasksFavorites = CoreDataManager.shered.getFavorites()
        tableView.reloadData()
    }
}

extension HomeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let userDefaults = UserDefaults.standard
        let amountTasks = userDefaults.integer(forKey: String.amountTaskKey)
        return amountTasks
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: identifier)
        }
        
        let task = tasksFavorites[indexPath.row]
        cell?.textLabel?.text = task.name
        cell?.detailTextLabel?.text = String(task.duration)

        return cell!
    }
}

extension HomeVC: UITableViewDelegate  {
    
    
}


extension HomeVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tasksFavorites.count
    }
}

extension HomeVC: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(row + 1, forKey: String.amountTaskKey)
        userDefaults.synchronize()
        tableView.reloadData()
    }
}

//MARK: register Notification
extension HomeVC {
    private func registerNotification() {
        //регистрация(разрешить уведомления) показывает окно уведомления
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
        }
    }
}

//MARK: create Notification
extension HomeVC {
    private func createNotification(task: Task, state: String, totalDuration: Double) {
        let content = UNMutableNotificationContent.init()
        content.title = task.name!
        content.body = state
        content.sound = .default
        content.subtitle = String(task.duration)
        
        let triger = UNTimeIntervalNotificationTrigger.init(timeInterval: totalDuration * 60, repeats: false)
        var identifier = task.name!
        if state == "start" {
            identifier += "1"
        }else {
            identifier += "2"
        }
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: triger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }else {
                print("Notif add")
            }
        }
    }
 
}

//MARK: Notification Delegate
extension HomeVC: UNUserNotificationCenterDelegate {
    // уведомление с открытым приложением
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
