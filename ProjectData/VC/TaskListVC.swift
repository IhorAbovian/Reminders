//
//  TaskListVC.swift
//  ProjectData
//
//  Created by Igor Abovyan on 29.10.2021.
//

import UIKit

class TaskListVC: UITableViewController {
    
    private var tasks = [Task].init()
}

//MARK: Controller lify cycle
extension TaskListVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.createTitle()
        self.loadTasks()
    }
}

//MARK: Configuration
extension TaskListVC {
    
    private func config() {
        self.view.backgroundColor = .white
        self.createAddButton()
        
    }
    
    private func createAddButton() {
        let button = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(createNewTask))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private func createNewTask() {
        let vc = TaskVC.init()
        let task = CoreDataManager.shered.createTask()
        vc.task = task
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func createTitle() {
        navigationItem.title = "Task List"
    }
    
    private func loadTasks() {
        tasks = CoreDataManager.shered.getAllTasks()
        tableView.reloadData()
    }
}

//MARK: Table view data source
extension TaskListVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: identifier)
        }
        
        let task = tasks[indexPath.row]
        cell?.textLabel?.text = task.name
        cell?.detailTextLabel?.text = String(task.duration)
        if task.isFavorites {
            cell?.accessoryType = .checkmark
        }else {
            cell?.accessoryType = .none
        }
        return cell!
    }
}

//MARK: Table view Delegate
extension TaskListVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Убирает потемнение ячейки при нажатии
        tableView.deselectRow(at: indexPath, animated: true)
        let task = tasks[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        
        if task.isFavorites == true {
            task.isFavorites = false
            cell?.accessoryType = .none
        }else {
            task.isFavorites = true
            cell?.accessoryType = .checkmark
        }
        var count = 0
        for task in tasks {
            if task.isFavorites {
                count += 1
            }
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(count, forKey: String.amountTaskKey)
        userDefaults.synchronize()
        CoreDataManager.shered.saveContext()
        
    }
}
