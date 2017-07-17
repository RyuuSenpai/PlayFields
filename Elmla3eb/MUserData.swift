//
//  PostLoginM.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/28/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class MUserData {
    
    
    //(completed : @escaping ([RepoVars]?) ->())
    private  let source = Constants.API.URLS()
    private   let parSource = Constants.API.Parameters()
    
    func postLoginData(mobileNum: String , userPassword:String ,completed : @escaping ((PostLoginVars?,Bool,String,[String:Any]?,String))->()) {
        let parameters : Parameters = [ parSource.mobile : mobileNum , parSource.password : userPassword ]
//        print("that is the parameters in postLoginData : \(parameters)")
        
        
//        CONFIGURATION.timeoutIntervalForResource = 10 // seconds
        
//        let alamofireManager = Alamofire.SessionManager(configuration: CONFIGURATION)
        let url = source.POST_login_USER_DATA + source.API_TOKEN
//        print("URL: is postLoginData RL : \(url)")

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
//                print("that is  postUserData_LOGIN getting the data Mate : %@", response.result.value!)
                
                
                let data = json[self.parSource.data]
                
                let success = json[self.parSource.success].intValue
                var sms = json[self.parSource.message].stringValue
                let  state =  success == 1 ? true : false

//                print("KILLVA: _PostLoginData success : \(success) STATUS:\(state) , sms: \(sms) data : \(response.result.value)\n")
                let code = data["code"].intValue
                let image = data["image"].stringValue
                if image != "" {
                    let imageURL = Constants.API.URLS()
                    let imageUrl =  imageURL.IMAGES_URL + image
//                    print("that's the Image Url : \(imageUrl)")
                    UserDefaults.standard.setValue(imageUrl, forKey: "profileImage")
                 }
                
                var smsREsponse = ""
                switch code {
               case 1 : smsREsponse = langDicClass().getLocalizedTitle("User not found")
                case 2 :smsREsponse = langDicClass().getLocalizedTitle("Wrong password")
                case 3 :smsREsponse = langDicClass().getLocalizedTitle("User not confirmed")
            default  :  smsREsponse = langDicClass().getLocalizedTitle("Request can't be empty")
                }

                if sms == "User not confirmed" {
                    let userId = data[self.parSource.id].intValue
                    let name = data[self.parSource.name].string
                    let dict : [String : Any] = ["id":userId,"name":name ?? ""]
                    completed((nil,state,sms,dict, smsREsponse))
                 }else {
                    
                 let xUser = PostLoginVars(jsonData: data)
//                    print("that's the userType : \(xUser.type)")
                    UserDefaults.standard.setValue(xUser.type, forKey: "User_Type")
                    completed((xUser,state,sms,nil,smsREsponse))
                }
                break
                
            case .failure(_) :
                
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
//                    print("Failure Response: \(json)")
                }
