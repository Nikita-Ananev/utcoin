//
//  CarouselCell.swift
//  utcoin
//
//  Created by Никита Ананьев on 30.11.2022.
//

import Foundation
import UIKit

class CarouselCell: UICollectionViewCell {
    
    // MARK: SubViews
    
    private lazy var imageView = UIImageView()
    
    // MARK: Properties
    
    static let cellId = "CarouselCell"
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

// MARK: Setups
private extension CarouselCell {
    func setupUI() {
        backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
       
    }
}

// MARK: Public
extension CarouselCell {
    public func configure(image: UIImage?) {
        imageView.image = image
    }
}
