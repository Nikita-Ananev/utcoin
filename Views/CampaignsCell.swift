//
//  CampaignsCell.swift
//  utcoin
//
//  Created by Никита Ананьев on 24.11.2022.
//

import UIKit

final class CampaignsCell: UICollectionViewCell {

    
    lazy var cashbackLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "до 62.30%"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    lazy var cashbackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.colorFromHex("d6468f")
        view.layer.cornerRadius = 10
        
        return view
    }()
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowRadius = 2
        
        return view
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        label.text = "Aliexpress"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setConstraints()
    }
    
    func setConstraints() {
        
        addSubview(shadowView)
        NSLayoutConstraint.activate  ([
            shadowView.centerXAnchor.constraint(equalTo: centerXAnchor),
            shadowView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            shadowView.widthAnchor.constraint(equalToConstant: frame.size.width - 10),
            shadowView.heightAnchor.constraint(equalToConstant: frame.size.width - 10)
        ])
        shadowView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: shadowView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: shadowView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor)
        ])
        
        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: shadowView.leftAnchor, constant: 5),
            nameLabel.rightAnchor.constraint(equalTo: shadowView.rightAnchor, constant: -5),
            nameLabel.topAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
        addSubview(cashbackView)
        NSLayoutConstraint.activate([
            cashbackView.leftAnchor.constraint(equalTo: shadowView.leftAnchor, constant: 5),
            cashbackView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -5),
        ])
        cashbackView.addSubview(cashbackLabel)
        NSLayoutConstraint.activate([
            cashbackView.leftAnchor.constraint(equalTo: cashbackLabel.leftAnchor, constant: -10),
            cashbackView.rightAnchor.constraint(equalTo: cashbackLabel.rightAnchor, constant: 10),
            cashbackLabel.topAnchor.constraint(equalTo: cashbackView.topAnchor, constant: 2),
            cashbackLabel.bottomAnchor.constraint(equalTo: cashbackView.bottomAnchor, constant: -2)
        ])
        
    }
    func displayImage(image: UIImage?) {
        imageView.image = image
      }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    //    setConstraints()

    }
}
