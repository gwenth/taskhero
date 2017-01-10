//
//  Logout.swift
//  TaskHero
//
//  Created by Christopher Webb-Orenstein on 12/6/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import Firebase


/* Extension that adds on features - sets up action for logout button press, add task button press and adds these as selectors on navigation items which are added to navigation controller. */

extension HomeViewController {
    
    // ============================
    // MARK: Selector Methods
    // ============================
    
    /* Logs out user by settings root ViewController to Loginview */
    
    func logoutButtonPressed() {
        let loginVC = UINavigationController(rootViewController:LoginViewController())
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        DataStore.sharedInstance.logout()
        appDelegate.window?.rootViewController = loginVC
    }
    
    /* Pushes AddTaskViewcontroller to current current view controller on button press */
    
    func addTaskButtonTapped() {
        navigationController?.pushViewController(AddTaskViewController(), animated:false)
    }
    
    /* Adds two methods above to as selector methods in navigation items and adds navigation items to navigation controller */
    
    // ====================
    // MARK: - Nav Items
    // ====================
    
    func addNavItemsToController() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(logoutButtonPressed))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: Constants.Font.fontMedium!], for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add-white-2")?.withRenderingMode(.alwaysOriginal) , style: .done, target: self, action: #selector(addTaskButtonTapped))
    }
}


extension HomeViewController: UIImagePickerControllerDelegate {
    
    // ==================================================
    // MARK: - Header and Task cell Delegate Methods
    // ==================================================
    
    /* If popover is not visible shows popover / if popover is displayed it hides popover */
    
    // ====================
    // MARK: - Profile Pic
    // ====================
    
    func profilePictureTapped() {
        photoPopover.popView.isHidden = false
        photoPopover.showPopView(viewController: self)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hidePopoverView))
        photoPopover.containerView.addGestureRecognizer(tap)
        photoPopover.popView.button.addTarget(self, action: #selector(tapPickPhoto(sender:)), for: .touchUpInside)
    }
    
    func tapPickPhoto(sender:UIButton) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        photoPopover.hideView(viewController: self)
    }
    
    /* Method toggles UI states from editing to not editing when save is pressed */
    
    // ====================
    // MARK: - TaskCell
    // ====================
    
    func toggleForButtonState(sender:UIButton) {
        print("inside toggleForButtonState")
        let superview = sender.superview
        let cell = superview?.superview as? TaskCell
        let indexPath = tableView.indexPath(for: cell!)
        helpers.tapEdit(tableView: tableView, atIndex: indexPath!)
    }
    
    func taskCell(didToggleEditState editState:Bool) {
        //
    }
    
    /* Kicks off cycling between taskcell editing states */
    
    func toggleForEditState(sender:UIGestureRecognizer) {
        let tapLocation = sender.location(in: self.tableView)
        guard let tapIndex = tableView.indexPathForRow(at: tapLocation) else { return }
        helpers.tapEdit(tableView:tableView, atIndex: tapIndex)
    }
    
    
    // ====================
    // MARK: - Popover
    // ====================
    
    /* Hides popover view when operation has ended. */
    
    func hidePopoverView() {
        photoPopover.hidePopView(viewController: self)
    }
}
