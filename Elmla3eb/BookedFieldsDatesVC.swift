//
//  BookedFieldsDatesVC.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/27/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit

class BookedFieldsDatesVC: UIViewController , UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet weak var expandTableView: UITableView!
    var selectedIndex = -1
    
    var day = ["1/3/2017","2/3/2017","3/3/2017","4/3/2017","5/3/2017"]
    var am = ["from 1 to 2 ","from 2 to 3 ","from 3 to 4 ","from 4 to 5 ","from 5 to 6 "]
    var pm = ["from 6 : 8 " , "from 8 : 12 "]
    let  playgView = ViewPlayFeildVC()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.expandTableView.delegate = self
        self.expandTableView.dataSource = self
        expandTableView.estimatedRowHeight = 40
        expandTableView.rowHeight = UITableViewAutomaticDimension
        
        //        playgView.timeDataDelegate = self
        //        let pf_Info = GetpgInfosWebServ()
        
        day = am
    }
    
    
    func methodOfReceivedNotification(notification: Notification){
        //Take Action on Notification
        print("that is the data of times : \(notification.userInfo?["times"])")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return day.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! BookedFieldsDatesCell
        
        cell.dayTitle.text = ""
        cell.dateLabel.text = day[indexPath.row]
        if(selectedIndex == indexPath.row) {
            cell.hideAmPmBtns = false
        }else {
            cell.hideAmPmBtns = true
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(selectedIndex == indexPath.row) {
            //return 100;
            return 300
        } else {
            return 42;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(selectedIndex == indexPath.row) {
            selectedIndex = -1
            
        } else {
            
            let oldIndex = selectedIndex
            selectedIndex = indexPath.row
            self.expandTableView.reloadRows(at: [[0,oldIndex]], with: UITableViewRowAnimation.automatic )
        }
        self.expandTableView.beginUpdates()
        self.expandTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic )
        self.expandTableView.endUpdates()
    }
    
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        let backItem = UIBarButtonItem()
    //        backItem.title = ""
    //        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    //    }
}


