//
//  SectionView.swift
//  utcoin
//
//  Created by Никита Ананьев on 29.11.2022.
//

import UIKit

class SectionView: UIView {
    var section: UIView
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        label.text = "Цена"
        label.numberOfLines = 1
        return label
    }()

    init(frame: CGRect, section: UIView, titleText: String) {
        self.section = section
        super.init(frame: frame)
        titleLabel.text = titleText
        setupConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupConstraints() {
        section.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        addSubview(section)
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: titleLabel.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            //titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            section.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            section.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            section.rightAnchor.constraint(equalTo: rightAnchor),
            bottomAnchor.constraint(equalTo: section.bottomAnchor)
        ])
        
    }
}
