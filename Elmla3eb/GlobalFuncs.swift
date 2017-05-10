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
 
