//
//  ProductCell.swift
    //  utcoin
//
//  Created by Никита Ананьев on 27.11.2022.
//

import UIKit

final class ProductCell: UITableViewCell {

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
    
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "999,00 RUB"
        label.font = .systemFont(ofSize: 21, weight: .bold)
        return label
    }()
    lazy var campaignPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var photo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Product name Product name Product name"
        label.numberOfLines = 2
        return label
    }()
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("Hello")
        setConstraints()
    }
    private func setConstraints() {
        contentView.addSubview(photo)
        NSLayoutConstraint.activate([
            photo.widthAnchor.constraint(equalToConstant: 100),
            photo.heightAnchor.constraint(equalToConstant: 150),
            contentView.topAnchor.constraint(equalTo: photo.topAnchor, constant: -20),
            contentView.bottomAnchor.constraint(equalTo: photo.bottomAnchor, constant: 20),
            photo.leftAnchor.constraint(equalTo: leftAnchor, constant: 10)
        ])
        
        contentView.addSubview(productNameLabel)
        NSLayoutConstraint.activate([
            productNameLabel.leftAnchor.constraint(equalTo: photo.rightAnchor, constant: 10),
            productNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            productNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])
        contentView.addSubview(campaignPhoto)
        NSLayoutConstraint.activate([
            campaignPhoto.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 10),
            campaignPhoto.leftAnchor.constraint(equalTo: productNameLabel.leftAnchor, constant: 5),
            campaignPhoto.widthAnchor.constraint(equalToConstant: 80),
            campaignPhoto.heightAnchor.constraint(equalToConstant: 20)
        ])
        contentView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.leftAnchor.constraint(equalTo: productNameLabel.leftAnchor),
            priceLabel.topAnchor.constraint(equalTo: campaignPhoto.bottomAnchor, constant: 10)
        ])
        
        contentView.addSubview(cashbackView)
        
        NSLayoutConstraint.activate([
            cashbackView.leftAnchor.constraint(equalTo: productNameLabel.leftAnchor),
            cashbackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50)
        ])
        cashbackView.addSubview(cashbackLabel)
        
        NSLayoutConstraint.activate([
            cashbackView.leftAnchor.constraint(equalTo: cashbackLabel.leftAnchor, constant: -10),
            cashbackView.rightAnchor.constraint(equalTo: cashbackLabel.rightAnchor, constant: 10),
            cashbackLabel.topAnchor.constraint(equalTo: cashbackView.topAnchor, constant: 2),
            cashbackLabel.bottomAnchor.constraint(equalTo: cashbackView.bottomAnchor, constant: -2)
        ])
        
      
    }
    func displayProductImage(image: UIImage?) {
        photo.image = image
      }
    func displayCampaignImage(image: UIImage?) {
        campaignPhoto.image = image
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
