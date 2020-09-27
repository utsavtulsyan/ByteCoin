//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(_ coinManager: CoinManager,_ coinModel: CoinModel)
    func didFailWithError(_ error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "CEFF5D37-38BE-47FD-AFFF-5D43F648FD6D"
    
    var delegate: CoinManagerDelegate? = nil
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String){
        performRequest(urlString: "\(baseURL)/\(currency)?apikey=\(apiKey)")
    }
    
    func performRequest(urlString: String){
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handleComplete(data:urlResponse:error:))
            task.resume()
        }
        
    }
    
    func handleComplete( data: Data?, urlResponse: URLResponse?, error: Error?){
        if let error = error {
            delegate?.didFailWithError(error)
            return
        }
        if let data = data {
            let decoder = JSONDecoder()
            do{
                let decodedData = try decoder.decode(CoinData.self, from: data)
                let rate = String(format: "%.2f", decodedData.rate)
                let coinModel = CoinModel(rate: rate, currency: decodedData.asset_id_quote)
                delegate?.didUpdatePrice(self, coinModel)
                
            }catch{
                delegate?.didFailWithError(error)
            }
        }
    }
    
}
