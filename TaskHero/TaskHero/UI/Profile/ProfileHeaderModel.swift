//
//  ProfileHeaderModel.swift
//  TaskHero
//

import UIKit

protocol ProfileHeaderModel {
    var joinDate: String { get }
    var levelLabel: String { get }
    var profilePicture: String { get }
    var usernameLabel: String { get }
    var emailLabel: String { get }
}

struct ProfileHeaderCellModel {

    let store = UserDataStore.sharedInstance
    internal var emailLabel: String
    internal var usernameLabel: String
    internal var profilePicture: String
    internal var levelLabel: String
    internal var joinDate: String
    internal var joinDateIsHidden: Bool
    
    init() {
        if let user = self.store.currentUser {
            emailLabel = user.email
            usernameLabel = user.username
            if let profilePic = user.profilePicture {
                profilePicture = profilePic
            } else {
                profilePicture = "Void"
            }
            levelLabel = "Level: \(user.level)"
            joinDate = "Joined: \(user.joinDate)"
            joinDateIsHidden = true
        } else {
            emailLabel = "Void"
            usernameLabel = "Void"
            profilePicture = "Void"
            levelLabel = "Level: Void"
            joinDate = "Joined:  Void"
            joinDateIsHidden = true
        }
    }
}
