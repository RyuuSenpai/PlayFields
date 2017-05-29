////
////  MHomeData.swift
////  Elmla3eb
////
////  Created by Macbook Pro on 3/29/17.
////  Copyright © 2017 Killvak. All rights reserved.
////
//
//import Foundation
//import Alamofire
//import SwiftyJSON
//
//class MHomeData  {
//    
//    private  let source = Constants.API.URLS()
//    private   let parSource = Constants.API.Parameters()
//
//    func getAllHomeData(completed:@escaping ([VarsHomeData]?) ->()) {
//        
//        let url = source.GET_HOME_DATA_ALL + source.API_TOKEN
//        print("URL: is get all data RL : \(url)")
// 
////        let request = GLOBAL.alamoRequest(query_url: url )
//        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
////        Alamofire.request(request).responseJSON { (response) in
//            print(response.result)
//            switch(response.result) {
//            case .success(_):
//                guard response.result.error == nil else {
//                    
//                    // got an error in getting the data, need to handle it
//                    print("error fetching data from url")
//                    print(response.result.error!)
//                    return
//                    
//                }
//                let json = JSON( response.result.value!) // SwiftyJSON
////                print("KILLVA: is  MHomeData_GET_ALL_HOME_DATA getting the data Mate : %@", response.result.value!)
//                
//                
//                
//                                    let success = json[self.parSource.success].boolValue
//                                    let sms = json[self.parSource.message].stringValue
//                print("KILLVA: is  MHomeData_GET_ALL_HOME_DATA state : \(success) sms : \(sms)  data : %@", response.result.value!)
//                
//                print("_GetAllHomeData STATUS:\(success) , sms: \(sms) \n")
//
//                //                    let playGrounds = PlayGrounds(success: success, sms: sms)
//                
//                let playGJData = json[self.parSource.data]
//                var playGData = [VarsHomeData]()
//                
//                for a in 0..<playGJData.count {
//                    let xData = VarsHomeData(jsonData: playGJData[a])
//                    playGData.append(xData)
//                }
//                //                     playGrounds.data = playGData
//                
//                completed(playGData)
//                
//                
//                break
//            case .failure(_) :
//                print("that is fail i n getting the data Mate : %@",response.result.error)
//                completed(nil)
//                break
//            }
//        }
//  
//    }
//    
//    func getHomeDataById(id:Int , completed : @escaping (VarsHomeData?) ->()) {
//        
//        let url = source.GET_HOME_DATA_BY_ID + "\(id)" + source.API_TOKEN
//        print("URL: is getHomeDataById URL : \(url)")
//        
//         Alamofire.request(url , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
//            //        Alamofire.request(request).responseJSON { (response) in
//            print(response.result)
//            switch(response.result) {
//            case .success(_):
//                guard response.result.error == nil else {
//                    
//                    // got an error in getting the data, need to handle it
//                    print("error fetching data from url")
//                    print(response.result.error!)
//                    return
//                    
//                }
//                let json = JSON( response.result.value!) // SwiftyJSON
//                //                print("KILLVA: is  MHomeData_GET_ALL_HOME_DATA getting the data Mate : %@", response.result.value!)
//                
//                
//                
//                let success = json[self.parSource.success].boolValue
//                let sms = json[self.parSource.message].stringValue
////                print("KILLVA: is  getHomeDataById state : \(success) sms : \(sms)  data : %@", response.result.value!)
//                let playGJData = json[self.parSource.data]
//
//                //                    let playGrounds = PlayGrounds(success: success, sms: sms)
//                print("KILLVA: _GetHomeDataById STATUS:\(success) , sms: \(sms) data: \(playGJData) \n")
//
//                
//                     let xData = VarsHomeData(jsonData: playGJData)
//                
//                //                     playGrounds.data = playGData
//                
//                completed(xData)
//                
//                
//                break
//            case .failure(_) :
//                print("that is fail i n getting the data Mate : %@",response.result.error)
//                completed(nil)
//                break
//            }
//        }
//        
//    }
//    
//    func postHomedataCreated(title:String,image:String , completed:@escaping (Bool)-> ()) {
//        let parameters : Parameters = [parSource.title : title, parSource.image : image ]
//        print("that is the parameters in getReviewRequesData : \(parameters)")
//        
//        
//        //        CONFIGURATION.timeoutIntervalForResource = 10 // seconds
//        
//        //        let alamofireManager = Alamofire.SessionManager(configuration: CONFIGURATION)
//        let url = source.POST_HOME_DATA + source.API_TOKEN
//        print("THAT: is Post all data RL : \(url)")
//        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
//            print(response.result)
//            switch(response.result) {
//            case .success(_):
//                guard response.result.error == nil else {
//                    
//                    // got an error in getting the data, need to handle it
//                    print("error fetching data from url")
//                    print(response.result.error!)
//                    return
//                    
//                }
//                let json = JSON( response.result.value!) // SwiftyJSON
//                print("KILLVA: that is  _PostHomedataCreated getting the data Mate : %@", response.result.value!)
//                
//                
////                let data = json[self.parSource.data]
//                
//                                let success = json[self.parSource.success].boolValue
//                                let sms = json[self.parSource.message].stringValue
//                
////                let xData = VarsHomeData(jsonData: data)
//                print("_PostHomedataCreated STATUS:\(success) , sms: \(sms)\n")
//
//                completed(success)
//                
//                break
//            case .failure(_) :
//                print("that is fail i n getting the data Mate : %@",response.result.error)
//                completed(false)
//                break
//            }
//        }
//        
//        
//        
//    }
//    
//}
//
//
//
//
//
//
//
//
//
