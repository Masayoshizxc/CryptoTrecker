//
//  Models.swift
//  CryptoTrecker
//
//  Created by Adilet on 22/3/22.
//

import Foundation


struct Crypto: Codable{
    let currency: String
    let name: String?
    let price: String?
    let logo_url: String?
}

struct Icon: Codable{
    let logo_url: String
    let currency: String
}
