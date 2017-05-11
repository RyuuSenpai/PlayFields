//
//  Pg_Info_Vars.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 4/16/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import Foundation
import SwiftyJSON


class PlayGroundsInfoSubData {
    private var _success  : Int?
    var times : [Pg_Times_Data]?
    var news : [Pg_News_Data]?
    var images :[Pg_Images_Data]?
    var info : Pg_Info_Data?
    var details : Pg_Details_Data?
    private  var _sms : String?
    private let source = Constants.API.Parameters()
    
    var success : Bool {
        guard _success == 1 else { return false }
        return true
    }
    var sms : String {
        guard let x = _sms else {return"local_error with PlayGroundsInfoSubData SMS" }
        return x
    }
    init(json:JSON) {
        self._success = json[source.success].intValue
        self._sms = json[source.message].stringValue
    }
    
}
//---------------------------------------------------------------------

class Pg_Times_Data {
    
    private var _date : String?
    var am_class : [AmPm_data]?
    var pm_class : [AmPm_data]?
    private let source = Constants.API.Parameters()
    
    var date : String{
        guard  let x = _date else { return "" }
        return x
    }
    
    
    
    init(json:JSON) {
   
        self._date = json[source.date].stringValue
   
        
    }
}

struct  AmPm_data {
    
    
    private var _id : Int?
    private var _pg_id : Int?
    private var _am_pm : String?
    private var _fromDataTime : String?
    private var _to_datetime : String?
    private var _time : String?
    private var _booked : Int?
    private let source = Constants.API.Parameters()
    
    var id : Int{
        guard  let x = _id else { return 0 }
        return x
    }
    var pg_ID : Int{
        guard  let x = _pg_id else { return 0 }
        return x
    }
    var amOrPm : String{
        guard  let x = _am_pm else { return "" }
        return x
    }
    var fromDataTime : String{
        guard  let x = _fromDataTime else { return "" }
        return x
    }
    var toDataTime : String{
        guard  let x = _to_datetime else { return "" }
        return x
    }
    var time : String{
        guard  let x = _time else { return "" }
        if L102Language.currentAppleLanguage() == "ar" {
            return "من الساعه" + " " + x
        }else {
                return "Time Range : \(x)"
        }
     }
    var isBooked : Bool{
        guard  let x = _booked , x == 1 else { return  false}
        return true
    }
    
    
    init(json:JSON) {
        self._id = json[source.id].intValue
        self._pg_id = json[source.pg_id].intValue
        self._am_pm = json[source.am_pm].stringValue
        self._fromDataTime = json[source.from_datetime].stringValue
        self._to_datetime = json[source.to_datetime].stringValue
        self._booked = json[source.booked].intValue
        self._time = json[source.time].stringValue

        
    }
}

//---------------------------------------------------------------------

class Pg_News_Data {
    
    private var _id : Int?
    private var _pg_id : Int?
    private var _title : String?
    private var _content : String?
    private let source = Constants.API.Parameters()
    
    var id : Int{
        guard  let x = _id else { return 0 }
        return x
    }
    var pg_ID : Int{
        guard  let x = _pg_id else { return 0 }
        return x
    }
    var title : String{
        guard  let x = _title else { return "" }
        return x
    }
    var content : String{
        guard  let x = _content else { return "" }
        return x
    }
    
    
    init(json:JSON) {
        self._id = json[source.id].intValue
        self._pg_id = json[source.pg_id].intValue
        self._title = json[source.title].stringValue
        self._content = json[source.content].stringValue
        
        
    }
}


//---------------------------------------------------------------------

class Pg_Images_Data {
    
    private var _id : Int?
    private var _pg_id : Int?
    private var _image : String?
    private let source = Constants.API.Parameters()
    private   let imageURL = Constants.API.URLS()

    var id : Int{
        guard  let x = _id else { return 0 }
        return x
    }
    var pg_ID : Int{
        guard  let x = _pg_id else { return 0 }
        return x
    }
    var image : String{
        guard  let x = _image , x != "" else {print("that's the _image path : \(_image)"); return "" }
        print("that's the imageURL.IMAGES_URL + x   : \(x)")
        return imageURL.IMAGES_URL + x
    }
    
    init(json:JSON) {
        self._id = json[source.id].intValue
        self._pg_id = json[source.pg_id].intValue
        self._image = json[source.image].stringValue
        
        
    }
}


//---------------------------------------------------------------------


class  Pg_Info_Data  {
    
    //    private var _success : Bool?
    private var  _ground_type : String?
    private var _light_available : String?
    private var _football_available : String?
    private var _pg_numberoffields :Int?
    private var _times_msg : String?
    private   let source = Constants.API.Parameters()
    
    var groundType : String {
        guard let x = _ground_type , x != "" else { return "unknown" }
        return x
    }
    var lightAvailable : Bool {
        guard let x = _light_available , x == "1" else { return false  }
        return true
    }
    var footballAvailable : Bool {
        guard let x = _football_available , x == "1" else { return false  }
        return true
    }
    var pgNumbersOfFeilds : Int {
        guard let x = _pg_numberoffields else { return 0 }
        return x
    }
    var times_msg : String {
        guard let x = _times_msg , x != "" else { return "" }
        return x
    }
    
    init(jsonData : JSON) {
        //        self._success = jsonData[source.success].boolValue
        self._ground_type = jsonData[source.ground_type].stringValue
        self._light_available = jsonData[source.light_available].stringValue
        self._football_available = jsonData[source.football_available].stringValue
        self._pg_numberoffields = jsonData[source.pg_numberoffields].intValue
        self._times_msg = jsonData[source.times_msg].stringValue

    }
}

//---------------------------------------------------------------------

class Pg_Details_Data {
    
    private var _id : Int?
    private var _user_Id : Int?
    private var _pg_name : String?
    private var _Address : String?
    private var _lat : String?
    private var _lang : String?
    private var _price : String?
    private var _pg_Booking_Num : Int?
    
    private let source = Constants.API.Parameters()
    
    var id : Int{
        guard  let x = _id else { return 0 }
        return x
    }
    var user_ID : Int{
        guard  let x = _user_Id else { return 0 }
        return x
    }
    var pgName : String{
        guard  let x = _pg_name else { return "" }
        return x
    }
    var address : String{
        guard  let x = _Address else { return "" }
        return x
    }
    var lat : String{
        guard  let x = _lat else { return "" }
        return x
    }
    var lang : String{
        guard  let x = _lang else { return "" }
        return x
    }
    var price : String{
        guard  let x = _price else { return "" }
        if L102Language.currentAppleLanguage() == "ar" {
            return "\(x) ريال"

        }
        return "\(x) SAR"
    }
    var pgBookingTimes : Int{
        guard  let x = _pg_Booking_Num   else { return  0}
        return x
    }
    
    
    init(json:JSON) {
        self._id = json[source.id].intValue
        self._user_Id = json[source.user_id].intValue
        self._pg_name = json[source.pg_name].stringValue
        self._Address = json[source.address].stringValue
        self._lat = json[source.map_lat].stringValue
        self._lang = json[source.map_lon].stringValue
        self._price = json[source.price].stringValue
        self._pg_Booking_Num = json[source.pg_BookingNumbers].intValue
        
    }
}


//---------------------------------------------------------------------

