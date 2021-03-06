import UIKit

enum ButtonType {
    
    case login(title:String), system(title:String, color: UIColor), tag(title:String, color:UIColor, tag: Int, index: IndexPath)
    
    fileprivate func setupLoginButton(with title:String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = Constants.Color.mainColor.setColor
        button.setAttributedTitle( NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: Constants.Font.fontNormal!]), for: .normal)
        configureButton(button: button)
        return button
    }
    
    fileprivate func configureButton(button:UIButton) {
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 1
    }
    
    fileprivate func setupSystemButton(with title:String, color: UIColor?) -> UIButton {
        let button = TagButton()
        let buttonColor = color ?? .black
        button.setAttributedTitle( NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: buttonColor, NSFontAttributeName: Constants.Font.fontNormal!]), for: .normal)
        configureButton(button: button)
        return button as UIButton
    }
    
    fileprivate func setupTagButton(with title:String, color: UIColor?, tag: Int, index: IndexPath) -> TagButton {
        let button = TagButton()
        let buttonColor = color ?? .black
        button.setAttributedTitle( NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: buttonColor, NSFontAttributeName: Constants.Font.fontNormal!]), for: .normal)
        configureButton(button: button)
        button.buttonTag = tag
        button.index = index
        return button
    }
    
    public var newButton: UIButton {
        switch self {
        case let .login(title):
            return setupLoginButton(with: title)
        case let .system(title, color):
            return setupSystemButton(with: title, color: color)
        default:
            return UIButton()
        }
    }
    
    public var tagButton: TagButton {
        switch self {
        case let .tag(title: title, color: color, tag: tag, index:index):
            return setupTagButton(with: title, color: color, tag: tag, index:index)
        default:
            return TagButton()
        }
    }
}

final class TagButton: UIButton {
    var buttonTag: Int?
    var index: IndexPath?
}
