//
//  Pg_Times.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/30/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class MPg_Times  {
    
    private let source = Constants.API.URLS()
    private let parSource = Constants.API.Parameters()
    
    func getPgTimesByID(id:Int , completed : @escaping (VarsPlaygTimes?) -> ()) {
        
        let url = source.GET_PG_TIMES_BY_ID + "\(id)" + source.API_TOKEN
        print("_GET_PLAY_FIELD_INFO_by_ID URL: \(url)")
//        let url_ = URL(string: url)
//        guard let _url = url_ else {   assertionFailure("didn't get the url of  getPgTimesByID right") ;return}
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil else {
                    
                    // got an error in getting the data, need to handle it
                    print("error fetching data from url")
                    print(response.result.error!)
                    return
                    
                }
                let json = JSON( response.result.value!) // SwiftyJSON
//                print("that is  _GET_PLAY_FIELD_INFO_by_ID getting the data Mate : %@", response.result.value!)
                
                
                let data = json["data"]
                
                let success = json[self.parSource.success].intValue
                let sms = json[self.parSource.message].stringValue
                let  state =  success == 1 ? true : false

                
                let  pgData = VarsPlaygTimes(jsonData: data)
                print("KILLVA: _GetPgTimesByID STATUS:\(state) , sms: \(sms) data : \(data) \n")
                
                //                let pfInfo = PlayGroundsInfo(success: success, data: pgData, sms: sms)
                
                completed(pgData)
                break
            case .failure(_) :
                print("that is fail i n getting the data Mate : %@",response.result.error)
                completed(nil)
                break
            }
        }
        
        
        
    }
    
    
    
    func postRegisterNewTime(time:String , playgID:Int , fromTime : String, toTime: String,  completed:@escaping (Bool) -> ()) {
        let parameters : Parameters = [parSource.pg_id : playgID, parSource.time: time ,parSource.from_datetime : fromTime , parSource.to_datetime : toTime  ]
        
        
        let url = source.POST_PG_TIMES_DATA + source.API_TOKEN
        print("postRegisterPlayField URL: \(url)")
        Alamofire.request(url , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil else {
                    
                    // got an error in getting the data, need to handle it
                    print("error fetching data from url")
                    print(response.result.error!)
                    return
                    
                }
                let json = JSON( response.result.value!) // SwiftyJSON
//                                print("that is  postRegisterNewTime getting the data Mate : %@", response.result.value!)
                
                
//                let data = json[self.parSource.data]
                
                let success = json[self.parSource.success].intValue
                let sms = json[self.parSource.message].stringValue
                let  state =  success == 1 ? true : false
                print("KILLVA: _PostRegisterNewTime STATUS:\(state) , sms: \(sms) data : \(response.result.value) \n")
                
                //                let xUser = PostLoginVars(jsonData: data)
                
                completed(state)
                
                break
            case .failure(_) :
                print("that is fail i n getting the data Mate : %@",response.result.error)
                completed(false)
                break
            }
        }
    }
    
    
}


class VarsPlaygTimes {
    
    //    private var _success : Bool?
        private var _pg_id : Int?
    private var _times :String?
    //     private var _message : String?
    
    private   let source = Constants.API.Parameters()
    
    //    var success : Bool {
    //        guard let suc = _success else { return false }
    //        return suc
    //    }
    
  
    var times : String {
        guard let x = _times else { return "" }
        return x
    }
 
    var pg_id : Int {
        guard let pg_id = _pg_id else { return 0 }
        return pg_id
    }
 
    init(jsonData : JSON) {
        //        self._success = jsonData[source.success].boolValue
         self._times = jsonData[source.time].stringValue
          self._pg_id = jsonData[source.pg_id].intValue
     }
    
    
    
    
    
    
    
    
    
    
    
    
}
