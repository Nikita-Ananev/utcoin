//
//  RequirementView.swift
//  utcoin
//
//  Created by Никита Ананьев on 30.11.2022.
//

import UIKit

class RequirementView: UIView {
    var actions: [Action] {
        didSet {
            setupConstraints()
        }
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()
    init(frame: CGRect, actions: [Action]) {
        self.actions = actions
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func setupConstraints() {
        
        guard let action = actions.first else {return}
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let pinkText = "\(action.value) "
        let attrs = [NSAttributedString.Key.foregroundColor : UIColor.systemPink]
        let attributedString = NSMutableAttributedString(string:pinkText, attributes:attrs)
        
        let normalText = action.text
        let normalString = NSMutableAttributedString(string:normalText)
        
        attributedString.append(normalString)
        label.attributedText = attributedString
        label.numberOfLines = 0
        stackView.addArrangedSubview(label)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            topAnchor.constraint(equalTo: stackView.topAnchor),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])
    }
    func showAllActions() {
        guard actions.count > 1 else {return}
        print(actions)
        for i in 1..<actions.count {
            let action = actions[i]
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            
            let pinkText = "\(action.value) "
            let attrs = [NSAttributedString.Key.foregroundColor : UIColor.systemPink]
            let attributedString = NSMutableAttributedString(string:pinkText, attributes:attrs)
            
            let normalText = action.text
            let normalString = NSMutableAttributedString(string:normalText)
            
            attributedString.append(normalString)
            label.attributedText = attributedString
            label.numberOfLines = 0
            stackView.addArrangedSubview(label)
        }
    }
}
