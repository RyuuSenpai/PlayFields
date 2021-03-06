//
//  PlayGroundsVars.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 4/16/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import Foundation
import SwiftyJSON


class MainPage_Data {
    
    private var _success  : Int?
    var  image : String?
    var playGrounds : [PlayGroundsData_Data]?
    var pagerData :  [HomePagerData_Data]?
    var staticsdata :  Statics_Data?
    var ratePg_Data : [RatePg_Data]?
    private  var _sms : String?
    private   let source = Constants.API.Parameters()
    
    var success : Bool {
        guard _success == 1 else { return false }
        return true
    }
    
    var sms : String {
        guard let x = _sms else {return"local_error with All Data SMS" }
        return x
    }
    init(json:JSON) {
        self._success = json[source.success].intValue
        self._sms = json[source.message].stringValue
    }
}
//---------------------------------------------------------------------
class  PlayGroundsData_Data {
    
    //    private var _success : Bool?
    private var  _id : Int?
    private var  _user_id : Int?
    private var _name : String?
    private var _subtitle : String?
    private var _address : String?
    private var _map_lon : Double?
    private var _map_lat :Double?
    private var _image : String?
    private var _price : Int?
    private var _reservation_count : Int?
    //     private var _message : String?
    private var _rating : Int?
    
    private   let source = Constants.API.Parameters()
    
    //    var success : Bool {
    //        guard let suc = _success else { return false }
    //        return suc
    //    }
    
    var id : Int {
        guard let x = _id else { return 0 }
        return x
    }
    var user_id : Int {
        guard let user_id = _user_id else { return 0 }
        return user_id
    }
    var name : String {
        guard let name = _name else { return "" }
        return name
    }
    var subtitle : String {
        guard let x = _subtitle else { return "" }
        return x
    }
    var address : String {
        guard let address = _address else { return "" }
        return address
    }
    var map_lon : Double {
        guard let map_lon = _map_lon else { return 0.0 }
        return map_lon
    }
    var map_lat : Double {
        guard let map_lat = _map_lat else { return 0.0 }
        return map_lat
    }
    var price : Int {
        guard let price = _price else { return 0 }
        return price
    }
    var reservation_count : Int {
        guard let reservation_count = _reservation_count else { return 0 }
        return reservation_count
    }
    var image : String {
        guard let x = _image else { return "" }
        return x
    }
    var rate : Int{
        guard  let x = _rating else { return 0 }
        return x
    }
    
    
    init(json : JSON) {
        //        self._success = jsonData[source.success].boolValue
        self._id = json[source.id].intValue
        self._user_id = json[source.user_id].intValue
        self._name = json[source.pg_name].stringValue
        self._subtitle = json[source.subtitle].stringValue
        self._address = json[source.address].stringValue
        self._map_lon = json[source.map_lon].doubleValue
        self._map_lat = json[source.map_lat].doubleValue
        self._price = json[source.price].intValue
        self._reservation_count = json[source.reservation_count].intValue
        self._image = json[source.image].stringValue
        self._rating = json[source.rating].intValue
        
    }
}

//---------------------------------------------------------------------

class  HomePagerData_Data {
    
    private var _title : String?
    private var _image : String?
    private var _createdAt : String?
    private var _updatedAt : String?
    private   let source = Constants.API.Parameters()
    private   let imageURL = Constants.API.URLS()

    var title : String {
        guard  let x = _title else { return "" }
        return x
    }
    var image : String{
        guard  let x = _image else { return "" }
        return imageURL.IMAGES_URL + x
    }
    var createdAt : String{
        guard  let x = _createdAt else { return "" }
        return x
    }
    var updatedAt : String{
        guard  let x = _updatedAt else { return "" }
        return x
    }
 
    init(json:JSON) {
        self._title = json[source.title].stringValue
        self._image = json[source.image].stringValue
        self._createdAt = json[source.created_at].stringValue
        self._updatedAt = json[source.updated_at].stringValue
    }
}

//---------------------------------------------------------------------

class Statics_Data {
    
    private var _id : Int?
    private var _visitors : Int?
    private var _field_Added : Int?
    private var _booked_fields  : Int?
    private let source = Constants.API.Parameters()
    
    var id : Int {
        guard  let x = _id else { return 0 }
        return x
    }
    var visitors : Int{
        guard  let x = _visitors else { return 0 }
        return x
    }
    var fieldAdded : Int{
        guard  let x = _field_Added else { return 0 }
        return x
    }
    var bookedFields : Int{
        guard  let x = _booked_fields else { return 0 }
        return x
    }
    
    init(json:JSON) {
        self._id = json[source.id].intValue
        self._visitors = json[source.visitors].intValue
        self._field_Added = json[source.fields_added].intValue
        self._booked_fields = json[source.booked_fields].intValue
        
    }
}


//---------------------------------------------------------------------

class  RatePg_Data {
    
    private var _pg_name : String?
    private var _rating : Int?
    private var _id : Int?
     private   let source = Constants.API.Parameters()
    
    var pg_name : String {
//        print("That's the pg_name : \(_pg_name)")
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
 
    init(json:JSON) {
//        print("that intel data : \(json)")
         self._pg_name = json[source.pg_name].stringValue
        self._rating = json[source.rating].intValue
        self._id = json[source.id].intValue
//        print("that intel _pg_name : \(_pg_name)")

    }
}


//---------------------------------------------------------------------

class NearByFields_Data {
    
    //    private var _success : Bool?
    private var  _ground_type : String?
    private var _light_available : String?
    private var _football_available : String?
    private var _pg_numberoffields :Int?
    private var _times_msg : String?
    private   let source = Constants.API.Parameters()
    private   let imageURL = Constants.API.URLS()
    
    
    private var _id : Int?
    private var _user_Id : Int?
    private var _pg_name : String?
    private var _Address : String?
    private var _lat : String?
    private var _lang : String?
    private var _price : String?
    private var _pg_Booking_Num : Int?
    private var _image  : String?
    
    var image : String{
        guard  let x = _image , x != "" else {
//            print("that's the _image path : \(_image)");
            return "" }
//        print("that's the imageURL.IMAGES_URL + x   : \(x)")
        return imageURL.IMAGES_URL + x
    }
    
    
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
    
    init(json : JSON) {
        //        self._success = jsonData[source.success].boolValue
        self._ground_type = json[source.ground_type].stringValue
        self._light_available = json[source.light_available].stringValue
        self._football_available = json[source.football_available].stringValue
        self._pg_numberoffields = json[source.pg_numberoffields].intValue
        self._times_msg = json[source.times_msg].stringValue
        self._id = json[source.id].intValue
        self._user_Id = json[source.user_id].intValue
        self._pg_name = json[source.pg_name].stringValue
        self._Address = json[source.address].stringValue
        self._lat = json[source.map_lat].stringValue
        self._lang = json[source.map_lon].stringValue
        self._price = json[source.price].stringValue
        self._pg_Booking_Num = json[source.pg_BookingNumbers].intValue
        self._image = json[source.image].stringValue
        
    }
}

//---------------------------------------------------------------------

