import UIKit

class User: NSObject, NSCoding {
    var uid: String = ""
    var email: String = ""
    var username: String = ""
    var firstName: String?
    var lastName: String?
    var profilePicture: String?
    var experiencePoints: Int = 0
    var level: String = ""
    var joinDate: String = ""
    var tasks: [Task]?
    var numberOfTasksCompleted: Int = 0 
    
    init(uid: String,  email: String, firstName: String?, lastName: String?, profilePicture: String?, username: String, experiencePoints: Int, level: String, joinDate: String, tasks: [Task]?, numberOfTasksCompleted: Int) {
        self.uid = uid
        self.username = username
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.profilePicture = profilePicture
        self.experiencePoints = experiencePoints
        self.level = level
        self.joinDate = joinDate
        self.tasks = tasks
        self.numberOfTasksCompleted = numberOfTasksCompleted
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.uid = aDecoder.decodeObject(forKey: "uid") as! String
        self.username = aDecoder.decodeObject(forKey: "username") as! String
        self.email = aDecoder.decodeObject(forKey: "email") as! String
        self.firstName = aDecoder.decodeObject(forKey: "firstName") as? String
        self.lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        self.profilePicture = aDecoder.decodeObject(forKey: "profilePicture") as? String
        self.experiencePoints = aDecoder.decodeObject(forKey: "experiencePoints") as! Int
        self.level = aDecoder.decodeObject(forKey: "level") as! String
        self.joinDate = aDecoder.decodeObject(forKey: "joinDate") as! String
        self.numberOfTasksCompleted =  aDecoder.decodeObject(forKey: "numberOfTasksCompleted") as! Int
        super.init()
    }
    
    override convenience init() {
        self.init(uid:" ",
                  email:" ",
                  firstName: " ",
                  lastName:" ",
                  profilePicture: "None",
                  username: " ",
                  experiencePoints: 0,
                  level: "Task Goat",
                  joinDate: Date().dateStringFormatted(),
                  tasks:[Task](),
                  numberOfTasksCompleted: 0)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(profilePicture, forKey: "profilePicture")
        aCoder.encode(experiencePoints, forKey: "experiencePoints")
        aCoder.encode(level, forKey: "level")
        aCoder.encode(joinDate, forKey: "joinDate")
        aCoder.encode(numberOfTasksCompleted, forKey: "numberOfTasksCompleted")
    }
    
    class func createUser(uid: String, username:String, email:String) -> User {
        let newUser = User()
        newUser.uid = uid
        newUser.username = username
        newUser.email = email
        newUser.profilePicture = "None"
        newUser.firstName = "N/A"
        newUser.lastName = "N/A"
        newUser.experiencePoints = 0
        newUser.tasks = [Task]()
        return newUser
    }
}

struct Levels {
    func getLevelFor(_ user:User) -> String {
        let level: String = user.experiencePoints < 20 ? "Task Goat" : "Task Wizard"
        return level
    }
}


