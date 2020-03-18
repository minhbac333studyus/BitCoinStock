//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation
protocol CoinManagerDelegate {
    func didUpdateCoin(CoinManagerInput: CoinManager, coinModelObject:CoinModel)
    func didFailWithError(error: Error)
}
struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "E5F5F2F0-E785-4F86-932C-6BB7CC1DC7BA"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    func getCoinPrice(for currency: String)  {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        self.performRequest(with :urlString)
        
    }
    var delegateCoinObject:CoinManagerDelegate?
    func performRequest(with urlString:String)  {
        if  let urlLink = URL( string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: urlLink, completionHandler: handle(data:response:error:))
            task.resume()
        }
    }
    func handle(data: Data?, response: URLResponse?, error: Error?)  {
        if error != nil {
            self.delegateCoinObject?.didFailWithError(error: error!)
            return
        }
        let dataAsString = String(data: data!,encoding: .utf8)
        print(dataAsString!)
        if let safeData = data {
            if let coinDecodeObject_byJSON = self.parseJSON(safeData){
                self.delegateCoinObject?.didUpdateCoin(CoinManagerInput: self, coinModelObject: coinDecodeObject_byJSON )
            }
        }
    }
    func parseJSON(_ data: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPriceRate = decodedData.rate
            let lastCurrencyUnit = decodedData.asset_id_quote
            let CoinModelObject_rate = CoinModel(priceRate: lastPriceRate, currencyExchange: lastCurrencyUnit)
            
            print (lastPriceRate)
            return CoinModelObject_rate
        } catch {
            delegateCoinObject?.didFailWithError(error: error)
            return nil
        }
    }
    
    //func parseJSON(safeData:)
    
}
