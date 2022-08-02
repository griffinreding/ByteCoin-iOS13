//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

protocol CoinDataDelegate {
	func didUpdateBTCPrice(_ coinData: CoinData, coin: CoinModel)
	func didFailWithError(error: Error)
}

struct CoinData {
	
	var delegate: CoinDataDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "03ECAF03-CCDA-449B-8B57-CC36FEAA290D"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
					delegate?.didFailWithError(error: error!)
                    print(error!)
                    return
                }
				if let safeData = data {
					if let coin = self.parseJSON(safeData) {
						delegate?.didUpdateBTCPrice(self, coin: coin)
					}
				}
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinModel.self, from: data)
            let lastPrice = decodedData.rate
			let fiatCurr = decodedData.asset_id_quote
			let cryptoCurr = decodedData.asset_id_base
            
			let coin = CoinModel(asset_id_base: cryptoCurr, asset_id_quote: fiatCurr, rate: lastPrice)
			return coin
            
        } catch {
			delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
