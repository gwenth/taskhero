import UIKit

class NotificationPopover: BasePopoverAlert {
    
    lazy var notifyPopView: NotificationView = {
        let popView = NotificationView()
        popView.layer.cornerRadius = 10
        popView.backgroundColor = .white
        popView.layer.borderColor = UIColor.black.cgColor
        popView.layer.borderWidth = 1
        return popView
    }()
    
    override func showPopView(viewController: UIViewController) {
        super.showPopView(viewController: viewController)
        notifyPopView.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.width * 0.8, height:UIScreen.main.bounds.height * 0.35)
        notifyPopView.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY * 0.7)
        notifyPopView.clipsToBounds = true
        viewController.view.addSubview(notifyPopView)
        viewController.view.bringSubview(toFront: notifyPopView)
        notifyPopView.isHidden = false
        notifyPopView.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor, constant: 0).isActive = true
        notifyPopView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor, constant: 0).isActive = true
    }
    
    override func hidePopView(viewController: UIViewController) {
        notifyPopView.isHidden = true
        viewController.view.sendSubview(toBack: notifyPopView)
        
    }
}
