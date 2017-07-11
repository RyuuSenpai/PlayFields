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
//        print("getProfileData URL: \(url)")
        //        let request = GLOBAL.alamoRequest(query_url: url)
        
        Alamofire.request(url, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
//            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil else {
                    
                    // got an error in getting the data, need to handle it
//                    print("error fetching data from url getProfileData")
//                    print(response.result.error!)
                    return
                    
                }
                let json = JSON( response.result.value!) // SwiftyJSON
//                print("that is  getProfileData getting the data Mate : %@", response.result.value!)
                
                
                let data = json["data"]
                
                let success = json[self.parSource.success].intValue
                let sms = json[self.parSource.message].stringValue
                let  state =  success == 1 ? true : false
//                print("KILLVA: getProfileData STATUS:\(state) , sms: \(sms) \n")
                
         let profileData = PostLoginVars(jsonData: data)
                
                completed(profileData,sms,state)
                break
            case .failure(_) :
//                print("that is fail i n getting the getProfileData data Mate : \(response.result.error)")
                completed(nil,langDicClass().getLocalizedTitle("Network timeout"),false)
                break
            }
        }
        
        
        
    }
    
    
    
    
    func postProfileData(  name :String?,mobile:String?,city : String?,team : String?,birthD : String?,lon : String?,lat : String?,image : String?,snap_chat : String?,position:String? , completed : @escaping (Bool,String) -> ()) {
        let parameters : Parameters = [parSource.user_id : USER_ID , parSource.name :name ?? "",parSource.city : city ?? "", parSource.team : team ?? "",parSource.birth_date:birthD ?? "",parSource.map_lon:lon ?? "",parSource.map_lat:lat ?? "", parSource.image : image ?? "",parSource.snap_chat : snap_chat ?? "",parSource.position : position ?? ""]
        
        // for printing
//        let printIt :Parameters = [parSource.user_id : USER_ID , parSource.name :name ?? "", parSource.mobile : mobile ?? "",parSource.city : city ?? "", parSource.team : team ?? "",parSource.birth_date:birthD ?? "",parSource.map_lon:lon ?? "",parSource.map_lat:lat ?? "",parSource.password : "", parSource.image : image ?? "nil",parSource.snap_chat : snap_chat ?? "",parSource.position : position] as [String : Any]
         print("that is the parameters in postProfileData : \(parameters)")
//
        let url = source.POST_PROFILE_DATA + source.API_TOKEN
//        print("URL: is postProfileData   : \(url)")
        
        Alamofire.request(url , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
//            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil else {
                    
                    // got an error in getting the data, need to handle it
//                    print("error fetching data from url postProfileData")
//                    print(response.result.error!)
                    return
                    
                }
                let json = JSON( response.result.value!) // SwiftyJSON
//                                print("that is  postUserData_LOGIN getting the data Mate : %@", response.result.value)
                
                
                
                let success = json[self.parSource.success].intValue
                let sms = json[self.parSource.message].stringValue
                let data = json[self.parSource.data]
                let image = data["image"].string
                var imageUrl = String()
                if let img = image , img != "" , img != " " {
                    imageUrl = self.source.IMAGES_URL + img
                    ad.saveUserLogginData(email: "default", photoUrl: imageUrl, uid: -1 ,name:"default")
                }else {
                    imageUrl = ""
                }
                print("That's the new im,age : \(imageUrl)")
                let  state =  success == 1 ? true : false
//                print("KILLVA: postProfileData success : \(success) STATUS:\(state) , sms: \(sms)\n data :  \(json)")
                
                
                completed( state,sms )
                break
            case .failure(_) :
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
//                    print("Failure Response: \(json)")
                }