//                print("that is fail i n getting the Login data Mate : \(response.result.error?.localizedDescription)")
 
                completed((nil,false, "Network Time out",nil ,"Network Time out"))
                break
            }
        }
    }
    
    func postRegisterUser(name:String , mobile:String, city:String, area: String, pgType: Int,email:String,password:String  , completed:@escaping ((PostLoginVars?,Bool,String,[String:Any]?)) -> ()) {
        var parameters : Parameters!
        if ad.production {
              parameters  = [parSource.name : name , parSource.mobile : mobile,parSource.city : city , parSource.area :area , parSource.type : pgType == 0 ? "player" : "pg_owner"   , parSource.birth_date : "" ,parSource.email : email, parSource.password : password  ]

        }else {
             parameters  = [parSource.name : name , parSource.mobile : mobile,parSource.city : city , parSource.area :area , parSource.type : pgType == 0 ? "player" : "pg_owner"   , parSource.birth_date : "" ,parSource.email : email, parSource.password : password ,"test":"test" ]

        }

        
//        print("that is the parameters in getReviewRequesData : \(parameters)")
        
//        print("that's the postRegisterUser parameteres: \(parameters)")
        //        CONFIGURATION.timeoutIntervalForResource = 10 // seconds
        
        //        let alamofireManager = Alamofire.SessionManager(configuration: CONFIGURATION)
        let url = source.POST_Register_USER_DATA + source.API_TOKEN
//        print("URL: is postRegisterUser RL : \(url)")
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
//                                print("that is  postRegisterUser getting the data Mate : %@", response.result.value!)
                
                
                let data = json[self.parSource.data]
                
                let success = json[self.parSource.success].intValue
                var sms = json[self.parSource.message].stringValue
                
                let userId = data[self.parSource.id].intValue
                 let dict : [String : Any] = ["id":userId,"name":name ]
                
                let  state =  success == 1 ? true : false
                let code = data["code"].intValue
                switch code {
                case 1 : sms = langDicClass().getLocalizedTitle("mobile number already exist")
                    case 2 :sms = langDicClass().getLocalizedTitle("Username already exist, please choose another one")
                    case 3 :sms = langDicClass().getLocalizedTitle("Sorry some error occurred, please try again later")
                default  :  sms = langDicClass().getLocalizedTitle("Request can't be empty")
                }
//                print("KILLVA: _postRegisterUser STATUS:\(state) , sms: \(sms) data : \(response.result.value)\n")

//                let xUser = PostLoginVars(jsonData: data)
                
                completed((nil,state,sms,dict))
                
                break
            case .failure(_) :
//                print("response.result.value : : \(response.result.value)")
//                print("that is fail i n getting the data Mate : %@",response.result.error.debugDescription)
                completed((nil,false,"Network Time out",nil))
                break
            }
        }
    }
    
    
    func userFCMToken(userID: Int , token:String ,completed : @escaping ((Bool,String))->()) {
        let parameters : Parameters = [parSource.user_id : userID , parSource.token : token ]
//        print("that is the parameters in userFCMToken : \(parameters)")
        
        
        //        CONFIGURATION.timeoutIntervalForResource = 10 // seconds
        
        //        let alamofireManager = Alamofire.SessionManager(configuration: CONFIGURATION)
        let url = source.USER_FCM_TOKEN + source.API_TOKEN
//        print("URL: is userFCMToken   : \(url)")
        
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
//                print("KILLVA: userFCMToken success : \(success) STATUS:\(state) , sms: \(sms)")
                
                
                completed((state,sms))
                break
            case .failure(_) :
//                print("that is fail i n getting the userFCMToken Mate : \(response.result.error))")
                completed((false, "Network Time out" ))
                break
            }
        }
    }
    
    
    
    func getPhoneConfirmation(user_id:Int , code :String , completed : @escaping (Bool,String) -> ()) {
        let parameters : Parameters = [parSource.user_id : user_id ,"code" : code  ]
//        print("that is the parameters in getPhoneConfirmation : \(parameters)")
        
        
        //        CONFIGURATION.timeoutIntervalForResource = 10 // seconds
        
        //        let alamofireManager = Alamofire.SessionManager(configuration: CONFIGURATION)
        let url = source.GET_CONFIRMATION_CODE + source.API_TOKEN
//        print("URL: is getPhoneConfirmation   : \(url)")
        
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
//                print("KILLVA: getPhoneConfirmation success : \(success) STATUS:\(state) , sms: \(sms)")
                
                
                completed( state,sms )
                break
            case .failure(_) :
//                print("that is fail i n getting the getPhoneConfirmation Mate : \(response.result.error)")
                completed( false, "Network Time out" )
                break
            }
        }
    }
    
    
    func postFaceBLogin(mobile: String , image :String,fbID : String ,completed : @escaping ([String:Any]?,Bool,String, Bool)->()) {
        var parameters : Parameters!
        var name = ""
        if let userName = UserDefaults.standard.value(forKey: "usreName") as? String {
            name = userName
        }
        if ad.production {
            
            parameters =  [ parSource.mobile : mobile , parSource.image : image , parSource.fb_user_id : fbID , "name" : name ]

        }else {
              parameters = [ parSource.mobile : mobile , parSource.image : image , parSource.fb_user_id : fbID, "name" : name  ,"test":"test"]

        }

//        print("that is the parameters in postFaceBLogin : \(parameters)")
         let url = source.FACEBOOK_USER_LOGIN + source.API_TOKEN
//        print("URL: is postFaceBLogin RL : \(url)")
        
        Alamofire.request(url , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
//            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil else {
                    
                    // got an error in getting the data, need to handle it
//                    print("error fetching data from url postFaceBLogin")
//                    print(response.result.error!)
                    return
                    
                }
                let json = JSON( response.result.value!) // SwiftyJSON
//                                print("that is  postUserData_LOGIN getting the data Mate : %@", response.result.value!)
                
                
                let data = json[self.parSource.data]
                
                let success = json[self.parSource.success].intValue
                let sms = json[self.parSource.message].stringValue
                let  state =  success == 1 ? true : false
                let codeD = data["code"].intValue
                let  code =  codeD == 1 ? true : false

            
//                print("KILLVA: postFaceBLogin success : \(success) STATUS:\(state), CodeVerification : \(code), sms: \(sms) data : \(response.result.value)\n")
                
//                switch codeD {
//                case 1 : sms = langDicClass().getLocalizedTitle("Mobile number is required in order to create user.")
////                case 2 :sms = langDicClass().getLocalizedTitle("Mobile number already exist, please try another one.")
//                case 2 : sms = "Dublicated_Num"
//                case 3 :sms = langDicClass().getLocalizedTitle("Sorry some error occurred, please try again later.")
//                case 4 :sms = langDicClass().getLocalizedTitle("User not confirmed")
////                default  :  sms = langDicClass().getLocalizedTitle("New user, please send with valid mobile number")
//                default  :  sms =  "New_User"
//                }
                
//                print("that's the nerw sms ; \(sms)")
//                if !code {
                    let userId = data[self.parSource.id].intValue
                    let name = data[self.parSource.name].string
                let dict : [String : Any] = ["id":userId,"name":name ?? "", "state" : state ]
                    completed(dict,code,sms,state)
//                }else {
//                    
////                    let xUser = PostLoginVars(jsonData: data)
//                    
//                    completed(nil,code,sms )
//                }
                break
            case .failure(_) :
//                print("that is fail i n getting the postFaceBLogin data Mate : \(response.result.error)")
                completed(nil,false, "Network Time out",false  )
                break
            }
        }
    }
    
    
    
    func postResendVerificationCode( user_id: Int ,completed : @escaping ( String,Bool)->()) {
        var parameters : Parameters!
        if ad.production {

              parameters  = [ parSource.user_id : user_id   ]
          }else {
              parameters = [ parSource.user_id : user_id  ,"test":"test"]
         }

        let url = source.RESEND_VERIFICATION_CODE  + source.API_TOKEN
//        print("postResendVerificationCode URL: \(url)")
        //        let request = GLOBAL.alamoRequest(query_url: url)
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil else {
                    
                    // got an error in getting the data, need to handle it
//                    print("error fetching data from url postResendVerificationCode")
//                    print(response.result.error!)
                    return
                    
                }
                let json = JSON( response.result.value!) // SwiftyJSON
//                print("that is  postResendVerificationCode getting the data Mate : %@", response.result.value!)
                
                
//                let data = json["data"]
                
                let success = json[self.parSource.success].intValue
                let sms = json[self.parSource.message].stringValue
                let  state =  success == 1 ? true : false
//                print("KILLVA: postResendVerificationCode STATUS:\(state) , sms: \(sms) \n")
                
                
                completed(sms,state)
                break
            case .failure(_) :
//                print("that is fail i n getting the postResendVerificationCode data Mate : \(response.result.error?.localizedDescription)")
                completed( langDicClass().getLocalizedTitle("Network timeout"),false)
                break
            }
        }
        
        
        
    }

    
    func postForgotPassword( mobile: String ,completed : @escaping ( String,Bool)->()) {
        var parameters : Parameters!
        if ad.production {

              parameters  = [ parSource.mobile : mobile ]
         }else {
              parameters = [ parSource.mobile : mobile  ,"test":"test"]
         }
        
        let url = source.POST_FORGOT_PASSWORD  + source.API_TOKEN
//        print("postForgotPassword URL: \(url)")
        //        let request = GLOBAL.alamoRequest(query_url: url)
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
//            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil else {
                    
                    // got an error in getting the data, need to handle it
//                    print("error fetching data from url postForgotPassword")
//                    print(response.result.error!)
                    return
                    
                }
                let json = JSON( response.result.value!) // SwiftyJSON
