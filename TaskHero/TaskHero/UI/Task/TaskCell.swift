//
//  TaskCell.swift
//  TaskHero
//
//  Created by Christopher Webb-Orenstein on 9/24/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol TaskCellDelegate: class {
    func toggleForEditState(_ sender:UIGestureRecognizer)
    func toggleForButtonState(_ sender:UIButton)
}

final class TaskCell: UITableViewCell {
    
    // MARK: - Deallocation from memory
    
    deinit {
        print("Task cell deallocated")
    }
    
    // MARK: - Properties
    
    static let cellIdentifier = "TaskCell"
    weak var delegate: TaskCellDelegate?
    var toggled: Bool = false
    var taskViewModel: TaskCellViewModel!
    
    // MARK: - Setup UI Elements
    
    lazy var taskNameLabel: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.black
        textView.font = Constants.Font.bolderFontMediumLarge
        return textView
    }()
    
    lazy var taskDescriptionLabel: UITextView = {
        let textView = UITextView()
        textView.labelTextViewStyle()
        return textView
    }()
    
    lazy var taskDueLabel: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.black
        textView.font = Constants.Font.fontMedium
        return textView
    }()
    
    lazy var taskCompletedView: UIImageView = {
        let taskCompletedImageView = UIImageView()
        taskCompletedImageView.isUserInteractionEnabled = true
        return taskCompletedImageView
    }()
    
    lazy var saveButton: UIButton = {
        let button = ButtonType.system(title: "Save", color: UIColor.black)
        var ui = button.newButton
        ui.setAttributedTitle(NSAttributedString(string: "Save", attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: Constants.Font.fontSmall]), for: .normal)
        ui.isHidden = true
        ui.isEnabled = false
        return ui
    }()
}

extension TaskCell {
    
    // MARK: - Initialization
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectionStyle = .none
        setupConfigures()
        contentView.layer.masksToBounds = true
        layoutMargins = UIEdgeInsets.zero
        preservesSuperviewLayoutMargins = false
        contentView.backgroundColor = UIColor.clear
    }
}

extension TaskCell {
    
    // MARK: - Configure cell
    
    fileprivate func setupConfigures() {
        configureTextView(label: taskDescriptionLabel)
        configureTextView(label: taskDueLabel)
        configureTextView(label: taskNameLabel)
        setupConstraints()
    }
}

extension TaskCell {
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        taskNameLabel.text = ""
        taskDescriptionLabel.text = ""
    }
}
