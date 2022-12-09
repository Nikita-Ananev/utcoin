//
//  DescriptionController.swift
//  utcoin
//
//  Created by Никита Ананьев on 28.11.2022.
//

import UIKit

final class ProductDescriptionController: UIViewController {
    
    //MARK: Property
    var product: Product?
    let network = Networking()
    //MARK: Views
    private var carouselView: CarouselView?
    private var carouselData = [CarouselView.CarouselData]()
    
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
    lazy var requirementView: RequirementView = {
        let view = RequirementView(frame: CGRect(), actions: [Action]())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Product name Product name Product name"
        label.font = .systemFont(ofSize: 19, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    lazy var campaignPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "999,00 RUB"
        label.font = .systemFont(ofSize: 21, weight: .bold)
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        unwrapButton.addTarget(self, action: #selector(unwrapButtonPressed), for: .touchUpInside)
        setModel()


        
    }
    func setModel() {
        guard let product = product else { return }
        productNameLabel.text = product.name
        priceLabel.text = product.price
        cashbackLabel.text = product.cashback
        paymentTimeLabel.text = product.paymentTime
        requirementView.actions = product.actions
        
        carouselView = CarouselView(pages: product.imageUrls.count, delegate: self)

        for url in product.imageUrls {
            guard let url: URL = URL(string: url) else { return}
            network.downloadWithUrlSession(url: url) {[weak self] image in
                DispatchQueue.main.async {
                    self?.carouselData.append(CarouselView.CarouselData(image: image))
                    self?.carouselView?.configureView(with: self!.carouselData)
    
                }
            }
        }
        if let url: URL = URL(string: product.campaignImageUrl) {
            network.downloadWithUrlSession(url: url) { [weak self] image in
                DispatchQueue.main.async {
                    self?.campaignPhoto.image = image
                }
            }

        }
        setLayout()

    }
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
        carouselView?.configureView(with: carouselData)

        }
    @objc func unwrapButtonPressed() {
        requirementView.showAllActions()
        scrollView.layoutSubviews()
        unwrapButton.isHidden = true
        print("hello")
    }
    func setLayout() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        if let carouselView = carouselView {
            carouselView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(carouselView)
            carouselView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                carouselView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
                carouselView.leftAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leftAnchor),
                carouselView.rightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.rightAnchor),
                carouselView.heightAnchor.constraint(equalToConstant: 200),
            ])
        }
        scrollView.addSubview(productNameLabel)
        NSLayoutConstraint.activate([
            productNameLabel.topAnchor.constraint(equalTo: carouselView!.bottomAnchor, constant: 50),
            productNameLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20),
            productNameLabel.rightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.rightAnchor)
        ])
        scrollView.addSubview(campaignPhoto)
        NSLayoutConstraint.activate([
            campaignPhoto.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 20),
            campaignPhoto.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 60),
            campaignPhoto.heightAnchor.constraint(equalToConstant: 50),
            campaignPhoto.widthAnchor.constraint(equalToConstant: 100)
            
        ])
        
        scrollView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: campaignPhoto.bottomAnchor, constant: 20),
            priceLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20),
            priceLabel.rightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.rightAnchor)
        ])
        
        let cashbackSection = SectionView(frame: CGRect(), section: cashbackView, titleText: "Кэшбек")
        cashbackView.addSubview(cashbackLabel)
        
        scrollView.addSubview(cashbackSection)
        cashbackSection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cashbackSection.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 40),
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

// MARK: - Extensions

extension ProductDescriptionController: CarouselViewDelegate {
    func currentPageDidChange(to page: Int) {
        print("CarouselWorks")
    }
    
}
