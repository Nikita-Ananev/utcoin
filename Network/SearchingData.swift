//
//  SearchingData.swift
//
//
//  Created by Никита Ананьев on 25.11.2022.
//

import Foundation

// MARK: - SearchingData
struct SearchingData: Codable, NetworkData {
    let successful: Bool
    //let errorMessage, errorMessageCode: String
    let campaigns: [Campaign]
    let products: [Product]
}

// MARK: - Campaign
struct Campaign: Codable {
    let id: Int
    let name: String
    let cashback: String
    let actions: [Action]
    let imageUrl: String
    let paymentTime: String

}

// MARK: - Action
struct Action: Codable {
    let value: String
    let text: String
}



// MARK: - Product
struct Product: Codable {
    let id: Int
    let name: String
    let cashback: String
    let actions: [Action]
    let imageUrls: [String]
    let price: String
    let campaignName: String
    let campaignImageUrl: String
    let paymentTime: String

}
