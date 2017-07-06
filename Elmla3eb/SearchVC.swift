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
    
    @IBOutlet weak var clearCityBtn: UIButton!
    @IBOutlet weak var cityTxt: UITextField!
    
    @IBOutlet weak var clearRateBtn: UIButton!
    @IBOutlet weak var rateTxt: UITextField!
    
    @IBOutlet weak var fromTxt: UITextFieldX!
    
    @IBOutlet weak var clearToTimeBtn: UIButton!
    @IBOutlet weak var toTxt: UITextFieldX!
    @IBOutlet weak var clearFromTimebtn: UIButton!
    @IBOutlet weak var loadingVC: UIView!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    var isCityPicker = true
    var searchModel : Search_Model!
    var cities = ["cairo","Alex"]
    let rateList = ["1","2","3","4","5"]
    var fromDateVar : Date?
    var toMinDate : Date?
    var selectedCity = ""
    var selectedRate = ""
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5
            ) {

            self?.view.squareLoading.stop(0)
            }
        })
        
    }
    
    override func toSidemenuVC() {
        super.toSidemenuVC()
        ad.sideMenuTrigger(self,"Search")
    }
    
    @IBAction func searchBtnAct(_ sender: UIButton) {
        disableView(true)
        //        guard let name =  fieldNameTxt.text, let city = cityTxt.text, let rate = rateTxt.text, let fromDate = fromTxt.text, let toDate = toTxt.text,(!name.isEmpty || !city.isEmpty || !rate.isEmpty || !fromDate.isEmpty || !toDate.isEmpty ) else{
        //            ad.showAlert(langDicClass().getLocalizedTitle("Error"), langDicClass().getLocalizedTitle("At least one Field has to be filled"))
        //            disableView(false)
        //            return
        //        }
        searchModel = Search_Model()
        //        searchModel.getSearchData(pg_name: name, address: city, rating: rate, fromData: fromDate, toDate: toDate) {[weak self] (data) in
        searchModel.getSearchData(pg_name: fieldNameTxt.text, address: cityTxt.text, rating: rateTxt.text, fromData: fromTxt.text, toDate: toTxt.text) {[weak self] (data) in
            if data.2 /* -> State */{
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
                ad.showAlert("X", "\(data.1)")
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
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fieldNameTxt.text = ""
        cityTxt.text = ""
        rateTxt.text = ""
        fromTxt.text = ""
        toTxt.text = ""
        clearCityBtn.alpha = 0
        clearRateBtn.alpha = 0
        clearFromTimebtn.alpha = 0
        clearToTimeBtn.alpha = 0
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
            fromDateVar = sender.date
            fromTxt.text = formatter.string(from: sender.date)
        }else {
            toTxt.text = formatter.string(from: sender.date)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let datePicker = UIDatePicker()
        
        if textField == toTxt || textField == fromTxt {
            if textField == toTxt {
                guard let fromTxt = fromTxt.text , !fromTxt.isEmpty , let fromDate = fromDateVar else {
                ad.showAlert(langDicClass().getLocalizedTitle("Error"), langDicClass().getLocalizedTitle("'From' Field is required to fill 'To' Field."))
                    toTxt.resignFirstResponder()
                    return }
                isFromDate = false
                 toTxt.text = ""
                let secondsInDay: TimeInterval = 86400
                toMinDate = Date(timeInterval: secondsInDay, since: fromDate)
                datePicker.minimumDate = toMinDate
                let secondsInMonth: TimeInterval = 360 * 24 * 60 * 60
                if let date = toMinDate {
                datePicker.maximumDate = Date(timeInterval: secondsInMonth, since: fromDate)
                }
            } else {
                isFromDate = true
                toTxt.text = ""
                fromTxt.text = ""
                 clearBtnUIMangment(clearToTimeBtn, toTxt)
                datePicker.minimumDate = Date()
                let secondsInMonth: TimeInterval = 360 * 24 * 60 * 60
                datePicker.maximumDate = Date(timeInterval: secondsInMonth, since: Date())

            }
            
            
            
            datePicker.datePickerMode = UIDatePickerMode.date
            textField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(self.timePickerChanged(_:)), for: .valueChanged)
        }
        
        switch textField {
          case fromTxt :
            clearBtnUIMangment(clearFromTimebtn, fromTxt)
        case toTxt :
            clearBtnUIMangment(clearToTimeBtn, toTxt)
        default:
            clearBtnUIMangment(clearCityBtn, cityTxt)
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if   textField == toTxt || textField == fromTxt  ,  textField.text == "" {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            var date = ""
            if   textField == toTxt , let minDate = toMinDate{
                date  = formatter.string(from:minDate)
            }else if   textField == fromTxt{
                fromDateVar = NSDate() as Date
                 date  = formatter.string(from: NSDate() as Date)

            }
            textField.text = date
            
            if textField == fromTxt {
            }
        } /*else if  textField == cityTxt ,  textField.text == "" {
         textField.text = cities[0]
         
         }else  if  textField == rateTxt ,  textField.text == "" {
         textField.text = rateList[0]
         
         }*/
        switch textField {
        case rateTxt:
            clearBtnUIMangment(clearRateBtn, rateTxt)
        case fromTxt :
            clearBtnUIMangment(clearFromTimebtn, fromTxt)
        case toTxt :
            guard let fromTxt = fromTxt.text , !fromTxt.isEmpty , let fromDate = fromDateVar else {
                toTxt.text = ""
                return }
            clearBtnUIMangment(clearToTimeBtn, toTxt)
        default:
            clearBtnUIMangment(clearCityBtn, cityTxt)
            
        }
        
        
    }
    
    func clearBtnUIMangment(_ btn : UIButton, _ txt : UITextField){
        
        if let txt = txt.text , !txt.isEmpty {
            btn.alpha = 1
        }else {
            btn.alpha = 0
        }
        
    }
    
    @IBAction func clearTextBtnAct(_ sender: UIButton) {
        sender.alpha = 0
        
        switch sender.tag  {
        case 1:
            rateTxt.text = ""
        case 2:
            fromTxt.text = ""
        case 3:
            toTxt.text = ""
        default:
            cityTxt.text = ""
        }
        //            if sender.tag == 0 {//City
        //                cityTxt.text = ""
        //        }else { //Rate
        //            rateTxt.text = ""
        //            sender.alpha = 0
        //        }
    }
    
    
 }
 
 
 
 
 
 
 
 extension SearchVC :  UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    func setupPicker() {
        citiesPickerV = UIPickerView()
        citiesPickerV.dataSource = self
        citiesPickerV.delegate = self
        
        ratePickerV = UIPickerView()
        ratePickerV.dataSource = self
        ratePickerV.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title:  langDicClass().getLocalizedTitle("Done") , style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title:  langDicClass().getLocalizedTitle("Cancel"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        cityTxt.inputView = citiesPickerV
        cityTxt.inputAccessoryView = toolBar
        
        rateTxt.inputView = ratePickerV
        rateTxt.inputAccessoryView = toolBar
        
    }
    
    func donePicker (sender:UIBarButtonItem)
    {
        // Put something here
        
        if isCityPicker {
            
            cityTxt.text = selectedCity == "" ? cities[0] : selectedCity
            selectedCity = ""
            //            clearCityBtn.alpha = 1
            
        }else {
             rateTxt.text = selectedRate == "" ? rateList[0] : selectedRate
            selectedRate = ""
            //            clearRateBtn.alpha = 1
        }
        self.view.endEditing(true)
    }
    
    func cancelPicker (sender:UIBarButtonItem)
    {
        // Put something here
        selectedCity = ""
        selectedRate = ""
        self.view.endEditing(true)
        
        //        cityTxt.resignFirstResponder()
        //        rateTxt.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard pickerView == citiesPickerV else {
            isCityPicker = false
            return rateList.count
        }
        isCityPicker = true
        return cities.count
    }
    //    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //        return cities[row]
    //    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard pickerView == citiesPickerV else {
            //            rateTxt.text = rateList[row]
            //            self.view.endEditing(true)
            selectedRate = rateList[row]
            return
        }
        //        cityTxt.text = cities[row]
        //        self.view.endEditing(true)
        selectedCity = cities[row]
        
        
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
 
