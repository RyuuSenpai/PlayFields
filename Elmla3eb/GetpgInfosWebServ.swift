//
//  pgInfosWebServ.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/26/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import UIKit
class GetpgInfosWebServ  {
    
    private let source = Constants.API.URLS()
    private let parSource = Constants.API.Parameters()
    
    func getPgInfosByID(id:Int , completed : @escaping (PlayGroundsInfoSubData?) -> ()) {
        
        let url = source.GET_PG_INFO_DATA_BY_ID + "\(id)" + source.API_TOKEN
//        print("_GET_PLAY_FIELD_INFO_by_ID URL: \(url)")
        Alamofire.request(url , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
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
//                                print("that is  _GET_PLAY_FIELD_INFO_by_ID getting the data Mate : %@", response.result.value!)
                
                
                let data = json["data"]
                let times = data["times"]
                let news = data["news"]
                let images = data["images"]
                let info = data["info"]
                let details = data["details"]
//                let am = data["times"][0]["times"]["am"]
//                let pm = data["times"][0]["times"]
                //                let am = timesX2["am"]
                //                let pm = timesX2["pm"]
                let success = data[self.parSource.success].boolValue
                let sms = data[self.parSource.message].stringValue
                
                let pgData = PlayGroundsInfoSubData(json: data)
                
                var timesArray = [Pg_Times_Data]()
                
                //                print("times : \(times[1]) ")
                //                print("TIME: am : \(times.count)")
                //                print("TIME: pm : \(pm)")
                
                for (_,i) in times  {
//                    print("that is i : \(i)")
                    let timesClass = Pg_Times_Data(json: i)
                    
                    var amList = [AmPm_data]()
                    var pmList = [AmPm_data]()

                    for a in i {
                        let amLst = a.1["am"]
                        let pmLst = a.1["pm"]
                        
                        for amL in amLst {
                            let am = AmPm_data(json: amL.1)
                            amList.append(am)
                        }
                        for pmL in pmLst {
                            let pm = AmPm_data(json: pmL.1)
                            pmList.append(pm)
                        }
                        //
                    }
                    //                    for p in i {
                    ////                        print("that is pmList : \(p["pm"])")
                    ////
                    ////                        let pm = AmPm_data(json: p)
                    ////                        pmList.append(pm)
                    //                    }
                    timesClass.am_class = amList
                    timesClass.pm_class = pmList
                    timesArray.append(timesClass)
                }
                
                
                //                print("ZXC that's the time array : \(timesArray)")
                //                print("that is the pg  Details : \(details) \n and that is the info : \(info)")
                var newsArray = [Pg_News_Data]()
                for i in 0..<news.count {
                    let y = Pg_News_Data(json: news[i])
                    newsArray.append(y)
                }
//                print("images : \(images)")
                var imagesArray = [Pg_Images_Data]()
                for i in 0..<images.count {
                    let y = Pg_Images_Data(json: images[i])
                    imagesArray.append(y)
//                    print("that's the Pg_Images_Data_images : \(y.image)")

                }
                let infoObject = Pg_Info_Data(jsonData: info)
                //                 for i in 0..<info.count {
                //                    let y = Pg_Info_Data(jsonData: info[i])
                //                    infoArray.append(y)
                //                }
                
                let detailsObject = Pg_Details_Data(json: details)
                //                for i in 0..<details.count {
                //                    let y = Pg_Details_Data(json: details[i])
                //                    detailsArray.append(y)
                //                }
                
                
                
                pgData.times = timesArray
                pgData.news = newsArray
                pgData.images = imagesArray
                pgData.info = infoObject
                pgData.details = detailsObject
//                                print("KILLVA: _GET_PLAY_FIELD_INFO_by_ID STATUS:\(success) , sms: \(sms) data : \(response.result.value) \n")
                
                //                let pfInfo = PlayGroundsInfo(success: success, data: pgData, sms: sms)
             
                completed(pgData)
                break
            case .failure(_) :
//                print("that is fail i n getting the data Mate : \(response.result.error?.localizedDescription)")
                completed(nil)
                break
            }
        }
        //        let urlR = URL(string: url)
        //        URLSession.shared.dataTask(with: urlR!, completionHandler: {
        //            (data, response, error) in
        //            if(error != nil){
//                        print("error")
        //            }else{
        //                do{
        //                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
        //
        //                    print("data _GET_PLAY_FIELD_INFO_by_ID : \(json) ")
        ////                    OperationQueue.main.addOperation({
        ////                        self.tableView.reloadData()
        ////                    })
        //
        //                }catch let error as NSError{
        //                    print(error)
        //                }
        //            }
        //        }).resume()
        
        
    }
    
   
    func getImagesDict(imageString : String , completedImageDownload: @escaping (UIImage?)->())   {
        
        Alamofire.request(imageString).responseImage { response in
            
            if let image = response.result.value {
//                print("image downloaded: \(image)")
               completedImageDownload(image)
            }else {
                completedImageDownload(nil)
            }
        }
    }
    
    func postRegisterPlayFieldInfo(groundType:String, lighValid:Bool, footballValid:Bool, playgID:Int , pgNumbers:String? ,completed:@escaping (Bool) -> ()) {
        
        let parameters : Parameters = [parSource.ground_type :groundType, parSource.light_available : lighValid, parSource.football_available:footballValid, parSource.pg_id : playgID, parSource.pg_numberoffields: pgNumbers ?? "" ]
        
//        print("PARAMETERS: _PostRegisterPlayFieldInfo \(parameters)")
        let url = source.POST_PG_INFO_DATA + source.API_TOKEN
//        print("URL: _PostRegisterPlayFieldInfo \(url)")
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
                
                
                let data = json[self.parSource.data]
                
                let success = json[self.parSource.success].boolValue
                let sms = json[self.parSource.message].stringValue
//                print("KILLVA: _PostRegisterPlayFieldInfo STATUS:\(success) , sms: \(sms) data : \(data)\n")
                
                //                let xUser = PostLoginVars(jsonData: data)
                
                completed(success)
                
                break
            case .failure(_) :
//                print("that is fail i n getting the data Mate : \(response.result.error)")
                completed(false)
                break
            }
        }
    }
    
    
    
    func postBookDate( pg_Id : Int, reservationArray : [Int] ,completed:@escaping (Bool) -> ()) {
        var yzx = [String]()
        for y in reservationArray {
            yzx.append("\(y)")
        }
        
        let stringParm = yzx.joined(separator: ",")
//        print("thats the seleected dates_ID : \(stringParm)")
        var userId : Int?
        if let id = UserDefaults.standard.value(forKey: "userId") as? Int   {
            userId = id
        }
//        print("thats the seleected userId : \(userId)")
        let parameters : Parameters =  ["time_id":stringParm ,"player_id" : userId ?? "","pg_id" : pg_Id]
//        print("that is postBookDate param : \(parameters)")
        let url = source.POST_Reservation + source.API_TOKEN

//        print("postBookDate URL: \(url)")
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
                
                
                let data = response.result.value
                
                let success = json[self.parSource.success].intValue
                let sms = json[self.parSource.message].stringValue
                let  state =  success == 1 ? true : false
                
//                print("KILLVA: postRegisterNewPlayg STATUS:\(state) , sms: \(sms) data : \(data) \n")
                
                //                let xUser = PostLoginVars(jsonData: data)
                
                completed(state)
                
                break
            case .failure(_) :
//                print("that is fail postRegisterNewPlayg i n getting the data Mate : %@",response.result.error?.localizedDescription)
                completed(false)
                break
            }
        }
    }
    
}


