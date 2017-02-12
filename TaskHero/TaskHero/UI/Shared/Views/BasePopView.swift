import UIKit

class BasePopView: UIView {
    
    open lazy var headBanner: UIView = {
        let banner = UIView()
        banner.backgroundColor = .black
        return banner
    }()
    
    open lazy var alertLabel: UILabel = {
        let searchLabel = UILabel()
        searchLabel.textColor = .white
        searchLabel.text = "Notification"
        searchLabel.font = Constants.Font.fontNormal
        searchLabel.textAlignment = .center
        return searchLabel
    }()
    
    private func addHeaderBanner(headBanner:UIView) {
        addSubview(headBanner)
        headBanner.translatesAutoresizingMaskIntoConstraints = false
        headBanner.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headBanner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        headBanner.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25).isActive = true
        headBanner.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
    }
    
    private func addAlertLabel(label:UILabel) {
        addSubview(alertLabel)
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        alertLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        alertLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        alertLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25).isActive = true
        alertLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
    }
    
    open func setupConstraints() {
        addHeaderBanner(headBanner: headBanner)
        addAlertLabel(label:alertLabel)
    }
}
