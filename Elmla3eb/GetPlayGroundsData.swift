//
//  GetMianPageData.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/26/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class GetPlayGroundsData {
    
    
    //(completed : @escaping ([RepoVars]?) ->())
    private  let source = Constants.API.URLS()
    private  let parSource = Constants.API.Parameters()
    
    func getPlayFieldsData(completed : @escaping (MainPage_Data?,Bool, String)->()) {
 
//        let parameters : Parameters = [parSource.user_id : userID ]

//        let url = "http://appstest.xyz/api/homedatas"
                let url = source.GET_PLAY_GROUNDS_ALL + source.API_TOKEN + "&user_id=\(USER_ID)"
        print("URL: is getPlayFieldsData  : \(url)")
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
                print("that is  _GetPlayFieldsData getting the data Mate : %@", response.result.value!)
                
                
                
                //                    let playGrounds = PlayGrounds(success: success, sms: sms)
                //                print("KILLVA: _GetPlayFieldsData STATUS:\(success) , sms: \(sms) data : \(json)\n")
                
                let jsonData = json[self.parSource.data]
                let nonrated_playgrounds =  jsonData[self.parSource.nonrated_playgrounds]
                let playgroundsJsonData = jsonData[self.parSource.playgrounds]
                let pagerJsonData = jsonData[self.parSource.images]
                let staticsJsonData = jsonData[self.parSource.statistics]
                
                let mainPageData = MainPage_Data(json: jsonData)
                var playGrounds = [PlayGroundsData_Data]()
                var pagerData =  [HomePagerData_Data]()
                let staticsdata =   Statics_Data(json: staticsJsonData)
                print("that is  jsonData getting the data Mate : %@", jsonData)
                print("that is  playgroundsJsonData getting the data Mate : %@", playgroundsJsonData)
                print("that is  pagerJsonData getting the data Mate : %@", pagerJsonData)
                print("that is  staticsJsonData getting the data Mate : %@", staticsJsonData)
                
                var ratePg_Data = [RatePg_Data]()
                for i in 0..<nonrated_playgrounds.count {
                    let x = RatePg_Data(json: playgroundsJsonData[i])
                    ratePg_Data.append(x)
                }
                
                for i in 0..<playgroundsJsonData.count {
                    let x = PlayGroundsData_Data(json: playgroundsJsonData[i])
                    playGrounds.append(x)
                }
                
                for i in 0..<pagerJsonData.count {
                    let x = HomePagerData_Data(json: pagerJsonData[i])
//                    if let url = URL(string: x.image) {
//                        if let data = NSData(contentsOf: url) as? Data {
//                            let image = UIImage(data: data)
//                            x.uiImage = image
//                        }        
//                    }
                    
                    pagerData.append(x)
                }
                
                
                mainPageData.ratePg_Data = ratePg_Data
                mainPageData.playGrounds = playGrounds
                mainPageData.pagerData = pagerData
                mainPageData.staticsdata = staticsdata
                
                
                //                var pagerDataClass = HomePagerData_Data(json: jsonData)
                //                var staticsdataClass = Statics_Data(json: jsonData)
                
                //                    var playGData : [PlayGroundsData]?
                //
                //                    for a in 0..<playGJData.count {
                //                        let pgData = PlayGroundsData(jsonData: playGJData[a])
                //                        playGData?.append(pgData)
                //                    }
                //                     playGrounds.data = playGData
                let success = json[self.parSource.success].intValue
                let sms = json[self.parSource.message].stringValue
                let  state =  success == 1 ? true : false
                print("KILLVA: _GetPlayFieldsData STATUS:\(state) , sms: \(sms) playGroundsCount : \(mainPageData.playGrounds?.count) pagerData : \(mainPageData.pagerData?.count) \n")
                
                completed(mainPageData,state,sms)
                
                
                break
            case .failure(_) :
                print("that is fail i n getting the data Mate : \(response.result.error.debugDescription)")
                completed(nil,false,"")
                break
            }
        }
        
        
        
    }
    
    
    
    func postRegisterNewPlayg(userId : Int , name : String, subtitle: String, address:String,mapLon:Double,mapLat:Double,price : Int , reservationCount : Int ,completed:@escaping (Bool) -> ()) {
        let parameters : Parameters = [parSource.user_id : userId,parSource.pg_name : name ,parSource.subtitle : subtitle,parSource.address : address,parSource.map_lon:mapLon, parSource.map_lat: mapLat, parSource.price:price, parSource.reservation_count: reservationCount]
        
        
        let url = source.POST_PLAY_GROUNDS_DATA + source.API_TOKEN
        print("postRegisterNewPlayg URL: \(url)")
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
                
                
                let data = response.result.value
                
                let success = json[self.parSource.success].intValue
                let sms = json[self.parSource.message].stringValue
                let  state =  success == 1 ? true : false
                
                print("KILLVA: postRegisterNewPlayg STATUS:\(state) , sms: \(sms) data : \(data) \n")
                
                //                let xUser = PostLoginVars(jsonData: data)
                
                completed(state)
                
                break
            case .failure(_) :
                print("that is fail postRegisterNewPlayg i n getting the data Mate : \(response.result.error)")
                completed(false)
                break
            }
        }
    }
    
   

