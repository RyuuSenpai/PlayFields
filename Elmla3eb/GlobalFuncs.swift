//
//  GlobalFuncs.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/26/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
import Alamofire

let isAraLang = {
     return  L102Language.currentAppleLanguage() == "ar"

    }
let langDicClass = {
       return  Constants.LanguagesDict()
}

var USER_ID :Int {
    guard  let userID = UserDefaults.standard.value(forKey: "userId") as? Int else {
        print("error fetching userId from NSUserD.userId")
        return 0
    }
    return userID
}

//var profileGlobalImage : UIImage?
class GLOBAL {
    
    
     static func alamoRequest (query_url : String ) -> URLRequest {
        
        
        let urlAddressEscaped = query_url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        
        //MARK: timeout after ... Sec
        let request = URLRequest(url: URL(string: urlAddressEscaped!)!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 8)
        return  request
    }
    
    
    func getImagesDict(imageString : String , completedImageDownload: @escaping (UIImage?)->())   {
        
        Alamofire.request(imageString).responseImage { response in
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                completedImageDownload(image)
            }else {
                completedImageDownload(nil)
            }
        }
    }
 
      func readJson(langIs : String , completed : @escaping ([String])->()) {
        DispatchQueue.global().async {
            
            do {
                
                
                if let file = Bundle.main.url(forResource: "cities", withExtension: "json") {
                    let data = try Data(contentsOf: file)
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let object = json as? [String: Any] {
                        // json is a dictionary
                     } else if let object = json as? [Any] {
                        // json is an array
                        //                    print(object)
                        var citiesAraName = [String]()
                        var citiesEngName = [String]()
                        for cityObject in object {
                            //                        print("that's the city : \(cityObject)")
                            if let name = cityObject as? [String:Any] {
                                if let cityName = name["name"] as? [String:String] {
                                      citiesAraName.append(cityName["ar"]!)
                                    citiesEngName.append(cityName["en"]!)
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            
                            if langIs  == "ar" {
                             completed ( citiesAraName.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending } )
                                
                                
                            }else {
                               completed ( citiesEngName.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending } )
                                
                            }
                        }
                        
                        
                        
                    } else {
                        print("JSON is invalid")
                    }
                } else {
                    print("no file")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
//    
//        func getImagesDict(imageString : String ) -> UIImage {
//    
//            Alamofire.request(imageString).responseImage { response in
//    
//                     if let image = response.result.value {
//                        print("image downloaded: \(image)")
//                        return image
//                     }else {
//                        return UIImage(named: "courtplaceholder_3x")
//                }
//         }
//    }
    
}
 
