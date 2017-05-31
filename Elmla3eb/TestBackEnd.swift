//
//  TestBackEnd.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/29/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class TestBackEnd {
    
    
//    static  func HOmePage() {
//        let homePage = MHomeData()
//        
////        homePage.postHomedataCreated(title: "Apps1011", image: "ss") { (booleanD) in
////            
////            //            print("the operation success is : \(booleanD)")
////        }
//         homePage.getAllHomeData { (dataArray) in
//            
//                        print("that is the count of data : [\(dataArray?.count)]")
//        }
// //        homePage.getHomeDataById(id: 3) { (data) in
////            
////            
////        }
//    }
    
    
    static func PLayField_INfo() {
        
        let pf_Info = GetpgInfosWebServ()
        
        pf_Info.getPgInfosByID(id: 1) { (data) in
            
//            print("that is arabic sentince : \(data)")

        }
        
//        pf_Info.postRegisterPlayFieldInfo(groundType: "asphalt 88", lighValid: true, footballValid: false, playgID: 8, pgNumbers: nil) { (isIt) in
//            
//            
//        }
        
    }
    
 
    
    
    static func PlaygNews() {
        
        let playgNews = MPgNews()
        playgNews.postPgNews(playgID: 1, title: "Sports √", content: "asda∑√") { (isit) in
            
            
        }
        playgNews.getPgNewsByID(id: 1) { (data) in
            
            guard let data = data else { print("error getting pg news by id data is empty"); return }
            
            for x in data {
            print("that is arabic sentince : \(x.content)")
            print("that is arabic sentince : \(x.title)")
            }
        }
        print("--------------------------")
//        playgNews.callWebService()
       
        
        
    }
    
    
    static func playgTimes() {
        let pg_Times  = MPg_Times()
        
        pg_Times.getPgTimesByID(id: 1) { (data) in
            
            print("that is arabic sentince : \(data?.pg_id)")
            print("that is arabic sentince : \(data?.times)")

        }
        
        pg_Times.postRegisterNewTime(time: "1 : 3 ", playgID: 1, fromTime : "1", toTime: "3") { (isIt) in
            
        }
    }
    
    

    
    static func playGrounds() {
        
        let x = GetPlayGroundsData()
        
//        x.getPlayFieldsData { (data) in
//            
//            
//        }
        
//        x.postRegisterNewPlayg(userId: 1, name: "Code grass", subtitle: "code", address: "236.Said", mapLon: 0, mapLat: 0, price: 0, reservationCount: 0) { (isIt) in
//            
//        }
//        x.getPlaygByID(playgID: 3) { (data) in
//            
//            
//        }
        
//        x.getSearchData(pg_name: "Code Grass", address: "", rating: "", fromData: "", toDate: "") { (data) in
//            
//            print("YAYAYAYAYA")
//        }
    }
    
    static func playgTeams() {
        
        let pg_teams = MPlaygTeams()
        
        pg_teams.getAllTeamsData { (data) in
            
            
        }
        
        pg_teams.getTeamDataById(id: 7) { (data) in
            
            
        }
        
        pg_teams.postTeamDataCreated(name: "The trible squad Team") { (isIT) in
            
            
        }
       
    }
    
    static func User() {
        let user = MUserData()
        
        user.postRegisterUser(name: "eslam", mobile: "0123123122", city: "cairo", area: "51", pgType: 1, email: "eslam@gmail.com", password: "1234§") {  (isIt) in
            
            
        }
        
        user.postLoginData(mobileNum: "", userPassword: "") { (data) in
            
            
        }
    }
    
    
//    func getImages(imageLink : String) -> UIImage? {
//        Alamofire.request("http://appstest.xyz/" + imageLink).responseImage { response in
//            debugPrint(response)
//            
//            print(response.request)
//            print(response.response)
//            debugPrint(response.result)
//            
//            if let image = response.result.value {
//                print("image downloaded: \(image)")
//                return image
//            }
//        }
//    }
}

//    func callWebService() {
//        // Show MBProgressHUD Here
//        var config                              :URLSessionConfiguration!
//        var urlSession                          :URLSession!
//
//        config = URLSessionConfiguration.default
//        urlSession = URLSession(configuration: config)
//
//        // MARK:- HeaderField
//        let HTTPHeaderField_ContentType         = "Content-Type"
//
//        // MARK:- ContentType
//        let ContentType_ApplicationJson         = "application/json"
//
//        //MARK: HTTPMethod
//        let HTTPMethod_Get                      = "GET"
//        let url = source.GET_PG_NEWS_BY_ID + "\(1)" + source.API_TOKEN
//
//        let callURL = URL.init(string: url)
//
//        var request = URLRequest.init(url: callURL!)
//
//        request.timeoutInterval = 60.0 // TimeoutInterval in Second
//        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
//        request.addValue(ContentType_ApplicationJson, forHTTPHeaderField: HTTPHeaderField_ContentType)
//        request.httpMethod = HTTPMethod_Get
//
//        let dataTask = urlSession.dataTask(with: request) { (data,response,error) in
//            if error != nil{
//                return
//            }
//            do {
//                let resultJson = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
//                print("Result",resultJson!)
//            } catch {
//                print("Error -> \(error)")
//            }
//        }
//
//        dataTask.resume()
//    }




/*
 cell.courtImage.af_setImage(
 withURL: URL(string: "http://appstest.xyz/" + data.image)!,
 placeholderImage: UIImage(named: "court_pic"),
 filter: nil,
 imageTransition: .crossDissolve(0.2)
 )
 
 */
