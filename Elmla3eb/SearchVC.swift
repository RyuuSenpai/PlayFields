 //
 //  SearchVC.swift
 //  Elmla3eb
 //
 //  Created by Macbook Pro on 5/2/17.
 //  Copyright © 2017 Killvak. All rights reserved.
 //
 
 import UIKit
 import CDAlertView
 
 class SearchVC: ToSideMenuClass , UITextFieldDelegate{
    
    
    @IBOutlet weak var searchBtnOL: UIButton!
    @IBOutlet weak var fieldNameTxt: UITextField!
    
    @IBOutlet weak var cityTxt: UITextField!
    
    @IBOutlet weak var rateTxt: UITextField!
    
    @IBOutlet weak var fromTxt: UITextField!
    
    @IBOutlet weak var toTxt: UITextField!
    @IBOutlet weak var loadingVC: UIView!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    var searchModel : Search_Model!
    var cities = ["cairo","Alex"]
    let rateList = ["1","2","3","4","5"]
    fileprivate var citiesPickerV: UIPickerView!
    fileprivate var ratePickerV: UIPickerView!
    var isFromDate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title =  langDicClass().getLocalizedTitle("Search")
        
        cityTxt.delegate = self
        fieldNameTxt.delegate = self
        rateTxt.delegate = self
        fromTxt.delegate = self
        toTxt.delegate = self
        
     setupPicker()
        
        self.view.squareLoading.start(0)
        let global = GLOBAL()
        let langIs = L102Language.currentAppleLanguage()
        global.readJson(langIs: langIs, completed: { [weak self] (data) in
            
            self?.cities = data
            self?.view.squareLoading.stop(0)
        })
        
    }
    
    override func toSidemenuVC() {
        super.toSidemenuVC()
        ad.sideMenuTrigger(self,"Search")
    }
    
    @IBAction func searchBtnAct(_ sender: UIButton) {
        disableView(true)
        guard let name =  fieldNameTxt.text, let city = cityTxt.text, let rate = rateTxt.text, let fromDate = fromTxt.text, let toDate = toTxt.text,(!name.isEmpty || !city.isEmpty || !rate.isEmpty || !fromDate.isEmpty || !toDate.isEmpty ) else{
            ad.showAlert(langDicClass().getLocalizedTitle("Error"), langDicClass().getLocalizedTitle("At least one Field has to be filled"))
            disableView(false)
            return
        }
        searchModel = Search_Model()
        searchModel.getSearchData(pg_name: name, address: city, rating: rate, fromData: fromDate, toDate: toDate) {[weak self] (data) in
            if data.2 {
                guard let searchResult = data.0 , searchResult.count > 0 else {
                    DispatchQueue.main.async {
                        
                        let alert = CDAlertView(title: langDicClass().getLocalizedTitle("Done"), message:langDicClass().getLocalizedTitle("No Data Found") , type: .warning)
                        alert.show()
                        self?.disableView(false)
                    }
                    return
                }
            
                DispatchQueue.main.async {
                    let vc = SearchResultVC(nibName: "SearchResultVC", bundle: nil)
                    vc.searchResultData = searchResult
                     self?.navigationController?.pushViewController(vc, animated: true)
                    self?.disableView(false)
                }
                
            }else {
                ad.showAlert("defaultTitle", "\(data.1)")
                self?.disableView(false)
            }
            
        }
        
        
    }
    
    func disableView( _ state : Bool) {
       if state {
            self.loadingVC.alpha = 1
            self.loadingActivity.startAnimating()
        }else {
            self.loadingVC.alpha = 0
            self.loadingActivity.stopAnimating()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //    func datePickerChanged(_ sender: UIDatePicker) {
    //        let formatter = DateFormatter()
    //        formatter.dateFormat = "dd/MM/yyyy"
    //        dateTextField.text = formatter.string(from: sender.date)
    //    }
    func timePickerChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if isFromDate {
            fromTxt.text = formatter.string(from: sender.date)
        }else {
            toTxt.text = formatter.string(from: sender.date)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == toTxt || textField == fromTxt {
            if textField == toTxt {    isFromDate = false } else {   isFromDate = true }
            
            let datePicker = UIDatePicker()
            datePicker.minimumDate = Date()
            
            let secondsInMonth: TimeInterval = 360 * 24 * 60 * 60
            datePicker.maximumDate = Date(timeInterval: secondsInMonth, since: Date())
            
            datePicker.datePickerMode = UIDatePickerMode.date
            textField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(self.timePickerChanged(_:)), for: .valueChanged)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if   textField == toTxt || textField == fromTxt  ,  textField.text == "" {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let date  = formatter.string(from: NSDate() as Date)
            textField.text = date
            
        } else if  textField == cityTxt ,  textField.text == "" {
            textField.text = cities[0]
            
        }else  if  textField == rateTxt ,  textField.text == "" {
            textField.text = rateList[0]
            
        }
    }
    
    
    
    
 }
 
 
 
 
 
 
 
 extension SearchVC :  UIPickerViewDelegate, UIPickerViewDataSource {
    
    func setupPicker() {
        citiesPickerV = UIPickerView()
        citiesPickerV.dataSource = self
        citiesPickerV.delegate = self
        cityTxt.inputView = citiesPickerV
        
        ratePickerV = UIPickerView()
        ratePickerV.dataSource = self
        ratePickerV.delegate = self
        rateTxt.inputView = ratePickerV
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard pickerView == citiesPickerV else {
            return rateList.count
        }
        return cities.count
    }
    //    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //        return cities[row]
    //    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard pickerView == citiesPickerV else {
            rateTxt.text = rateList[row]
            self.view.endEditing(true)
            return
        }
        cityTxt.text = cities[row]
        self.view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.font = UIFont(name: "Times New Roman", size: 22.0)
        label.tag = 20
        label.textAlignment = .center
        
        guard pickerView == citiesPickerV else {
            label.text = rateList[row]
            return label
        }
        label.text = cities[row]
        return label
    }
    
    
 }
 
