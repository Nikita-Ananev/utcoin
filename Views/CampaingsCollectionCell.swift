//
//  CampaingsCollectionCell.swift
//  utcoin
//
//  Created by Никита Ананьев on 29.11.2022.
//

import UIKit
protocol SelectCollectionDelegate: AnyObject {
    func didSelectCampaingCell(indexPath: IndexPath)
}
final class CollectionViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var campaings = [Campaign]()
    let network = Networking()
    var collectionView: UICollectionView?
    var delegate: SelectCollectionDelegate?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectCampaingCell(indexPath: indexPath)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size + size / 3)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        campaings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CampaignsCell", for: indexPath) as! CampaignsCell
        let campaign = campaings[indexPath.row]
        let url = URL(string: "\(campaign.imageUrl)")!
        cell.nameLabel.text = campaign.name
        cell.cashbackLabel.text = campaign.cashback
        network.downloadWithUrlSession(url: url) { image in
            DispatchQueue.main.async {
                cell.displayImage(image: image)
            }
        }
        return cell
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView?.register(CampaignsCell.self, forCellWithReuseIdentifier: "CampaignsCell")
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.backgroundColor = .white
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        setConstraints()

    }
    func setConstraints() {
        guard let collectionView = collectionView else {return}
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            contentView.heightAnchor.constraint(equalToConstant: 280)
        ])
    }
    
}

