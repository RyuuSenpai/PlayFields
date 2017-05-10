//
//  BookNowTablesVC.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/28/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit


class BookNowTablesVC: UIViewController ,UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var invalidDaysLbl: UILabel!
    @IBOutlet weak var daysTableView: UITableView!
    @IBOutlet weak var datestableView: UITableView!
    
    @IBOutlet weak var datesStackView: UIStackView!
    
    @IBOutlet weak var daysView: UIView!
    
    @IBOutlet weak var datesView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayTitle: UILabel!
    
    @IBOutlet weak var amBtn: UIButton!
    
    @IBOutlet weak var pmBtn: UIButton!
    @IBOutlet weak var backToDatesTableBtnOL: UIButton!
    
    let  vplaygVC = ViewPlayFeildVC()
    var  currentArray = [String ]()
    var dayAvailable = [String]()
    var am = ["from 1 to 2 ","from 2 to 3 ","from 3 to 4 ","from 4 to 5 ","from 5 to 6 "]
    var pm = ["from 6 : 8 " , "from 8 : 12 "]
    var times = [Pg_Times_Data]()
    
    var selectedDay = ""
    var isAraLang = false
    var selectedDatesDict = [String : String ]()
    var amSelectedCelles = [Int]()
    var pmSelectedCelles = [Int]()
    var selected_AmTimes_ID = [Int]()
    var selected_PmTimes_ID = [Int]()
    //    var seletedTimes_ID = [Int]()
    var pg_ID  : Int? {
        didSet {
            print("that's the new value of worked : \(pg_ID)")
        }
    }
    
    var times_msg : String? {
        didSet {
            print("that's the times sms : \(times_msg)")

        }
    }
    
    
    var resetCellBtn = false
    var isAM = true
    var selectedDates = [Int]()
    var theSelectedArray = [Int]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        amBtn.addTarget(self, action: #selector(self.amBtnClicked), for: .touchUpInside )
        pmBtn.addTarget(self, action: #selector(self.pmBtnClicked), for: .touchUpInside )
        currentArray = am
        dayTitle.text = ""
        if let sms = times_msg {
            self.invalidDaysLbl.text = sms
        }
        // Do any additional setup after loading the view.
        
        if L102Language.currentAppleLanguage() == "ar" {
            isAraLang = true
            backToDatesTableBtnOL.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI ))

        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.dayTitle.text = " "
   
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToDaysTableViewAct(_ sender: UIButton) {
        self.daysTableView.alpha = 1
        self.datesStackView.alpha = 0
        self.daysTableView.reloadData()
        
        self.amBtnClicked()
        
        UIView.transition(from: self.datesView, to: daysView, duration: 0.5, options: [.transitionFlipFromRight,.showHideTransitionViews])

        print("that is the current array : \(selectedDatesDict)")
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == daysTableView {
            self.daysTableView.alpha = 0
            self.datesStackView.alpha = 1
            self.selectedDay = dayAvailable[indexPath.row]
            self.selectedDayFromlist(index: indexPath.row)
            self.dateLabel.text = selectedDay
            amBtnClicked()
            self.datestableView.reloadData()
            if isAraLang {
                UIView.transition(from: self.daysView, to: datesView, duration: 0.5, options: [.transitionFlipFromRight,.showHideTransitionViews])

            }else {
            UIView.transition(from: self.daysView, to: datesView, duration: 0.5, options: [.transitionFlipFromLeft,.showHideTransitionViews])
            }
        }
    }
    
    func selectedDayFromlist(index : Int ) {
        
        //        print("that is times : \(self.times[0].am_class )")
        //        print("that is times1 : \(self.times[1].am_class )")
        let sTime = self.times[index]
        //        print("gogogogo \(sTime.am_class)")
        self.am = [String]()
        if  let amA = sTime.am_class {
            for x in amA {
                self.am.append("\(x.fromDataTime): \(x.toDataTime)")
                self.selected_AmTimes_ID.append(x.id)
            }
        }
        if let pmA = sTime.pm_class {
            self.pm = [String]()
            for y in pmA {
//                self.pm.append("\(y.fromDataTime): \(y.toDataTime)")
                self.pm.append("\(y.fromDataTime): \(y.toDataTime)")
                self.selected_PmTimes_ID.append(y.id)
            }
        }
        print("that is am : \(self.am) and pm : \(self.pm)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard tableView == self.datestableView else { return self.dayAvailable.count }
        return currentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == datestableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookNowCell", for: indexPath) as! BookNowCell
            
            cell.label.text = currentArray[indexPath.row]
            cell.tag = indexPath.row
            cell.selectRow.tag = cell.tag
            cell.selectRow.isSelected = false
            //            cell.timeIDLbl.text = s
            //        if resetCellBtn {
            //            cell.selectRow.isSelected = false
            //            resetCellBtn = false
            //        }
            
            if selectedDatesDict.count > 0 {
                for (key,_) in selectedDatesDict {
                    print("that is the value and : \("\(self.selectedDay),\(currentArray[indexPath.row])") , that's the key : \(key)")
                    if  "\(self.selectedDay),\(currentArray[indexPath.row])" == key {
                        cell.selectRow.isSelected = true
                    }
                }
            }
            //            var tagsArray = [Int]()
            //            if isAM { tagsArray = amSelectedCelles } else  { tagsArray = pmSelectedCelles }
            //            if tagsArray.count > 0 {
            //                for x in tagsArray {
            //                    if indexPath.row == x {
            //                        cell.selectRow.isSelected = true
            //                    }
            //                }
            //            }
            
            cell.selectRow.setBackgroundImage(#imageLiteral(resourceName: "Thin Circle_77cd52_100"), for: .normal)
            cell.selectRow.setBackgroundImage(#imageLiteral(resourceName: "Circled Down Left 2_77cd52_32"), for: .selected)
            cell.selectRow.addTarget(self, action: #selector(self.selectedCell(_:)), for: .touchUpInside)
            return cell
            
        }else {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "BookNowDaysCell", for: indexPath) as! BookNowDaysCell
            cell.dateLbl.text = self.dayAvailable[indexPath.row]
            return cell
            
        }
        
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension BookNowTablesVC {
    
    func selectedCell(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            //            sender.setBackgroundImage(#imageLiteral(resourceName: "Thin Circle_77cd52_100"), for: .selected)
            if isAM {
                self.amSelectedCelles.append(sender.tag)
                ViewPlayFeildVC.seletedTimes_ID.append(selected_AmTimes_ID[sender.tag])
            }else {
                self.pmSelectedCelles.append(sender.tag)
                ViewPlayFeildVC.seletedTimes_ID.append(selected_PmTimes_ID[sender.tag])
            }
            
            self.selectedDatesDict["\(self.selectedDay),\(currentArray[sender.tag])"] = "\(currentArray[sender.tag])"
            
        }else {
            //            sender.setBackgroundImage(#imageLiteral(resourceName: "Circled Down Left 2_77cd52_32"), for: .selected)
            if let index = self.selectedDatesDict["\(self.selectedDay),\(currentArray[sender.tag])"] , index == "\(currentArray[sender.tag])" {
                //                selectedDatesDict.remove(at: index)
                print("that is the current array before deletion : \(selectedDatesDict)")
                selectedDatesDict.removeValue(forKey: "\(self.selectedDay),\(currentArray[sender.tag])")
                print("that is the current array after : \(selectedDatesDict)")
            }
            let index = self.theSelectedArray[sender.tag]
            
            if let item = ViewPlayFeildVC.seletedTimes_ID.index(of: index) {
                ViewPlayFeildVC.seletedTimes_ID.remove(at: item    )
            }
            
        }
        print("that is the current array : \(selectedDatesDict)")
    }
    
    
    func amBtnClicked() {
        resetCellBtn = true
        self.currentArray = am
        self.theSelectedArray = selected_AmTimes_ID
        isAM = true
        datestableView.reloadData()
        self.pmBtn.backgroundColor = Constants.Colors.green
        
        self.amBtn.backgroundColor = Constants.Colors.darkGreen
    }
    
    func pmBtnClicked() {
        resetCellBtn = true
        isAM = false
        self.currentArray = pm
        self.theSelectedArray = selected_PmTimes_ID
        datestableView.reloadData()
        self.pmBtn.backgroundColor = Constants.Colors.darkGreen
        
        self.amBtn.backgroundColor = Constants.Colors.green
        
    }
    
}

/*
 //
 //  BookNowTablesVC.swift
 //  Elmla3eb
 //
 //  Created by Macbook Pro on 3/28/17.
 //  Copyright © 2017 Killvak. All rights reserved.
 //
 
 import UIKit
 
 var seletedTimes_ID = [Int]()
 
 class BookNowTablesVC: UIViewController ,UITableViewDelegate , UITableViewDataSource{
 
 @IBOutlet weak var daysTableView: UITableView!
 @IBOutlet weak var datestableView: UITableView!
 
 @IBOutlet weak var datesStackView: UIStackView!
 
 
 @IBOutlet weak var dateLabel: UILabel!
 @IBOutlet weak var dayTitle: UILabel!
 
 @IBOutlet weak var amBtn: UIButton!
 
 @IBOutlet weak var pmBtn: UIButton!
 
 let  vplaygVC = ViewPlayFeildVC()
 var  currentArray = [String ]()
 var day : [String]?{
 didSet {
 //            self.daysTableView.reloadData()
 }
 }
 var am = ["from 1 to 2 ","from 2 to 3 ","from 3 to 4 ","from 4 to 5 ","from 5 to 6 "]
 var pm = ["from 6 : 8 " , "from 8 : 12 "]
 
 var selectedDay = ""
 
 var selectedDatesDict = [String : String ]()
 var amSelectedCelles = [Int]()
 var pmSelectedCelles = [Int]()
 var selected_AmTimes_ID = [Int]()
 var selected_PmTimes_ID = [Int]()
 //    var seletedTimes_ID = [Int]()
 var pg_ID  : Int? {
 didSet {
 print("that's the new value of worked : \(pg_ID)")
 }
 }
 
 var resetCellBtn = false
 var isAM = true
 var selectedDates = [Int]()
 var theSelectedArray = [Int]()
 var worked : String? {
 didSet {
 print("that's the new value of worked : \(worked)")
 }
 }
 
 
 
 override func viewDidLoad() {
 super.viewDidLoad()
 amBtn.addTarget(self, action: #selector(self.amBtnClicked), for: .touchUpInside )
 pmBtn.addTarget(self, action: #selector(self.pmBtnClicked), for: .touchUpInside )
 currentArray = am
 
 dayTitle.text = ""
 // Do any additional setup after loading the view.
 }
 override func viewWillAppear(_ animated: Bool) {
 self.dayTitle.text = " did it \(worked) work "
 print( " did it \(worked) work ")
 }
 var times = [Pg_Times_Data]()
 
 override func viewDidAppear(_ animated: Bool) {
 super.viewDidAppear(animated)
 
 //        let pf_Info = GetpgInfosWebServ()
 //         pf_Info.getPgInfosByID(id: pg_ID ?? 0 ) { [weak weakSelf = self ](dataOBject) in
 //
 //            //            print("that is arabic sentince : \(data)")
 //            guard let data = dataOBject else { print("GetPgInfosByID equal NIL ç≈Ωß");return }
 //
 //                       //            self.timeDataDelegate?.sendTimeData(data.times)
 //
 //             print("that is times : \(data.times)")
 //            //            self.playFieldInfo = data
 //            weakSelf?.day = [String]()
 //            guard let times = data.times else { return }
 //            for x in times {
 //                weakSelf?.day.append(x.date)
 //                print("that is am_class \(x.am_class)")
 //                print("that is pm_class \(x.pm_class)")
 //                print("that is day \(x.date)")
 //
 //            }
 //            print("that is all day \(weakSelf?.day)")
 //            weakSelf?.times = times
 //            weakSelf?.daysTableView.reloadData()
 //            //            print("that is the data : \(self.playFieldInfo?.pg_id) , \(self.playFieldInfo?.light_available) , \(self.playFieldInfo?.ground_type)")
 //
 //        }
 }
 
 override func didReceiveMemoryWarning() {
 super.didReceiveMemoryWarning()
 // Dispose of any resources that can be recreated.
 }
 
 @IBAction func backToDaysTableViewAct(_ sender: UIButton) {
 self.daysTableView.alpha = 1
 self.datesStackView.alpha = 0
 self.daysTableView.reloadData()
 
 self.amBtnClicked()
 
 print("that is the current array : \(selectedDatesDict)")
 
 }
 
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 if tableView == daysTableView {
 self.daysTableView.alpha = 0
 self.datesStackView.alpha = 1
 guard let days = self.day else { print("check thos line  in booknowtableVC"); return }
 self.selectedDay = days[indexPath.row]
 self.selectedDayFromlist(index: indexPath.row)
 self.dateLabel.text = selectedDay
 amBtnClicked()
 self.datestableView.reloadData()
 
 }
 }
 
 func selectedDayFromlist(index : Int ) {
 
 //        print("that is times : \(self.times[0].am_class )")
 //        print("that is times1 : \(self.times[1].am_class )")
 let sTime = self.times[index]
 //        print("gogogogo \(sTime.am_class)")
 self.am = [String]()
 if  let amA = sTime.am_class {
 for x in amA {
 self.am.append("\(x.fromDataTime): \(x.toDataTime)")
 self.selected_AmTimes_ID.append(x.id)
 }
 }
 if let pmA = sTime.pm_class {
 self.pm = [String]()
 for y in pmA {
 self.pm.append("\(y.fromDataTime): \(y.toDataTime)")
 self.selected_PmTimes_ID.append(y.id)
 }
 }
 print("that is am : \(self.am) and pm : \(self.pm)")
 }
 
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
 if  tableView == self.daysTableView  {
 guard let days = self.day else { return 0}
 return days.count
 }else {
 return currentArray.count
 }
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 if tableView == datestableView {
 let cell = tableView.dequeueReusableCell(withIdentifier: "BookNowCell", for: indexPath) as! BookNowCell
 
 cell.label.text = currentArray[indexPath.row]
 cell.tag = indexPath.row
 cell.selectRow.tag = cell.tag
 cell.selectRow.isSelected = false
 //            cell.timeIDLbl.text = s
 //        if resetCellBtn {
 //            cell.selectRow.isSelected = false
 //            resetCellBtn = false
 //        }
 
 if selectedDatesDict.count > 0 {
 for (key,_) in selectedDatesDict {
 print("that is the value and : \("\(self.selectedDay),\(currentArray[indexPath.row])") , that's the key : \(key)")
 if  "\(self.selectedDay),\(currentArray[indexPath.row])" == key {
 cell.selectRow.isSelected = true
 }
 }
 }
 //            var tagsArray = [Int]()
 //            if isAM { tagsArray = amSelectedCelles } else  { tagsArray = pmSelectedCelles }
 //            if tagsArray.count > 0 {
 //                for x in tagsArray {
 //                    if indexPath.row == x {
 //                        cell.selectRow.isSelected = true
 //                    }
 //                }
 //            }
 
 cell.selectRow.setBackgroundImage(#imageLiteral(resourceName: "Thin Circle_77cd52_100"), for: .normal)
 cell.selectRow.setBackgroundImage(#imageLiteral(resourceName: "Circled Down Left 2_77cd52_32"), for: .selected)
 cell.selectRow.addTarget(self, action: #selector(self.selectedCell(_:)), for: .touchUpInside)
 return cell
 
 }else {
 let cell =  tableView.dequeueReusableCell(withIdentifier: "BookNowDaysCell", for: indexPath) as! BookNowDaysCell
 cell.dateLbl.text = self.day?[indexPath.row]
 return cell
 
 }
 
 
 
 }
 
 
 /*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
 
 }
 
 extension BookNowTablesVC {
 
 func selectedCell(_ sender : UIButton) {
 sender.isSelected = !sender.isSelected
 if sender.isSelected {
 //            sender.setBackgroundImage(#imageLiteral(resourceName: "Thin Circle_77cd52_100"), for: .selected)
 if isAM {
 self.amSelectedCelles.append(sender.tag)
 seletedTimes_ID.append(selected_AmTimes_ID[sender.tag])
 }else {
 self.pmSelectedCelles.append(sender.tag)
 seletedTimes_ID.append(selected_PmTimes_ID[sender.tag])
 }
 
 self.selectedDatesDict["\(self.selectedDay),\(currentArray[sender.tag])"] = "\(currentArray[sender.tag])"
 
 }else {
 //            sender.setBackgroundImage(#imageLiteral(resourceName: "Circled Down Left 2_77cd52_32"), for: .selected)
 if let index = self.selectedDatesDict["\(self.selectedDay),\(currentArray[sender.tag])"] , index == "\(currentArray[sender.tag])" {
 //                selectedDatesDict.remove(at: index)
 print("that is the current array before deletion : \(selectedDatesDict)")
 selectedDatesDict.removeValue(forKey: "\(self.selectedDay),\(currentArray[sender.tag])")
 print("that is the current array after : \(selectedDatesDict)")
 }
 let index = self.theSelectedArray[sender.tag]
 
 if let item = seletedTimes_ID.index(of: index) {
 seletedTimes_ID.remove(at: item    )
 }
 
 }
 print("that is the current array : \(selectedDatesDict)")
 }
 
 
 func amBtnClicked() {
 resetCellBtn = true
 self.currentArray = am
 self.theSelectedArray = selected_AmTimes_ID
 isAM = true
 datestableView.reloadData()
 self.pmBtn.backgroundColor = Constants.Colors.green
 
 self.amBtn.backgroundColor = Constants.Colors.darkGreen
 }
 
 func pmBtnClicked() {
 resetCellBtn = true
 isAM = false
 self.currentArray = pm
 self.theSelectedArray = selected_PmTimes_ID
 datestableView.reloadData()
 self.pmBtn.backgroundColor = Constants.Colors.darkGreen
 
 self.amBtn.backgroundColor = Constants.Colors.green
 
 }
 
 }
 
 
 */
