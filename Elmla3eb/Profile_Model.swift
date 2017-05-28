//
//  Profile_Model.swift
//  Elmla3eb
//
//  Created by Killvak on 22/05/2017.
//  Copyright © 2017 Killvak. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class Profile_Model {
    private let source = Constants.API.URLS()
    private let parSource = Constants.API.Parameters()

    
    func getProfileData( completed:@escaping (PostLoginVars?,String,Bool) -> ()) {
        
        let url = source.POST_Register_USER_DATA + "/\(USER_ID)" + source.API_TOKEN
        print("getProfileData URL: \(url)")
        //        let request = GLOBAL.alamoRequest(query_url: url)
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil else {
                    
                    // got an error in getting the data, need to handle it
                    print("error fetching data from url getProfileData")
                    print(response.result.error!)
                    return
                    
                }
                let json = JSON( response.result.value!) // SwiftyJSON
                print("that is  getProfileData getting the data Mate : %@", response.result.value!)
                
                
                let data = json["data"]
                
                let success = json[self.parSource.success].intValue
                let sms = json[self.parSource.message].stringValue
                let  state =  success == 1 ? true : false
                print("KILLVA: getProfileData STATUS:\(state) , sms: \(sms) \n")
                
         let profileData = PostLoginVars(jsonData: data)
                
                completed(profileData,sms,state)
                break
            case .failure(_) :
                print("that is fail i n getting the getProfileData data Mate : \(response.result.error)")
                completed(nil,"Network Error",false)
                break
            }
        }
        
        
        
    }
    
    
    
    
    func postProfileData(  name :String?,mobile:String?,city : String?,team : String?,birthD : String?,lon : String?,lat : String?,image : String?,snap_chat : String?,position:String? , completed : @escaping (Bool,String) -> ()) {
        let parameters : Parameters = [parSource.user_id : USER_ID , parSource.name :name ?? "", parSource.mobile : mobile ?? "",parSource.city : city ?? "", parSource.team : team ?? "",parSource.birth_date:birthD ?? "",parSource.map_lon:lon ?? "",parSource.map_lat:lat ?? "",parSource.password : "", parSource.image : image ?? "",parSource.snap_chat : snap_chat ?? "",parSource.position : position]
        let parsCopy : Parameters = [parSource.user_id : USER_ID , parSource.name :name ?? "", parSource.mobile : mobile ?? "",parSource.city : city ?? "", parSource.team : team ?? "",parSource.birth_date:birthD ?? "",parSource.map_lon:lon ?? "",parSource.map_lat:lat ?? "",parSource.password : "", parSource.image : "",parSource.snap_chat : snap_chat ?? "",parSource.position : position]

        print("that is the parameters in postProfileData : \(parsCopy)")
   
        let url = source.POST_PROFILE_DATA + source.API_TOKEN
        print("URL: is postProfileData   : \(url)")
        
        Alamofire.request(url , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil else {
                    
                    // got an error in getting the data, need to handle it
                    print("error fetching data from url postProfileData")
                    print(response.result.error!)
                    return
                    
                }
                let json = JSON( response.result.value!) // SwiftyJSON
                //                print("that is  postUserData_LOGIN getting the data Mate : %@", response.result.value!)
                
                
                
                let success = json[self.parSource.success].intValue
                let sms = json[self.parSource.message].stringValue
                let  state =  success == 1 ? true : false
                print("KILLVA: postProfileData success : \(success) STATUS:\(state) , sms: \(sms)")
                
                
                completed( state,sms )
                break
            case .failure(_) :
                print("that is fail i n getting the postProfileData Mate :\(response.result.error)")
                completed( false, "Network Time out" )
                break
            }
        }
    }
    
    
    
    
    
    
}




class profile_Data {
    private var _success  : Int?
    var times : [Pg_Times_Data]?
    var news : [Pg_News_Data]?
    var images :[Pg_Images_Data]?
    var info : Pg_Info_Data?
    var details : Pg_Details_Data?
    private  var _sms : String?
    private let source = Constants.API.Parameters()
    
    var success : Bool {
        guard _success == 1 else { return false }
        return true
    }
    var sms : String {
        guard let x = _sms else {return"local_error with PlayGroundsInfoSubData SMS" }
        return x
    }
    init(json:JSON) {
        self._success = json[source.success].intValue
        self._sms = json[source.message].stringValue
    }
    
}











