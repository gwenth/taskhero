//
//  SettingsViewController.swift
//  TaskHero
//
//  Created by Christopher Webb-Orenstein on 9/29/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class SettingsViewController: UITableViewController {
    
    // MARK: - Properties
    
    let applicationSettings = ["Notifications"]
    let userSettings = ["Edit Profile", "Friends"]
    let segmentControl = UISegmentedControl(items: ["User Settings", "Application Settings"])
    let label = UILabel()
    var settings = [String]()
    let alertPop = AlertPopover()
    let notifyPop = NotificationPopover()
    var settingsViewModel:SettingsCellViewModel!
    let helpers = Helpers()
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings = userSettings
        edgesForExtendedLayout = []
        view.backgroundColor = UIColor.backgroundColor()
        navigationController?.navigationBar.setBottomBorderColor(color: UIColor.lightGray, height: Constants.Border.borderWidth)
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.cellIdentifier)
        let header = UIView(frame:CGRect(x:0, y:0, width: Int(view.bounds.width), height: 50))
        header.backgroundColor = UIColor.white
        header.addSubview(segmentControl)
        tableView.tableHeaderView = header
        tableView.separatorColor = UIColor.blue
        tableView.setupTableView(view:self.view)
        setupSegment()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        hide()
    }
}

extension SettingsViewController {
    
    // MARK: UITableViewController Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsCell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.cellIdentifier, for: indexPath as IndexPath) as! SettingsCell
        settingsViewModel = SettingsCellViewModel(settings[indexPath.row])
        settingsCell.configureCell(setting: settingsViewModel)
        settingsCell.contentView.clipsToBounds = true
        return settingsCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if settings[indexPath.row] == "Edit Profile" {
            navigationController?.pushViewController(ProfileSettingsViewController(), animated: true)
        }
        else if settings[indexPath.row] == "Friends" {
            let friendsVC = FriendsSettingsViewController()
            navigationController?.pushViewController(friendsVC, animated: true)
        }
        else if settings[indexPath.row] == "Notifications" {
            notificationPopup()
            notifyPop.notifyPopView.doneButton.addTarget(self, action: #selector(dismissNotificationButton), for: .touchUpInside)
        }
    }
}

extension SettingsViewController {

    // MARK: Public Methods
    
    fileprivate func alertPopInitialOpacity() {
        alertPop.popView.layer.opacity = 0
        alertPop.popView.isHidden = false
        alertPop.containerView.isHidden = false
        alertPop.containerView.layer.opacity = 0
    }
    
    fileprivate func launchPopupView() {
        alertPopInitialOpacity()
        alertPop.showPopView(viewController: self)
        UIView.animate(withDuration: 0.1, animations: { [unowned self] in
            self.alertPop.popView.layer.opacity = 1
            self.alertPop.containerView.layer.opacity = 0.1
        })
        self.alertPop.alertPopView.resultLabel.text = "Try Again Later."
        self.alertPop.alertPopView.doneButton.addTarget(self, action: #selector(dismissButton), for: .touchUpInside)
        self.alertPop.alertPopView.cancelButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
    }
    
    // Displays popover when notifications cell is selected
    
    fileprivate func notificationPopInitialOpacity() {
        notifyPop.popView.isHidden = false
        notifyPop.containerView.isHidden = false
        notifyPop.containerView.layer.opacity = 0
        notifyPop.popView.layer.opacity = 0
    }
}

extension SettingsViewController {

    func notificationPopup() {
        notificationPopInitialOpacity()
        notifyPop.showPopView(viewController: self)
        UIView.animate(withDuration: 0.1, animations: { [unowned self] in
            self.notifyPop.popView.layer.opacity = 1
            self.notifyPop.containerView.layer.opacity = 0.1 }
        )
    }
    
    // MARK: - Setup buttons
    // Hides notification popover
    
    func dismissNotificationButton() {
        notifyPop.popView.isHidden = true
        notifyPop.containerView.isHidden = true
        notifyPop.hidePopView(viewController: self)
    }
    
    func dismissButton() {
        alertPop.popView.isHidden = true
        alertPop.containerView.isHidden = true
        alertPop.hidePopView(viewController: self)
    }
    
    func hide() {
        alertPop.popView.isHidden = true
        alertPop.containerView.isHidden = true
        alertPop.hidePopView(viewController: self)
    }
}

extension SettingsViewController {

    // MARK: - Switch between segments
    
    func changeView(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            settings = userSettings
            segmentControl.subviews[0].backgroundColor = UIColor.white
            dump(segmentControl)
        default:
            settings = applicationSettings
            segmentControl.subviews[1].backgroundColor = UIColor.white
            dump(segmentControl)
        }
        tableView.reloadData()
    }
    
    // MARK: - Segment Control UI
    
    func setupSegment() {
        let multipleAttributes: [String : Any] = [NSForegroundColorAttributeName: UIColor.white]
        let multipleUnselectedAttributes: [String : Any] = [NSForegroundColorAttributeName: UIColor.black]
        segmentControl.layer.cornerRadius = Constants.Settings.Segment.segmentBorderRadius
        segmentControl.tintColor = UIColor.black
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.setTitleTextAttributes(multipleAttributes, for: .selected)
        segmentControl.setTitleTextAttributes(multipleUnselectedAttributes, for:.normal)
        segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentControl.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        if let header = self.tableView.tableHeaderView {
            segmentControl.topAnchor.constraint(equalTo:header.topAnchor).isActive = true
            segmentControl.heightAnchor.constraint(equalTo:header.heightAnchor).isActive = true
        }
        segmentControl.addTarget(self, action: #selector(changeView), for: .valueChanged)
    }
}

protocol Hiddable {
    func hide(view:UIView)
}


extension Hiddable {
    func hide(view:UIView, viewController:UIViewController) {
        
    }
}