//                print("that is  postForgotPassword getting the data Mate : %@", response.result.value!)
                
                
                //                let data = json["data"]
                
                let success = json[self.parSource.success].intValue
                let sms = json[self.parSource.message].stringValue
//                let sms = langDicClass().getLocalizedTitle("Wrong Old Password")
                let  state =  success == 1 ? true : false
//                print("KILLVA: postForgotPassword STATUS:\(state) , sms: \(sms) \n")
                
                
                completed(sms,state)
                break
            case .failure(_) :
//                print("that is fail i n getting the postForgotPassword data Mate : \(response.result.error?.localizedDescription)")
                completed( langDicClass().getLocalizedTitle("Network timeout"),false)
                break
            }
        }
        
        
        
    }
 
   
    func postLogout( completed : @escaping ( String,Bool)->()) {
         let parameters : Parameters = [ parSource.user_id : USER_ID  , parSource.token : UserDefaults.standard.value(forKey: "FCMToken") as? String  ?? "" ]
//        print("parameters postLogout: \(parameters)")

        let url = source.POST_LOGOUT  + source.API_TOKEN
//        print("postLogout URL: \(url)")
        //        let request = GLOBAL.alamoRequest(query_url: url)
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
//            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil else {
                    
                    // got an error in getting the data, need to handle it
//                    print("error fetching data from url postLogout")
//                    print(response.result.error!)
                    return
                    
                }
                let json = JSON( response.result.value!) // SwiftyJSON
