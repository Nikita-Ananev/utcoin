//
//  PhoneRequestData.swift
//  utcoin
//
//  Created by Никита Ананьев on 24.11.2022.
//

import Foundation

/*
 //MARK: JSON Data example
 {
 "successful": true,
 "errorMessage": "",
 "errorMessageCode": "",
 "settings": null,
 "normalizedPhone": "+77076830225",
 "explainMessage": "Введите последние 4 цифры номера телефона входящего звонка. Звонок поступит на номер +77076830225"
 }
 */

struct PhoneRequsetData: Codable, NetworkData {
    let successful: Bool
    let errorMessage: String
    let explainMessage: String
}
