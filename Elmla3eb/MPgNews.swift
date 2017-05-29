//
//  MPGNews.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/29/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MPgNews {
    
    private let source = Constants.API.URLS()
    private let parSource = Constants.API.Parameters()
    
    func getPgNewsByID(id:Int , completed : @escaping ([VarsPlaygNews]?) -> ()) {
        
        let url = source.GET_PG_NEWS_BY_ID + "\(id)" + source.API_TOKEN
        print("_GetPgNewsByID URL: \(url)")
//        let request = GLOBAL.alamoRequest(query_url: url)

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
                print("that is  _GetPgNewsByID getting the data Mate : %@", response.result.value!)
                
                
                let data = json["data"]
                
                let success = data[self.parSource.success].intValue
                let sms = data[self.parSource.message].stringValue
                let  state =  success == 1 ? true : false
                print("KILLVA: _GetPgNewsByID STATUS:\(state) , sms: \(sms) \n")

                var pgsData = [VarsPlaygNews]()
                for i in 0..<data.count {
                    
               
                let pgData = VarsPlaygNews(jsonData: data[i])
 
                      pgsData.append(pgData)
                //                let pfInfo = PlayGroundsInfo(success: success, data: pgData, sms: sms)
                 }
                completed(pgsData)
                break
            case .failure(_) :
                print("that is fail i n getting the data Mate : %@",response.result.error)
                completed(nil)
                break
            }
        }
        
        
        
    }
    
    
    
    func postPgNews(playgID:Int , title:String, content:String ,completed:@escaping (Bool) -> ()) {
        let parameters : Parameters = [parSource.pg_id:playgID, parSource.title : title, parSource.content:content]
        
        
        let url = source.POST_PG_NEWS_DATA + source.API_TOKEN
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
                //                print("that is  postUserData_LOGIN getting the data Mate : %@", response.result.value!)
                
                
                let data = json[self.parSource.data]
                let success = json[self.parSource.success].intValue
                let sms = json[self.parSource.message].stringValue
                let  state =  success == 1 ? true : false
                print("KILLVA: _PostPgNews STATUS:\(state) , sms: \(sms)\n")
                
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


class VarsPlaygNews {
    
    let source = Constants.API.Parameters()
    private var  _pgID : Int?
    private var _title : String?
    private var _content : String?
    
    var pgID : Int {
        guard  let x = _pgID else {  return 0  }
        return  x
    }
    var title : String {
        guard  let x = _title else {  return ""  }
        return  x
    }
    var content : String {
        guard  let x = _content else {  return ""  }
        return  x
    }
    
    init(jsonData : JSON) {
        self._pgID = jsonData[source.pg_id].intValue
        self._title = jsonData[source.title].stringValue
        self._content = jsonData[source.content].stringValue
        print("that is the _content : \(self._content)")

        print("that is the title : \(self._title)")
    }
}


