//
//  LoginRequestData.swift
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
     "settings": {
         "moneyFraction": 2,
         "tokenFraction": 2,
         "mainCurrencyDisplay": "$"
     },
     "sessionId": "7384069735"
 }
 */
struct LoginRequestData: Codable, NetworkData {
    var successful: Bool
    var errorMessage: String
    var sessionId: String
}
