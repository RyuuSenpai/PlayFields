//
//  Constants.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/12/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import Foundation
import UIKit
class Constants  {
    static let screenSize: CGRect = UIScreen.main.bounds
    
    class API {
        //       private static let main_url = "http://appstest.xyz/api/"
        private static let main_url = "http://amtechs.site/api/"
        
        
        class URLS {
            let API_TOKEN = "?api_token=776645543"
            let IMAGES_URL = "http://appstest.xyz/"
            
            //ARTICLES
            //            let POST_ARTICLES_DATA = API.main_url + "articles"
            //            let GET_ARTICLES_ALL = API.main_url + "articles"
            //            let GET_ARTICLES_DATA_BY_ID = API.main_url + "articles/"
            //////////////
            //HOMEDATA
            let POST_HOME_DATA = API.main_url + "homedatas"
            let GET_HOME_DATA_ALL = API.main_url + "homedatas"
            let GET_HOME_DATA_BY_ID = API.main_url + "homedatas/"
            //////////////
            //PG_INFO
            let POST_PG_INFO_DATA = API.main_url + "playgrounds"
            let GET_PG_INFO_ALL = API.main_url + "playgrounds"
            let GET_PG_INFO_DATA_BY_ID = API.main_url + "playgrounds/"
            //////////////
            //PG_NEWS
            let POST_PG_NEWS_DATA = API.main_url + "pg_news"
            let GET_PG_NEWS_ALL = API.main_url + "pg_news"
            let GET_PG_NEWS_BY_ID = API.main_url + "pg_news/"
            //////////////
            //PG_TIMES
            let POST_PG_TIMES_DATA = API.main_url + "pgtimes"
            let GET_PG_TIMES_ALL = API.main_url + "pgtimes"
            let GET_PG_TIMES_BY_ID = API.main_url + "pgtimes/"
            //////////////
            //PLAY_GROUNDS
            let POST_PLAY_GROUNDS_DATA = API.main_url + "homedatas"
            let GET_PLAY_GROUNDS_ALL = API.main_url + "homedatas"
            let GET_PLAY_GROUNDS_ID = API.main_url + "homedatas/"
            let POST_PLAY_GROUND_RATE = API.main_url + "playgrounds/rating"
            //////////////
            //SETTINGS
            let POST_SETTINGS_DATA = API.main_url + "settings"
            let GET_SETTINGS_ALL = API.main_url + "settings"
            let GET_SETTINGS_BY_ID = API.main_url + "settings/"
            //////////////
            //TEAMS
            let POST_TEAMS_DATA = API.main_url + "teams"
            let GET_TEAMS_ALL = API.main_url + "teams"
            let GET_TEAMS_BY_ID = API.main_url + "teams/"
            //////////////
            //USER
            let POST_login_USER_DATA = API.main_url + "users/login"
            let POST_Register_USER_DATA = API.main_url + "users"
            //            let GET_USER_ALL = API.main_url + "users"
            //            let GET_USER_BY_ID = API.main_url + "users/"
            let GET_CONFIRMATION_CODE =  API.main_url + "users/confirm"
            let POST_PROFILE_DATA =  API.main_url + "users/profile"
            let USER_FCM_TOKEN =   API.main_url + "fcm"
            let FACEBOOK_USER_LOGIN =  API.main_url + "users/fb-login"
            let RESEND_VERIFICATION_CODE = API.main_url + "users/resend-code"
            let POST_FORGOT_PASSWORD = API.main_url + "users/forget-password"
            let POST_LOGOUT = "/users/logout"
            //////////////
            
        }
        
        class Parameters {
            
            
            let success = "success"
            let message = "message"
            let data = "data"
            let id = "id"
            let ground_type = "ground_type"
            let light_available = "light_available"
            let football_available = "football_available"
            let pg_id = "pg_id"
            let pg_numberoffields = "pg_numberoffields"
            let user_id = "user_id"
            let pg_name = "pg_name"
            let address = "address"
            let map_lon = "map_lon"
            let map_lat = "map_lat"
            let price = "price"
            let reservation_count = "reservation_count"
            let mobile = "mobile"
            let city = "city"
            let area = "area"
            let pg_type = "pg_type"
            let type = "type"
            let team = "team"
            let likes = "likes"
            let birth_date = "birth_date"
            let email = "email"
            let password = "password"
            let remember_token = "remember_token"
            let api_token = "api_token"
            let created_at = "created_at"
            let updated_at = "updated_at"
            let deleted_at = "deleted_at"
            let title = "title"
            let image = "image"
            let content = "content"
            let time = "time"
            let subtitle = "subtitle"
            let from_datetime = "from_datetime"
            let to_datetime = "to_datetime"
            let playgrounds = "playgrounds"
            let visitors = "visitors"
            let fields_added = "fields_added"
            let booked_fields = "booked_fields"
            let images = "images"
            let statistics = "statistics"
            let am_pm = "am_pm"
            let booked = "booked"
            let pg_BookingNumbers = "pg_BookingNumbers"
            let date = "date"
            let times_msg = "times_msg"
            let token = "token"
            let username = "username"
            let nonrated_playgrounds = "nonrated_playgrounds"
            let rating = "rating"
            let value = "value"
            let points = "points"
            let snap_chat = "snap_chat"
            let position = "position"
            let name = "name"
            let fb_user_id = "fb_user_id"
        }
        
    }
    
    
    
