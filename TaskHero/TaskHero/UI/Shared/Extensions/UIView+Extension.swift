//
//  UIView+Extension.swift
//  TaskHero
//
//  Created by Christopher Webb-Orenstein on 11/23/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func constrainEdges(to view: UIView) {
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
}

extension UITextView {
    
    func setupStyledTextView() -> UITextView {
        layer.borderWidth = Constants.Dimension.mainWidth
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = Constants.Settings.searchFieldButtonRadius
        font = Constants.signupFieldFont
        contentInset = Constants.TaskCell.Description.boxInset
        return self
    }
    
    func setupCellStyle() -> UITextView {
        let textView = UITextView()
        textView.textColor = UIColor.black
        textView.font = Constants.Font.fontMedium
        return textView
    }
}

//func setupTableView(tableView: UITableView, view: UIView) {
//    tableView.tableFooterView = UIView(frame: CGRect.zero)
//    tableView.separatorStyle = .singleLine
//    tableView.allowsSelection = false
//    tableView.rowHeight = UITableViewAutomaticDimension
//    tableView.estimatedRowHeight = view.frame.height / 4
//    tableView.layoutMargins = UIEdgeInsets.zero
//    tableView.separatorInset = UIEdgeInsets.zero
//}

public extension UITableView {
    
    public func setupTableView() {
        estimatedRowHeight = Constants.Settings.rowHeight
        layoutMargins = UIEdgeInsets.zero
        separatorInset = UIEdgeInsets.zero
        separatorStyle = .singleLineEtched
        rowHeight = UITableViewAutomaticDimension
        tableFooterView = UIView(frame: CGRect.zero)
        tableHeaderView?.backgroundColor = UIColor.white
    }
}
