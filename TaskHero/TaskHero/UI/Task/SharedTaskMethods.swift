import UIKit

enum TaskListType {
    case home, taskList
}

final class SharedTaskMethods {
    
    let store = UserDataStore.sharedInstance
    
    func deleteTask(indexPath: IndexPath, tableView:UITableView, type: TaskListType) {
        var rowIndex: Int
        switch type {
        case .home:
            guard indexPath.row != 0 else { return }
            rowIndex = indexPath.row - 1
            print(rowIndex)
        case .taskList:
            rowIndex = indexPath.row
        }
        DispatchQueue.global(qos: .default).async {
            let removeTaskID: String = self.store.tasks[rowIndex].taskID
            print(indexPath.row - 1)
            self.store.tasks.remove(at: rowIndex)
            self.store.updateUserScore()
            self.store.firebaseAPI.registerUser(user: self.store.currentUser)
            self.store.firebaseAPI.removeTask(ref: removeTaskID, taskID: removeTaskID)
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
        print(self.store.tasks)
    }
  
    func tapEdit(viewController: UIViewController, tableView: UITableView, atIndex:IndexPath, type: TaskListType) {
        let tapCell = tableView.cellForRow(at: atIndex) as! TaskCell
        var newTask: Task!
        switch type {
        case .home:
            newTask = self.store.tasks[atIndex.row - 1]
        case .taskList:
            newTask = self.store.tasks[atIndex.row]
        }
        if tapCell.toggled == false {
            newTask.taskDescription = tapCell.taskDescriptionLabel.text
            self.store.firebaseAPI.updateTask(ref: newTask.taskID, taskID: newTask.taskID, task: newTask)
            tapCell.taskDescriptionLabel.text = newTask.taskDescription
        }
        let tap = UIGestureRecognizer(target: viewController, action: #selector(HomeViewController.toggleForEditState(_:)))
        tapCell.taskCompletedView.addGestureRecognizer(tap)
        tapCell.taskCompletedView.isUserInteractionEnabled = true
    }
}
