//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coinData: CoinData)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "65D041FB-39FE-420C-BC2B-4C9E253AEAE2"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        //1.Create URL
        if let url = URL(string: urlString){
            //2.Create URL session
            let session = URLSession(configuration: .default)
            //3.Give the session a task
            let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            //4.Start the task
            task.resume()
        }
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil{
            self.delegate?.didFailWithError(error: error!)
            return
        }
        if let safeData = data {
            if let coin = parseJSON(coinData: safeData){
                self.delegate?.didUpdateCoin(self, coinData:coin)
            }
        }
    }
    
    func parseJSON(coinData: Data) -> CoinData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let rate = decodedData.rate
            let base = decodedData.asset_id_base
            let quote = decodedData.asset_id_quote
            
            let coin = CoinData(asset_id_base: base, asset_id_quote: quote, rate: rate)
            
            return coin
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

    
}