//                print("that is  postLogout getting the data Mate : %@", response.result.value!)
                
                
                                let data = json["data"]
                
                let success = json[self.parSource.success].intValue
                let sms = json[self.parSource.message].stringValue
                let  state =  success == 1 ? true : false
//                print("KILLVA: postLogout STATUS:\(state) , sms: \(sms) \n and that's the data `: \(data)")
                
                
                completed(sms,state)
                break
            case .failure(_) :
//                print("that is fail i n getting the postLogout data Mate : \(response.result.error?.localizedDescription)")
                completed( langDicClass().getLocalizedTitle("Network timeout"),false)
                break
            }
        }
     }
    
    
   }



class PostLoginVars {
    private   let source = Constants.API.Parameters()
    private   let imageURL = Constants.API.URLS()

    //[
    private var _success : String?
    // [:]
    private var _data  : String?
    private var _id :Int?

    private var _name  : String?
    private var _mobile  : String?
    private var _city : String?
    private var _area  : String?
    private var _pg_type : String?
    private var _type  : String?
    private var _team :String?
    private var _points : Int?
    private var _birth_date  : String?
    private var _map_lon  : String?
    private var _map_lat  : String?
    private var _email : String?
    private var _password  : String?
    private var _remember_token : String?
    private var _api_token : String?
    private var _created_at : String?
    private var _updated_at  : String?
    private var _deleted_at  : String?
    private var _image  : String?

     private var _position  : String?
    private var _snap_chat  : String?
    private var _fbId : String?
    private  var _message  : String?
    //]
    
