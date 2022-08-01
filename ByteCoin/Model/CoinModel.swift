//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Griffin Reding on 7/31/22.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel: Codable{
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}
