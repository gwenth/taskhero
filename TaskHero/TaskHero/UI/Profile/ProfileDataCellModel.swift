//
//  ProfileDataCellModel.swift
//  TaskHero
//

import UIKit

protocol ProfileDataCellModel {
    var level: String { get }
    var experience: Int { get }
    var tasksCompleted: Int { get }
}

struct ProfileDataCellViewModel {
    let store = UserDataStore.sharedInstance
    
    internal var tasksCompleted: Int
    internal var experience: Int
    internal var level: String
    
    init() {
        self.level = (self.store.currentUser.level)
        self.experience = (self.store.currentUser.experiencePoints)
        self.tasksCompleted = (self.store.currentUser?.numberOfTasksCompleted)!
    }
}
