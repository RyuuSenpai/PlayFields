//
//  Search_Model.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 5/31/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class Search_Model {
    
    private  let source = Constants.API.URLS()
    private   let parSource = Constants.API.Parameters()

    
    
    
    func getSearchData(pg_name:String?,address : String?,rating:String?,fromData : String?,toDate:String? ,completed:@escaping ([Search_Data]?,String,Bool) -> ()) {
        let parameters : Parameters = [parSource.pg_name:pg_name ?? "",parSource.address : address ?? "", parSource.rating : rating ?? "" ,parSource.date_from:fromData ?? "",parSource.date_to:toDate ?? ""]
        
        
        let url = source.SEARCH_URL + source.API_TOKEN
        print("getSearchData URL: \(url)")
        Alamofire.request(url , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {  (response:DataResponse<Any>) in
            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil else {
                    
                    // got an error in getting the data, need to handle it
                    print("error fetching data from getSearchData url")
                    print(response.result.error!)
                    return
                    
                }
                let parSource = Constants.API.Parameters()
                
                let succe = parSource.success; let sm = parSource.message; let dataa = parSource.data
                
                let json = JSON( response.result.value!) // SwiftyJSON
                //                print("that is  postUserData_LOGIN getting the data Mate : %@", response.result.value!)
                let data = json[dataa]
                var play_grounds : [Search_Data]?
                if data.count >  0 {
                    play_grounds = [Search_Data]()
                    for item in data {
                        print("that's the item : \(item)")
                        let x = Search_Data(json: item.1)
                        play_grounds?.append(x)
                    }
                    print("thats the array of fields : \(play_grounds)")
                    //                let data = response.result.value
                }
                let success = json[succe].intValue
                let sms = json[sm].stringValue
                let  state =  success == 1 ? true : false
                
                print("KILLVA: getSearchData STATUS:\(state) , sms: \(sms) data : \(data) \n")
                
                //                let xUser = PostLoginVars(jsonData: data)
                
                completed(play_grounds,sms,state)
                
                break
            case .failure(_) :
                print("that is fail getSearchData i n getting the data Mate : \(response.result.error)")
                completed(nil,"Network Timeout",false)
                break
            }
        }
    }
    
    
}




//---------------------------------_-_-____-_______-_-----_---_---_-------_-_-__-_-___

class Search_Data {
    
    private var _pg_name : String?
    private var _rating : Int?
    private var _id : Int?
    private var _image : String?
    private var _address : String?
    private var _price : String?

    private   let source = Constants.API.Parameters()
    private   let imageURL = Constants.API.URLS()
    
    var pg_name : String {
        guard  let x = _pg_name else { return "" }
        return x
    }
    var rating : Int{
        guard  let x = _rating else { return 0 }
        return x
    }
    var id : Int{
        guard  let x = _id else { return 0 }
        return x
    }
    
    var address : String {
        guard let address = _address else { return "" }
        return address
    }
    var image : String {
        guard let x = _image else { return "" }
        return imageURL.IMAGES_URL + x
    }
    var price : String {
        guard  let x = _price else { return "" }
        if L102Language.currentAppleLanguage() == "ar" {
            return "\(x) ريال"
            
        }
        return "\(x) SAR"
    }
    
    init(json:JSON) {
        self._pg_name = json[source.pg_name].stringValue
        self._rating = json[source.rating].intValue
        self._id = json[source.id].intValue
        self._image = json[source.image].string
        self._address = json[source.address].string
        self._price = json[source.price].string
    }
}

