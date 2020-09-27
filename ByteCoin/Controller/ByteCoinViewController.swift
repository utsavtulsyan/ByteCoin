//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ByteCoinViewController: UIViewController {
    
    var coinManager = CoinManager()
    
    
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
    
    
    


}

//MARK: - UIPickerViewDataSource

extension ByteCoinViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}


//MARK: - UIPickerViewDelegate

extension ByteCoinViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.getCoinPrice(for: coinManager.currencyArray[ row ])
    }
}

//MARK: - CoinManagerDelegate

extension ByteCoinViewController: CoinManagerDelegate{
    func didUpdatePrice(_ coinManager: CoinManager, _ coinModel: CoinModel) {
        DispatchQueue.main.async{
            self.bitcoinLabel.text = coinModel.rate
            self.currencyLabel.text = coinModel.currency
        }
        
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
    
}
