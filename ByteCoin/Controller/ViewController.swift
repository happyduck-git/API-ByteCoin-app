//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    var coinManager = CoinManager()
    
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var bitCoinPriceLabel: UILabel!
    @IBOutlet var currencyPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPickerView.dataSource = self
        currencyPickerView.delegate = self
        coinManager.delegate = self
    }

}

//MARK: - UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}

//MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return coinManager.currencyArray[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currencySelected = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: currencySelected)
    }
}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coinData: CoinData) {
        DispatchQueue.main.async {
            self.currencyLabel.text = coinData.asset_id_quote
            self.bitCoinPriceLabel.text = String(format: "%.2f", coinData.rate)
            print(String(format: "%.2f", coinData.rate))
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}