    //[
    var success : String {
        guard let x = _success else { return "" }
        return x
    }
    // [:]
    var data  : String {
        guard let x = _data else { return "" }
        return x
    }
    var image : String{
        guard  let x = _image , x != "" else {
//            print("that's the _image path : \(_image)");
            return "" }
//        print("that's the imageURL.IMAGES_URL + x   : \(x)")
        return imageURL.IMAGES_URL + x
    }
    var image_Response : String{
        guard  let x = _image , x != "" else {
//            print("that's the _image path : \(_image)");
            return "" }
         return  x
    }
    var name  : String {
        guard let x = _name , x != "" , x != " " else { return "unknown" }
        return x
    }
    var mobile  : String {
        guard let x = _mobile else { return "unknown" }
        return x
    }
    var city : String {
        guard let x = _city else { return "unknown" }
        return x
    }
    var area  : String {
        guard let x = _area else { return "unknown" }
        return x
    }
    var pg_type : String {
        guard let x = _pg_type else { return "" }
        return x
    }
    var type  : String {
        guard let x = _type else { return "" }
        return x
    }
    var team :String {
        guard let x = _team, x != "" , x != " " else { return langDicClass().getLocalizedTitle("Pick Team") }
        return x
    }
    var id :Int {
        guard let x = _id else { return 1 }
        return x
    }
    var points : String {
        guard let x = _points else { return "unknown" }
        guard  L102Language.currentAppleLanguage() == "ar" else {
            return "\(x)" + " Point "
           }
        return "\(x) نقطه "

    }
    var intPoints :Int {
        guard let x = _points else { return 0 }
        return x
    }
    var birth_date  : String {
        guard let x = _birth_date , x != " " else { return "unknown" }
          let stringB  = x.components(separatedBy: " ")

        return stringB[0]
    }
    var map_lon  : String {
        guard let x = _map_lon else { return "" }
        return x
    }
    var map_lat  : String {
        guard let x = _map_lat else { return "" }
        return x
    }
    var email : String {
        guard let x = _email else { return "unknown" }
        return x
    }
    var password  : String {
        guard let x = _password else { return "" }
        return x
    }
    var remember_token : String {
        guard let x = _remember_token else { return "" }
        return x
    }
    var api_token : String {
        guard let x = _api_token else { return "" }
        return x
    }
    var created_at : String {
        guard let x = _created_at else { return "" }
        return x
    }
    var updated_at  : String {
        guard let x = _updated_at else { return "" }
        return x
    }
    var deleted_at  : String {
        guard let x = _deleted_at else { return "" }
        return x
    }
    
    var message  : String {
        guard let x = _message else { return "" }
        return x
    }
    
    var teamName : String {
        guard let x = _team , x != "" , x != " " else { return "unknown" }
        return x
    }
    var positionName : String {
        guard let x = _position , x != "" , x != " "  else { return langDicClass().getLocalizedTitle("Position") }
         return x
    }
    var snapChat : String {
         guard let x = _snap_chat , x != "" , x != " "  else { return "unknown" }
         return x
    }
    var fbIDToken : String {
        guard let x = _fbId , x != "" , x != " "  else { return "unknown" }
        return x
    }
    
    var isFbUser : Bool {
        guard let x = _fbId , x != "" , x != " "  else { return false }
//        print("that is teh fb value : \(x)")
        return true
        
    }
    //]
    
//    init(name : String?,mobile:String?, city:String?,area:String?,ph_type:String?, map_lon:Double?,map_lat:Double?,email:String?,password:String?,rememberToken:String?,apiToken:String?,createdAt:String?,updatedAt:String?,deletedAt:String?,success:Bool?,message:String?) {
//        
//        
//    }
    
//    convenience init(name:String?,email:String?,city:String?,type:String?) {
//        self.init(name : nil,mobile:nil, city:nil,area:nil,ph_type:nil, map_lon:nil,map_lat:nil,email:nil,password:nil,rememberToken:nil,apiToken:nil,createdAt:nil,updatedAt:nil,deletedAt:nil,success:nil,message:nil)
    init(jsonData : JSON) {
        self._name = jsonData[source.name].stringValue
        self._email = jsonData[source.email].stringValue
        self._city = jsonData[source.city].stringValue
        self._pg_type = jsonData[source.pg_type].stringValue
        self._id = jsonData[source.id].intValue
        self._mobile = jsonData[source.mobile].stringValue
        self._points = jsonData[source.points].intValue
        self._team = jsonData[source.team].stringValue
        self._position = jsonData[source.position].stringValue
        self._snap_chat = jsonData[source.snap_chat].stringValue
        self._birth_date = jsonData[source.birth_date].stringValue
        self._image = jsonData[source.image].stringValue
        self._fbId = jsonData[source.fb_user_id].stringValue
        self._type = jsonData[source.type].stringValue

    }
    
    
}
