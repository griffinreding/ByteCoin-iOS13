//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    let coinData = CoinData()
//MARK: - PickerComponents
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinData.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinData.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinData.getCoinPrice(for: coinData.currencyArray[row])
    }
}
//MARK: - CoinDataDelegate
extension ViewController: CoinDataDelegate {

    func didUpdateBTCPrice(_ coinData: CoinData, coin: CoinModel) {
        DispatchQueue.main.async {
            print(coin.rate)
            self.bitcoinLabel.text = String(format: ".2f", coin.rate)
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}
