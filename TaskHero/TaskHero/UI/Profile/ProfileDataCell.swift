//
//  ProfileDataCell.swift
//  TaskHero
//
//  Created by Christopher Webb-Orenstein on 9/28/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class ProfileDataCell: UITableViewCell {
    
    static let cellIdentifier = "ProfileDataCell"
    static let dataCellRadius = Constants.Settings.profileDataRadius
    
    // MARK: - UI Elements and cellModel
    // =========================================================================
    
    var dataCellModel: ProfileDataCellViewModel =  {
        var cellModel = ProfileDataCellViewModel()
        return cellModel
    }()
    
    var levelLabel: UILabel = {
        let levelLabel = UILabel()
        return levelLabel
    }()
    
    var experiencePointsLabel: UILabel = {
        let experiencePointsLabel = UILabel()
        return experiencePointsLabel
    }()
    
    var tasksCompletedLabel: UILabel = {
        let taskCompletedLabel = UILabel()
        return taskCompletedLabel
    }()
}

extension ProfileDataCell {
    
    // MARK: - Initialization
    // =========================================================================
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    // MARK: - Configuration
    // =========================================================================
    
    func configureLabels(label:UILabel) {
        label.layer.cornerRadius = ProfileDataCell.dataCellRadius
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.backgroundColor = UIColor.experienceBackground()
        label.textColor = UIColor.black
        label.layer.borderWidth = 1
        label.font = Constants.Font.fontSmall
        label.sizeToFit()
    }
    
    // Most likely will be removed
    
    func configureConstraints(label:UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        
        configureLabels(label: levelLabel)
        contentView.addSubview(levelLabel)
        configureConstraints(label: levelLabel)
        
        levelLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.Settings.levelLabelLeftOffset).isActive = true
        levelLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        levelLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3).isActive = true
        levelLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5).isActive = true
        
        configureLabels(label: experiencePointsLabel)
        contentView.addSubview(experiencePointsLabel)
        configureConstraints(label: experiencePointsLabel)
        
        experiencePointsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        experiencePointsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        experiencePointsLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3).isActive = true
        experiencePointsLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5).isActive = true
        
        configureLabels(label: tasksCompletedLabel)
        contentView.addSubview(tasksCompletedLabel)
        configureConstraints(label: tasksCompletedLabel)
        
        tasksCompletedLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        tasksCompletedLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: Constants.Settings.profileDataRightOffset).isActive = true
        tasksCompletedLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3).isActive = true
        tasksCompletedLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5).isActive = true
    }
    
    func configureCell() {
        
        levelLabel.text = "Level: \(dataCellModel.level)"
        experiencePointsLabel.text = "Experience: \(String(describing: dataCellModel.experience))"
        tasksCompletedLabel.text = "Tasks Completed: \(String(describing: dataCellModel.tasksCompleted))"
        layoutSubviews()
        layoutMargins = UIEdgeInsets.zero
    }
    
    override func prepareForReuse() {
        experiencePointsLabel.text = " "
        levelLabel.text = ""
    }
}