//                print("that is fail i n getting the postProfileData data Mate : \(response.result.error?.localizedDescription)")
//                print("that is fail i n getting the postProfileData Mate :\(response.result.error)")
                completed( false, "Network Time out" )
                break
            }
        }
    }
    
    
    func postChangeUserPassword(userID: Int , oldPassword:String,newPassword : String ,completed : @escaping (Bool,String)->()) {
        let parameters : Parameters = [parSource.user_id : userID , parSource.old_password : oldPassword,parSource.new_password : newPassword  ]
//        print("that is the parameters in postChangeUserPassword : \(parameters)")
        
        
        //        CONFIGURATION.timeoutIntervalForResource = 10 // seconds
        
        //        let alamofireManager = Alamofire.SessionManager(configuration: CONFIGURATION)
        let url = source.POST_CHANGE_PASSWORD + source.API_TOKEN
//        print("URL: is postChangeUserPassword   : \(url)")
        
        Alamofire.request(url , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
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
//                                print("that is  postUserData_LOGIN getting the data Mate : %@", response.result.value!)
                
                
                
                let success = json[self.parSource.success].intValue
                let sms = json[self.parSource.message].stringValue
                let  state =  success == 1 ? true : false
//                print("KILLVA: postChangeUserPassword success : \(success) STATUS:\(state) , sms: \(sms)")
                
                
                completed(state,sms)
                break
            case .failure(_) :
//                print("that is fail i n getting the postChangeUserPassword Mate : \(response.result.error))")
                completed(false, "Network Time out" )
                break
            }
        }
    }

    
    func getPointsData( completed:@escaping ([Points_Data]?,String,Bool) -> ()) {
        
        let url = source.GET_POINTS_REQUEST + source.API_TOKEN
//        print("getPointsData URL: \(url)")
        //        let request = GLOBAL.alamoRequest(query_url: url)
        
        Alamofire.request(url, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
//            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil else {
                    
                    // got an error in getting the data, need to handle it
//                    print("error fetching data from url getPointsData")
//                    print(response.result.error!)
                    return
                    
                }
                let json = JSON( response.result.value!) // SwiftyJSON
//                print("that is  getPointsData getting the data Mate : %@", response.result.value!)
                
                
                let data = json["data"]
                
                let success = json[self.parSource.success].intValue
                let sms = json[self.parSource.message].stringValue
                let  state =  success == 1 ? true : false
//                print("KILLVA: getPointsData STATUS:\(state) , sms: \(sms) \n")
                var pointsDataArray = [Points_Data]()
                for item in data {
                    let pointsClass = Points_Data(jsonData: item.1)
                    pointsDataArray.append(pointsClass)
                }
                
                completed(pointsDataArray,sms,state)
                break
            case .failure(_) :
//                print("that is fail i n getting the getPointsData data Mate : \(response.result.error)")
                completed(nil,langDicClass().getLocalizedTitle("Network timeout"),false)
                break
            }
        }
    }
    
    func post_PointsReward(points : Int ,completed : @escaping (Int?,Bool,String)->()) {
        let parameters : Parameters = [parSource.user_id : USER_ID , "points" : points ]
//        print("that is the parameters in post_PointsReward : \(parameters)")
        
        //        CONFIGURATION.timeoutIntervalForResource = 10 // seconds
        
        //        let alamofireManager = Alamofire.SessionManager(configuration: CONFIGURATION)
        let url = source.POST_POINTS_REQUEST + source.API_TOKEN
//        print("URL: is post_PointsReward   : \(url)")
        
        Alamofire.request(url , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
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
//                                print("that is  postUserData_LOGIN getting the data Mate : %@", response.result.value!)
                
                
                
                let success = json[self.parSource.success].intValue
                let sms = json[self.parSource.message].stringValue
                let  state =  success == 1 ? true : false
                let point = json["data"] ["points"].intValue
//                print("KILLVA: post_PointsReward success : \(success) STATUS:\(state) , sms: \(sms) returned points : \(point)")
                
                
                completed(point,state,sms)
                break
            case .failure(_) :
//                print("that is fail i n getting the post_PointsReward Mate : \(response.result.error))")
                completed(nil,false, "Network Time out" )
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


class Points_Data {
    private   let source = Constants.API.Parameters()
    private   let imageURL = Constants.API.URLS()
    
    
 
    private var _img_achieved  : String?
    private var _img_unachieved  : String?
    private var _points : Int?
    
    

    
    var img_achieved : String{
        guard  let x = _img_achieved , x != "" else {
//            print("that's the _image path : \(String(describing: _img_achieved))");
            return "" }
//        print("that's the imageURL.IMAGES_URL + x   : \(x)")
        return imageURL.IMAGES_URL + x
    }

    var img_unachieved : String{
        guard  let x = _img_unachieved , x != "" else {
//            print("that's the _image path : \(String(describing: _img_achieved))");
            return "" }
//        print("that's the imageURL.IMAGES_URL + x   : \(x)")
        return imageURL.IMAGES_URL + x
    }
    
    var points : Int {
//        print("that's the points : \(_points)")
        guard let x = _points else { return 0 }
        return x
    }
    //]
    
    //    init(name : String?,mobile:String?, city:String?,area:String?,ph_type:String?, map_lon:Double?,map_lat:Double?,email:String?,password:String?,rememberToken:String?,apiToken:String?,createdAt:String?,updatedAt:String?,deletedAt:String?,success:Bool?,message:String?) {
    //
    //
    //    }
    
    //    convenience init(name:String?,email:String?,city:String?,type:String?) {
    //        self.init(name : nil,mobile:nil, city:nil,area:nil,ph_type:nil, map_lon:nil,map_lat:nil,email:nil,password:nil,rememberToken:nil,apiToken:nil,createdAt:nil,updatedAt:nil,deletedAt:nil,success:nil,message:nil)
    init(jsonData : JSON) {
        self._img_achieved = jsonData["img_achieved"].stringValue
        self._img_unachieved = jsonData["img_unachieved"].stringValue
        self._points = jsonData["points"].intValue
        
    }
    
    
}










