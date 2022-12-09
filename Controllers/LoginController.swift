//
//  ViewController.swift
//  utcoin
//
//  Created by Никита Ананьев on 23.11.2022.
//

import UIKit

final class LoginController: UIViewController {
    
    //MARK: Property
    var textFieldValue = ""
    let network = Networking()
    
    //MARK: Views
    lazy var headerText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.text = "Войти"
        label.numberOfLines = 0
        return label
    }()
    lazy var enterNumberDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Введите номер телефона, чтобы войти или зарегистрироваться"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .light)
        return label
    }()
    lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Номер телефона"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    lazy var phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "+79001112233"
        textField.keyboardType = .phonePad
        textField.addBottomBorder()
        return textField
    }()
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Далее", for: .normal)
        button.isEnabled = false
        button.backgroundColor = UIColor.colorFromHex("c9c9c9")
        button.layer.cornerRadius = 25
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    lazy var rulesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Нажимая кнопку \"Далее\", вы соглашаетесь с условиями Пользовательского соглашения и с обработкой вашей персональной информации на условиях Политики конфиденциальности."
        label.font = .systemFont(ofSize: 14, weight: .thin)
        label.numberOfLines = 0
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        phoneNumberTextField.delegate = self
        
        phoneNumberTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        
        setContraints()
    }
    
    @objc func nextButtonPressed() {
        print(textFieldValue)
        sendRequest()
        
    }
    
    private func sendRequest() {
        network.sendPhoneRequest(to: textFieldValue) { [weak self] result in
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
            } else {
                let loginConfirm = LoginConfirmController()
                loginConfirm.phoneNumber = self.textFieldValue
                self.navigationController?.pushViewController(loginConfirm, animated: true)
            }
        
    }
    //MARK: Constraints
    private func setContraints() {
        view.addSubview(headerText)
        NSLayoutConstraint.activate([
            headerText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 17),
            headerText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -17)
        ])
        view.addSubview(enterNumberDescriptionLabel)
        NSLayoutConstraint.activate([
            enterNumberDescriptionLabel.leftAnchor.constraint(equalTo: headerText.leftAnchor),
            enterNumberDescriptionLabel.rightAnchor.constraint(equalTo: headerText.rightAnchor),
            enterNumberDescriptionLabel.topAnchor.constraint(equalTo: headerText.bottomAnchor, constant: 10)
        ])
        
        view.addSubview(phoneNumberLabel)
        NSLayoutConstraint.activate([
            phoneNumberLabel.leftAnchor.constraint(equalTo: enterNumberDescriptionLabel.leftAnchor),
            phoneNumberLabel.topAnchor.constraint(equalTo: enterNumberDescriptionLabel.bottomAnchor, constant: 25)
        ])
        
        view.addSubview(phoneNumberTextField)
        NSLayoutConstraint.activate([
            phoneNumberTextField.leftAnchor.constraint(equalTo: enterNumberDescriptionLabel.leftAnchor),
            phoneNumberTextField.rightAnchor.constraint(equalTo: enterNumberDescriptionLabel.rightAnchor),
            phoneNumberTextField.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 10),
        ])
        view.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.widthAnchor.constraint(equalToConstant: 300),
            nextButton.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 15),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        view.addSubview(rulesLabel)
        NSLayoutConstraint.activate([
            rulesLabel.leftAnchor.constraint(equalTo: enterNumberDescriptionLabel.leftAnchor),
            rulesLabel.rightAnchor.constraint(equalTo: enterNumberDescriptionLabel.rightAnchor),
            rulesLabel.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 20)
        ])
    }
}

extension LoginController: UITextFieldDelegate {
    
    @objc func textFieldChanged(_ sender: Any) {
        guard let tf = sender as? UITextField else { return }
        let text: String = tf.text ?? ""
        textFieldValue = text
        
        checkTextCondition(text)
        
    }
    
    private func checkTextCondition(_ text: String) {
        if text.first == "+" && text.count <= 19 && text.count >= 8 {
            buttonCondition(state: true)
        } else {
            buttonCondition(state: false)
        }
    }
    
    /// - Changing condition nextButton
    private func buttonCondition(state: Bool) {
        nextButton.isEnabled = state
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0) { [weak nextButton = self.nextButton] in
                nextButton?.backgroundColor = state ? UIColor.colorFromHex("00cc00") : UIColor.colorFromHex("c9c9c9")
            }
        }
    }
}