//    func getImagesDict(imageString : String )-> UIImage {
// 
//        Alamofire.request(imageString).responseImage { response in
//            
//                 if let image = response.result.value {
//                    print("image downloaded: \(image)")
//                    return image
//                 }else {
//                    return UIImage(named: "courtplaceholder_3x")
//            }
//     
//            //            debugPrint(response)
//            //
//            //            print(response.request)
//            //            print(response.response)
//            //            debugPrint(response.result)
//            
//            //          else {
//             //            }
//     
//        
//    }
//
//}
    
    
    
    func postPlay_gRateing(pg_id:Int , ratingValue : Int,completed:@escaping (Bool) -> ()) {
        let parameters : Parameters = [parSource.user_id : USER_ID,parSource.pg_id : pg_id,parSource.value : ratingValue  ]
        
        
        let url = source.POST_PLAY_GROUND_RATE + source.API_TOKEN
        print("postPlay_gRateing URL: \(url)")
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
                
                
                let data = response.result.value
                
                let success = json[self.parSource.success].intValue
                let sms = json[self.parSource.message].stringValue
                let  state =  success == 1 ? true : false
                
                print("KILLVA: postPlay_gRateing STATUS:\(state) , sms: \(sms) data : \(data) \n")
                
                //                let xUser = PostLoginVars(jsonData: data)
                
                completed(state)
                
                break
            case .failure(_) :
                print("that is fail postPlay_gRateing i n getting the data Mate : \(response.result.error)")
                completed(false)
                break
            }
        }
    }
    
    

}

/*
 
 
 func getPlayFieldsData(completed : @escaping ([PlayGrounds]?)->()) {
 
 let request = alamoRequest(query_url: source.PLAY_GROUNDS_URL)
 Alamofire.request(request).responseJSON { (response) in
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
 print("that is  response.result.value! getting the data Mate : %@", response.result.value!)
 
 var playGroundsArray = [PlayGrounds]()
 
 for i in 0..<json.count {
 let data = json[i]
 
 let success = data[self.source.success].boolValue
 let sms = data[self.source.message].stringValue
 let playGrounds = PlayGrounds(success: success, sms: sms)
 
 let playGJData = data[self.source.data]
 var playGData : [PlayGroundsData]?
 
 for a in 0..<playGJData.count {
 let pgData = PlayGroundsData(jsonData: playGJData[a])
 playGData?.append(pgData)
 }
 playGrounds.data = playGData
 playGroundsArray.append(playGrounds)
 }
 
 completed(playGroundsArray)
 
 
 break
 case .failure(_) :
 print("that is fail i n getting the data Mate : %@",response.result.error)
 completed(nil)
 break
 }
 }
 
 
 
 }
 */
