//
//  MPlayGTeams.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/30/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MPlaygTeams {
    
    private  let source = Constants.API.URLS()
    private   let parSource = Constants.API.Parameters()
    
    func getAllTeamsData(completed:@escaping ([VarsPlaygTeams]?) ->()) {
        
        let url = source.GET_TEAMS_ALL + source.API_TOKEN
//        print("URL: is get all data RL : \(url)")
        
//        let request = GLOBAL.alamoRequest(query_url: url )
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            //        Alamofire.request(request).responseJSON { (response) in
//            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil else {
                    
                    // got an error in getting the data, need to handle it
//                    print("error fetching data from url")
//                    print(response.result.error!)
                    return
                    
                }
                let json = JSON( response.result.value!) // SwiftyJSON
//                                print("KILLVA: is  MHomeData_GET_ALL_HOME_DATA getting the data Mate : %@", response.result.value!)
                
                
                
                let success = json[self.parSource.success].intValue
                let sms = json[self.parSource.message].stringValue
                let  state =  success == 1 ? true : false
//                print("KILLVA: is  ـGetAllTeamsData state : \(state) sms : \(sms)  data : %@ \n", response.result.value!)
                
//                print("_GetAllHomeData STATUS:\(success) , sms: \(sms) \n")
                
                //                    let playGrounds = PlayGrounds(success: success, sms: sms)
                
                let playGJData = json[self.parSource.data]
                var playGData : [VarsPlaygTeams]?
                
                for a in 0..<playGJData.count {
                    let xData = VarsPlaygTeams(jsonData: playGJData[a])
                    playGData?.append(xData)
                }
                //                     playGrounds.data = playGData
                
                completed(playGData)
                
                
                break
            case .failure(_) :
//                print("that is fail i n getting the data Mate : %@",response.result.error)
                completed(nil)
                break
            }
        }
        
    }
    
    func getTeamDataById(id:Int , completed : @escaping (VarsPlaygTeams?) ->()) {
        
        let url = source.GET_TEAMS_BY_ID + "\(id)" + source.API_TOKEN
//        print("URL: is getHomeDataById URL : \(url)")
        
//        let request = GLOBAL.alamoRequest(query_url: url )
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            //        Alamofire.request(request).responseJSON { (response) in
//            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil else {
                    
                    // got an error in getting the data, need to handle it
//                    print("error fetching data from url")
//                    print(response.result.error!)
                    return
                    
                }
                let json = JSON( response.result.value!) // SwiftyJSON
//                                print("KILLVA: is  MHomeData_GET_ALL_HOME_DATA getting the data Mate : %@", response.result.value!)
                
                
                
                let success = json[self.parSource.success].intValue
                let sms = json[self.parSource.message].stringValue
                let  state =  success == 1 ? true : false
//                                print("KILLVA: is  getHomeDataById state : \(success) sms : \(sms)  data : %@", response.result.value!)
                
                //                    let playGrounds = PlayGrounds(success: success, sms: sms)
//                print("KILLVA: _GetTeamDataById STATUS:\(state) , sms: \(sms) data : \(response.result.value) \n")
                
                let playGJData = json[self.parSource.data]
                
                let xData = VarsPlaygTeams(jsonData: playGJData)
                
                //                     playGrounds.data = playGData
                
                completed(xData)
                
                
                break
            case .failure(_) :
//                print("that is fail i n getting the data Mate : %@",response.result.error)
                completed(nil)
                break
            }
        }
        
    }
    
    func postTeamDataCreated(name:String  , completed:@escaping (Bool)-> ()) {
        let parameters : Parameters = [parSource.pg_name : name ]
//        print("that is the parameters in getReviewRequesData : \(parameters)")
        
        
        //        CONFIGURATION.timeoutIntervalForResource = 10 // seconds
        
        //        let alamofireManager = Alamofire.SessionManager(configuration: CONFIGURATION)
        let url = source.POST_TEAMS_DATA + source.API_TOKEN
//        print("THAT: is Post all data RL : \(url)")
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
//            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil else {
                    
                    // got an error in getting the data, need to handle it
//                    print("error fetching data from url")
//                    print(response.result.error!)
                    return
                    
                }
                let json = JSON( response.result.value!) // SwiftyJSON
//                print("that is  _PostHomedataCreated getting the data Mate : %@", response.result.value!)
                
                
                //                let data = json[self.parSource.data]
                
                
                let success = json[self.parSource.success].intValue
                let sms = json[self.parSource.message].stringValue
                let  state =  success == 1 ? true : false
                //                let xData = VarsHomeData(jsonData: data)
//                print("KILLVA: _PostTeamDataCreated STATUS:\(state) , sms: \(sms) data : \(response.result.value)\n")
                
                completed(state)
                
                break
            case .failure(_) :
//                print("that is fail i n getting the data Mate : %@",response.result.error)
                completed(false)
                break
            }
        }
        
        
        
    }
    
}



class VarsPlaygTeams {
    
    let source = Constants.API.Parameters()
    private var  _name : String?
    private var _created_at : String?
    private var _updated_at : String?
    
    var name : String {
        guard  let x = _name else {  return ""  }
        return  x
    }
    var createdAt : String {
        guard  let x = _created_at else {  return ""  }
        return  x
    }
    var updatedAt : String {
        guard  let x = _updated_at else {  return ""  }
        return  x
    }
    
    init(jsonData : JSON) {
        self._name = jsonData[source.pg_name].stringValue
        self._created_at = jsonData[source.created_at].stringValue
        self._updated_at = jsonData[source.updated_at].stringValue
    }
}

