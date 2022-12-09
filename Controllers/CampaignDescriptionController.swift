//
//  CampaignDescriptionController.swift
//  utcoin
//
//  Created by Никита Ананьев on 30.11.2022.
//

import UIKit

class CampaignDescriptionController: UIViewController {
    // MARK: - Property
    var campaign: Campaign?
    let network = Networking()
    // MARK: - Views
    
    lazy var buyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Купить с кэшбеком", for: .normal)
        button.isEnabled = false
        button.backgroundColor = UIColor.colorFromHex("0017ff")
        button.layer.cornerRadius = 25
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    lazy var unwrapButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Развернуть", for: .normal)
        button.isEnabled = true
        button.layer.cornerRadius = 25
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var photo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var campaignNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Product name Product name Product name"
        label.font = .systemFont(ofSize: 19, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
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
    lazy var paymentTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "от 00 до 99 дней"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    lazy var requirementView: RequirementView = {
        let view = RequirementView(frame: CGRect(), actions: [Action]())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setModel()
        unwrapButton.addTarget(self, action: #selector(unwrapButtonPressed), for: .touchUpInside)


        // Do any additional setup after loading the view.
    }
    private func setModel() {
        guard let campaign = campaign else { return }
        campaignNameLabel.text = campaign.name
        cashbackLabel.text = campaign.cashback
        requirementView.actions = campaign.actions
        if let url: URL = URL(string: campaign.imageUrl) {
            network.downloadWithUrlSession(url: url) { [weak self] image in
                DispatchQueue.main.async {
                    self?.photo.image = image
                }
            }

        }
        setConstraints()

    }
    @objc func unwrapButtonPressed() {
        requirementView.showAllActions()
        scrollView.layoutSubviews()
        unwrapButton.isHidden = true
    }
    private func setConstraints() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        scrollView.addSubview(photo)
        
        NSLayoutConstraint.activate([
            photo.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            photo.leftAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leftAnchor, constant: 20),
            photo.rightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.rightAnchor, constant: -20),
            photo.heightAnchor.constraint(equalToConstant: 200)
        ])
        scrollView.addSubview(campaignNameLabel)
        NSLayoutConstraint.activate([
            campaignNameLabel.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 20),
            campaignNameLabel.leftAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leftAnchor, constant: 20),
            campaignNameLabel.rightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.rightAnchor, constant: -20)
        ])
        let cashbackSection = SectionView(frame: CGRect(), section: cashbackView, titleText: "Кэшбек")
        cashbackView.addSubview(cashbackLabel)
        
        scrollView.addSubview(cashbackSection)
        cashbackSection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cashbackSection.topAnchor.constraint(equalTo: campaignNameLabel.bottomAnchor, constant: 40),
            cashbackSection.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            cashbackSection.rightAnchor.constraint(equalTo: scrollView.rightAnchor)
        ])
        NSLayoutConstraint.activate([
            cashbackView.leftAnchor.constraint(equalTo: cashbackLabel.leftAnchor, constant: -10),
            cashbackView.rightAnchor.constraint(equalTo: cashbackLabel.rightAnchor, constant: 10),
            cashbackLabel.topAnchor.constraint(equalTo: cashbackView.topAnchor, constant: 2),
            cashbackLabel.bottomAnchor.constraint(equalTo: cashbackView.bottomAnchor, constant: -2),
            cashbackLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
        let cashbackTimeSection = SectionView(frame: CGRect(), section: paymentTimeLabel, titleText: "Время для начисления кэшбека")
        cashbackTimeSection.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(cashbackTimeSection)
        NSLayoutConstraint.activate([
            cashbackTimeSection.topAnchor.constraint(equalTo: cashbackSection.bottomAnchor, constant: 20),
            cashbackTimeSection.leftAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leftAnchor),
            cashbackTimeSection.rightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.rightAnchor)
            
        ])
        let requirementSection = SectionView(frame: CGRect(), section: requirementView, titleText: "Условия")
        scrollView.addSubview(requirementSection)
        
        requirementSection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            requirementSection.topAnchor.constraint(equalTo: cashbackTimeSection.bottomAnchor, constant: 20),
            requirementSection.leftAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leftAnchor),
            requirementSection.rightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.rightAnchor,constant: -10),
        ])
        scrollView.addSubview(unwrapButton)
        NSLayoutConstraint.activate([
            unwrapButton.topAnchor.constraint(equalTo: requirementSection.bottomAnchor, constant: 20),
            unwrapButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            unwrapButton.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -10),
            unwrapButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        view.addSubview(buyButton)
        NSLayoutConstraint.activate([
            buyButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            buyButton.heightAnchor.constraint(equalToConstant: 50),
            buyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)
        
        ])
    }
    
}
