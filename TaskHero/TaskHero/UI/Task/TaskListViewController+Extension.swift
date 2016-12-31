//
//  TaskListViewController+Extension.swift
//  TaskHero
//
//  Created by Christopher Webb-Orenstein on 12/20/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

import UIKit

extension TaskListViewController {
    
    // MARK: - TaskList UI
    // =========================================================================
    
    func emptyTableViewState() {
        if (store.tasks.count < 1) && (!addTasksLabel.isHidden) {
            view.addSubview(addTasksLabel)
            addTasksLabel.center = self.view.center
            addTasksLabel.text = "No tasks have been added yet."
            addTasksLabel.translatesAutoresizingMaskIntoConstraints = false
            addTasksLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: Constants.Profile.profileHeaderLabelHeight).isActive = true
            addTasksLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.Login.loginFieldWidth).isActive = true
            addTasksLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            addTasksLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        } else if store.tasks.count < 1 {
            addTasksLabel.isHidden = false
        }
    }
    
    // MARK: - Configure
    // =========================================================================
    
    func setupTableView() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = view.frame.height / 4
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
    }
}


extension TaskListViewController: TaskHeaderCellDelegate {
    
    // MARK: - Public Methods
    // =========================================================================
    
    func changeView(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Tasks To Do")
        default:
            print("Tasks Completed")
        }
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    // MARK: - Setup navbar
    // =========================================================================
    
    func setupNavItems() {
        navigationController?.navigationBar.setBottomBorderColor(color: UIColor.lightGray, height: Constants.NavBar.bottomHeight)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(logoutButtonPressed))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: Constants.Font.fontMedium], for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add-white-2")?.withRenderingMode(.alwaysOriginal) , style: .done, target: self, action: #selector(addTaskButtonTapped))
    }
}


extension TaskListViewController {
    
    // MARK: - Button methods
    // =========================================================================
    
    func logoutButtonPressed() {
        DispatchQueue.main.async {
            let loginVC = UINavigationController(rootViewController:LoginViewController())
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = loginVC
        }
    }
    
    @objc fileprivate func addTaskButtonTapped() {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(AddTaskViewController(), animated:false)
        }
    }
    
    func deleteTasks(id:String, indexPath: IndexPath) {
        self.store.updateUserScore()
        self.store.firebaseAPI.insertUser(user: self.store.currentUser)
        self.store.firebaseAPI.removeTask(ref: id, taskID: id)
        self.store.tasks.remove(at: indexPath.row)
    }
    
    func tapEdit(atIndex:IndexPath) {
        let tapCell = tableView.cellForRow(at: atIndex) as! TaskCell
        if tapCell.toggled == true {
            var newTask = self.store.tasks[atIndex.row]
            newTask.taskDescription = tapCell.taskDescriptionBox.text
            self.store.firebaseAPI.updateTask(ref: newTask.taskID, taskID: newTask.taskID, task: newTask)
            DispatchQueue.main.async {
                tapCell.taskDescriptionLabel.text = newTask.taskDescription
            }
            tapCell.taskDescriptionBox.resignFirstResponder()
        }
    }
    
    func toggleForButtonState(sender:UIButton) {
        let superview = sender.superview
        let cell = superview?.superview as? TaskCell
        let indexPath = tableView.indexPath(for: cell!)
        tapEdit(atIndex: indexPath!)
    }
    
    // Kicks off cycling between taskcell editing states
    
    func toggleForEditState(sender:UIGestureRecognizer) {
        let tapLocation = sender.location(in: self.tableView)
        guard let tapIndex = tableView.indexPathForRow(at: tapLocation) else { return }
        tapEdit(atIndex: tapIndex as IndexPath)
    }
}
