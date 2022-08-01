//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "03ECAF03-CCDA-449B-8B57-CC36FEAA290D"
    
    func getCoinPrice(for currency: String) {
        print(currency)
    }
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let coin = parseJSON(safeData) {
                        delegate?.didUpdateCoin(self, coin: coin)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinModel.self, from: coinData)
            let coinName = decodedData.asset_id_base
            let fiat = decodedData.asset_id_quote
            let rate = decodedData.rate
            let coin = CoinModel(asset_id_base: coinName, asset_id_quote: fiat, rate: rate)
            return coin
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
