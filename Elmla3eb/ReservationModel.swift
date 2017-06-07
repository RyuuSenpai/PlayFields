//
//  ConfirmedAndNotData.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 6/6/17.
//  Copyright © 2017 Killvak. All rights reserved.
//



import Foundation
import Alamofire
import SwiftyJSON


class ReservationModel {
    private let source = Constants.API.URLS()
    private let parSource = Constants.API.Parameters()
    
    
    func deleteReservation( reservation_id : Int, completed:@escaping (String,Bool) -> ()) {
        
        let url = source.POST_Reservation + "\(reservation_id)" + source.API_TOKEN
        print("deleteReservation URL: \(url)")
        //        let request = GLOBAL.alamoRequest(query_url: url)
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil else {
                    
                    // got an error in getting the data, need to handle it
                    print("error fetching data from url deleteReservation")
                    print(response.result.error!)
                    return
                    
                }
                let json = JSON( response.result.value!) // SwiftyJSON
                print("that is  deleteReservation getting the data Mate : %@", response.result.value!)
                let data = json["data"]
                
                
                let success = json[self.parSource.success].intValue
                let sms = json[self.parSource.message].stringValue
                let  state =  success == 1 ? true : false
                print("KILLVA: getPGReservationStatus STATUS:\(state) , sms: \(sms) \n")
                
                
                completed(sms,state)
                break
            case .failure(_) :
                print("that is fail i n getting the deleteReservation data Mate : \(response.result.error)")
                completed("Network Error",false)
                break
            }
        }
        
        
        
    }
    
}



//
//class FieldsReservStatusData {
//    private var _success  : Bool?
//    var not_confirmed : [NotConfirmedFields_Data]?
//    var confirmed : [ConfirmedFields_Data]?
//    private  var _sms : String?
//    private let source = Constants.API.Parameters()
//    
//    var success : Bool {
//        guard let success = _success else { return false }
//        return success
//    }
//    var sms : String {
//        guard let x = _sms else {return"local_error with PlayGroundsInfoSubData SMS" }
//        return x
//    }
//    init(_ state : Bool?,_ sms:String?,_ confirmed:[ConfirmedFields_Data]?,_ notConfirmed :[NotConfirmedFields_Data]?) {
//        self._success = state
//        self._sms = sms
//        self.not_confirmed = notConfirmed
//        self.confirmed = confirmed
//    }
//    
//}
//
//class NotConfirmedFields_Data {
//    
//    private var _pg_id : Int?
//    private var _time_id : Int?
//    private var _date : String?
//    private var _time  : String?
//    
//    private let source = Constants.API.Parameters()
//    private  let imageURL = Constants.API.URLS()
//    
//    private var _pg_name : String?
//    private var _image : String?
//    private var _address : String?
//    
//    
//    var pg_id : Int {
//        guard let x = _pg_id else {return 0 }
//        return x
//    }
//    var time_id : Int {
//        guard let x = _time_id else {return 0 }
//        return x
//    }
//    var date : String {
//        guard let x = _date else {return "" }
//        return x
//    }
//    var time : String {
//        guard let x = _time else {return "" }
//        return x
//    }
//    var pg_name : String {
//        guard  let x = _pg_name else { return "" }
//        return x
//    }
//    var address : String {
//        guard let address = _address else { return "" }
//        return address
//    }
//    var image : String {
//        guard let x = _image else { return "" }
//        return imageURL.IMAGES_URL + x
//    }
//    
//    
//    
//    init(json:JSON) {
//        self._pg_id = json[source.pg_id].intValue
//        self._time_id = json[source.time_id].intValue
//        let created_at = json[source.created_at]
//        self._date = created_at[source.date].stringValue
//        self._time = created_at[source.time].stringValue
//        
//        self._pg_name = json[source.pg_name].stringValue
//        self._image = json[source.image].string
//        self._address = json[source.address].string
//        
//    }
//    
//}
//
//
//class ConfirmedFields_Data {
//    
//    private var _pg_id : Int?
//    private var _time_id : Int?
//    private var _date : String?
//    private var _time  : String?
//    
//    private let source = Constants.API.Parameters()
//    private  let imageURL = Constants.API.URLS()
//    
//    private var _pg_name : String?
//    private var _image : String?
//    private var _address : String?
//    
//    
//    var pg_id : Int {
//        guard let x = _pg_id else {return 0 }
//        return x
//    }
//    var time_id : Int {
//        guard let x = _time_id else {return 0 }
//        return x
//    }
//    var date : String {
//        guard let x = _date else {return "" }
//        return x
//    }
//    var time : String {
//        guard let x = _time else {return "" }
//        return x
//    }
//    var pg_name : String {
//        guard  let x = _pg_name else { return "" }
//        return x
//    }
//    var address : String {
//        guard let address = _address else { return "" }
//        return address
//    }
//    var image : String {
//        guard let x = _image else { return "" }
//        return imageURL.IMAGES_URL + x
//    }
//    
//    
//    
//    init(json:JSON) {
//        self._pg_id = json[source.pg_id].intValue
//        self._time_id = json[source.time_id].intValue
//        let created_at = json[source.created_at]
//        self._date = created_at[source.date].stringValue
//        self._time = created_at[source.time].stringValue
//        
//        self._pg_name = json[source.pg_name].stringValue
//        self._image = json[source.image].string
//        self._address = json[source.address].string
//        
//    }
//    
//}
//
//









