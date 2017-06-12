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


class OwnerModel {
    
    private  let source = Constants.API.URLS()
    private   let parSource = Constants.API.Parameters()
    
    
    
    
    func getP_GBooksManager(userID:Int,pgID : Int,completed:@escaping (OwnerBooksmanager_Data?,String,Bool) -> ()) {
        
        
        let url = source.GET_OWNER_SYSTEM_MANAGER + source.API_TOKEN + "&user_id=\(userID)&pg_id=\(pgID)"
        print("getP_GBooksManager URL: \(url)")
        Alamofire.request(url , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { [weak self]  (response:DataResponse<Any>) in
            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil else {
                    
                    // got an error in getting the data, need to handle it
                    print("error fetching data from getSearchData url")
                    print(response.result.error!)
                    return
                    
                }
                func parseBookingData(_ data : JSON) -> (String?,[AmPm_data]?,[AmPm_data]?) {
                    
                    let date = data["date"].stringValue
                    let amAndPmObject =  data["times"]
                    let amBooks = amAndPmObject["am"]
                    let pmBooks = amAndPmObject["pm"]
                    
                    print("that's the date \(date)\n  \n ⚛️amNotBooked : \(amBooks)\n 🆔pmNotBooked : \(pmBooks)")
                    
                    
                    var amData = [AmPm_data]()
                    
                    for amTimes in amBooks {
                        print(" ⚛️amNotBooked : \(amTimes)\n  \n")
                        amData.append(AmPm_data(json: amTimes.1))
                    }
                    var pmData = [AmPm_data]()
                    for pmTimes in pmBooks {
                        print(" ⚛️pmNotBooked : \(pmTimes)\n  \n")
                        pmData.append(AmPm_data(json: pmTimes.1))
                    }
                    return(date,amData,pmData)
                    
                }
                
                let parSource = Constants.API.Parameters()
                
                let succe = parSource.success; let sm = parSource.message; let dataa = parSource.data
                
                let json = JSON( response.result.value!) // SwiftyJSON
                //                print("that is  postUserData_LOGIN getting the data Mate : %@", response.result.value!)
                let data = json[dataa]
                
                let success = json[succe].intValue
                let sms = json[sm].stringValue
                let  state =  success == 1 ? true : false
                
//                print("KILLVA: getP_GBooksManager STATUS:\(state) , sms: \(sms) data : \(data) \n")
                 let info = data["info"]
                let pgName = info["pg_name"].stringValue
                let timesR = data["times"]
                
                let notBookedR = timesR["not_booked"]
                
//                print("notBookedR : \(notBookedR)\n")
                
//                print("that's pgName : \(pgName)\n timesR : \(timesR)\n bookedFields : \(timesR["booked"])\n")
                var ownerNotBookedP_G_Data = [OwnerP_G_BookingData]()
                for notBookedTimes in notBookedR {
//                    print("notBookedR Item : \(notBookedTimes.1)\n")
                    let returnedData = parseBookingData(notBookedTimes.1)
                    var ownerNotBooked = OwnerP_G_BookingData()
                    ownerNotBooked._date = returnedData.0
                    ownerNotBooked.amData = returnedData.1
                    ownerNotBooked.pmData = returnedData.2
//                    print("that's the ownerNotBookedP_G_Data \(ownerNotBooked._date)\n amData :\(ownerNotBooked.amData)\n pmData : \(ownerNotBooked.pmData)\n")
                    ownerNotBookedP_G_Data.append(ownerNotBooked)
                }
                
                let bookedR = timesR["booked"]
                var ownerBookedP_G_Data = [OwnerP_G_BookingData]()
                for bookedTimes in bookedR {
//                    print("bookedTimes Item : \(bookedTimes.1)\n")
                    let returnedData = parseBookingData(bookedTimes.1)
                    var ownerBooked = OwnerP_G_BookingData()
                    ownerBooked._date = returnedData.0
                    ownerBooked.amData = returnedData.1
                    ownerBooked.pmData = returnedData.2
//                    print("that's the ownerBooked \(ownerBooked._date)\n amData :\(ownerBooked.amData)\n pmData : \(ownerBooked.pmData)\n")
                    ownerBookedP_G_Data.append(ownerBooked)
                }
//                print("⚠️that's the booked :\(ownerBookedP_G_Data)\n and notBooked : \(ownerNotBookedP_G_Data) ")
                
                let ownerData = OwnerBooksmanager_Data()
                ownerData._pg_name = pgName
                ownerData.booked = ownerBookedP_G_Data
                ownerData.notBooked = ownerNotBookedP_G_Data
                
                completed(ownerData,sms,state)
                
                break
            case .failure(_) :
                print("that is fail getP_GBooksManager i n getting the data Mate : \(response.result.error)")
                completed(nil,"Network Timeout",false)
                break
            }
        }
    }
    

    
}




//---------------------------------_-_-____-_______-_-----_---_---_-------_-_-__-_-___

class OwnerBooksmanager_Data    {
    
    fileprivate var _pg_name : String?
    var pg_name : String {
        guard let x = _pg_name else { return "" }
        return x
    }
    var notBooked : [OwnerP_G_BookingData]?
    var booked : [OwnerP_G_BookingData]?
    
    
}
//**/*/*/*/*/*/*/*/*/*/****/*/*/*/*/+

struct OwnerP_G_BookingData {
    
    fileprivate var _date  : String?
    var date : String {
        guard let x = _date else { return "" }
        return x
    }
    var amData : [AmPm_data]?
    var pmData : [AmPm_data]?
}
//**/*/*/*/*/*/*/*/*/*/****/*/*/*/*/+


