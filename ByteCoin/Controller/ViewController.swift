//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //Thêm UIPickerViewDataSource ( Protocal) vào có nghĩa là ViewController sẽ cung cấp dữ liệu cho UIPickerView
    //Cái thanh mình vuốt (pickerView) sẽ nhân data từ đây, cụ thể là CoinManager
    //-> cần tạo 1 object của CoinManager, để đưa giá trị vào picker
    var coinManagerObject = CoinManager()
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var bitcoinValueLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
}
//MARK: -UIPickerViewDataSource
extension ViewController {
    override func viewDidLoad() {
           super.viewDidLoad()
           // Do any additional setup after loading the view.
           //Phải cài đặt cho WiewController là đataSource cho Picker
           currencyPicker.dataSource =  self //Data Sourse là build in function
           //The data source must implement the required methods to "return the number of components" and the "number of rows in each component."
           currencyPicker.delegate = self // Muốn gọi dòng này thì phải thêm UIPickerViewDelegate ở ViewController mới
           coinManagerObject.delegateCoinObject = self
       }
}
//MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           //Xác định có bao nhiêu cột muốn thêm vào trong UIPickerView -> trong trường hợp này là 1
           return 1
       }
       
       // Bây giờ nói cho Xcode biết bao nhiêu dòng mình cần viết bao nhiêu dòng cho Picker
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           //trả vể độ dài của chuỗi currencyArray
           
           return coinManagerObject.currencyArray.count
       }
       //Bây giờ viết chồng hàm Delegate pickerView -> trả về string là tên của các currency được lưu trong currencyArray ở coinManager
       func pickerView(_ pickerView:UIPickerView, titleForRow rowIndex:Int, forComponent component:Int) ->String? {
           // Hàm này bây giờ trả về toàn bộ data currencyArray-> thêm vào PickerView để người dùng thấy được toàn bộ lưạ chọn có thể chọn của họ
           return coinManagerObject.currencyArray[rowIndex]
           
       }
       
       func pickerView(_ pickerView:UIPickerView, didSelectRow row:Int , inComponent component:Int) {
           print(coinManagerObject.currencyArray[row]) //In ra gía trị của Index trong CurrencyArray -> máy đã hiểu người dùng muốn chọn gì
           let selectedCurrency = coinManagerObject.currencyArray[row]// Bươc tiếp theo sẽ đưa giá trị đồng tiền tìm được trên Internet -> gán vào đồng tiền mà người dùng đã chọn
           coinManagerObject.getCoinPrice(for: selectedCurrency)
       }
}
//MARK: - CoinManagerDelegate
extension ViewController:CoinManagerDelegate {
    func didUpdateCoin(CoinManagerInput: CoinManager, coinModelObject:CoinModel)
       {
           print (coinModelObject.priceRate)
           DispatchQueue.main.async {
               self.bitcoinValueLabel.text =  String(format: "%0.4f", coinModelObject.priceRate )
               self.currencyLabel.text  = coinModelObject.currencyExchange
           }
       }
       func didFailWithError(error: Error){
           print(error)
       }
}