/*
 func getPgInfosByID(id:Int , completed : @escaping (PlayGroundsInfoSubData?) -> ()) {
 
 let url = source.GET_PG_INFO_DATA_BY_ID + "\(id)" + source.API_TOKEN
 print("_GET_PLAY_FIELD_INFO_by_ID URL: \(url)")
 Alamofire.request(url , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
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
 let times = data["times"]
 let news = data["news"]
 let images = data["images"]
 let info = data["info"]
 let details = data["details"]
 let am = data["times"][0]["times"]["am"]
 let pm = data["times"][0]["times"]["pm"]
 //                let am = timesX2["am"]
 //                let pm = timesX2["pm"]
 let success = data[self.parSource.success].boolValue
 let sms = data[self.parSource.message].stringValue
 
 let pgData = PlayGroundsInfoSubData(json: data)
 
 var timesArray = [Pg_Times_Data]()
 for i in 0..<times.count {
 let timesClass = Pg_Times_Data(json: times[i])
 
 //                    let am1 = data["times"]["am"].array
 //                    let pm1 = data["times"]["am"]
 //                    let am2 = data["times"]["times"].dictionary
 //                    let pm2 = data["times"]["times"]
 //                    let am3 = data["times"]["times"]["am"]
 //                    let pm3 = data["times"]["times"]["pm"]
 print("that is am  : \(am) and pm: \(pm)")
 //                    print("that is am1 : \(am1) and pm: \(pm1)")
 //                    print("that is am2 : \(am2) and pm: \(pm2)")
 //                    print("that is am3 : \(am3) and pm: \(pm3)")
 
 
 var amArray = [AmPm_data]()
 //                    for (_, subJson) in am {
 //                        print("that is value : \(subJson)")
 //                        let x = AmPm_data(json: subJson)
 //                        print("im X : \(x)")
 //                        amArray.append(x)
 //
 //                    }
 for item in am.arrayValue {
 print("cut the crap index : \(item)")
 let x = AmPm_data(json: item)
 print("im X : \(x)")
 amArray.append(x)
 }
 
 //                    for iam in 0..<am.array!.count {
 //                        print("i'm index : \(iam) count : \(am.array?.count)")
 //                        let x = AmPm_data(json: am[iam])
 //                        print("im X : \(x)")
 //                        amArray.append(x)
 //                    }
 var pmArray = [AmPm_data]()
 for ipm in pm.array! {
 print("i'm index : \(ipm) count : \(pm.array)")
 let x = AmPm_data(json: ipm)
 print("im X : \(x)")
 pmArray.append(x)
 }
 //                    for ipm in 0..<pm.count - 1 {
 //                        let x = AmPm_data(json: pm[ipm])
 //                        pmArray.append(x)
 //                    }
 timesClass.am_class = amArray
 timesClass.pm_class = pmArray
 timesArray.append(timesClass)
 //                    print("that is am class : \(amArray)")
 //                    print("that is am class : \(pmArray)")
 }
 print("that is shit \(timesArray[0].am_class?[0])")
 print("that is shit2 \(timesArray[1].am_class?[0])")
 
 //                print("ZXC that's the time array : \(timesArray)")
 //                print("that is the pg  Details : \(details) \n and that is the info : \(info)")
 var newsArray = [Pg_News_Data]()
 for i in 0..<news.count {
 let y = Pg_News_Data(json: news[i])
 newsArray.append(y)
 }
 
 var imagesArray = [Pg_Images_Data]()
 for i in 0..<images.count {
 let y = Pg_Images_Data(json: images[i])
 imagesArray.append(y)
 }
 let infoObject = Pg_Info_Data(jsonData: info)
 //                 for i in 0..<info.count {
 //                    let y = Pg_Info_Data(jsonData: info[i])
 //                    infoArray.append(y)
 //                }
 
 let detailsObject = Pg_Details_Data(json: details)
 //                for i in 0..<details.count {
 //                    let y = Pg_Details_Data(json: details[i])
 //                    detailsArray.append(y)
 //                }
 
 pgData.times = timesArray
 pgData.news = newsArray
 pgData.images = imagesArray
 pgData.info = infoObject
 pgData.details = detailsObject
 //                print("KILLVA: _GET_PLAY_FIELD_INFO_by_ID STATUS:\(success) , sms: \(sms) data : \(response.result.value) \n")
 
 //                let pfInfo = PlayGroundsInfo(success: success, data: pgData, sms: sms)
 
 completed(pgData)
 break
 case .failure(_) :
 print("that is fail i n getting the data Mate : %@",response.result.error)
 completed(nil)
 break
 }
 }
 //        let urlR = URL(string: url)
 //        URLSession.shared.dataTask(with: urlR!, completionHandler: {
 //            (data, response, error) in
 //            if(error != nil){
 //                print("error")
 //            }else{
 //                do{
 //                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
 //
 //                    print("data _GET_PLAY_FIELD_INFO_by_ID : \(json) ")
 ////                    OperationQueue.main.addOperation({
 ////                        self.tableView.reloadData()
 ////                    })
 //
 //                }catch let error as NSError{
 //                    print(error)
 //                }
 //            }
 //        }).resume()
 
 
 }
 
 */

