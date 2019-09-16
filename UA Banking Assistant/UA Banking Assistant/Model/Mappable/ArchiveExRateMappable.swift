//
//  ArchiveExRateMappable.swift
//  UA Banking Assistant
//
//  Created by admin on 9/9/19.
//  Copyright © 2019 Viacheslav Savitsky. All rights reserved.
//

import Foundation
import ObjectMapper

class ArchiveExRateMappable: Mappable {
    
    var date: String?
    var bank: String?
    var baseCurrency: Int?
    var baseCurrencyLit: String?
    var exchangeRate: [ExchangeRateMappable] = []
    
    required init?(map: Map) {
        do {
            self.date = try map.value("date")
        } catch {
            debugPrint("No status present")
        }
    }
    
    func mapping(map: Map) {
        bank                <- map["bank"]
        baseCurrency        <- map["baseCurrency"]
        baseCurrencyLit     <- map["baseCurrencyLit"]
        exchangeRate        <- map["exchangeRate"]
    }
}

class ExchangeRateMappable: Mappable {
    
    var baseCurrency: String?
    var currency: String?
    var saleRate: Double?
    var purchaseRate: Double?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        baseCurrency       <- map["baseCurrency"]
        currency           <- map["currency"]
        saleRate           <- map["saleRateNB"]
        purchaseRate       <- map["purchaseRateNB"]
    }
}
