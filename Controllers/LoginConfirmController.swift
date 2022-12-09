//
//  LoginConfirmController.swift
//  utcoin
//
//  Created by Никита Ананьев on 24.11.2022.
//

import UIKit

final class LoginConfirmController: UIViewController {
    
    // MARK: Property
    var phoneNumber: String = ""
    var textFieldValue: String = ""
    let network = Networking()
    
    // MARK: Views
    lazy var headerText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.text = "Подтверждение телефона"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let boldText = "\(phoneNumber)"
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
        
        let normalText = "Введите код из SMS, отправленного на номер "
        let normalString = NSMutableAttributedString(string:normalText)
        
        normalString.append(attributedString)
        label.attributedText = normalString
        label.numberOfLines = 0
        return label
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "****"
        textField.keyboardType = .phonePad
        textField.addBottomBorder()
        return textField
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отправить код ещё раз", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        passwordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
        setConstraints()
    }
    
    
    private func setConstraints() {
        view.addSubview(headerText)
        NSLayoutConstraint.activate([
            headerText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 17),
            headerText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -17)
            
        ])
        
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: headerText.bottomAnchor, constant: 10),
            descriptionLabel.leftAnchor.constraint(equalTo: headerText.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: headerText.rightAnchor)
        ])
        view.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            passwordTextField.leftAnchor.constraint(equalTo: headerText.leftAnchor),
            passwordTextField.rightAnchor.constraint(equalTo: headerText.rightAnchor)
        ])
        view.addSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            sendButton.leftAnchor.constraint(equalTo: passwordTextField.leftAnchor)
        ])
    }
    
    @objc func sendButtonPressed() {
        network.sendPhoneRequest(to: phoneNumber) { [weak self] result in
            switch result {
            case .sucsses(let data):
                guard let phoneData: PhoneRequsetData = data as? PhoneRequsetData else {
                    return
                }
                self?.requestHandler(request: phoneData)
            case .error(let error):
                print(error)
            }
        }
    }
    private func requestHandler(request: PhoneRequsetData) {
            if request.errorMessage != "" {
                let popup = PopUpWindow(title: "Ошибка", text: request.errorMessage, buttontext: "Ок")
                self.present(popup, animated: true, completion: nil)
            }
    }
    
    private func sendRequest() {
        guard let password = passwordTextField.text else { return }
        network.sendLoginRequest(number: phoneNumber, password: password) { [weak self] result in
            switch result {
            case .error(error: let erorr):
                print(erorr)
            case .sucsses(data: let data):
                guard let loginData = data as? LoginRequestData else { return }
                self?.requestHandler(request: loginData)
                print(loginData)
            }
            
            
        }
    }
    private func requestHandler(request: LoginRequestData) {
            if request.errorMessage != "" {
                let popup = PopUpWindow(title: "Ошибка", text: request.errorMessage, buttontext: "Ок")
                self.present(popup, animated: true, completion: nil)
            } else {
                let searchController = SearchViewController()
                self.navigationController?.pushViewController(searchController, animated: true)
            }
        
    }
    
}



extension LoginConfirmController: UITextFieldDelegate {
    
    @objc func textFieldChanged(_ sender: Any) {
        guard let tf = sender as? UITextField else { return }
        let text: String = tf.text ?? ""
        textFieldValue = text
        if textFieldValue.count == 4 {
            sendRequest()
        }
    }
}
