//
//  SearchResultVC.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 5/30/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit

class SearchResultVC: UIViewController , UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!

    var searchResultData : [Search_Data]?
    
   
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "FieldsCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
        title = langDicClass().getLocalizedTitle("Search Result")
    }

   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = searchResultData?.count else {
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FieldsCell
        guard let data = searchResultData else { return cell }
        cell.configCell(data[indexPath.row])
        
        cell.bookNowBtn.setTitle(langDicClass().getLocalizedTitle("Book Now!"), for: .normal)
        cell.bookNowBtn.removeTarget(nil, action: nil, for: .allEvents)
        cell.bookNowBtn.addTarget(self, action: #selector(self.bookNow(_:)), for: UIControlEvents.touchUpInside )
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  147
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let data = searchResultData else { return }
        let id = data[indexPath.row].id
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "ViewPlayFeildVC") as! ViewPlayFeildVC
         detailVC.pg_id =  id
             detailVC.pg_title = data[indexPath.row].pg_name
            print("that is the field name : \(title)")
        
        self.navigationController?.pushViewController(detailVC, animated: true)
     }
    
    func bookNow(_ sender: UIButton) {
        guard let data = searchResultData else { return }
        print("can i book an reservation plz , my id is : \(sender.tag)")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "ViewPlayFeildVC") as! ViewPlayFeildVC
        detailVC.pg_id =  sender.tag
        detailVC.bookNowCellTrigger = true 
        print("that is the field name : \(title)")
        
        self.navigationController?.pushViewController(detailVC, animated: true)
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