    class Colors {
        static let blue = UIColor(colorLiteralRed: 57/255, green: 84/255, blue: 159/255, alpha: 1) //  #39599f
        
        static let green = UIColor(colorLiteralRed: 92/255, green: 173/255, blue: 40/255, alpha: 1)   //  #5cad28
        
        static let red = UIColor(colorLiteralRed: 177/255, green: 17/255, blue: 22/255, alpha: 1)    // #b11116
        
        static  let black = UIColor(colorLiteralRed: 40/255, green: 40/255, blue: 40/255, alpha: 1)    //   #282828
        static  let lightGray = UIColor(colorLiteralRed: 175/255, green: 175/255, blue: 175/255, alpha: 1)     //   #989898
        
        static  let gray = UIColor(colorLiteralRed: 152/255, green: 152/255, blue: 152/255, alpha: 1)     //   #989898
        
        static  let darkGreen = UIColor(colorLiteralRed: 74/255, green: 139/255, blue: 32/255, alpha: 1)     //   #4A8B20
        
        //    static  let yellow = UIColor(colorLiteralRed: 152/255, green: 152/255, blue: 152/255, alpha: 1)  //   #d8c800
    }
    
    
    class LanguagesDict {
        // langDicClass().getLocalizedTitle(
        private  var dict = ["Search":"بحث",
                             "Login":"تسجيل الدخول",
                             "Profile":"الصفحه الشخصيه",
                             "Registration":"انشاء حساب",
                             "Field Name:":"اسم الملعب : ",
                             "address:":"العنوان : ",
                             "books Times: ":"مرات الحجز : ",
                             "Price for hour: ":"سعر الساعه : ",
                             "Num of Fields: ":"عدد الملاعب : ",
                             "Field Type: ":"نوع الارضيه : ",
                             "Ball: ":"توفير كره : ",
                             "field Lighting: ":"توفير اضاءه : ",
                             "You have Booked This Field":"تم بنجاح حجز الملعب",
                             "Done":"تم",
                             "Error with ":" خطا في ",
                             "try again!!":"اعد المحاوله!!",
                             "Something Went Wrong":"حدث خطا",
                             "You didn't pick Booking Date":"لم تختر معاد للحجز",
                             " Points ":"نقطه",
                             "Invalid username or password":"خطا في رقم الهاتف او كلمة المرور",
                             "Phone Number Already Exists":"رقم الهاتف مستخدم من قبل",
                             "There's no Dates to pick":"لا توجد اوقات متوفره حاليا",
                             "Code Field is Empty" : "حقل رمز التاكيد فارغ",
                             " Network Time out " : " خطأ في الاتصال ",
                             "Failed to Upload Changes" : "فشل في تجديد البيانات",
                             "Confirm" :"تاكيد",
                             "Phone number isn't in a Correct Format":"رقم التلفون غير صحيح",
                             "Please, Enter activation code that was sent to you by sms to activate your account." : "من فضلك قم بادخال الرمز الذي تم ارساله اليك  لتفعيل الاكونت.",
                             "Code" : "الرمز",
                             "Phone Number" : "رقم الهاتف",
                             "  Verfication Code :" : "ادخل رمز التفعيل :",
                             "  Phone Number :" : "ادخل رقم الهاتف :",
                             "Please, Enter The Phone Number To Complete the Process" : "من فضلك، قم بادخال رقم الهاتف لاتمام العمليه",
                             "Activate" : "تفعيل",
                             "All Fields are Required" : "جميع الحقول مطلوبه",
                             "Send" : "ارسال",
                             "Invalid Mobile Number ":"خطا في رقم الهاتف ",


                             
            //                             "":"",
            //                             "":"",
            //                             "":"",
            //                             "":"",
            //                             "":"",
            //                             "":"",
            //                             "":"",
            //                             "":"",
            //                             "":"",
            //                             "":"",
            //                             "":"",
            
        ]
        
        
        func getLocalizedTitle(_ title : String) -> String {
            if L102Language.currentAppleLanguage() == "ar" {
                if let arTitle = dict[title] {
                    print("that's the loclized value : \(arTitle)")
                    return arTitle
                }
            }
            print("that's the loclized value : \(title)")
            return title
        }
        
        
    }
    
    
}
